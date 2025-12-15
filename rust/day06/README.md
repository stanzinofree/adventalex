# Structs

## Obiettivo

Imparare a definire e usare **structs** in Rust per creare **tipi di dati custom**. Le struct sono il modo principale per raggruppare dati correlati e creare abstractions, simili a class in altri linguaggi ma senza ereditarietà.

### Contesto Pratico

Le struct in Rust sono fondamentali per:
- **Domain modeling**: rappresentare entità del business (User, Order, Product)
- **Data structures**: creare tipi complessi (Tree, Graph, Cache)
- **API design**: definire request/response types
- **Configuration**: raggruppare settings correlati

Rust ha 3 tipi di struct:
- **Named-field structs**: campi con nomi (più comuni)
- **Tuple structs**: campi anonimi posizionali
- **Unit structs**: nessun campo (markers, zero-size types)

In produzione:
- Database models: `struct User { id, name, email }`
- API types: `struct ApiResponse { status, data, error }`
- Config: `struct AppConfig { port, host, debug }`
- State management: `struct AppState { users, sessions }`

### Named-Field Structs

```rust
// Definizione
struct User {
    username: String,
    email: String,
    age: u32,
    active: bool,
}

fn main() {
    // Creazione istanza
    let user1 = User {
        username: String::from("alice"),
        email: String::from("alice@example.com"),
        age: 30,
        active: true,
    };
    
    // Accesso campi
    println!("Username: {}", user1.username);
    println!("Email: {}", user1.email);
    
    // Struct mutabile
    let mut user2 = User {
        username: String::from("bob"),
        email: String::from("bob@example.com"),
        age: 25,
        active: false,
    };
    
    // Modifica campo (struct deve essere mut)
    user2.active = true;
    user2.age += 1;
    
    println!("Bob age: {}", user2.age);
}
```

**⚠️ Nota**: tutta la struct è mutabile o immutabile, non singoli campi.

### Field Init Shorthand

```rust
struct User {
    username: String,
    email: String,
}

fn create_user(username: String, email: String) -> User {
    // Se parametro ha stesso nome del campo, shorthand
    User {
        username,  // Equivalente a username: username
        email,     // Equivalente a email: email
    }
}

fn main() {
    let user = create_user(
        String::from("alice"),
        String::from("alice@example.com")
    );
    
    println!("{}", user.username);
}
```

### Struct Update Syntax

```rust
struct User {
    username: String,
    email: String,
    age: u32,
    active: bool,
}

fn main() {
    let user1 = User {
        username: String::from("alice"),
        email: String::from("alice@example.com"),
        age: 30,
        active: true,
    };
    
    // Crea user2 copiando da user1 con alcuni campi diversi
    let user2 = User {
        email: String::from("bob@example.com"),
        username: String::from("bob"),
        ..user1  // Resto dei campi da user1 (MOVE!)
    };
    
    // ⚠️ user1.username e user1.email sono stati MOSSI
    // println!("{}", user1.username);  // ❌ ERRORE
    // Ma user1.age e user1.active sono Copy types, ancora validi
    println!("Age from user1: {}", user1.age);  // ✅ OK
}
```

### Tuple Structs

```rust
// Struct senza nomi campo (solo tipi)
struct Color(i32, i32, i32);
struct Point(f64, f64, f64);

fn main() {
    let black = Color(0, 0, 0);
    let origin = Point(0.0, 0.0, 0.0);
    
    // Accesso per indice
    println!("Red: {}", black.0);
    println!("X: {}", origin.0);
    
    // Destructuring
    let Color(r, g, b) = black;
    println!("RGB: {}, {}, {}", r, g, b);
}
```

**Quando usare tuple struct:**
- Type safety: `Color(255, 0, 0)` vs `Point(255.0, 0.0, 0.0)` sono tipi diversi
- Newtype pattern: wrapper per type safety

### Unit Structs (Zero-Sized Types)

```rust
// Struct senza campi
struct Marker;
struct AlwaysEqual;

fn main() {
    let m = Marker;
    let eq = AlwaysEqual;
    
    // Utili per:
    // - Trait markers
    // - State machines
    // - Type-level programming
}
```

