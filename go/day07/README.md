# Error Handling

## Obiettivo

Padroneggiare la **gestione degli errori idiomatica in Go**. A differenza di altri linguaggi che usano eccezioni (try/catch), Go tratta gli errori come valori normali. Imparerai a creare, controllare, wrappare errori, e quando usare panic/recover.

### Contesto Pratico

Error handling è CRITICO in production code:
- **API services**: ritornare errori HTTP appropriati (400, 500, 503)
- **Database operations**: distinguere tra errore di connessione, constraint violation, not found
- **File I/O**: gestire "file not found" diversamente da "permission denied"
- **Network calls**: retry su errori temporanei, fail su errori permanenti
- **Debugging**: stack trace e context per capire dove è fallito

In Go, il pattern standard è:
```go
result, err := someFunction()
if err != nil {
    // Gestisci errore
}
```

Questo rende gli errori **espliciti e verificabili** a compile-time.

### Error Type Base

```go
package main

import (
    "errors"
    "fmt"
)

func main() {
    // Creare errori semplici
    err1 := errors.New("something went wrong")
    err2 := fmt.Errorf("failed with code %d", 500)
    
    fmt.Println(err1)  // something went wrong
    fmt.Println(err2)  // failed with code 500
    
    // Error è un'interfaccia
    var err error = errors.New("test")
    fmt.Println(err.Error())  // Chiama metodo Error()
}
```

**L'interfaccia error:**
```go
type error interface {
    Error() string
}
```

Qualsiasi tipo che implementa `Error() string` è un errore!

### Pattern: Check Error Immediately

```go
package main

import (
    "fmt"
    "os"
)

func readConfig(filename string) error {
    data, err := os.ReadFile(filename)
    if err != nil {
        return err  // Propaga errore al chiamante
    }
    
    fmt.Printf("Config loaded: %d bytes\n", len(data))
    return nil  // Successo
}

func main() {
    err := readConfig("config.txt")
    if err != nil {
        fmt.Printf("Error: %v\n", err)
        os.Exit(1)
    }
    
    fmt.Println("Success!")
}
```

### Error Wrapping (Go 1.13+)

Wrapping aggiunge contesto senza perdere errore originale:

```go
package main

import (
    "errors"
    "fmt"
    "os"
)

func loadData(filename string) ([]byte, error) {
    data, err := os.ReadFile(filename)
    if err != nil {
        // Wrap error con %w per mantenere errore originale
        return nil, fmt.Errorf("failed to load %s: %w", filename, err)
    }
    return data, nil
}

func processFile(filename string) error {
    data, err := loadData(filename)
    if err != nil {
        // Ulteriore wrapping
        return fmt.Errorf("process failed: %w", err)
    }
    
    fmt.Printf("Processed %d bytes\n", len(data))
    return nil
}

func main() {
    err := processFile("missing.txt")
    if err != nil {
        fmt.Println("Error chain:", err)
        // Output: Error chain: process failed: failed to load missing.txt: open missing.txt: no such file or directory
        
        // Unwrap per controllare errore specifico
        if errors.Is(err, os.ErrNotExist) {
            fmt.Println("File does not exist!")
        }
    }
}
```

**Differenza `%v` vs `%w`:**
- `%v` - Formatta errore ma NON mantiene catena
- `%w` - Wrappa errore mantenendo accesso all'originale

### Controllare Errori Specifici: errors.Is / errors.As

```go
package main

import (
    "errors"
    "fmt"
    "os"
)

func main() {
    // errors.Is - controlla se errore è uguale a un valore specifico
    _, err := os.Open("nonexistent.txt")
    
    if errors.Is(err, os.ErrNotExist) {
        fmt.Println("File not found")
    } else if errors.Is(err, os.ErrPermission) {
        fmt.Println("Permission denied")
    }
    
    // errors.As - controlla se errore è di un tipo specifico
    var pathErr *os.PathError
    if errors.As(err, &pathErr) {
        fmt.Printf("Path error on: %s\n", pathErr.Path)
        fmt.Printf("Operation: %s\n", pathErr.Op)
        fmt.Printf("Underlying: %v\n", pathErr.Err)
    }
}
```

### Custom Error Types

