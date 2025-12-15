# Variables & Types

## Obiettivo

Imparare a dichiarare **variabili e tipi** in Go, comprendere type system statico e type inference.

Concetti da padroneggiare:
- Dichiarazione var vs := (short declaration)
- Tipi base (int, float64, string, bool)
- Zero values (default values)
- Type inference
- Costanti con const

### Contesto Pratico
Go ha type system statico ma con inference intelligente:
- Nessuna conversione implicita (safety)
- Type inference riduce verbosità
- Zero values prevengono undefined behavior
- Costanti compile-time ottimizzate

### File da Creare
- `main.go`

### Test da Passare
1. Dichiarazioni var e :=
2. Diversi tipi dimostrati
3. Zero values mostrati
4. Costanti usate
5. Type inference funzionante

### Esempi Codice
```go
package main

import "fmt"

func main() {
    // Dichiarazione esplicita
    var name string = "Alice"
    var age int = 30
    
    // Type inference
    var city = "Rome"  // string inferred
    
    // Short declaration (solo in funzioni)
    active := true
    score := 95.5
    
    // Zero values
    var count int        // 0
    var message string   // ""
    var enabled bool     // false
    
    // Costanti
    const Pi = 3.14159
    const AppName = "MyApp"
    
    // Multiple declaration
    var (
        x int
        y float64
        z string
    )
    
    fmt.Printf("Name: %s, Age: %d\n", name, age)
    fmt.Printf("Score: %.2f, Active: %t\n", score, active)
}
```

### Tipi Base in Go
- `int`, `int8`, `int16`, `int32`, `int64`
- `uint`, `uint8`, `uint16`, `uint32`, `uint64`
- `float32`, `float64`
- `string`
- `bool`
- `byte` (alias per uint8)
- `rune` (alias per int32, Unicode point)

### Zero Values
- Numerici: `0`
- String: `""`
- Boolean: `false`
- Pointer/slice/map/channel/func/interface: `nil`

## Requisiti
- [ ] var e := usati correttamente
- [ ] Tipi diversi dimostrati
- [ ] Zero values mostrati
- [ ] Const definite
- [ ] Output formattato

## Risorse
- [Go Tour - Basic Types](https://go.dev/tour/basics/11)
- [Go by Example - Variables](https://gobyexample.com/variables)
- [Go Spec - Types](https://go.dev/ref/spec#Types)

## Note
In Go, dichiarare una variabile senza usarla è errore di compilazione!
