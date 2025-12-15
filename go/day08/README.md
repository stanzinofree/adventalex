# JSON Marshal/Unmarshal

## Obiettivo

Imparare a **serializzare e deserializzare JSON** in Go usando il package `encoding/json`. JSON è il formato più usato per API REST, configurazioni, e scambio dati. Go offre reflection-based encoding/decoding con struct tags per controllo fine.

### Contesto Pratico

JSON è ovunque nel mondo moderno:
- **REST API**: richieste/risposte HTTP in formato JSON
- **Configuration files**: `config.json`, `package.json`, `.vscode/settings.json`
- **Database storage**: MongoDB, PostgreSQL JSONB columns
- **Message queues**: Kafka, RabbitMQ messages
- **WebSocket**: real-time data exchange

In Go, il pattern è:
- **Marshal**: Go struct → JSON bytes
- **Unmarshal**: JSON bytes → Go struct
- **Struct tags**: controllare nomi field, omissione, validazione

### Marshal: Go → JSON

```go
package main

import (
    "encoding/json"
    "fmt"
)

type Person struct {
    Name  string
    Age   int
    Email string
}

func main() {
    person := Person{
        Name:  "Alice",
        Age:   30,
        Email: "alice@example.com",
    }
    
    // Marshal to JSON (compact)
    jsonBytes, err := json.Marshal(person)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    
    fmt.Println("Compact JSON:")
    fmt.Println(string(jsonBytes))
    // Output: {"Name":"Alice","Age":30,"Email":"alice@example.com"}
    
    // MarshalIndent for pretty-printing
    jsonPretty, err := json.MarshalIndent(person, "", "  ")
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    
    fmt.Println("\nPretty JSON:")
    fmt.Println(string(jsonPretty))
    /* Output:
    {
      "Name": "Alice",
      "Age": 30,
      "Email": "alice@example.com"
    }
    */
}
```

### Unmarshal: JSON → Go

```go
package main

import (
    "encoding/json"
    "fmt"
)

type Person struct {
    Name  string
    Age   int
    Email string
}

func main() {
    jsonData := `{
        "Name": "Bob",
        "Age": 25,
        "Email": "bob@example.com"
    }`
    
    var person Person
    err := json.Unmarshal([]byte(jsonData), &person)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    
    fmt.Printf("Name: %s\n", person.Name)
    fmt.Printf("Age: %d\n", person.Age)
    fmt.Printf("Email: %s\n", person.Email)
}
```

### Struct Tags: Controllare JSON Output

```go
package main

import (
    "encoding/json"
    "fmt"
)

type User struct {
    // json:"name" - campo JSON si chiama "name" (minuscolo)
    ID       int    `json:"id"`
    Username string `json:"username"`
    
    // omitempty - ometti se valore zero
    Email    string `json:"email,omitempty"`
    
    // "-" - ignora completamente questo campo
    Password string `json:"-"`
    
    // Campo non esportato (minuscolo) - ignorato automaticamente
    internal string
}

func main() {
    user := User{
        ID:       1,
        Username: "alice",
        Email:    "",  // Verrà omesso
        Password: "secret123",  // Non apparirà nel JSON
        internal: "hidden",
    }
    
    jsonBytes, _ := json.MarshalIndent(user, "", "  ")
    fmt.Println(string(jsonBytes))
    /* Output:
    {
      "id": 1,
      "username": "alice"
    }
    Email omesso (stringa vuota + omitempty)
    Password non appare (tag "-")
    internal non appare (non esportato)
    */
}
```

**Tag comuni:**
- `json:"fieldname"` - Nome custom nel JSON
- `json:"fieldname,omitempty"` - Ometti se zero value
- `json:"-"` - Escludi dal JSON
- `json:",string"` - Converti in string (per int/bool in JSON come "123")

### Nested Structs e Arrays

