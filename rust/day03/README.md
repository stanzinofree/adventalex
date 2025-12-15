# String vs &str

## Obiettivo

Comprendere la differenza fondamentale tra **`String`** (owned, heap-allocated) e **`&str`** (borrowed string slice), due tipi di stringhe in Rust. Capire quando usare ciascuno è cruciale per scrivere codice Rust idiomatico ed efficiente.

### Contesto Pratico

In Rust ci sono **due principali tipi per stringhe**:
- **`String`**: owned, growable, heap-allocated (come `Vec<u8>` di UTF-8)
- **`&str`**: borrowed, immutable, stack o data segment

Questa distinzione riflette il sistema di ownership e permette:
- **Performance**: evita copie inutili
- **Safety**: garantisce validità UTF-8
- **Flessibilità**: cresce dinamicamente quando serve

In produzione:
- String literals (`"hello"`) sono `&str`
- Configurazioni, input utente → `String`
- Function parameters → preferisci `&str` (più flessibile)
- API responses → spesso `String` (ownership chiara)

### String: Owned, Growable

```rust
fn main() {
    // Creazione String
    let mut s = String::new();  // Stringa vuota
    s.push_str("Hello");
    s.push(' ');
    s.push_str("Rust");
    
    // Da literal
    let s2 = String::from("Hello");
    let s3 = "Hello".to_string();  // Equivalente
    
    // Modificabile
    s.push('!');
    println!("{}", s);  // "Hello Rust!"
}
```

**Caratteristiche `String`:**
- Tipo **owned** (hai ownership)
- **Heap-allocated** (dimensione variabile)
- **Growable**: `push()`, `push_str()`, `+`, `format!()`
- **Mutable** (se dichiarata `let mut`)
- Drop automatico quando esce dallo scope

### &str: String Slice (Borrowed)

```rust
fn main() {
    // String literal (tipo &str, nel data segment)
    let s1: &str = "Hello, world!";
    
    // Slice da String
    let string = String::from("Hello Rust");
    let slice: &str = &string[0..5];  // "Hello"
    let slice2: &str = &string;        // Intera string
    
    // Immutabile
    // s1.push('!');  // ❌ ERRORE: &str è immutabile
    
    println!("{}", s1);
}
```

