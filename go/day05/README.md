# File I/O

## Obiettivo

Imparare a **leggere e scrivere file** in Go usando i package `os` e `io`. Go offre diverse API per file operations, da quelle high-level (ReadFile/WriteFile) a quelle low-level (Read/Write con buffer), ognuna adatta a casi d'uso diversi.

### Contesto Pratico

File I/O è una delle operazioni più comuni in programmazione:
- **Configurazioni**: leggere file .env, .yaml, .json
- **Log processing**: analizzare log files da GB di dati
- **Data pipelines**: leggere CSV, trasformare, scrivere output
- **Backup/Restore**: copiare file, creare archivi
- **System monitoring**: leggere /proc files (Linux)

In Go, il pattern standard è:
1. Aprire file con `os.Open()` o `os.Create()`
2. Usare `defer file.Close()` per garantire chiusura
3. Leggere/scrivere con `io.Reader`/`io.Writer` interfaces
4. Gestire errori esplicitamente

### API High-Level: ReadFile / WriteFile

Per file piccoli (< 10 MB), usa le funzioni convenience:

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    // Scrivere file (crea o sovrascrive)
    data := []byte("Hello, Go!\nFile I/O is easy.\n")
    err := os.WriteFile("output.txt", data, 0644)
    if err != nil {
        fmt.Println("Error writing:", err)
        return
    }
    
    // Leggere file intero in memoria
    content, err := os.ReadFile("output.txt")
    if err != nil {
        fmt.Println("Error reading:", err)
        return
    }
    
    fmt.Printf("File content:\n%s", content)
}
```

**Quando usare:**
- File di configurazione (KB)
- File di testo piccoli
- Quando puoi permetterti di caricare tutto in memoria

**Quando NON usare:**
- File grandi (> 10 MB) - rischio OutOfMemory
- Streaming di dati
- Lettura parziale

### API Low-Level: Open / Create + Read / Write

Per file grandi o streaming, usa `os.Open()` con buffering:

```go
package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    // Creare e scrivere
    file, err := os.Create("data.txt")
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    defer file.Close()  // Garantisce chiusura
    
    // Writer con buffer (più efficiente)
    writer := bufio.NewWriter(file)
    writer.WriteString("Line 1\n")
    writer.WriteString("Line 2\n")
    writer.WriteString("Line 3\n")
    writer.Flush()  // Importante: scrive buffer su disco
    
    // Leggere riga per riga
    file2, err := os.Open("data.txt")
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    defer file2.Close()
    
    scanner := bufio.NewScanner(file2)
    lineNum := 1
    for scanner.Scan() {
        line := scanner.Text()
        fmt.Printf("%d: %s\n", lineNum, line)
        lineNum++
    }
    
    if err := scanner.Err(); err != nil {
        fmt.Println("Error scanning:", err)
    }
}
```

### Modalità di Apertura File

```go
// Lettura (file deve esistere)
file, err := os.Open("file.txt")

// Scrittura (crea o tronca)
file, err := os.Create("file.txt")

// Append (aggiungi senza truncare)
file, err := os.OpenFile("file.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)

// Lettura + Scrittura
file, err := os.OpenFile("file.txt", os.O_RDWR|os.O_CREATE, 0644)
```

**Flag comuni:**
- `os.O_RDONLY` - Read only
- `os.O_WRONLY` - Write only
- `os.O_RDWR` - Read + Write
- `os.O_APPEND` - Append mode
- `os.O_CREATE` - Crea se non esiste
- `os.O_TRUNC` - Tronca se esiste

### Permessi File (Unix)

Il terzo parametro è un file mode (octal):

```go
0644  // rw-r--r-- (owner: read/write, group: read, others: read)
0755  // rwxr-xr-x (owner: rwx, group: rx, others: rx)
0600  // rw------- (solo owner può leggere/scrivere)
```

### Controllare Esistenza File

```go
package main

import (
    "fmt"
    "os"
)

func fileExists(filename string) bool {
    _, err := os.Stat(filename)
    return err == nil
}

func main() {
    if fileExists("config.txt") {
        fmt.Println("File exists!")
    } else {
        fmt.Println("File not found")
    }
    
    // Distinguere errore "not exist" da altri errori
    info, err := os.Stat("file.txt")
    if os.IsNotExist(err) {
        fmt.Println("File does not exist")
    } else if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Printf("File size: %d bytes\n", info.Size())
        fmt.Printf("Modified: %s\n", info.ModTime())
        fmt.Printf("Is directory: %v\n", info.IsDir())
    }
}
```

### Esempio Completo: Log File Analyzer

```go
package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"
)

