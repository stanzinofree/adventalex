# Hello + Cargo

## Obiettivo

Creare il tuo **primo progetto Rust** usando **Cargo**, il build system e package manager ufficiale di Rust. Imparerai la struttura base di un progetto Rust, come compilare ed eseguire programmi, e i comandi fondamentali di Cargo.

### Contesto Pratico

Rust è un linguaggio **systems programming** focalizzato su:
- **Memory safety** senza garbage collector
- **Performance** comparabile a C/C++
- **Concurrency** sicura a compile-time
- **Zero-cost abstractions**

Cargo è lo strumento centrale dell'ecosistema Rust:
- Build system automatico
- Package manager (crates.io)
- Test runner integrato
- Documentation generator
- Dependency management

In real-world projects:
- **CLI tools**: ripgrep, fd, bat, exa (alternative Rust a grep, find, cat, ls)
- **System tools**: compilatori, database, web servers
- **Embedded**: IoT, microcontrollori
- **WebAssembly**: applicazioni browser performanti

### Installazione Rust

```bash
# Installa rustup (gestore versioni Rust)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Verifica installazione
rustc --version  # Compilatore Rust
cargo --version  # Build tool

# Update Rust
rustup update
```

### Struttura Progetto Cargo

```bash
# Crea nuovo progetto
cargo new hello_rust
cd hello_rust

# Struttura creata:
hello_rust/
├── Cargo.toml          # Manifest file (dipendenze, metadata)
├── Cargo.lock          # Lock file dipendenze (auto-generato)
├── src/
│   └── main.rs         # Entrypoint programma
└── target/             # Directory build output (gitignored)
```

### Cargo.toml - Manifest File

```toml
[package]
name = "hello_rust"
version = "0.1.0"
edition = "2021"        # Rust edition (2015, 2018, 2021, 2024)

[dependencies]
# Dipendenze esterne (da crates.io)
# serde = "1.0"
# tokio = { version = "1.0", features = ["full"] }
```

**Sezioni importanti:**
- `[package]` - Metadata del progetto
- `[dependencies]` - Librerie esterne
- `[dev-dependencies]` - Solo per test/bench
- `edition` - Versione linguaggio (backward compatible)

### main.rs - Hello World

```rust
fn main() {
    println!("Hello, world!");
}
```

**Anatomia:**
- `fn main()` - Entry point (come C, Go, Java)
- `println!()` - Macro (nota il `!`) per print con newline
- No return: `main()` ritorna implicitamente `()`
- No `;` all'ultima espressione di un blocco

### Comandi Cargo Fondamentali

```bash
# Build (debug mode, più veloce da compilare)
cargo build
# Output: ./target/debug/hello_rust

# Build + Run in un comando
cargo run

# Build ottimizzato (release mode, più lento da compilare, eseguibile veloce)
cargo build --release
# Output: ./target/release/hello_rust

# Controlla errori senza generare binary (veloce!)
cargo check

# Run test
cargo test

# Genera documentazione
cargo doc --open

# Pulisci artifacts
cargo clean
```

### Debug vs Release Mode

```bash
# Debug (default): compilazione veloce, esecuzione lenta
cargo build
# - Ottimizzazioni disabilitate
# - Debug symbols inclusi
# - Assertions abilitate
# - Binary più grande

# Release: compilazione lenta, esecuzione veloce
cargo build --release
# - Ottimizzazioni massime (-O3)
# - No debug symbols
# - Assertions disabilitate (tranne overflow checks)
# - Binary più piccolo e ottimizzato
```

**Performance difference:** release può essere 10-100x più veloce!

### Esempio Hello World Esteso

```rust
fn main() {
    // println! è una macro (nota il !)
    println!("=== Rust Hello World ===");
    
    // Formatting
    let language = "Rust";
    let year = 2025;
    println!("Language: {}", language);
    println!("Year: {}", year);
    
    // Named arguments
    println!("{lang} was created in {year}", lang = language, year = 2010);
    
    // Debug formatting (per tipi complessi)
    let numbers = vec![1, 2, 3, 4, 5];
    println!("Numbers: {:?}", numbers);  // Debug format
    println!("Numbers pretty: {:#?}", numbers);  // Pretty debug
    
    // Format specifiers
    let pi = 3.141592653589793;
    println!("Pi: {:.2}", pi);  // 2 decimal places
    
    println!("\n✓ Rust setup complete!");
}
```

