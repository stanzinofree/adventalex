# CLI Flags

## Obiettivo

Imparare a creare **tool CLI professionali** in Go usando il package `flag` per parsing di argomenti command-line. Go è eccellente per CLI tools grazie a compilazione statica, velocità, e portabilità (single binary).

### Contesto Pratico

CLI tools sono ovunque in DevOps/SysAdmin:
- **git**: `git commit -m "message" --amend`
- **docker**: `docker run -d -p 8080:80 nginx`
- **kubectl**: `kubectl get pods -n production --watch`
- **Custom tools**: deployment scripts, automation, monitoring

In Go, il package `flag` permette di:
- Definire flag con tipo (string, int, bool)
- Parsing automatico con validazione
- Help message automatico (-h / --help)
- Supporto per flag e positional arguments

### Sintassi Base del Package flag

```go
package main

import (
    "flag"
    "fmt"
)

func main() {
    // Definisci flag
    name := flag.String("name", "World", "Nome da salutare")
    count := flag.Int("count", 1, "Numero di volte")
    verbose := flag.Bool("verbose", false, "Modalità verbose")
    
    // Parsing (deve essere chiamato prima di usare i flag)
    flag.Parse()
    
    // Usa i flag (sono puntatori!)
    if *verbose {
        fmt.Println("Verbose mode enabled")
    }
    
    for i := 0; i < *count; i++ {
        fmt.Printf("Hello, %s!\n", *name)
    }
}
```

**Uso:**
```bash
go run main.go -name Alice -count 3
go run main.go -name Bob -verbose
go run main.go -h  # Mostra help automatico
```

### Flag vs FlagVar (Variabili Esistenti)

```go
package main

import (
    "flag"
    "fmt"
)

func main() {
    // Metodo 1: flag.String ritorna puntatore
    name1 := flag.String("name", "default", "description")
    
    // Metodo 2: flag.StringVar assegna a variabile esistente
    var name2 string
    flag.StringVar(&name2, "user", "admin", "Username")
    
    flag.Parse()
    
    fmt.Println("Name1:", *name1)  // Dereferenzia puntatore
    fmt.Println("Name2:", name2)   // Già valore
}
```

**Quando usare StringVar:**
- Vuoi usare variabile senza puntatore
- Variabile è parte di una struct config
- Più chiaro per team non-Go

### Tipi di Flag Supportati

```go
package main

import (
    "flag"
    "fmt"
    "time"
)

func main() {
    // Tipi built-in
    strFlag := flag.String("str", "default", "String flag")
    intFlag := flag.Int("int", 42, "Int flag")
    boolFlag := flag.Bool("bool", false, "Bool flag")
    float64Flag := flag.Float64("float", 3.14, "Float64 flag")
    durationFlag := flag.Duration("timeout", 30*time.Second, "Timeout duration")
    
    flag.Parse()
    
    fmt.Printf("String:   %s\n", *strFlag)
    fmt.Printf("Int:      %d\n", *intFlag)
    fmt.Printf("Bool:     %v\n", *boolFlag)
    fmt.Printf("Float:    %.2f\n", *float64Flag)
    fmt.Printf("Duration: %s\n", *durationFlag)
}
```

**Uso:**
```bash
go run main.go -str hello -int 100 -bool -float 2.71 -timeout 1m30s
```

### Positional Arguments (Non-Flag)

```go
package main

import (
    "flag"
    "fmt"
)

func main() {
    verbose := flag.Bool("v", false, "Verbose mode")
    flag.Parse()
    
    // Argomenti non-flag (dopo parsing)
    args := flag.Args()
    
    if len(args) == 0 {
        fmt.Println("Usage: program [flags] <file1> <file2> ...")
        return
    }
    
    if *verbose {
        fmt.Printf("Processing %d files\n", len(args))
    }
    
    for i, file := range args {
        fmt.Printf("File %d: %s\n", i+1, file)
    }
}
```

**Uso:**
```bash
go run main.go file1.txt file2.txt          # args = [file1.txt, file2.txt]
go run main.go -v file1.txt file2.txt       # verbose + 2 files
go run main.go file1.txt -v file2.txt       # ⚠️ -v deve venire PRIMA dei positional args
```

### Custom FlagSet (Subcommands)

```go
package main

import (
    "flag"
    "fmt"
    "os"
)

func main() {
    // Simula git-like commands: program add/remove/list
    
    if len(os.Args) < 2 {
        fmt.Println("Usage: program <add|remove|list> [flags]")
        os.Exit(1)
    }
    
    // Subcommands
    addCmd := flag.NewFlagSet("add", flag.ExitOnError)
    addName := addCmd.String("name", "", "Item name")
    
    removeCmd := flag.NewFlagSet("remove", flag.ExitOnError)
    removeID := removeCmd.Int("id", 0, "Item ID")
    
    listCmd := flag.NewFlagSet("list", flag.ExitOnError)
    listVerbose := listCmd.Bool("v", false, "Verbose listing")
    
    // Parse basato su subcommand
    switch os.Args[1] {
    case "add":
        addCmd.Parse(os.Args[2:])
        if *addName == "" {
            fmt.Println("Error: -name is required")
            os.Exit(1)
        }
        fmt.Printf("Adding item: %s\n", *addName)
        
    case "remove":
        removeCmd.Parse(os.Args[2:])
        if *removeID == 0 {
            fmt.Println("Error: -id is required")
            os.Exit(1)
        }
        fmt.Printf("Removing item ID: %d\n", *removeID)
        
    case "list":
        listCmd.Parse(os.Args[2:])
        if *listVerbose {
            fmt.Println("=== Verbose Listing ===")
        }
        fmt.Println("Item 1")
        fmt.Println("Item 2")
        
    default:
        fmt.Printf("Unknown command: %s\n", os.Args[1])
        os.Exit(1)
    }
}
```

