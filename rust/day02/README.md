# Ownership

## Obiettivo

Comprendere il **sistema di ownership di Rust**, il concetto fondamentale che garantisce **memory safety senza garbage collector**. Imparerai le regole di ownership, borrowing (prestito), e come Rust previene data races, use-after-free, e null pointer dereferences a **compile-time**.

### Contesto Pratico

Ownership è ciò che rende Rust **unico e potente**:
- **No garbage collector** → performance prevedibili
- **No manual memory management** → no segfaults
- **Thread safety** garantita dal compilatore
- **Zero-cost abstractions** → performance come C/C++

Problemi che ownership risolve:
- **Use-after-free**: accedere a memoria deallocata (vulnerabilità critica)
- **Double free**: liberare memoria due volte (crash)
- **Data races**: accesso concorrente non sincronizzato
- **Dangling pointers**: puntatori a memoria invalida
- **Memory leaks**: ridotti significativamente

In produzione:
- **Concurrency sicura**: nessun data race possibile
- **API design**: ownership guida interfacce chiare
- **Refactoring**: il compilatore previene errori

### Le 3 Regole di Ownership

```rust
// Regola 1: Ogni valore ha un OWNER (una variabile)
let s1 = String::from("hello");  // s1 è l'owner di "hello"

// Regola 2: Ci può essere UN SOLO owner alla volta
let s2 = s1;  // Ownership si MUOVE da s1 a s2
// println!("{}", s1);  // ❌ ERRORE: s1 non è più valido!

// Regola 3: Quando l'owner esce dallo scope, il valore viene DROP (deallocato)
{
    let s3 = String::from("temporary");
    // s3 è valido qui
} // s3 esce dallo scope → memoria deallocata automaticamente
```

### Move Semantics

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1;  // MOVE: ownership si sposta da s1 a s2
    
    // println!("{}", s1);  // ❌ ERRORE: value borrowed after move
    println!("{}", s2);  // ✅ OK
    
    // Tipi che implementano Copy (stack-only) si COPIANO invece di muoversi
    let x = 5;
    let y = x;  // COPY: x rimane valido
    println!("x: {}, y: {}", x, y);  // ✅ OK
}
```

**Tipi Copy (si copiano):**
- Interi: `i32`, `u64`, etc.
- Float: `f32`, `f64`
- Bool: `bool`
- Char: `char`
- Tuple di tipi Copy: `(i32, i32)`

**Tipi che si muovono:**
- `String`
- `Vec<T>`
- Struct/Enum custom (tranne se hanno `#[derive(Copy)]`)

### Borrowing: References Immutabili

```rust
fn main() {
    let s1 = String::from("hello");
    
    // Borrowing immutabile: &T
    let len = calculate_length(&s1);  // Presta s1, non lo muove
    
    println!("The length of '{}' is {}.", s1, len);  // s1 ancora valido!
}

fn calculate_length(s: &String) -> usize {
    // s è una reference, non possiede il valore
    s.len()
}  // s esce dallo scope, ma NON dealloca (non è owner)
```

**Reference rules:**
- `&T` - Reference immutabile (read-only)
- Puoi avere **infinite reference immutabili** contemporaneamente
- No modifica attraverso reference immutabile

### Mutable Borrowing: References Mutabili

```rust
fn main() {
    let mut s = String::from("hello");
    
    // Borrowing mutabile: &mut T
    change(&mut s);
    
    println!("{}", s);  // "hello, world"
}

fn change(s: &mut String) {
    s.push_str(", world");
}
```

**Mutable reference rules:**
- `&mut T` - Reference mutabile (read-write)
- **UNA SOLA** reference mutabile alla volta
- **NESSUNA** reference immutabile contemporanea a una mutabile

### Le Regole del Borrow Checker

