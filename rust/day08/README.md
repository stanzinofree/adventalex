# Traits

## Obiettivo

Comprendere i **traits** in Rust, il meccanismo per definire **comportamenti condivisi** tra tipi. I traits sono simili a interfacce di altri linguaggi ma più potenti: permettono polymorphism, default implementations, trait bounds, e sono la base della generics in Rust.

### Contesto Pratico

I traits sono fondamentali per:
- **Polymorphism**: stesso comportamento per tipi diversi
- **Code reuse**: comportamenti comuni condivisi
- **Generic constraints**: limitare tipi generici
- **Operator overloading**: implementare `+`, `==`, etc.
- **Standard library**: `Debug`, `Clone`, `Iterator`, etc.

In produzione:
- Serialization: `Serialize`/`Deserialize` traits (serde)
- Database: `FromRow` trait per mapping
- HTTP: `Handler` trait per request handlers
- Logging: `Log` trait per backend multipli

### Definire un Trait

```rust
// Trait definition
trait Summary {
    fn summarize(&self) -> String;
}

struct NewsArticle {
    headline: String,
    location: String,
    author: String,
    content: String,
}

struct Tweet {
    username: String,
    content: String,
    reply: bool,
    retweet: bool,
}

// Implement trait for NewsArticle
impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

// Implement trait for Tweet
impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}

fn main() {
    let article = NewsArticle {
        headline: String::from("Rust 1.0 Released"),
        location: String::from("San Francisco"),
        author: String::from("Mozilla"),
        content: String::from("Rust is now stable..."),
    };
    
    let tweet = Tweet {
        username: String::from("rustlang"),
        content: String::from("Announcing Rust 1.0!"),
        reply: false,
        retweet: false,
    };
    
    println!("Article: {}", article.summarize());
    println!("Tweet: {}", tweet.summarize());
}
```

### Default Implementations

```rust
trait Summary {
    fn summarize_author(&self) -> String;
    
    // Default implementation
    fn summarize(&self) -> String {
        format!("(Read more from {}...)", self.summarize_author())
    }
}

struct Tweet {
    username: String,
    content: String,
}

impl Summary for Tweet {
    fn summarize_author(&self) -> String {
        format!("@{}", self.username)
    }
    
    // Can override default if needed
    // fn summarize(&self) -> String { ... }
}

fn main() {
    let tweet = Tweet {
        username: String::from("rustlang"),
        content: String::from("Hello Rust!"),
    };
    
    println!("{}", tweet.summarize());  // Uses default implementation
}
```

### Traits as Parameters

```rust
trait Summary {
    fn summarize(&self) -> String;
}

// Trait bound syntax
fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

// Equivalent trait bound (longer syntax)
fn notify_verbose<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}

// Multiple trait bounds
fn notify_multiple(item: &(impl Summary + Display)) {
    println!("{}", item);
}

// Where clause (more readable for complex bounds)
fn some_function<T, U>(t: &T, u: &U) -> i32
where
    T: Summary + Clone,
    U: Summary + Debug,
{
    // ...
    0
}
```

### Returning Traits

```rust
trait Summary {
    fn summarize(&self) -> String;
}

struct NewsArticle {
    headline: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        self.headline.clone()
    }
}

// Return impl Trait
fn returns_summarizable() -> impl Summary {
    NewsArticle {
        headline: String::from("Breaking News"),
    }
}

fn main() {
    let article = returns_summarizable();
    println!("{}", article.summarize());
}
```

**⚠️ Limitazione**: `impl Trait` può ritornare UN SOLO tipo concreto.

### Standard Library Traits

```rust
use std::fmt;

#[derive(Debug, Clone, PartialEq)]
struct Point {
    x: i32,
    y: i32,
}

// Manual Display implementation
impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

fn main() {
    let p1 = Point { x: 1, y: 2 };
    
    // Debug trait (derived)
    println!("{:?}", p1);
    
    // Display trait (manual)
    println!("{}", p1);
    
    // Clone trait (derived)
    let p2 = p1.clone();
    
    // PartialEq trait (derived)
    if p1 == p2 {
        println!("Points are equal");
    }
}
```