### Methods (impl blocks)

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    // Method (prende &self)
    fn area(&self) -> u32 {
        self.width * self.height
    }
    
    // Method mutabile
    fn resize(&mut self, width: u32, height: u32) {
        self.width = width;
        self.height = height;
    }
    
    // Associated function (no self) - costruttore
    fn new(width: u32, height: u32) -> Rectangle {
        Rectangle { width, height }
    }
    
    // Associated function - factory
    fn square(size: u32) -> Rectangle {
        Rectangle {
            width: size,
            height: size,
        }
    }
    
    // Method con parametro
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}

fn main() {
    // Costruttore (associated function)
    let mut rect1 = Rectangle::new(30, 50);
    let rect2 = Rectangle::square(20);
    
    // Methods
    println!("Area: {}", rect1.area());
    
    rect1.resize(40, 60);
    println!("New area: {}", rect1.area());
    
    if rect1.can_hold(&rect2) {
        println!("rect1 can hold rect2");
    }
}
```

**Self vs self:**
- `Self` (tipo): il tipo della struct
- `self`: istanza (equivalente a `self: Self`)
- `&self`: reference immutabile (equivalente a `self: &Self`)
- `&mut self`: reference mutabile (equivalente a `self: &mut Self`)

### Derive Traits

```rust
// Derive automatic trait implementations
#[derive(Debug, Clone, PartialEq)]
struct Point {
    x: f64,
    y: f64,
}

fn main() {
    let p1 = Point { x: 1.0, y: 2.0 };
    
    // Debug: {:?} formatting
    println!("Point: {:?}", p1);
    println!("Point pretty: {:#?}", p1);
    
    // Clone: create deep copy
    let p2 = p1.clone();
    
    // PartialEq: comparison
    if p1 == p2 {
        println!("Points are equal");
    }
}
```

**Trait comuni derivabili:**
- `Debug` - `{:?}` formatting
- `Clone` - `.clone()` method
- `Copy` - implicit copy (solo per stack types!)
- `PartialEq` - `==` operator
- `Eq` - full equality
- `PartialOrd`, `Ord` - ordering
- `Default` - `.default()` constructor

### Struct con Lifetime Parameters

```rust
// Struct che contiene reference
struct Book<'a> {
    title: &'a str,
    author: &'a str,
    year: u32,
}

fn main() {
    let title = String::from("The Rust Book");
    let author = "Steve Klabnik";
    
    let book = Book {
        title: &title,
        author,
        year: 2023,
    };
    
    println!("{} by {}", book.title, book.author);
}
```

**Lifetime 'a**: dice al compilatore che le reference in `Book` devono vivere almeno quanto `'a`.

### Esempio Completo: User Management System

