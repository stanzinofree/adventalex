# Functions

## Obiettivo

Padroneggiare le **funzioni in Go**, incluse caratteristiche uniche come **multiple return values**, **named returns**, e **defer**. Le funzioni sono first-class citizens in Go e il linguaggio offre pattern idiomatici per error handling e resource cleanup.

### Contesto Pratico

In Go, le funzioni sono lo strumento principale per organizzare il codice:
- **Multiple return values**: permette di ritornare risultato + errore (pattern dominante in Go)
- **Named returns**: utile per documentare cosa ritorna una funzione
- **Defer**: garantisce cleanup di risorse (file, connessioni, lock) anche in caso di panic
- **Error handling**: esplicito e verificabile, no eccezioni

Casi d'uso reali:
- File I/O: ritorna dati + errore
- API calls: ritorna response + status + error
- Database queries: ritorna rows + error
- Resource cleanup: defer close() su file/connessioni

### Sintassi Base delle Funzioni

```go
package main

import "fmt"

// Funzione semplice
func greet(name string) {
    fmt.Println("Hello,", name)
}

// Con return value
func add(a int, b int) int {
    return a + b
}

// Parametri stesso tipo (sintassi compatta)
func multiply(a, b int) int {
    return a * b
}

// Multiple return values
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("division by zero")
    }
    return a / b, nil
}

func main() {
    greet("Gopher")
    
    sum := add(3, 5)
    fmt.Println("Sum:", sum)
    
    // Error handling idiom Go
    result, err := divide(10, 2)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println("Result:", result)
}
```

### Named Return Values

```go
package main

import "fmt"

// Named returns: documenta e semplifica return
func split(sum int) (x, y int) {
    x = sum * 4 / 9
    y = sum - x
    return  // "naked return" ritorna x e y
}

// Named returns con error handling
func readConfig(filename string) (config map[string]string, err error) {
    config = make(map[string]string)
    
    // Se c'è errore, err è già dichiarato
    // if err = openFile(filename); err != nil {
    //     return  // Ritorna nil map e l'errore
    // }
    
    config["status"] = "loaded"
    return  // Ritorna config e nil error
}

func main() {
    x, y := split(17)
    fmt.Printf("Split 17: x=%d, y=%d\n", x, y)
}
```

**⚠️ Attenzione**: naked returns sono pratici ma possono ridurre leggibilità in funzioni lunghe. Usali solo in funzioni brevi.

### Defer: Cleanup Garantito

```go
package main

import (
    "fmt"
    "os"
)

// defer esegue la funzione DOPO il return, in ordine LIFO
func demonstrateDefer() {
    defer fmt.Println("3 - Third (executed first)")
    defer fmt.Println("2 - Second")
    defer fmt.Println("1 - First (executed last)")
    
    fmt.Println("Function body")
}

// Uso pratico: chiudere file
func writeFile(filename string, data string) error {
    f, err := os.Create(filename)
    if err != nil {
        return err
    }
    defer f.Close()  // Garantisce chiusura anche se c'è errore dopo
    
    _, err = f.WriteString(data)
    if err != nil {
        return err  // f.Close() verrà chiamato comunque
    }
    
    return nil  // f.Close() chiamato qui
}

func main() {
    demonstrateDefer()
    // Output:
    // Function body
    // 1 - First (executed last)
    // 2 - Second
    // 3 - Third (executed first)
}
```

### Funzioni Variadiche

```go
package main

import "fmt"

// Accetta numero variabile di argomenti
func sum(nums ...int) int {
    total := 0
    for _, num := range nums {
        total += num
    }
    return total
}

func main() {
    fmt.Println(sum(1, 2))           // 3
    fmt.Println(sum(1, 2, 3, 4, 5)) // 15
    
    // Espandi slice con ...
    numbers := []int{10, 20, 30}
    fmt.Println(sum(numbers...))     // 60
}
```

### Funzioni Come Valori (First-Class)