### Operator Overloading

```rust
use std::ops::Add;

#[derive(Debug, Copy, Clone)]
struct Point {
    x: i32,
    y: i32,
}

// Implement Add trait to overload +
impl Add for Point {
    type Output = Point;
    
    fn add(self, other: Point) -> Point {
        Point {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

fn main() {
    let p1 = Point { x: 1, y: 2 };
    let p2 = Point { x: 3, y: 4 };
    
    let p3 = p1 + p2;  // Uses Add trait!
    
    println!("{:?}", p3);  // Point { x: 4, y: 6 }
}
```

### Associated Types

```rust
trait Iterator {
    type Item;  // Associated type
    
    fn next(&mut self) -> Option<Self::Item>;
}

struct Counter {
    count: u32,
}

impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}

impl Iterator for Counter {
    type Item = u32;  // Specify concrete type
    
    fn next(&mut self) -> Option<Self::Item> {
        if self.count < 5 {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}

fn main() {
    let mut counter = Counter::new();
    
    while let Some(num) = counter.next() {
        println!("{}", num);
    }
}
```

### Trait Objects (Dynamic Dispatch)

```rust
trait Draw {
    fn draw(&self);
}

struct Circle {
    radius: f64,
}

struct Square {
    side: f64,
}

impl Draw for Circle {
    fn draw(&self) {
        println!("Drawing circle with radius {}", self.radius);
    }
}

impl Draw for Square {
    fn draw(&self) {
        println!("Drawing square with side {}", self.side);
    }
}

fn main() {
    // Trait object: dyn Draw
    let shapes: Vec<Box<dyn Draw>> = vec![
        Box::new(Circle { radius: 5.0 }),
        Box::new(Square { side: 3.0 }),
    ];
    
    for shape in shapes.iter() {
        shape.draw();  // Dynamic dispatch
    }
}
```

**`Box<dyn Trait>`**:
- Runtime polymorphism
- Overhead di virtual dispatch
- Permette collection eterogenee

### Esempio Completo: Plugin System

```rust
use std::fmt;

// Trait per plugin
trait Plugin: fmt::Debug {
    fn name(&self) -> &str;
    fn version(&self) -> &str;
    fn execute(&self) -> Result<String, String>;
}

#[derive(Debug)]
struct LoggerPlugin {
    log_level: String,
}

impl Plugin for LoggerPlugin {
    fn name(&self) -> &str {
        "Logger"
    }
    
    fn version(&self) -> &str {
        "1.0.0"
    }
    
    fn execute(&self) -> Result<String, String> {
        Ok(format!("Logging at level: {}", self.log_level))
    }
}

#[derive(Debug)]
struct DatabasePlugin {
    connection_string: String,
}

impl Plugin for DatabasePlugin {
    fn name(&self) -> &str {
        "Database"
    }
    
    fn version(&self) -> &str {
        "2.1.0"
    }
    
    fn execute(&self) -> Result<String, String> {
        if self.connection_string.is_empty() {
            Err("Connection string is empty".to_string())
        } else {
            Ok(format!("Connected to: {}", self.connection_string))
        }
    }
}

struct PluginManager {
    plugins: Vec<Box<dyn Plugin>>,
}

impl PluginManager {
    fn new() -> Self {
        PluginManager {
            plugins: Vec::new(),
        }
    }
    
    fn register(&mut self, plugin: Box<dyn Plugin>) {
        println!("Registering plugin: {} v{}", plugin.name(), plugin.version());
        self.plugins.push(plugin);
    }
    
    fn execute_all(&self) {
        println!("\n=== Executing Plugins ===");
        for plugin in &self.plugins {
            println!("\nPlugin: {}", plugin.name());
            match plugin.execute() {
                Ok(result) => println!("  ✓ {}", result),
                Err(e) => println!("  ✗ Error: {}", e),
            }
        }
    }
}

fn main() {
    let mut manager = PluginManager::new();
    
    manager.register(Box::new(LoggerPlugin {
        log_level: "INFO".to_string(),
    }));
    
    manager.register(Box::new(DatabasePlugin {
        connection_string: "postgresql://localhost:5432/mydb".to_string(),
    }));
    
    manager.execute_all();
    
    println!("\n✓ Trait operations complete!");
}
```

