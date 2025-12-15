# Slices & Maps

## Obiettivo

Imparare a utilizzare **slices** e **maps**, le due collezioni dinamiche fondamentali in Go. A differenza degli array (fissi), le slice sono viste dinamiche su array sottostanti, mentre le map sono strutture chiave-valore simili ai dict di Python o agli oggetti JavaScript.

### Contesto Pratico

Quando lavori con Go, userai quasi sempre slice invece di array:
- **Slice**: ideali per liste di dati di lunghezza variabile (log entries, file lines, API results)
- **Map**: perfette per lookup veloci (configurazioni, cache, contatori)
- **Combinazioni**: map di slice, slice di struct, ecc.

In real-world code, potresti usare:
- Slice per accumulare risultati di query
- Map per contare occorrenze di parole/eventi
- Map per cachare dati frequentemente acceduti
- Slice per processare batch di dati

### Differenze Chiave: Array vs Slice

```go
// Array - dimensione fissa, parte del tipo
var arr [5]int           // Array di 5 interi
arr := [3]string{"a", "b", "c"}

// Slice - dimensione dinamica, reference type
var s []int              // Slice di interi (nil inizialmente)
s := []string{"a", "b", "c"}
s := make([]int, 5)      // Slice di 5 interi inizializzati a zero
s := make([]int, 0, 10)  // Slice vuota con capacità 10
```

### Operazioni su Slice

```go
package main

import "fmt"

func main() {
    // Creazione
    numbers := []int{1, 2, 3, 4, 5}
    
    // Append (aggiunge elementi)
    numbers = append(numbers, 6, 7)
    
    // Slicing (crea sub-slice)
    subset := numbers[1:4]  // Elementi da indice 1 a 3 (esclude 4)
    first3 := numbers[:3]   // Primi 3 elementi
    last2 := numbers[len(numbers)-2:]  // Ultimi 2 elementi
    
    // Lunghezza e capacità
    fmt.Printf("len=%d cap=%d\n", len(numbers), cap(numbers))
    
    // Iterazione
    for i, v := range numbers {
        fmt.Printf("numbers[%d] = %d\n", i, v)
    }
    
    // Solo valori (ignora indice)
    for _, v := range numbers {
        fmt.Println(v)
    }
}
```

### Operazioni su Map

```go
package main

import "fmt"

func main() {
    // Creazione (con make)
    ages := make(map[string]int)
    
    // Literal initialization
    scores := map[string]int{
        "Alice": 100,
        "Bob":   85,
        "Carol": 92,
    }
    
    // Inserimento/Update
    ages["Alice"] = 30
    ages["Bob"] = 25
    
    // Lettura
    age := ages["Alice"]  // Se chiave non esiste, ritorna zero value
    
    // Check esistenza (idiom Go importante!)
    if age, ok := ages["Charlie"]; ok {
        fmt.Println("Charlie age:", age)
    } else {
        fmt.Println("Charlie not found")
    }
    
    // Cancellazione
    delete(ages, "Bob")
    
    // Iterazione (ordine NON garantito!)
    for name, score := range scores {
        fmt.Printf("%s: %d\n", name, score)
    }
}
```

### Esempio Completo: Word Counter

```go
package main

import (
    "fmt"
    "strings"
)

func main() {
    text := "go is awesome go is fast go is simple"
    
    // Split in parole
    words := strings.Fields(text)
    
    // Conta occorrenze con map
    wordCount := make(map[string]int)
    
    for _, word := range words {
        wordCount[word]++  // Se chiave non esiste, parte da 0
    }
    
    // Stampa risultati
    fmt.Println("=== Word Count ===")
    for word, count := range wordCount {
        fmt.Printf("%s: %d\n", word, count)
    }
}
```

### Comandi Utili

```bash
# Compila ed esegui
go run main.go

# Build ottimizzato
go build -o slices_maps main.go

# Formattazione automatica
go fmt main.go

# Verifica errori comuni
go vet main.go
```

### File da Creare
- `main.go` - Programma che dimostra uso di slice e map

### Test da Passare
1. ✅ Build success (`go build` senza errori)
2. ✅ Run success (programma termina con exit 0)
3. ✅ Funzionalità implementata (usa sia slice che map)
4. ✅ Go idioms seguiti (check ok per map, range corretto)
5. ✅ gofmt compliant (`go fmt` non modifica nulla)

### Esempio di Output Atteso

```
=== Slice Operations ===
Original: [1 2 3 4 5]
After append: [1 2 3 4 5 6 7]
Subset [1:4]: [2 3 4]
Length: 7, Capacity: 10

=== Map Operations ===
Alice: 30
Bob: 25
Charlie not found

=== Word Count ===
go: 3
is: 3
awesome: 1
fast: 1
simple: 1
```

## Requisiti
- [ ] Crea e manipola almeno una slice
- [ ] Crea e manipola almeno una map
- [ ] Usa append() su slice
- [ ] Usa il pattern `if v, ok := map[key]; ok` per check sicuro
- [ ] Itera con range su slice e map
- [ ] Error handling appropriato
- [ ] Commenti dove necessario
- [ ] `go fmt` applied

## Risorse
- [Go Tour - Slices](https://go.dev/tour/moretypes/7)
- [Go Tour - Maps](https://go.dev/tour/moretypes/19)
- [Effective Go - Slices](https://go.dev/doc/effective_go#slices)
- [Go by Example - Slices](https://gobyexample.com/slices)
- [Go by Example - Maps](https://gobyexample.com/maps)

## Note

**Gotchas importanti:**
- Le slice condividono l'array sottostante - attenzione alle modifiche!
- Le map NON hanno ordine garantito nell'iterazione
- Il valore zero di una map è `nil` - usa `make()` prima di inserire
- `append()` può riallocare - riassegna sempre il risultato: `s = append(s, x)`

Consulta STUDY.md per esempi specifici e best practices Go.
