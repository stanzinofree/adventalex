# Hello + Build

## Obiettivo

Creare il primo programma Go, comprendere la struttura base di un progetto Go e il processo di **build/run**.

Il programma deve:
- Usare package main
- Implementare func main()
- Stampare output su stdout
- Compilare con `go build`
- Eseguire direttamente con `go run`

### Contesto Pratico
Primo passo in Go per:
- Verificare installazione Go corretta
- Comprendere struttura progetto minima
- Differenza tra `go run` (compile+run) e `go build` (solo compile)
- Workflow sviluppo base
- Preparazione per tool CLI futuri

### File da Creare
- `main.go`

### Test da Passare
1. Go compiler presente (`go version`)
2. `go build` compila senza errori
3. Eseguibile creato funziona
4. `go run main.go` esegue correttamente
5. Output contiene testo atteso

### Struttura Minima
```go
package main

import "fmt"

func main() {
    fmt.Println("=== Go Hello ===")
    fmt.Println("Language: Go")
    fmt.Println("Status: OK")
}
```

### Comandi Go Essenziali
```bash
# Run diretto (compila + esegue)
go run main.go

# Build eseguibile
go build -o myapp main.go
./myapp

# Build ottimizzato per produzione
go build -ldflags="-s -w" -o myapp main.go

# Verifica codice
go fmt main.go
go vet main.go
```

### Struttura Package
- `package main` = eseguibile
- `package mylib` = libreria
- `func main()` = entry point
- `import` = dipendenze

## Requisiti
- [ ] Package main dichiarato
- [ ] func main() implementata
- [ ] Output su stdout
- [ ] Build senza errori
- [ ] Eseguibile funziona

## Risorse
- [Go Tour - Basics](https://go.dev/tour/basics)
- [Effective Go](https://go.dev/doc/effective_go)
- [Go by Example - Hello World](https://gobyexample.com/hello-world)

## Note
Questo è il pattern base per tutti i tool CLI Go che scriverai!