### Macro println! vs print!

```rust
fn main() {
    // println! - con newline
    println!("Line 1");
    println!("Line 2");
    
    // print! - senza newline
    print!("No newline ");
    print!("here!");
    println!();  // Newline vuota
    
    // eprintln! - stampa su stderr
    eprintln!("This goes to stderr");
}
```

### Esempio Completo: System Info

```rust
use std::env;

fn main() {
    println!("=== Rust System Info ===\n");
    
    // Rust version (da variabile compile-time)
    println!("Rust version: {}", env!("CARGO_PKG_VERSION"));
    
    // OS info
    let os = env::consts::OS;
    let arch = env::consts::ARCH;
    println!("OS: {} ({})", os, arch);
    
    // Current directory
    match env::current_dir() {
        Ok(path) => println!("Working dir: {}", path.display()),
        Err(e) => eprintln!("Error getting dir: {}", e),
    }
    
    // Environment variable
    match env::var("HOME") {
        Ok(home) => println!("Home: {}", home),
        Err(_) => println!("HOME not set"),
    }
    
    // Args
    let args: Vec<String> = env::args().collect();
    if args.len() > 1 {
        println!("\nArguments received:");
        for (i, arg) in args.iter().skip(1).enumerate() {
            println!("  {}: {}", i + 1, arg);
        }
    }
    
    println!("\n✓ Rust is working!");
}
```

### Comandi Utili

```bash
# Crea progetto
cargo new my_project

# Build e run
cargo run

# Build release
cargo build --release

# Run con argomenti
cargo run -- arg1 arg2

# Check senza build
cargo check

# Formattazione automatica
cargo fmt

# Linting (Clippy - molto utile!)
cargo clippy

# Run tests
cargo test

# Benchmark
cargo bench

# Clean build artifacts
cargo clean

# Update dependencies
cargo update

# Aggiungi dipendenza
cargo add serde
```

### File da Creare
- Progetto Cargo completo con `src/main.rs`

### Test da Passare
1. ✅ `cargo build` compila senza errori
2. ✅ `cargo run` esegue e stampa output
3. ✅ `cargo test` passa (se ci sono test)
4. ✅ `cargo check` non riporta errori
5. ✅ `cargo fmt` non modifica nulla (già formattato)
6. ✅ `cargo clippy` non riporta warning

### Esempio di Output Atteso

```bash
$ cargo run
   Compiling hello_rust v0.1.0 (/path/to/hello_rust)
    Finished dev [unoptimized + debuginfo] target(s) in 0.50s
     Running `target/debug/hello_rust`

=== Rust Hello World ===
Language: Rust
Year: 2025
Rust was created in 2010
Numbers: [1, 2, 3, 4, 5]
Pi: 3.14

✓ Rust setup complete!
```

## Requisiti
- [ ] Crea progetto con `cargo new`
- [ ] Implementa `main()` function
- [ ] Usa `println!()` per stampare output
- [ ] Compila con `cargo build`
- [ ] Esegui con `cargo run`
- [ ] Formatta con `cargo fmt`
- [ ] Codice funzionante e leggibile

## Risorse
- [The Rust Book - Getting Started](https://doc.rust-lang.org/book/ch01-00-getting-started.html)
- [The Rust Book - Hello, Cargo!](https://doc.rust-lang.org/book/ch01-03-hello-cargo.html)
- [Cargo Book](https://doc.rust-lang.org/cargo/)
- [Rust by Example - Hello World](https://doc.rust-lang.org/rust-by-example/hello.html)
- [println! macro](https://doc.rust-lang.org/std/macro.println.html)

## Note

**Rust editions:**
- 2015 - Originale
- 2018 - Module system migliorato
- 2021 - Closures migliorate, IntoIterator
- **2024** - Ultima edition (usa questa!)

**Best practices:**
- Sempre `cargo fmt` prima di commit
- Sempre `cargo clippy` per trovare problemi
- Debug build per sviluppo, release per distribuzione
- `.gitignore` deve includere `/target/` e `Cargo.lock` (per libraries)

**Differenze da altri linguaggi:**
- `!` dopo nome indica **macro**, non funzione
- No garbage collector (ownership system invece)
- Immutabilità di default (`let x` è immutabile, serve `let mut x`)
- Strict type checking a compile-time

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