**Uso:**
```bash
go run main.go add -name "Task 1"
go run main.go remove -id 42
go run main.go list -v
```

### Esempio Completo: File Search Tool

```go
package main

import (
    "flag"
    "fmt"
    "os"
    "path/filepath"
    "strings"
)

var (
    pattern   string
    dir       string
    recursive bool
    verbose   bool
)

func init() {
    flag.StringVar(&pattern, "pattern", "", "File pattern to search (e.g., *.txt)")
    flag.StringVar(&dir, "dir", ".", "Directory to search in")
    flag.BoolVar(&recursive, "r", false, "Recursive search")
    flag.BoolVar(&verbose, "v", false, "Verbose output")
}

func searchFiles(root string, pattern string, recursive bool) ([]string, error) {
    var matches []string
    
    entries, err := os.ReadDir(root)
    if err != nil {
        return nil, err
    }
    
    for _, entry := range entries {
        path := filepath.Join(root, entry.Name())
        
        if entry.IsDir() && recursive {
            subMatches, _ := searchFiles(path, pattern, recursive)
            matches = append(matches, subMatches...)
            continue
        }
        
        if !entry.IsDir() {
            matched, _ := filepath.Match(pattern, entry.Name())
            if matched {
                matches = append(matches, path)
            }
        }
    }
    
    return matches, nil
}

func main() {
    flag.Usage = func() {
        fmt.Fprintf(os.Stderr, "File Search Tool\n\n")
        fmt.Fprintf(os.Stderr, "Usage: %s [options]\n\n", os.Args[0])
        fmt.Fprintf(os.Stderr, "Options:\n")
        flag.PrintDefaults()
        fmt.Fprintf(os.Stderr, "\nExamples:\n")
        fmt.Fprintf(os.Stderr, "  %s -pattern '*.go' -dir ./src\n", os.Args[0])
        fmt.Fprintf(os.Stderr, "  %s -pattern '*.txt' -r -v\n", os.Args[0])
    }
    
    flag.Parse()
    
    // Validazione
    if pattern == "" {
        fmt.Println("Error: -pattern is required")
        flag.Usage()
        os.Exit(1)
    }
    
    if verbose {
        fmt.Printf("Searching for '%s' in '%s'\n", pattern, dir)
        if recursive {
            fmt.Println("Recursive mode enabled")
        }
    }
    
    // Cerca file
    matches, err := searchFiles(dir, pattern, recursive)
    if err != nil {
        fmt.Printf("Error: %v\n", err)
        os.Exit(1)
    }
    
    // Output
    if len(matches) == 0 {
        fmt.Println("No files found")
        return
    }
    
    fmt.Printf("Found %d file(s):\n", len(matches))
    for _, match := range matches {
        fmt.Println("  ", match)
    }
}
```

### Comandi Utili

```bash
# Build tool
go build -o search main.go

# Usa il tool
./search -pattern '*.go' -dir . -r -v
./search -h  # Help

# Cross-compile per altri OS
GOOS=linux GOARCH=amd64 go build -o search-linux main.go
GOOS=windows GOARCH=amd64 go build -o search.exe main.go
GOOS=darwin GOARCH=arm64 go build -o search-mac main.go

# Formattazione
go fmt main.go
```

### File da Creare
- `main.go` - CLI tool con flag parsing

### Test da Passare
1. ✅ Build success (`go build` senza errori)
2. ✅ Help funziona (`./program -h` mostra usage)
3. ✅ Accetta almeno 2-3 flag diversi
4. ✅ Valida input (errore se flag richiesti mancanti)
5. ✅ Gestisce positional args (opzionale)
6. ✅ Go idioms seguiti
7. ✅ gofmt compliant

### Esempio di Output Atteso

```bash
$ ./search -h
File Search Tool

Usage: search [options]

Options:
  -dir string
        Directory to search in (default ".")
  -pattern string
        File pattern to search (e.g., *.txt)
  -r    Recursive search
  -v    Verbose output

$ ./search -pattern '*.go' -v
Searching for '*.go' in '.'
Found 3 file(s):
   main.go
   utils.go
   config.go
```

## Requisiti
- [ ] Definisci almeno 3 flag (string, int, bool o altri)
- [ ] Implementa `flag.Parse()`
- [ ] Validazione input (check flag richiesti)
- [ ] Custom usage message (opzionale)
- [ ] Gestione positional arguments (opzionale)
- [ ] Error handling appropriato
- [ ] Commenti dove necessario
- [ ] `go fmt` applied

## Risorse
- [Package flag](https://pkg.go.dev/flag)
- [Go by Example - Command-Line Flags](https://gobyexample.com/command-line-flags)
- [Go by Example - Command-Line Subcommands](https://gobyexample.com/command-line-subcommands)
- [Effective Go - Command-line flags](https://go.dev/doc/effective_go#flags)

## Note

**Best Practices:**
- Flag prima dei positional args: `program -flag value arg1 arg2`
- Valida sempre input richiesti
- Fornisci help message chiaro con esempi
- Usa nomi flag brevi (`-v`) e lunghi (`-verbose`) per tools complessi
- Exit code 0 per successo, 1 per errore

**Alternative al package flag:**
- `github.com/spf13/cobra` - Per CLI complesse (kubectl, docker style)
- `github.com/urfave/cli` - Framework CLI completo
- `github.com/jessevdk/go-flags` - Più feature del flag standard

Consulta STUDY.md per esempi specifici e best practices Go.
