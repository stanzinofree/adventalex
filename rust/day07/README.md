# Enums

## Obiettivo

Padroneggiare **enums** (enumerations) e **pattern matching** in Rust. Gli enum sono molto più potenti che in altri linguaggi: possono contenere dati, e con `match` permettono di gestire tutti i casi in modo type-safe ed esaustivo.

### Contesto Pratico

Gli enum in Rust sono fondamentali per:
- **State machines**: rappresentare stati distinti
- **Message passing**: tipi di messaggi tra componenti
- **Error handling**: `Result<T, E>` e `Option<T>` sono enum!
- **Algebraic data types**: modellare domini complessi

Vantaggi:
- **Type safety**: compilatore garantisce gestione di tutti i casi
- **Data carrying**: varianti possono contenere dati
- **Pattern matching exhaustive**: no casi dimenticati
- **Zero cost**: ottimizzato a livello assembly

In produzione:
- HTTP methods: `enum Method { Get, Post, Put, Delete }`
- UI events: `enum Event { Click, KeyPress, Scroll }`
- State: `enum ConnectionState { Connecting, Connected, Disconnected }`
- Commands: `enum Command { Create(Data), Update(Id, Data), Delete(Id) }`

### Enum Base

```rust
enum IpAddrKind {
    V4,
    V6,
}

fn main() {
    let four = IpAddrKind::V4;
    let six = IpAddrKind::V6;
    
    route(four);
    route(six);
}

fn route(ip_kind: IpAddrKind) {
    // usa ip_kind
}
```

### Enum con Dati (Data-Carrying Enums)

```rust
// Ogni variante può avere dati diversi!
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

enum Message {
    Quit,                       // No data
    Move { x: i32, y: i32 },    // Named fields
    Write(String),              // Single value
    ChangeColor(i32, i32, i32), // Tuple
}

fn main() {
    let home = IpAddr::V4(127, 0, 0, 1);
    let loopback = IpAddr::V6(String::from("::1"));
    
    let msg1 = Message::Quit;
    let msg2 = Message::Move { x: 10, y: 20 };
    let msg3 = Message::Write(String::from("Hello"));
    let msg4 = Message::ChangeColor(255, 0, 0);
}
```

**Potenza**: ogni variante è un tipo distinto con propri dati!

### Pattern Matching con match

```rust
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}

fn main() {
    let coin = Coin::Quarter;
    println!("Value: {} cents", value_in_cents(coin));
}
```

**Match è esaustivo**: devi coprire TUTTE le varianti!

### Pattern Matching con Dati

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn process_message(msg: Message) {
    match msg {
        Message::Quit => {
            println!("Quit message");
        }
        Message::Move { x, y } => {
            println!("Move to x: {}, y: {}", x, y);
        }
        Message::Write(text) => {
            println!("Text message: {}", text);
        }
        Message::ChangeColor(r, g, b) => {
            println!("Change color to RGB({}, {}, {})", r, g, b);
        }
    }
}

fn main() {
    process_message(Message::Move { x: 10, y: 20 });
    process_message(Message::Write(String::from("Hello")));
    process_message(Message::ChangeColor(255, 0, 0));
}
```

### Match con Option<T>

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

fn main() {
    let five = Some(5);
    let six = plus_one(five);
    let none = plus_one(None);
    
    println!("six: {:?}", six);    // Some(6)
    println!("none: {:?}", none);  // None
}
```

### Match con Result<T, E>

```rust
use std::fs::File;

fn main() {
    let file_result = File::open("hello.txt");
    
    match file_result {
        Ok(file) => {
            println!("File opened successfully: {:?}", file);
        }
        Err(error) => {
            println!("Error opening file: {:?}", error);
        }
    }
}
```

### Catch-all Pattern: _

```rust
fn describe_number(n: u8) {
    match n {
        1 => println!("One"),
        2 => println!("Two"),
        3 => println!("Three"),
        _ => println!("Something else"),  // Catch-all
    }
}

fn main() {
    describe_number(1);
    describe_number(42);
}
```

### if let: Shortcut per Singolo Pattern

```rust
fn main() {
    let some_value = Some(3);
    
    // Verbose match
    match some_value {
        Some(3) => println!("three"),
        _ => (),
    }
    
    // Concise if let
    if let Some(3) = some_value {
        println!("three");
    }
    
    // Con else
    let config_max = Some(3u8);
    if let Some(max) = config_max {
        println!("Max is: {}", max);
    } else {
        println!("No max configured");
    }
}
```