```rust
fn main() {
    let mut s = String::from("hello");
    
    // ✅ OK: Multiple immutable references
    let r1 = &s;
    let r2 = &s;
    println!("{} and {}", r1, r2);
    // r1 e r2 non sono più usate dopo qui
    
    // ✅ OK: Mutable reference dopo che immutabili sono finite
    let r3 = &mut s;
    r3.push_str(" world");
    println!("{}", r3);
}

fn broken_example() {
    let mut s = String::from("hello");
    
    let r1 = &s;        // ✅ Immutable borrow
    let r2 = &s;        // ✅ Immutable borrow
    // let r3 = &mut s; // ❌ ERRORE: cannot borrow as mutable
                        //    perché r1 e r2 sono ancora in uso
    
    println!("{}, {}", r1, r2);
}

fn working_example() {
    let mut s = String::from("hello");
    
    let r1 = &s;
    let r2 = &s;
    println!("{}, {}", r1, r2);
    // r1 e r2 non sono più usate
    
    let r3 = &mut s;  // ✅ OK: nessuna reference attiva
    r3.push_str(" world");
}
```

**Perché queste regole?**
- Prevengono **data races** a compile-time
- Garantiscono che dati condivisi siano immutabili
- Se dati sono mutabili, accesso esclusivo garantito

### Ownership con Funzioni

```rust
fn main() {
    let s = String::from("hello");
    
    // s viene MOSSO nella funzione
    takes_ownership(s);
    // println!("{}", s);  // ❌ ERRORE: s è stato mosso
    
    let x = 5;
    // x viene COPIATO (Copy type)
    makes_copy(x);
    println!("{}", x);  // ✅ OK: x ancora valido
}

fn takes_ownership(some_string: String) {
    println!("{}", some_string);
}  // some_string esce dallo scope → DROP

fn makes_copy(some_integer: i32) {
    println!("{}", some_integer);
}  // some_integer esce dallo scope → nulla
```

### Ownership e Return Values

```rust
fn main() {
    let s1 = gives_ownership();  // Funzione trasferisce ownership
    
    let s2 = String::from("hello");
    let s3 = takes_and_gives_back(s2);  // s2 mosso dentro, poi fuori
    
    // println!("{}", s2);  // ❌ s2 è stato mosso
    println!("{}", s3);  // ✅ s3 valido
}

fn gives_ownership() -> String {
    let some_string = String::from("yours");
    some_string  // Ownership trasferita al chiamante
}

fn takes_and_gives_back(a_string: String) -> String {
    a_string  // Ownership ritorna al chiamante
}
```

### Pattern Comune: Return Reference

```rust
fn main() {
    let mut s = String::from("hello");
    
    let len = get_length(&s);
    println!("Length: {}", len);
    
    append_world(&mut s);
    println!("{}", s);
}

fn get_length(s: &String) -> usize {
    s.len()  // Prende reference, ritorna valore
}

fn append_world(s: &mut String) {
    s.push_str(" world");  // Modifica attraverso reference mutabile
}
```

### Dangling References: Rust Non Lo Permette!

```rust
// ❌ Questo NON compila
fn dangle() -> &String {
    let s = String::from("hello");
    &s  // ERRORE: s viene deallocato, reference sarebbe invalida
}  // s esce dallo scope

// ✅ Soluzione: ritorna valore (muove ownership)
fn no_dangle() -> String {
    let s = String::from("hello");
    s  // OK: ownership trasferita
}
```

**Il compilatore previene dangling pointers!**

### Slices: Borrowing Parziale

```rust
fn main() {
    let s = String::from("hello world");
    
    // Slice: reference a una parte della string
    let hello = &s[0..5];   // "hello"
    let world = &s[6..11];  // "world"
    
    // Sintassi shortcut
    let hello2 = &s[..5];   // Equivalente a [0..5]
    let world2 = &s[6..];   // Equivalente a [6..len]
    let whole = &s[..];     // Intera string
    
    println!("{} {}", hello, world);
}

fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];  // Slice fino allo spazio
        }
    }
    
    &s[..]  // Tutta la string se nessuno spazio
}
```

### Esempio Completo: String Processor

