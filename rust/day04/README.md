# Option & Result

## Obiettivo

Padroneggiare **`Option<T>`** e **`Result<T, E>`**, i due tipi fondamentali per **error handling idiomatico in Rust**. Questi enum sostituiscono null/exceptions di altri linguaggi, rendendo gli errori espliciti e verificabili a compile-time.

### Contesto Pratico

Rust **non ha null** e **non ha exceptions**. Invece usa:
- **`Option<T>`**: rappresenta valore che può essere assente (Some/None)
- **`Result<T, E>`**: rappresenta operazione che può fallire (Ok/Err)

Vantaggi:
- **Compile-time safety**: devi gestire errori esplicitamente
- **No null pointer exceptions**: impossibili in Rust sicuro
- **No uncaught exceptions**: tutti i path verificati
- **Performance**: zero overhead, ottimizzato dal compilatore

In produzione:
- **Database queries**: `Result<Row, DatabaseError>`
- **File I/O**: `Result<String, std::io::Error>`
- **API calls**: `Result<Response, NetworkError>`
- **Parsing**: `Result<Config, ParseError>`

### Option<T>: Valore Opzionale

```rust
fn main() {
    // Option è un enum con due varianti
    let some_number: Option<i32> = Some(5);
    let no_number: Option<i32> = None;
    
    // Pattern matching (modo più esplicito)
    match some_number {
        Some(value) => println!("Got: {}", value),
        None => println!("No value"),
    }
    
    // if let (shortcut per un solo case)
    if let Some(value) = some_number {
        println!("Value: {}", value);
    }
    
    // unwrap (⚠️ PANIC se None!)
    let x = some_number.unwrap();  // OK
    // let y = no_number.unwrap();  // ❌ PANIC!
}
```

**Definizione `Option<T>`:**
```rust
enum Option<T> {
    Some(T),
    None,
}
```

### Option Methods: Safe Unwrapping

```rust
fn main() {
    let some_value = Some(42);
    let no_value: Option<i32> = None;
    
    // unwrap_or: fornisci default
    let x = some_value.unwrap_or(0);    // 42
    let y = no_value.unwrap_or(0);      // 0
    
    // unwrap_or_else: lazy default (chiamato solo se None)
    let z = no_value.unwrap_or_else(|| {
        println!("Computing default...");
        100
    });
    
    // expect: unwrap con messaggio custom
    let a = some_value.expect("Failed to get value");
    
    // is_some / is_none
    if some_value.is_some() {
        println!("Has value");
    }
    
    // map: trasforma valore se Some
    let doubled = some_value.map(|x| x * 2);  // Some(84)
    
    // and_then: chain operations (flatMap)
    let result = some_value
        .and_then(|x| if x > 10 { Some(x * 2) } else { None });
}
```

### Result<T, E>: Operazioni Fallibili

```rust
use std::fs::File;
use std::io::Read;

fn main() {
    // Result è un enum con Ok/Err
    let result: Result<i32, String> = Ok(42);
    let error: Result<i32, String> = Err(String::from("error"));
    
    // Pattern matching
    match result {
        Ok(value) => println!("Success: {}", value),
        Err(e) => println!("Error: {}", e),
    }
    
    // File I/O ritorna Result
    match File::open("file.txt") {
        Ok(mut file) => {
            let mut contents = String::new();
            file.read_to_string(&mut contents).unwrap();
            println!("{}", contents);
        }
        Err(error) => {
            println!("Error opening file: {}", error);
        }
    }
}
```

**Definizione `Result<T, E>`:**
```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

### The ? Operator: Error Propagation

```rust
use std::fs::File;
use std::io::{self, Read};

// Vecchio stile: propagazione manuale
fn read_file_old(path: &str) -> Result<String, io::Error> {
    let mut file = match File::open(path) {
        Ok(file) => file,
        Err(e) => return Err(e),  // Propaga errore
    };
    
    let mut contents = String::new();
    match file.read_to_string(&mut contents) {
        Ok(_) => Ok(contents),
        Err(e) => Err(e),
    }
}