**Quando usare `if let`:**
- Ti interessa solo UN pattern
- Altri casi non importano o sono no-op

### Enum Methods

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
}

impl Message {
    // Method su enum
    fn call(&self) {
        match self {
            Message::Quit => println!("Quitting..."),
            Message::Move { x, y } => println!("Moving to ({}, {})", x, y),
            Message::Write(text) => println!("Writing: {}", text),
        }
    }
    
    // Associated function (constructor)
    fn move_to(x: i32, y: i32) -> Message {
        Message::Move { x, y }
    }
}

fn main() {
    let msg = Message::Write(String::from("Hello"));
    msg.call();
    
    let move_msg = Message::move_to(10, 20);
    move_msg.call();
}
```

### Pattern Guards

```rust
fn main() {
    let num = Some(4);
    
    match num {
        Some(x) if x < 5 => println!("Less than 5: {}", x),
        Some(x) => println!("Greater or equal to 5: {}", x),
        None => println!("None"),
    }
}
```

### Matching Multiple Patterns

```rust
fn main() {
    let x = 1;
    
    match x {
        1 | 2 => println!("one or two"),
        3 => println!("three"),
        _ => println!("anything"),
    }
}
```

### Range Patterns

```rust
fn main() {
    let x = 5;
    
    match x {
        1..=5 => println!("1 through 5"),
        6..=10 => println!("6 through 10"),
        _ => println!("something else"),
    }
    
    let c = 'c';
    match c {
        'a'..='j' => println!("Early letter"),
        'k'..='z' => println!("Late letter"),
        _ => println!("Not a letter"),
    }
}
```

### Destructuring Enums

```rust
enum Message {
    Move { x: i32, y: i32 },
    ChangeColor(i32, i32, i32),
}

fn main() {
    let msg = Message::ChangeColor(255, 0, 0);
    
    match msg {
        Message::Move { x, y } => {
            println!("Move to x: {}, y: {}", x, y);
        }
        Message::ChangeColor(r, g, b) => {
            println!("Change to RGB({}, {}, {})", r, g, b);
        }
    }
}
```

### Esempio Completo: State Machine

```rust
#[derive(Debug)]
enum TrafficLight {
    Red,
    Yellow,
    Green,
}

impl TrafficLight {
    fn duration(&self) -> u32 {
        match self {
            TrafficLight::Red => 60,
            TrafficLight::Yellow => 10,
            TrafficLight::Green => 45,
        }
    }
    
    fn next(&self) -> TrafficLight {
        match self {
            TrafficLight::Red => TrafficLight::Green,
            TrafficLight::Yellow => TrafficLight::Red,
            TrafficLight::Green => TrafficLight::Yellow,
        }
    }
    
    fn can_go(&self) -> bool {
        match self {
            TrafficLight::Green => true,
            _ => false,
        }
    }
}

#[derive(Debug)]
enum WebEvent {
    PageLoad,
    PageUnload,
    KeyPress(char),
    Click { x: i64, y: i64 },
    Paste(String),
}

fn inspect_event(event: WebEvent) {
    match event {
        WebEvent::PageLoad => println!("Page loaded"),
        WebEvent::PageUnload => println!("Page unloaded"),
        WebEvent::KeyPress(c) => println!("Pressed key: '{}'", c),
        WebEvent::Click { x, y } => {
            println!("Clicked at x={}, y={}", x, y);
        }
        WebEvent::Paste(text) => {
            println!("Pasted text: \"{}\"", text);
        }
    }
}

// Complex example: Command pattern
#[derive(Debug)]
enum Command {
    CreateUser { name: String, email: String },
    UpdateUser { id: u32, name: Option<String>, email: Option<String> },
    DeleteUser { id: u32 },
    ListUsers,
}

impl Command {
    fn execute(&self) {
        match self {
            Command::CreateUser { name, email } => {
                println!("Creating user: {} ({})", name, email);
            }
            Command::UpdateUser { id, name, email } => {
                println!("Updating user {}:", id);
                if let Some(n) = name {
                    println!("  New name: {}", n);
                }
                if let Some(e) = email {
                    println!("  New email: {}", e);
                }
            }
            Command::DeleteUser { id } => {
                println!("Deleting user {}", id);
            }
            Command::ListUsers => {
                println!("Listing all users...");
            }
        }
    }
}