```go
package main

import (
    "encoding/json"
    "fmt"
)

type Address struct {
    Street  string `json:"street"`
    City    string `json:"city"`
    ZipCode string `json:"zip_code"`
}

type Person struct {
    Name      string   `json:"name"`
    Age       int      `json:"age"`
    Emails    []string `json:"emails"`
    Address   Address  `json:"address"`
    IsActive  bool     `json:"is_active"`
}

func main() {
    person := Person{
        Name:     "Charlie",
        Age:      35,
        Emails:   []string{"charlie@work.com", "charlie@home.com"},
        Address:  Address{
            Street:  "123 Main St",
            City:    "NYC",
            ZipCode: "10001",
        },
        IsActive: true,
    }
    
    // Marshal
    jsonBytes, _ := json.MarshalIndent(person, "", "  ")
    fmt.Println("Marshaled:")
    fmt.Println(string(jsonBytes))
    
    // Unmarshal
    jsonData := `{
        "name": "Diana",
        "age": 28,
        "emails": ["diana@example.com"],
        "address": {
            "street": "456 Oak Ave",
            "city": "SF",
            "zip_code": "94102"
        },
        "is_active": true
    }`
    
    var person2 Person
    json.Unmarshal([]byte(jsonData), &person2)
    
    fmt.Println("\nUnmarshaled:")
    fmt.Printf("%+v\n", person2)
}
```

### Generic JSON: map[string]interface{}

Quando la struttura JSON è sconosciuta:

```go
package main

import (
    "encoding/json"
    "fmt"
)

func main() {
    jsonData := `{
        "name": "Eve",
        "age": 42,
        "tags": ["go", "rust", "python"],
        "metadata": {
            "created": "2025-01-01",
            "active": true
        }
    }`
    
    // Unmarshal in map generico
    var data map[string]interface{}
    err := json.Unmarshal([]byte(jsonData), &data)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    
    // Accedi ai campi con type assertions
    fmt.Println("Name:", data["name"].(string))
    fmt.Println("Age:", data["age"].(float64))  // JSON numbers → float64
    
    // Array
    tags := data["tags"].([]interface{})
    fmt.Println("First tag:", tags[0].(string))
    
    // Nested object
    metadata := data["metadata"].(map[string]interface{})
    fmt.Println("Created:", metadata["created"].(string))
}
```

⚠️ **Type assertions** sono necessarie ma rischiose - controlla sempre!

### Streaming: Encoder/Decoder

Per file grandi o network streams:

```go
package main

import (
    "encoding/json"
    "fmt"
    "os"
    "strings"
)

type LogEntry struct {
    Timestamp string `json:"timestamp"`
    Level     string `json:"level"`
    Message   string `json:"message"`
}

func main() {
    // Encoder: scrive JSON a stream (file, network)
    file, _ := os.Create("logs.json")
    defer file.Close()
    
    encoder := json.NewEncoder(file)
    encoder.SetIndent("", "  ")
    
    logs := []LogEntry{
        {"2025-01-01 10:00:00", "INFO", "Server started"},
        {"2025-01-01 10:01:23", "WARN", "High memory usage"},
        {"2025-01-01 10:05:45", "ERROR", "Connection failed"},
    }
    
    for _, log := range logs {
        encoder.Encode(log)  // Scrive ogni log come riga JSON
    }
    
    // Decoder: legge JSON da stream
    file2, _ := os.Open("logs.json")
    defer file2.Close()
    
    decoder := json.NewDecoder(file2)
    
    fmt.Println("Decoded logs:")
    for decoder.More() {  // Finché ci sono dati
        var log LogEntry
        if err := decoder.Decode(&log); err != nil {
            break
        }
        fmt.Printf("[%s] %s: %s\n", log.Timestamp, log.Level, log.Message)
    }
    
    os.Remove("logs.json")  // Cleanup
}
```

### Esempio Completo: API Response Parser