// Nuovo stile: operatore ? (molto più pulito!)
fn read_file_new(path: &str) -> Result<String, io::Error> {
    let mut file = File::open(path)?;  // ? propaga automaticamente
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

// Ancora più conciso
fn read_file_short(path: &str) -> Result<String, io::Error> {
    let mut contents = String::new();
    File::open(path)?.read_to_string(&mut contents)?;
    Ok(contents)
}

fn main() {
    match read_file_new("file.txt") {
        Ok(contents) => println!("File: {}", contents),
        Err(e) => eprintln!("Error: {}", e),
    }
}
```

**Come funziona `?`:**
- Se `Result` è `Ok(value)` → estrae `value`
- Se `Result` è `Err(e)` → ritorna `Err(e)` immediatamente
- Funziona solo in funzioni che ritornano `Result` o `Option`

### Result Methods

```rust
fn main() {
    let ok_result: Result<i32, String> = Ok(42);
    let err_result: Result<i32, String> = Err("error".to_string());
    
    // unwrap_or: default se Err
    let x = ok_result.unwrap_or(0);   // 42
    let y = err_result.unwrap_or(0);  // 0
    
    // map: trasforma Ok value
    let doubled = ok_result.map(|x| x * 2);  // Ok(84)
    
    // map_err: trasforma Err value
    let mapped_err = err_result.map_err(|e| format!("ERROR: {}", e));
    
    // and_then: chain operations
    let result = ok_result.and_then(|x| {
        if x > 10 {
            Ok(x * 2)
        } else {
            Err("too small".to_string())
        }
    });
    
    // or_else: handle error
    let recovered = err_result.or_else(|_| Ok(999));
    
    // is_ok / is_err
    if ok_result.is_ok() {
        println!("Success!");
    }
}
```

### Custom Error Types

```rust
use std::fmt;

// Simple error type
#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeSquareRoot,
}

impl fmt::Display for MathError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MathError::DivisionByZero => write!(f, "Division by zero"),
            MathError::NegativeSquareRoot => write!(f, "Square root of negative number"),
        }
    }
}

impl std::error::Error for MathError {}

fn divide(a: f64, b: f64) -> Result<f64, MathError> {
    if b == 0.0 {
        Err(MathError::DivisionByZero)
    } else {
        Ok(a / b)
    }
}

fn sqrt(x: f64) -> Result<f64, MathError> {
    if x < 0.0 {
        Err(MathError::NegativeSquareRoot)
    } else {
        Ok(x.sqrt())
    }
}

fn main() {
    match divide(10.0, 2.0) {
        Ok(result) => println!("10 / 2 = {}", result),
        Err(e) => println!("Error: {}", e),
    }
    
    match sqrt(-4.0) {
        Ok(result) => println!("sqrt(-4) = {}", result),
        Err(e) => println!("Error: {}", e),
    }
}
```

### Combinare Option e Result

```rust
fn main() {
    // Option → Result
    let option: Option<i32> = Some(42);
    let result: Result<i32, &str> = option.ok_or("no value");
    
    // Result → Option
    let result: Result<i32, String> = Ok(42);
    let option: Option<i32> = result.ok();  // Scarta errore
    
    // transpose: Option<Result> ↔ Result<Option>
    let x: Option<Result<i32, String>> = Some(Ok(42));
    let y: Result<Option<i32>, String> = x.transpose();
}
```

### Esempio Completo: Configuration Parser

```rust
use std::collections::HashMap;
use std::fs;

#[derive(Debug)]
enum ConfigError {
    FileNotFound,
    ParseError(String),
    MissingKey(String),
}

impl std::fmt::Display for ConfigError {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            ConfigError::FileNotFound => write!(f, "Config file not found"),
            ConfigError::ParseError(msg) => write!(f, "Parse error: {}", msg),
            ConfigError::MissingKey(key) => write!(f, "Missing key: {}", key),
        }
    }
}

struct Config {
    settings: HashMap<String, String>,
}

impl Config {
    // Carica config da file (ritorna Result)
    fn load(path: &str) -> Result<Config, ConfigError> {
        // Leggi file (? propaga errore)
        let content = fs::read_to_string(path)
            .map_err(|_| ConfigError::FileNotFound)?;
        
        // Parse content
        let mut settings = HashMap::new();
        for (line_num, line) in content.lines().enumerate() {
            let line = line.trim();
            
            // Salta commenti e righe vuote
            if line.is_empty() || line.starts_with('#') {
                continue;
            }
            
            // Parse key=value
            let parts: Vec<&str> = line.split('=').collect();
            if parts.len() != 2 {
                return Err(ConfigError::ParseError(
                    format!("Invalid format at line {}", line_num + 1)
                ));
            }
            
            settings.insert(
                parts[0].trim().to_string(),
                parts[1].trim().to_string()
            );
        }
        
        Ok(Config { settings })
    }
    
    // Get value (ritorna Option)
    fn get(&self, key: &str) -> Option<&String> {
        self.settings.get(key)
    }
    
    // Get value richiesto (ritorna Result)
    fn get_required(&self, key: &str) -> Result<&String, ConfigError> {
        self.settings
            .get(key)
            .ok_or_else(|| ConfigError::MissingKey(key.to_string()))
    }
    
    // Get integer
    fn get_int(&self, key: &str) -> Result<i32, ConfigError> {
        let value = self.get_required(key)?;
        value.parse::<i32>()
            .map_err(|_| ConfigError::ParseError(
                format!("'{}' is not a valid integer", value)
            ))
    }
}