```go
package main

import (
    "fmt"
    "time"
)

// Custom error type con campi extra
type ValidationError struct {
    Field   string
    Value   interface{}
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation failed on field '%s': %s (value: %v)",
        e.Field, e.Message, e.Value)
}

type DatabaseError struct {
    Query     string
    Timestamp time.Time
    Err       error
}

func (e *DatabaseError) Error() string {
    return fmt.Sprintf("database error at %s: %v (query: %s)",
        e.Timestamp.Format(time.RFC3339), e.Err, e.Query)
}

func (e *DatabaseError) Unwrap() error {
    return e.Err  // Permette errors.Is/As di funzionare
}

func validateAge(age int) error {
    if age < 0 {
        return &ValidationError{
            Field:   "age",
            Value:   age,
            Message: "must be positive",
        }
    }
    if age > 150 {
        return &ValidationError{
            Field:   "age",
            Value:   age,
            Message: "unrealistic value",
        }
    }
    return nil
}

func main() {
    err := validateAge(-5)
    if err != nil {
        fmt.Println(err)
        // Output: validation failed on field 'age': must be positive (value: -5)
        
        // Type assertion per accedere ai campi
        var valErr *ValidationError
        if errors.As(err, &valErr) {
            fmt.Printf("Invalid field: %s\n", valErr.Field)
        }
    }
}
```

### Panic e Recover

**⚠️ Usa panic solo per errori irrecuperabili!**

```go
package main

import (
    "fmt"
)

// panic ferma l'esecuzione
func mustOpen(filename string) {
    if filename == "" {
        panic("filename cannot be empty")
    }
    // ... open file
}

// recover cattura panic (solo dentro defer)
func safeDivide(a, b int) (result int, err error) {
    defer func() {
        if r := recover(); r != nil {
            err = fmt.Errorf("panic recovered: %v", r)
        }
    }()
    
    result = a / b  // Panic se b == 0
    return result, nil
}

func main() {
    // Panic non gestito termina il programma
    // mustOpen("")  // Questo crasherebbe
    
    // Recover cattura panic
    result, err := safeDivide(10, 0)
    if err != nil {
        fmt.Println("Error:", err)
        // Output: Error: panic recovered: runtime error: integer divide by zero
    } else {
        fmt.Println("Result:", result)
    }
}
```

**Quando usare panic:**
- Errori di programmazione (bug) che non dovrebbero mai accadere
- Inizializzazione fallita (database connessione al startup)
- Librerie: mai panic, sempre ritorna error

**Quando usare recover:**
- Server HTTP: evita che una richiesta crashata faccia down tutto il server
- Worker pool: recupera panic in goroutine
- Testing: verifica che codice panic come atteso

### Sentinel Errors (Errori Predefiniti)

```go
package main

import (
    "errors"
    "fmt"
)

// Definisci errori comuni come variabili
var (
    ErrNotFound     = errors.New("resource not found")
    ErrUnauthorized = errors.New("unauthorized access")
    ErrInvalidInput = errors.New("invalid input")
)

func getUser(id int) (string, error) {
    if id < 0 {
        return "", ErrInvalidInput
    }
    if id > 1000 {
        return "", ErrNotFound
    }
    if id == 42 {
        return "", ErrUnauthorized
    }
    return fmt.Sprintf("User-%d", id), nil
}

func main() {
    user, err := getUser(1001)
    
    // Confronto diretto con sentinel errors
    if err == ErrNotFound {
        fmt.Println("User not found, create new one?")
    } else if err == ErrUnauthorized {
        fmt.Println("Access denied")
    } else if err != nil {
        fmt.Println("Unexpected error:", err)
    } else {
        fmt.Println("User:", user)
    }
}
```

### Esempio Completo: API Client con Error Handling