// Analizza log file e conta errori/warning
func analyzeLogs(filename string) (errors, warnings, total int, err error) {
    file, err := os.Open(filename)
    if err != nil {
        return 0, 0, 0, fmt.Errorf("cannot open %s: %w", filename, err)
    }
    defer file.Close()
    
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()
        total++
        
        if strings.Contains(line, "ERROR") {
            errors++
        } else if strings.Contains(line, "WARN") {
            warnings++
        }
    }
    
    if err := scanner.Err(); err != nil {
        return 0, 0, 0, fmt.Errorf("error scanning: %w", err)
    }
    
    return errors, warnings, total, nil
}

// Genera report file
func writeReport(filename string, errors, warnings, total int) error {
    file, err := os.Create(filename)
    if err != nil {
        return err
    }
    defer file.Close()
    
    writer := bufio.NewWriter(file)
    defer writer.Flush()
    
    fmt.Fprintf(writer, "=== Log Analysis Report ===\n")
    fmt.Fprintf(writer, "Total lines: %d\n", total)
    fmt.Fprintf(writer, "Errors:      %d (%.1f%%)\n", errors, float64(errors)/float64(total)*100)
    fmt.Fprintf(writer, "Warnings:    %d (%.1f%%)\n", warnings, float64(warnings)/float64(total)*100)
    
    return nil
}

func main() {
    // Crea file di log di esempio
    logFile := "app.log"
    sampleLogs := `2025-01-01 10:00:00 INFO Application started
2025-01-01 10:01:23 WARN Low memory
2025-01-01 10:05:45 ERROR Connection failed
2025-01-01 10:06:12 INFO Retrying...
2025-01-01 10:06:15 ERROR Timeout
`
    
    err := os.WriteFile(logFile, []byte(sampleLogs), 0644)
    if err != nil {
        fmt.Println("Error creating log:", err)
        return
    }
    defer os.Remove(logFile)  // Cleanup
    
    // Analizza logs
    errors, warnings, total, err := analyzeLogs(logFile)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    
    fmt.Printf("Analyzed %d lines: %d errors, %d warnings\n", total, errors, warnings)
    
    // Genera report
    reportFile := "report.txt"
    err = writeReport(reportFile, errors, warnings, total)
    if err != nil {
        fmt.Println("Error writing report:", err)
        return
    }
    defer os.Remove(reportFile)  // Cleanup
    
    // Mostra report
    report, _ := os.ReadFile(reportFile)
    fmt.Printf("\n%s", report)
}
```

### Comandi Utili

```bash
# Esegui programma
go run main.go

# Build
go build -o fileio main.go

# Verifica file creati
ls -lh *.txt

# Leggi file creato
cat output.txt

# Formatta codice
go fmt main.go

# Controlla errori
go vet main.go
```

### File da Creare
- `main.go` - Programma che legge e scrive file

### Test da Passare
1. ✅ Build success (`go build` senza errori)
2. ✅ Run success (programma termina con exit 0)
3. ✅ Scrive almeno un file
4. ✅ Legge almeno un file
5. ✅ Usa `defer file.Close()` correttamente
6. ✅ Error handling su tutte le operazioni I/O
7. ✅ gofmt compliant

### Esempio di Output Atteso

```
=== File I/O Demo ===
Writing to file... done
Reading from file... done

File content:
Hello, Go!
File I/O is easy.

=== Log Analysis ===
Analyzed 5 lines: 2 errors, 1 warnings

=== Log Analysis Report ===
Total lines: 5
Errors:      2 (40.0%)
Warnings:    1 (20.0%)
```

## Requisiti
- [ ] Leggi almeno un file (ReadFile o Open+Scanner)
- [ ] Scrivi almeno un file (WriteFile o Create+Writer)
- [ ] Usa `defer file.Close()` per ogni file aperto
- [ ] Error handling su tutte le operazioni I/O
- [ ] Check esistenza file con `os.Stat()` (opzionale)
- [ ] Buffered I/O per efficienza (opzionale)
- [ ] Commenti dove necessario
- [ ] `go fmt` applied

## Risorse
- [Go by Example - Reading Files](https://gobyexample.com/reading-files)
- [Go by Example - Writing Files](https://gobyexample.com/writing-files)
- [Package os](https://pkg.go.dev/os)
- [Package io](https://pkg.go.dev/io)
- [Package bufio](https://pkg.go.dev/bufio)
- [Effective Go - Data](https://go.dev/doc/effective_go#data)

## Note

**Best Practices:**
- Sempre `defer file.Close()` dopo apertura file
- Controlla errori su ogni operazione I/O
- Usa `bufio` per file grandi (migliori performance)
- Usa `os.ReadFile`/`WriteFile` per file piccoli (più semplice)
- Scanner automaticamente gestisce `\n` e `\r\n`
- `writer.Flush()` è necessario per scrivere buffer su disco

**Errori comuni:**
- Dimenticare `defer file.Close()` → file descriptor leak
- Non controllare errori → dati corrotti non rilevati
- Non fare `Flush()` su Writer → dati persi
- Caricare file giganti con ReadFile → OutOfMemory

Consulta STUDY.md per esempi specifici e best practices Go.