### Derivable Traits

```rust
// Traits comuni che si possono derivare
#[derive(
    Debug,      // {:?} formatting
    Clone,      // .clone() method
    Copy,       // Implicit copy (only stack types!)
    PartialEq,  // == operator
    Eq,         // Full equality (requires PartialEq)
    PartialOrd, // <, >, <=, >=
    Ord,        // Full ordering (requires Eq + PartialOrd)
    Hash,       // Use in HashMap/HashSet
    Default,    // Default::default()
)]
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p1 = Point::default();
    let p2 = p1;  // Copy (not move)
    
    if p1 == p2 {
        println!("Equal!");
    }
    
    println!("{:?}", p1);
}
```

### Comandi Utili

```bash
# Build e run
cargo run

# Run tests
cargo test

# Clippy
cargo clippy

# Formattazione
cargo fmt
```

### File da Creare
- `src/main.rs` con trait definitions e implementations

### Test da Passare
1. ✅ Codice compila
2. ✅ Definisce almeno un trait custom
3. ✅ Implementa trait per almeno 2 tipi
4. ✅ Usa trait come parameter (`impl Trait`)
5. ✅ Deriva trait standard (`#[derive(...)]`)
6. ✅ Default implementation (opzionale)

### Esempio di Output Atteso

```
Registering plugin: Logger v1.0.0
Registering plugin: Database v2.1.0

=== Executing Plugins ===

Plugin: Logger
  ✓ Logging at level: INFO

Plugin: Database
  ✓ Connected to: postgresql://localhost:5432/mydb

✓ Trait operations complete!
```

## Requisiti
- [ ] Definisci almeno un trait
- [ ] Implementa trait per almeno 2 tipi diversi
- [ ] Usa trait come function parameter
- [ ] Deriva trait standard (`Debug`, `Clone`, etc.)
- [ ] Default trait implementation (opzionale)
- [ ] Trait objects `Box<dyn Trait>` (opzionale)
- [ ] Formattato con `cargo fmt`

## Risorse
- [The Rust Book - Traits](https://doc.rust-lang.org/book/ch10-02-traits.html)
- [Rust by Example - Traits](https://doc.rust-lang.org/rust-by-example/trait.html)
- [Trait Objects](https://doc.rust-lang.org/book/ch17-02-trait-objects.html)
- [Derivable Traits](https://doc.rust-lang.org/book/appendix-03-derivable-traits.html)

## Note

**Concetti chiave:**
- **Trait**: definisce comportamenti condivisi
- **impl Trait for Type**: implementazione
- **Trait bounds**: vincoli su generics
- **Default implementation**: metodi con default
- **Trait objects**: `dyn Trait` per dynamic dispatch

**Best practices:**
- Trait piccoli e focalizzati (Single Responsibility)
- Deriva trait quando possibile (`#[derive(...)]`)
- Usa `impl Trait` per parametri (più leggibile)
- `where` clause per bounds complessi
- Trait objects solo quando necessario (overhead)

**Differenze da altri linguaggi:**
- **Java interfaces**: simili ma Rust ha default impl e no ereditarietà
- **Go interfaces**: implicit in Go, explicit in Rust
- **TypeScript**: structural typing vs nominal in Rust
- **Haskell typeclasses**: molto simile concettualmente

**Performance:**
- **Static dispatch** (generics): zero overhead, monomorphization
- **Dynamic dispatch** (trait objects): virtual table, piccolo overhead
- Prefer static quando possibile

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