```go
package main

import "fmt"

// Funzione che accetta funzione come parametro
func apply(fn func(int) int, value int) int {
    return fn(value)
}

func main() {
    // Funzione anonima (closure)
    double := func(x int) int {
        return x * 2
    }
    
    square := func(x int) int {
        return x * x
    }
    
    fmt.Println(apply(double, 5))  // 10
    fmt.Println(apply(square, 5))  // 25
}
```

### Esempio Completo: File Reader con Error Handling

```go
package main

import (
    "fmt"
    "os"
    "strings"
)

// Multiple returns: lines, error
func readLines(filename string) ([]string, error) {
    data, err := os.ReadFile(filename)
    if err != nil {
        return nil, fmt.Errorf("failed to read %s: %w", filename, err)
    }
    
    lines := strings.Split(string(data), "\n")
    return lines, nil
}

// Named returns con defer
func processFile(filename string) (lineCount int, err error) {
    fmt.Println("Opening file...")
    defer fmt.Println("Cleanup done")
    
    lines, err := readLines(filename)
    if err != nil {
        return 0, err
    }
    
    lineCount = len(lines)
    return  // naked return
}

func main() {
    // Crea file di test
    testFile := "test.txt"
    defer os.Remove(testFile)  // Cleanup alla fine
    
    err := os.WriteFile(testFile, []byte("line1\nline2\nline3"), 0644)
    if err != nil {
        fmt.Println("Error creating file:", err)
        return
    }
    
    // Processa file
    count, err := processFile(testFile)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    
    fmt.Printf("Processed %d lines\n", count)
}
```

### Comandi Utili

```bash
# Compila ed esegui
go run main.go

# Build
go build -o functions main.go

# Formattazione
go fmt main.go

# Verifica errori comuni
go vet main.go

# Test coverage (se hai file _test.go)
go test -cover
```

### File da Creare
- `main.go` - Programma che dimostra funzioni, multiple returns, defer

### Test da Passare
1. ✅ Build success (`go build` senza errori)
2. ✅ Run success (programma termina con exit 0)
3. ✅ Usa almeno una funzione con multiple return values
4. ✅ Dimostra uso di `defer` per cleanup
5. ✅ Error handling con pattern `if err != nil`
6. ✅ Go idioms seguiti
7. ✅ gofmt compliant

### Esempio di Output Atteso

```
=== Function Examples ===
Simple add: 8
Division result: 5.00
Error handling: division by zero

=== Defer Demo ===
Function body executing
Deferred: cleanup 3
Deferred: cleanup 2
Deferred: cleanup 1

=== File Processing ===
Opening file...
Cleanup done
Processed 3 lines successfully
```

## Requisiti
- [ ] Implementa almeno 3 funzioni diverse
- [ ] Usa multiple return values (es. result + error)
- [ ] Dimostra defer per cleanup
- [ ] Error handling con `if err != nil`
- [ ] Opzionale: named returns o variadic function
- [ ] Commenti dove necessario
- [ ] `go fmt` applied

## Risorse
- [Go Tour - Functions](https://go.dev/tour/basics/4)
- [Go Tour - Multiple Results](https://go.dev/tour/basics/6)
- [Go Tour - Defer](https://go.dev/tour/flowcontrol/12)
- [Effective Go - Functions](https://go.dev/doc/effective_go#functions)
- [Go by Example - Functions](https://gobyexample.com/functions)
- [Error Handling in Go](https://go.dev/blog/error-handling-and-go)

## Note

**Pattern idiomatici Go:**
- Ritorna sempre errore come ultimo valore: `func foo() (result, error)`
- Check errore immediatamente: `if err != nil { return err }`
- Usa `defer` per garantire cleanup (file, lock, connessioni)
- Preferisci funzioni piccole e focused
- Named returns utili per documentare, ma naked returns solo in funzioni brevi

Consulta STUDY.md per esempi specifici e best practices Go.