**Caratteristiche `&str`:**
- Tipo **borrowed** (reference a string data)
- **Stack** (pointer + length)
- **Immutable**: no modifica
- **Fixed size**: no grow
- String literals sono `&'static str` (vivono per tutta l'esecuzione)

### Quando Usare Cosa

```rust
// ✅ Function parameter: preferisci &str (più flessibile)
fn print_string(s: &str) {
    println!("{}", s);
}

fn main() {
    let owned = String::from("owned");
    let literal = "literal";
    
    print_string(&owned);    // ✅ OK: &String -> &str (deref coercion)
    print_string(literal);   // ✅ OK: &str già
    print_string("inline");  // ✅ OK: literal
}

// ❌ Meno flessibile: accetta solo String
fn print_string_bad(s: String) {
    println!("{}", s);
}
// Richiederebbe .to_string() per literals
```

**Regola generale:**
- **Function parameters**: usa `&str` (accetta sia `String` che `&str`)
- **Return owned string**: usa `String`
- **Store in struct**: `String` (owned) o `&'a str` (con lifetime)
- **String literals**: sono automaticamente `&str`

### Conversioni String ↔ &str

```rust
fn main() {
    // &str → String
    let slice: &str = "hello";
    let owned1: String = slice.to_string();
    let owned2: String = String::from(slice);
    let owned3: String = slice.into();  // Trait Into
    
    // String → &str
    let string = String::from("hello");
    let slice1: &str = &string;         // Deref coercion
    let slice2: &str = string.as_str(); // Explicit
    let slice3: &str = &string[..];     // Slice notation
}
```

### String Operations

```rust
fn main() {
    let mut s = String::from("Hello");
    
    // Append
    s.push_str(" Rust");
    s.push('!');
    
    // Concatenation (move s1!)
    let s1 = String::from("Hello, ");
    let s2 = String::from("world!");
    let s3 = s1 + &s2;  // s1 mosso, s2 borrowato
    // println!("{}", s1);  // ❌ s1 non più valido
    
    // format! macro (no move)
    let s4 = String::from("tic");
    let s5 = String::from("tac");
    let s6 = String::from("toe");
    let s7 = format!("{}-{}-{}", s4, s5, s6);  // Tutti ancora validi
    
    println!("{}", s7);  // "tic-tac-toe"
}
```

### Slicing Strings

```rust
fn main() {
    let s = String::from("hello world");
    
    // Slices (attenzione: indici in BYTE, non caratteri!)
    let hello = &s[0..5];   // "hello"
    let world = &s[6..11];  // "world"
    
    // Shortcuts
    let hello2 = &s[..5];   // Equivalente
    let world2 = &s[6..];   // Fino alla fine
    let full = &s[..];      // Intera string
    
    println!("{} {}", hello, world);
}
```

**⚠️ ATTENZIONE: Slicing su UTF-8**
```rust
fn main() {
    let s = String::from("こんにちは");  // Giapponese
    
    // ❌ PANIC! Slicing in mezzo a carattere multi-byte
    // let slice = &s[0..1];
    
    // ✅ OK: caratteri completi
    let slice = &s[0..3];  // Un carattere (3 byte UTF-8)
    
    // Meglio: usa .chars() per iterare
    for c in s.chars() {
        println!("{}", c);
    }
}
```

### String Methods Comuni

```rust
fn main() {
    let s = String::from("  Hello Rust  ");
    
    // Trim whitespace
    let trimmed = s.trim();
    println!("'{}'", trimmed);  // "Hello Rust"
    
    // Contains
    if s.contains("Rust") {
        println!("Found Rust!");
    }
    
    // Replace
    let replaced = s.replace("Rust", "World");
    println!("{}", replaced);
    
    // Split
    let words: Vec<&str> = "one,two,three".split(',').collect();
    println!("{:?}", words);  // ["one", "two", "three"]
    
    // To uppercase/lowercase
    let upper = "hello".to_uppercase();  // String
    let lower = "HELLO".to_lowercase();  // String
    println!("{} {}", upper, lower);
    
    // Length (in bytes!)
    let len_bytes = s.len();
    let len_chars = s.chars().count();
    println!("Bytes: {}, Chars: {}", len_bytes, len_chars);
}
```

### Esempio Completo: Text Processor

```rust
fn main() {
    println!("=== String vs &str Demo ===\n");
    
    // 1. String literals sono &str
    let literal: &str = "Rust Programming";
    println!("Literal: {}", literal);
    
    // 2. String owned
    let mut owned = String::from("Hello");
    owned.push_str(", Rust!");
    println!("Owned: {}", owned);
    
    // 3. Slicing
    let full = String::from("Hello World");
    let hello = &full[..5];
    let world = &full[6..];
    println!("Sliced: '{}' and '{}'", hello, world);
    
    // 4. Function con &str parameter
    print_length("string literal");
    print_length(&owned);
    
    // 5. Concatenation
    let first = String::from("Rust");
    let second = String::from("Language");
    let combined = format!("{} {}", first, second);
    println!("\nCombined: {}", combined);
    
    // 6. Text processing
    let text = "  Rust is AMAZING  ";
    let processed = process_text(text);
    println!("Processed: '{}'", processed);
    
    // 7. Split and collect
    let csv = "apple,banana,cherry";
    let fruits = parse_csv(csv);
    println!("\nFruits: {:?}", fruits);
    
    println!("\n✓ String handling complete!");
}

fn print_length(s: &str) {
    println!("Length of '{}': {}", s, s.len());
}

fn process_text(input: &str) -> String {
    input.trim().to_lowercase()
}

fn parse_csv(input: &str) -> Vec<String> {
    input.split(',')
        .map(|s| s.trim().to_string())
        .collect()
}

// Esempio: first word finder
fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &byte) in bytes.iter().enumerate() {
        if byte == b' ' {
            return &s[..i];
        }
    }
    
    s
}

#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_first_word() {
        assert_eq!(first_word("hello world"), "hello");
        assert_eq!(first_word("rust"), "rust");
        assert_eq!(first_word(""), "");
    }
    
    #[test]
    fn test_process_text() {
        assert_eq!(process_text("  HELLO  "), "hello");
    }
}
```

### Memory Layout

```
String {
    ptr: *mut u8,     // Puntatore a heap
    len: usize,       // Lunghezza effettiva
    capacity: usize,  // Capacità allocata
}

&str {
    ptr: *const u8,   // Puntatore a data (heap, stack, o data segment)
    len: usize,       // Lunghezza
}
```

**String** occupa 24 bytes su stack + N bytes su heap.  
**&str** occupa 16 bytes su stack (puntatore + len).

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
- `src/main.rs` con esempi di `String` e `&str`

### Test da Passare
1. ✅ Codice compila
2. ✅ Crea e usa `String`
3. ✅ Usa string slices (`&str`)
4. ✅ Conversione `String` ↔ `&str`
5. ✅ Function con `&str` parameter
6. ✅ String operations (push, split, etc.)

### Esempio di Output Atteso

```
=== String vs &str Demo ===

Literal: Rust Programming
Owned: Hello, Rust!
Sliced: 'Hello' and 'World'
Length of 'string literal': 14
Length of 'Hello, Rust!': 12

Combined: Rust Language
Processed: 'rust is amazing'

Fruits: ["apple", "banana", "cherry"]

✓ String handling complete!
```

## Requisiti
- [ ] Usa sia `String` che `&str`
- [ ] Dimostra conversione tra i due
- [ ] Function parameter con `&str`
- [ ] String operations (push, split, trim, etc.)
- [ ] Slicing corretto (attenzione UTF-8)
- [ ] Test unitari (opzionale)
- [ ] Formattato con `cargo fmt`

## Risorse
- [The Rust Book - Strings](https://doc.rust-lang.org/book/ch08-02-strings.html)
- [Rust by Example - Strings](https://doc.rust-lang.org/rust-by-example/std/str.html)
- [std::string::String](https://doc.rust-lang.org/std/string/struct.String.html)
- [Primitive Type str](https://doc.rust-lang.org/std/primitive.str.html)

## Note

**Concetti chiave:**
- **`String`**: owned, growable, heap
- **`&str`**: borrowed, fixed, cheap
- **UTF-8**: Rust strings sono sempre UTF-8 valido
- **Slicing**: indici in byte, non caratteri (attenzione!)

**Best practices:**
- Function params: `&str` > `String` (più flessibile)
- Return value: `String` se ownership necessaria
- String literals (`"text"`) sono `&'static str`
- Usa `format!()` per concatenazione senza move
- Evita `.clone()` a meno che necessario

**Errori comuni:**
- Slicing in mezzo a carattere UTF-8 → panic
- `s1 + &s2` muove `s1` (meglio `format!("{}{}", s1, s2)`)
- `.len()` ritorna BYTE, non caratteri (usa `.chars().count()`)
- Confondere `String` e `&String` (usa `&str` invece di `&String`)

**Performance tips:**
- `&str` è "gratis" da passare (16 bytes)
- `String` clone è costoso (copia heap data)
- `String::with_capacity()` per pre-allocare
- `.as_str()` converte `&String` → `&str` senza costo

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