fn main() {
    println!("=== Traffic Light Demo ===");
    let mut light = TrafficLight::Red;
    println!("Light: {:?}, Duration: {}s, Can go: {}", 
        light, light.duration(), light.can_go());
    
    light = light.next();
    println!("Light: {:?}, Duration: {}s, Can go: {}", 
        light, light.duration(), light.can_go());
    
    println!("\n=== Web Events Demo ===");
    inspect_event(WebEvent::PageLoad);
    inspect_event(WebEvent::KeyPress('x'));
    inspect_event(WebEvent::Click { x: 100, y: 200 });
    inspect_event(WebEvent::Paste("Hello".to_string()));
    
    println!("\n=== Command Pattern Demo ===");
    let commands = vec![
        Command::CreateUser {
            name: "Alice".to_string(),
            email: "alice@example.com".to_string(),
        },
        Command::UpdateUser {
            id: 1,
            name: Some("Alice Smith".to_string()),
            email: None,
        },
        Command::ListUsers,
        Command::DeleteUser { id: 1 },
    ];
    
    for cmd in commands {
        cmd.execute();
        println!();
    }
    
    println!("✓ Enum operations complete!");
}
```

### Comandi Utili

```bash
# Build e run
cargo run

# Run tests
cargo test

# Clippy (rileva match non esaustivi!)
cargo clippy

# Formattazione
cargo fmt
```

### File da Creare
- `src/main.rs` con esempi di enum e pattern matching

### Test da Passare
1. ✅ Codice compila
2. ✅ Definisce almeno un enum
3. ✅ Usa `match` per pattern matching
4. ✅ Enum con data-carrying variants
5. ✅ Match esaustivo (tutti i casi)
6. ✅ `if let` per pattern singolo (opzionale)

### Esempio di Output Atteso

```
=== Traffic Light Demo ===
Light: Red, Duration: 60s, Can go: false
Light: Green, Duration: 45s, Can go: true

=== Web Events Demo ===
Page loaded
Pressed key: 'x'
Clicked at x=100, y=200
Pasted text: "Hello"

=== Command Pattern Demo ===
Creating user: Alice (alice@example.com)

Updating user 1:
  New name: Alice Smith

Listing all users...

Deleting user 1

✓ Enum operations complete!
```

## Requisiti
- [ ] Definisci almeno un enum
- [ ] Usa `match` per pattern matching esaustivo
- [ ] Enum con almeno una variante che contiene dati
- [ ] Match che estrae dati dalle varianti
- [ ] `if let` syntax (opzionale)
- [ ] Enum methods con `impl` (opzionale)
- [ ] Formattato con `cargo fmt`

## Risorse
- [The Rust Book - Enums](https://doc.rust-lang.org/book/ch06-01-defining-an-enum.html)
- [The Rust Book - Match](https://doc.rust-lang.org/book/ch06-02-match.html)
- [The Rust Book - if let](https://doc.rust-lang.org/book/ch06-03-if-let.html)
- [Rust by Example - Enums](https://doc.rust-lang.org/rust-by-example/custom_types/enum.html)
- [Pattern Syntax](https://doc.rust-lang.org/book/ch18-03-pattern-syntax.html)

## Note

**Concetti chiave:**
- **Enum**: tipo con varianti discrete
- **Data-carrying**: varianti possono contenere dati
- **match**: pattern matching esaustivo
- **Exhaustiveness**: compilatore richiede tutti i casi
- **if let**: shortcut per singolo pattern

**Best practices:**
- Sempre gestisci tutti i casi (no `_` se evitabile)
- Usa `if let` solo per pattern singolo
- Enum methods per behavior correlato
- `#[derive(Debug)]` per debug printing
- Named fields per varianti complesse

**Pattern comuni:**
- **State machine**: enum per stati
- **Command pattern**: enum per azioni
- **Error types**: enum per errori custom
- **Message passing**: enum per messaggi tra thread

**Differenze da altri linguaggi:**
- **Java/C#**: enum sono solo costanti → Rust può contenere dati
- **TypeScript unions**: simili ma Rust compile-time garantito
- **Haskell ADT**: Rust enum sono Algebraic Data Types
- **Exhaustiveness**: match DEVE coprire tutti i casi

**Performance:**
- Enum sono zero-cost: dimensione = variante più grande + tag
- Match è ottimizzato come jump table o if-chain
- No virtual dispatch, tutto compile-time

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