```rust
fn main() {
    println!("=== Ownership Demo ===\n");
    
    // 1. Move semantics
    let s1 = String::from("Rust ownership");
    let s2 = s1;  // s1 mosso in s2
    // println!("{}", s1);  // Error se decommentato
    println!("Moved string: {}", s2);
    
    // 2. Borrowing immutabile
    let text = String::from("Hello, Rust!");
    let len = string_length(&text);
    println!("\n'{}' has {} characters", text, len);
    
    // 3. Borrowing mutabile
    let mut message = String::from("Hello");
    add_exclamation(&mut message);
    println!("Modified: {}", message);
    
    // 4. Multiple immutable borrows
    let data = String::from("shared data");
    let r1 = &data;
    let r2 = &data;
    println!("\nShared: {} and {}", r1, r2);
    
    // 5. Slices
    let sentence = String::from("Rust is amazing");
    let first = first_word(&sentence);
    let last = last_word(&sentence);
    println!("\nFirst word: '{}', Last word: '{}'", first, last);
    
    // 6. Ownership transfer via return
    let new_string = create_string();
    println!("\nCreated: {}", new_string);
    
    println!("\n✓ Ownership rules enforced at compile-time!");
}

fn string_length(s: &String) -> usize {
    s.len()
}

fn add_exclamation(s: &mut String) {
    s.push_str("!");
}

fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &byte) in bytes.iter().enumerate() {
        if byte == b' ' {
            return &s[0..i];
        }
    }
    
    &s[..]
}

fn last_word(s: &String) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &byte) in bytes.iter().enumerate().rev() {
        if byte == b' ' {
            return &s[i+1..];
        }
    }
    
    &s[..]
}

fn create_string() -> String {
    String::from("Ownership transferred!")
}
```

### Comandi Utili

```bash
# Build e run
cargo run

# Check (più veloce, verifica solo errori)
cargo check

# Clippy (linter avanzato)
cargo clippy

# Formattazione
cargo fmt
```

### File da Creare
- `src/main.rs` con esempi di ownership, borrowing, slices

### Test da Passare
1. ✅ Codice compila senza errori
2. ✅ Dimostra move semantics
3. ✅ Usa immutable borrowing (`&T`)
4. ✅ Usa mutable borrowing (`&mut T`)
5. ✅ Esempio con slices (opzionale)
6. ✅ No warning da Clippy

### Esempio di Output Atteso

```
=== Ownership Demo ===

Moved string: Rust ownership

'Hello, Rust!' has 12 characters

Modified: Hello!

Shared: shared data and shared data

First word: 'Rust', Last word: 'amazing'

Created: Ownership transferred!

✓ Ownership rules enforced at compile-time!
```

## Requisiti
- [ ] Dimostra move semantics (ownership transfer)
- [ ] Usa immutable reference (`&T`)
- [ ] Usa mutable reference (`&mut T`)
- [ ] Commenti che spiegano ownership
- [ ] Codice compila senza errori o warning
- [ ] Formattato con `cargo fmt`

## Risorse
- [The Rust Book - Ownership](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html)
- [The Rust Book - References and Borrowing](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html)
- [The Rust Book - Slices](https://doc.rust-lang.org/book/ch04-03-slices.html)
- [Rust by Example - Ownership](https://doc.rust-lang.org/rust-by-example/scope/move.html)
- [Visualizing Memory Layout](https://rust-book.cs.brown.edu/)

## Note

**Concetti chiave:**
- **Ownership**: ogni valore ha UN owner
- **Move**: ownership trasferita (default per heap types)
- **Copy**: valore duplicato (solo stack types)
- **Borrow**: prestito temporaneo (`&` o `&mut`)
- **Lifetime**: quanto vive una reference (implicito qui)

**Errori comuni del borrow checker:**
- "value borrowed after move" → usa reference invece di move
- "cannot borrow as mutable" → già borrowato come immutabile
- "cannot borrow as mutable more than once" → solo un `&mut` alla volta

**Ownership vs altri linguaggi:**
- **C/C++**: manual memory management → Rust ownership automatico
- **Java/Python/Go**: garbage collector → Rust no GC, performance migliori
- **Rust**: compile-time memory safety → zero runtime overhead

**Debug tips:**
- Usa `cargo check` per feedback rapidi
- Leggi i messaggi del compilatore (sono eccellenti!)
- Usa Clippy per suggerimenti idiomatici
- Visualizza ownership con [Rust Playground](https://play.rust-lang.org/)

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