```rust
#[derive(Debug, Clone)]
struct User {
    id: u32,
    username: String,
    email: String,
    active: bool,
}

impl User {
    // Constructor
    fn new(id: u32, username: String, email: String) -> Self {
        User {
            id,
            username,
            email,
            active: true,
        }
    }
    
    // Deactivate user
    fn deactivate(&mut self) {
        self.active = false;
    }
    
    // Update email
    fn update_email(&mut self, new_email: String) -> Result<(), String> {
        if !new_email.contains('@') {
            return Err("Invalid email format".to_string());
        }
        self.email = new_email;
        Ok(())
    }
    
    // Display info
    fn display(&self) {
        let status = if self.active { "Active" } else { "Inactive" };
        println!("User #{}: {} ({}) - {}", 
            self.id, self.username, self.email, status);
    }
}

#[derive(Debug)]
struct UserDatabase {
    users: Vec<User>,
    next_id: u32,
}

impl UserDatabase {
    fn new() -> Self {
        UserDatabase {
            users: Vec::new(),
            next_id: 1,
        }
    }
    
    fn add_user(&mut self, username: String, email: String) -> u32 {
        let id = self.next_id;
        let user = User::new(id, username, email);
        self.users.push(user);
        self.next_id += 1;
        id
    }
    
    fn find_user(&self, id: u32) -> Option<&User> {
        self.users.iter().find(|u| u.id == id)
    }
    
    fn find_user_mut(&mut self, id: u32) -> Option<&mut User> {
        self.users.iter_mut().find(|u| u.id == id)
    }
    
    fn list_users(&self) {
        println!("\n=== User List ===");
        if self.users.is_empty() {
            println!("No users found");
            return;
        }
        
        for user in &self.users {
            user.display();
        }
    }
    
    fn active_users_count(&self) -> usize {
        self.users.iter().filter(|u| u.active).count()
    }
}

fn main() {
    let mut db = UserDatabase::new();
    
    // Add users
    let id1 = db.add_user(
        "alice".to_string(),
        "alice@example.com".to_string()
    );
    let id2 = db.add_user(
        "bob".to_string(),
        "bob@example.com".to_string()
    );
    let id3 = db.add_user(
        "charlie".to_string(),
        "charlie@example.com".to_string()
    );
    
    db.list_users();
    
    // Update user
    if let Some(user) = db.find_user_mut(id2) {
        user.update_email("bob.new@example.com".to_string()).unwrap();
        println!("\nUpdated user {}:", id2);
        user.display();
    }
    
    // Deactivate user
    if let Some(user) = db.find_user_mut(id3) {
        user.deactivate();
        println!("\nDeactivated user {}:", id3);
        user.display();
    }
    
    db.list_users();
    
    // Stats
    println!("\n=== Stats ===");
    println!("Total users: {}", db.users.len());
    println!("Active users: {}", db.active_users_count());
    
    println!("\n✓ Struct operations complete!");
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
- `src/main.rs` con esempi di struct

### Test da Passare
1. ✅ Codice compila
2. ✅ Definisce almeno una struct
3. ✅ Crea istanze di struct
4. ✅ Implementa metodi con `impl` block
5. ✅ Usa `#[derive(Debug)]` per printing
6. ✅ Associated functions (costruttori)

### Esempio di Output Atteso

```
=== User List ===
User #1: alice (alice@example.com) - Active
User #2: bob (bob@example.com) - Active
User #3: charlie (charlie@example.com) - Active

Updated user 2:
User #2: bob (bob.new@example.com) - Active

Deactivated user 3:
User #3: charlie (charlie@example.com) - Inactive

=== User List ===
User #1: alice (alice@example.com) - Active
User #2: bob (bob.new@example.com) - Active
User #3: charlie (charlie@example.com) - Inactive

=== Stats ===
Total users: 3
Active users: 2

✓ Struct operations complete!
```

## Requisiti
- [ ] Definisci almeno una struct con campi named
- [ ] Crea istanze di struct
- [ ] Implementa metodi con `impl` block
- [ ] Usa `#[derive(Debug)]` per debug printing
- [ ] Associated function (costruttore)
- [ ] Struct update syntax (opzionale)
- [ ] Formattato con `cargo fmt`

## Risorse
- [The Rust Book - Structs](https://doc.rust-lang.org/book/ch05-00-structs.html)
- [The Rust Book - Method Syntax](https://doc.rust-lang.org/book/ch05-03-method-syntax.html)
- [Rust by Example - Structs](https://doc.rust-lang.org/rust-by-example/custom_types/structs.html)
- [Derive Reference](https://doc.rust-lang.org/reference/attributes/derive.html)

## Note

**Concetti chiave:**
- **Struct**: type custom con campi named
- **impl block**: definire metodi su struct
- **self**: receiver (istanza)
- **Associated functions**: funzioni senza self (::)
- **Derive**: automatic trait implementation

**Best practices:**
- Sempre `#[derive(Debug)]` per struct
- Costruttori con `new()` o `default()`
- Methods con `&self` per read-only
- Methods con `&mut self` per modifiche
- Associated functions per costruzione (`::new`)

**Patterns comuni:**
- **Builder pattern**: costruzione fluent
- **Newtype pattern**: wrapper per type safety
- **Type state pattern**: encode state in type
- **Data-oriented design**: struct di dati, trait per behavior

**Differenze da altri linguaggi:**
- No ereditarietà (usa composition + traits)
- No costruttori automatici (define `new()`)
- Tutta la struct mut/immut (no campi singoli)
- Multiple `impl` blocks OK (separare concerns)

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