fn main() {
    // Crea config file di esempio
    let config_content = r#"
# Example config
host = localhost
port = 8080
debug = true
# max_connections = 100
"#;
    fs::write("config.txt", config_content).unwrap();
    
    // Carica config
    match Config::load("config.txt") {
        Ok(config) => {
            println!("=== Config Loaded ===");
            
            // Get optional value
            if let Some(host) = config.get("host") {
                println!("Host: {}", host);
            }
            
            // Get required value
            match config.get_required("port") {
                Ok(port) => println!("Port: {}", port),
                Err(e) => println!("Error: {}", e),
            }
            
            // Get as integer
            match config.get_int("port") {
                Ok(port) => println!("Port (int): {}", port),
                Err(e) => println!("Error: {}", e),
            }
            
            // Missing key
            match config.get_required("database") {
                Ok(db) => println!("Database: {}", db),
                Err(e) => println!("Error: {}", e),
            }
        }
        Err(e) => {
            eprintln!("Failed to load config: {}", e);
        }
    }
    
    // Cleanup
    fs::remove_file("config.txt").ok();
    
    println!("\n✓ Error handling complete!");
}
```

### Best Practices

```rust
// ✅ GOOD: Use ? for propagation
fn process() -> Result<(), Box<dyn std::error::Error>> {
    let data = read_file("data.txt")?;
    let parsed = parse_data(&data)?;
    save_result(&parsed)?;
    Ok(())
}

// ❌ BAD: unwrap everywhere (panic on error)
fn bad_process() {
    let data = read_file("data.txt").unwrap();
    let parsed = parse_data(&data).unwrap();
    save_result(&parsed).unwrap();
}

// ✅ GOOD: Pattern matching con informazioni
fn handle_result(result: Result<i32, String>) {
    match result {
        Ok(value) => println!("Success: {}", value),
        Err(e) => eprintln!("Error occurred: {}", e),
    }
}

// ✅ GOOD: expect con messaggio descrittivo
fn config_value() -> i32 {
    get_config("port")
        .expect("PORT environment variable must be set")
}
```

### Comandi Utili

```bash
# Build e run
cargo run

# Run tests
cargo test

# Clippy (rileva .unwrap() non necessari!)
cargo clippy

# Formattazione
cargo fmt
```

### File da Creare
- `src/main.rs` con esempi di `Option` e `Result`

### Test da Passare
1. ✅ Codice compila
2. ✅ Usa `Option<T>` per valori opzionali
3. ✅ Usa `Result<T, E>` per operazioni fallibili
4. ✅ Pattern matching su Option/Result
5. ✅ Usa operatore `?` per propagazione
6. ✅ Custom error type (opzionale)

### Esempio di Output Atteso

```
=== Option Demo ===
Some value: 42
No value (using default): 0

=== Result Demo ===
Division: 10 / 2 = 5.00
Error: Division by zero

=== Config Loaded ===
Host: localhost
Port: 8080
Port (int): 8080
Error: Missing key: database

✓ Error handling complete!
```

## Requisiti
- [ ] Usa `Option<T>` con Some/None
- [ ] Usa `Result<T, E>` con Ok/Err
- [ ] Pattern matching su entrambi
- [ ] Operatore `?` per propagazione errori
- [ ] Metodi `.unwrap_or()`, `.map()`, `.and_then()`
- [ ] Custom error type (opzionale)
- [ ] Formattato con `cargo fmt`

## Risorse
- [The Rust Book - Error Handling](https://doc.rust-lang.org/book/ch09-00-error-handling.html)
- [The Rust Book - Option](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html)
- [Rust by Example - Option](https://doc.rust-lang.org/rust-by-example/std/option.html)
- [Rust by Example - Result](https://doc.rust-lang.org/rust-by-example/std/result.html)
- [std::option::Option](https://doc.rust-lang.org/std/option/enum.Option.html)
- [std::result::Result](https://doc.rust-lang.org/std/result/enum.Result.html)

## Note

**Concetti chiave:**
- **Option**: Some/None (no null!)
- **Result**: Ok/Err (no exceptions!)
- **? operator**: early return su errore
- **Pattern matching**: gestione esplicita
- **Combinators**: map, and_then, unwrap_or

**Quando usare cosa:**
- Valore assente ma NON errore → `Option`
- Operazione che può fallire → `Result`
- `.unwrap()` solo in esempi/test
- `.expect()` con messaggio descrittivo
- `?` per propagazione pulita

**Errori comuni:**
- `.unwrap()` in production → usa `?` o pattern matching
- Ignorare Result → Clippy avvisa con `#[must_use]`
- Non gestire None/Err → compilatore forza gestione
- Confondere Option e Result

**Performance:**
- Option/Result sono zero-cost abstractions
- Ottimizzati a livello assembly come codice C
- No overhead runtime
- Compiler elimina code non necessario

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