```go
package main

import (
    "errors"
    "fmt"
    "math/rand"
    "time"
)

// Custom errors
var (
    ErrTimeout      = errors.New("request timeout")
    ErrServerError  = errors.New("server error")
    ErrRateLimited  = errors.New("rate limited")
)

type APIError struct {
    StatusCode int
    Message    string
    Err        error
}

func (e *APIError) Error() string {
    return fmt.Sprintf("API error %d: %s", e.StatusCode, e.Message)
}

func (e *APIError) Unwrap() error {
    return e.Err
}

// Simula chiamata API
func fetchData(url string) ([]byte, error) {
    rand.Seed(time.Now().UnixNano())
    
    // Simula vari scenari di errore
    scenario := rand.Intn(5)
    
    switch scenario {
    case 0:
        return []byte("success data"), nil
    case 1:
        return nil, fmt.Errorf("network error: %w", ErrTimeout)
    case 2:
        return nil, &APIError{
            StatusCode: 500,
            Message:    "Internal Server Error",
            Err:        ErrServerError,
        }
    case 3:
        return nil, &APIError{
            StatusCode: 429,
            Message:    "Too Many Requests",
            Err:        ErrRateLimited,
        }
    default:
        return nil, errors.New("unknown error")
    }
}

func getData(url string) ([]byte, error) {
    data, err := fetchData(url)
    if err != nil {
        // Wrap per aggiungere contesto
        return nil, fmt.Errorf("failed to fetch from %s: %w", url, err)
    }
    return data, nil
}

func main() {
    for i := 0; i < 5; i++ {
        fmt.Printf("\n=== Attempt %d ===\n", i+1)
        
        data, err := getData("https://api.example.com/data")
        
        if err != nil {
            // Controlla tipo di errore specifico
            var apiErr *APIError
            if errors.As(err, &apiErr) {
                fmt.Printf("API Error: status=%d msg=%s\n", apiErr.StatusCode, apiErr.Message)
                
                // Retry logic basato su errore
                if errors.Is(err, ErrRateLimited) {
                    fmt.Println("→ Should retry after delay")
                } else if errors.Is(err, ErrServerError) {
                    fmt.Println("→ Server issue, retry later")
                }
            } else if errors.Is(err, ErrTimeout) {
                fmt.Println("Timeout error, should retry")
            } else {
                fmt.Println("Unexpected error:", err)
            }
        } else {
            fmt.Printf("Success: %s\n", data)
        }
        
        time.Sleep(500 * time.Millisecond)
    }
}
```

### Comandi Utili

```bash
# Esegui
go run main.go

# Build
go build -o errorhandling main.go

# Formattazione
go fmt main.go

# Vet checks common errors
go vet main.go
```

### File da Creare
- `main.go` - Programma che dimostra error handling idiomatico

### Test da Passare
1. ✅ Build success
2. ✅ Usa error wrapping con `%w`
3. ✅ Controlla errori con `errors.Is` o `errors.As`
4. ✅ Definisce almeno un custom error type
5. ✅ Pattern `if err != nil` sempre presente
6. ✅ Dimostra panic/recover (opzionale)
7. ✅ gofmt compliant

### Esempio di Output Atteso

```
=== Error Handling Demo ===

✓ Simple error: file not found
✓ Formatted error: invalid age: -5
✓ Wrapped error: process failed: failed to load config.txt: open config.txt: no such file or directory

=== Custom Errors ===
Validation error: validation failed on field 'age': must be positive (value: -5)
Invalid field: age

=== API Error Handling ===
API Error: status=429 msg=Too Many Requests
→ Should retry after delay
```

## Requisiti
- [ ] Usa `fmt.Errorf` con `%w` per wrapping
- [ ] Controlla errori con `errors.Is` o `errors.As`
- [ ] Definisci almeno un custom error type
- [ ] Pattern `if err != nil` dopo ogni operazione fallibile
- [ ] Sentinel errors (opzionale)
- [ ] Panic/recover demo (opzionale)
- [ ] Commenti dove necessario
- [ ] `go fmt` applied

## Risorse
- [Go Blog - Error Handling](https://go.dev/blog/error-handling-and-go)
- [Go Blog - Working with Errors](https://go.dev/blog/go1.13-errors)
- [Effective Go - Errors](https://go.dev/doc/effective_go#errors)
- [Go by Example - Errors](https://gobyexample.com/errors)
- [Go by Example - Panic](https://gobyexample.com/panic)
- [Package errors](https://pkg.go.dev/errors)

## Note

**Best Practices:**
- Ritorna error come ultimo valore: `func foo() (result, error)`
- Controlla errori immediatamente: `if err != nil`
- Wrappa con contesto: `fmt.Errorf("context: %w", err)`
- Non ignorare mai errori (no `_` al posto di err)
- Panic solo per bug irrecuperabili, mai in librerie
- Log errors appropriatamente prima di ritornare

**Errori comuni:**
- Usare `%v` invece di `%w` per wrapping
- Non controllare `err != nil` dopo ogni operazione
- Usare panic al posto di error return
- Ignorare errori: `result, _ := someFunc()` ⚠️

Consulta STUDY.md per esempi specifici e best practices Go.