```go
package main

import (
    "encoding/json"
    "fmt"
    "time"
)

// API Response structure
type APIResponse struct {
    Status  string `json:"status"`
    Code    int    `json:"code"`
    Data    Data   `json:"data,omitempty"`
    Error   string `json:"error,omitempty"`
}

type Data struct {
    Users []User `json:"users"`
    Total int    `json:"total"`
}

type User struct {
    ID        int       `json:"id"`
    Username  string    `json:"username"`
    Email     string    `json:"email"`
    CreatedAt time.Time `json:"created_at"`
    IsActive  bool      `json:"is_active"`
}

// Simula risposta API
func fetchUsers() ([]byte, error) {
    response := APIResponse{
        Status: "success",
        Code:   200,
        Data: Data{
            Users: []User{
                {
                    ID:        1,
                    Username:  "alice",
                    Email:     "alice@example.com",
                    CreatedAt: time.Now(),
                    IsActive:  true,
                },
                {
                    ID:        2,
                    Username:  "bob",
                    Email:     "bob@example.com",
                    CreatedAt: time.Now().Add(-24 * time.Hour),
                    IsActive:  false,
                },
            },
            Total: 2,
        },
    }
    
    return json.MarshalIndent(response, "", "  ")
}

func parseResponse(jsonData []byte) error {
    var response APIResponse
    
    if err := json.Unmarshal(jsonData, &response); err != nil {
        return fmt.Errorf("failed to parse JSON: %w", err)
    }
    
    fmt.Printf("Status: %s (Code: %d)\n", response.Status, response.Code)
    
    if response.Status == "error" {
        return fmt.Errorf("API error: %s", response.Error)
    }
    
    fmt.Printf("\n=== Users (%d total) ===\n", response.Data.Total)
    for _, user := range response.Data.Users {
        status := "inactive"
        if user.IsActive {
            status = "active"
        }
        fmt.Printf("ID: %d | %s (%s) | %s | Created: %s\n",
            user.ID,
            user.Username,
            user.Email,
            status,
            user.CreatedAt.Format("2006-01-02"),
        )
    }
    
    return nil
}

func main() {
    // Fetch (simulate)
    jsonData, err := fetchUsers()
    if err != nil {
        fmt.Println("Error fetching:", err)
        return
    }
    
    fmt.Println("=== Raw JSON ===")
    fmt.Println(string(jsonData))
    
    // Parse
    fmt.Println("\n=== Parsed Data ===")
    if err := parseResponse(jsonData); err != nil {
        fmt.Println("Error:", err)
    }
}
```

### Comandi Utili

```bash
# Esegui
go run main.go

# Build
go build -o jsonapp main.go

# Formattazione
go fmt main.go

# Valida JSON con jq (tool esterno)
echo '{"name":"test"}' | jq .

# Pretty print JSON file
jq . < data.json
```

### File da Creare
- `main.go` - Programma che marshal/unmarshal JSON

### Test da Passare
1. ✅ Build success
2. ✅ Marshal struct to JSON
3. ✅ Unmarshal JSON to struct
4. ✅ Usa struct tags (`json:"name"`)
5. ✅ Error handling su Unmarshal
6. ✅ Almeno un esempio con nested struct o array
7. ✅ gofmt compliant

### Esempio di Output Atteso

```
=== Marshal Demo ===
{
  "name": "Alice",
  "age": 30,
  "email": "alice@example.com"
}

=== Unmarshal Demo ===
Name: Bob
Age: 25

=== API Response ===
Status: success (Code: 200)

=== Users (2 total) ===
ID: 1 | alice (alice@example.com) | active | Created: 2025-01-15
ID: 2 | bob (bob@example.com) | inactive | Created: 2025-01-14
```

## Requisiti
- [ ] Marshal almeno una struct in JSON
- [ ] Unmarshal JSON in struct
- [ ] Usa struct tags (`json:"name"`, `omitempty`)
- [ ] Error handling su Marshal/Unmarshal
- [ ] Pretty-print con MarshalIndent (opzionale)
- [ ] Nested structs o arrays (opzionale)
- [ ] Commenti dove necessario
- [ ] `go fmt` applied

## Risorse
- [Package encoding/json](https://pkg.go.dev/encoding/json)
- [Go by Example - JSON](https://gobyexample.com/json)
- [Go JSON Tutorial](https://go.dev/blog/json)
- [JSON and Go](https://go.dev/blog/json-and-go)
- [Effective Go - Interface conversions](https://go.dev/doc/effective_go#interface_conversions)

## Note

**Best Practices:**
- Usa struct tags per nomi field custom
- `omitempty` per optional fields
- Controlla sempre errore su Unmarshal
- Usa `time.Time` per date (auto-parsing RFC3339)
- Encoder/Decoder per streaming (file/network)
- Evita `map[string]interface{}` se conosci la struttura

**Errori comuni:**
- Field non esportati (lowercase) → ignorati da JSON
- Dimenticare `&` in Unmarshal: `json.Unmarshal(data, &struct)`
- Type assertion su `interface{}` senza check → panic
- JSON numbers diventano `float64`, non `int`

**Formati date comuni:**
- `time.RFC3339` - "2006-01-02T15:04:05Z07:00"
- `time.DateTime` - "2006-01-02 15:04:05"
- Custom format con `time.Parse()` / `time.Format()`

Consulta STUDY.md per esempi specifici e best practices Go.
