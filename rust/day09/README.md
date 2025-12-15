# Lifetimes

## Obiettivo

Comprendere i **lifetimes** in Rust, le annotazioni che indicano al compilatore quanto a lungo le references sono valide. I lifetimes prevengono dangling references e sono una parte fondamentale del sistema di ownership che garantisce memory safety.

### Contesto Pratico

I lifetimes sono necessari per:
- **References in structs**: quando struct contiene borrowed data
- **Function signatures**: quando input/output references sono correlati
- **Generic code**: vincolare quanto vivono le references
- **Complex borrowing**: situazioni dove il compilatore non può inferire

La maggior parte del tempo il compilatore **inferisce** i lifetimes automaticamente (lifetime elision), ma a volte devi specificarli esplicitamente.

In produzione:
- Parser con views su input: `struct Parser<'a> { input: &'a str }`
- Cache con borrowed keys: `struct Cache<'a> { keys: Vec<&'a str> }`
- Iterator su references: `impl<'a> Iterator for MyIter<'a>`

### Il Problema: Dangling References

```rust
// ❌ Questo NON compila
fn main() {
    let r;
    {
        let x = 5;
        r = &x;  // x vive solo nel blocco interno
    }  // x è deallocato qui
    // println!("{}", r);  // ERRORE: r punta a memoria invalida!
}
```

Il borrow checker previene questo a compile-time!

### Lifetime Syntax

```rust
// 'a è un lifetime parameter (leggi: "lifetime a")
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

fn main() {
    let string1 = String::from("abcd");
    let string2 = "xyz";
    
    let result = longest(string1.as_str(), string2);
    println!("Longest: {}", result);
}
```

**Significato**: il valore ritornato vivrà tanto quanto il più piccolo tra `x` e `y`.

### Lifetime Annotations in Functions

```rust
// Senza lifetime annotation (ERRORE)
// fn longest(x: &str, y: &str) -> &str {  // ❌ Missing lifetime
//     if x.len() > y.len() { x } else { y }
// }

// Con lifetime annotation (OK)
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// Return value vive quanto il primo parametro
fn first_word<'a>(s: &'a str) -> &'a str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[0..i];
        }
    }
    
    s
}

fn main() {
    let string1 = String::from("hello world");
    
    let word = first_word(&string1);
    println!("First word: {}", word);
}
```

### Lifetime Elision Rules

Il compilatore applica 3 regole per inferire lifetimes:

```rust
// Regola 1: ogni reference input ottiene proprio lifetime
fn foo(x: &i32) {}
// Diventa: fn foo<'a>(x: &'a i32) {}

// Regola 2: se c'è UNA sola input lifetime, output la usa
fn foo(x: &i32) -> &i32 {}
// Diventa: fn foo<'a>(x: &'a i32) -> &'a i32 {}

// Regola 3: se c'è &self o &mut self, output usa il suo lifetime
impl MyStruct {
    fn foo(&self, x: &i32) -> &i32 {}
    // Diventa: fn foo<'a, 'b>(&'a self, x: &'b i32) -> &'a i32 {}
}
```

**Quando servono annotazioni esplicite**: quando le 3 regole non bastano.

### Lifetimes in Structs

```rust
// Struct che contiene reference
struct ImportantExcerpt<'a> {
    part: &'a str,  // Questa reference deve vivere almeno 'a
}

impl<'a> ImportantExcerpt<'a> {
    // Method (lifetime elision applicata)
    fn level(&self) -> i32 {
        3
    }
    
    // Return reference con same lifetime di self
    fn announce_and_return_part(&self, announcement: &str) -> &str {
        println!("Attention: {}", announcement);
        self.part
    }
}

fn main() {
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().expect("No '.'");
    
    let excerpt = ImportantExcerpt {
        part: first_sentence,
    };
    
    println!("Excerpt: {}", excerpt.part);
}
```

**Regola**: la struct non può outlive la reference che contiene.

### Multiple Lifetimes

```rust
// Due lifetimes diversi
fn longest_with_announcement<'a, 'b>(
    x: &'a str,
    y: &'a str,
    ann: &'b str,
) -> &'a str {
    println!("Announcement: {}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

fn main() {
    let string1 = String::from("long string is long");
    let string2 = String::from("short");
    let announcement = "Comparing strings";
    
    let result = longest_with_announcement(
        string1.as_str(),
        string2.as_str(),
        announcement,
    );
    
    println!("Longest: {}", result);
}
```

### The Static Lifetime

```rust
// 'static: vive per tutta la durata del programma
let s: &'static str = "I have a static lifetime.";

// String literals sono sempre 'static (nel binary)
fn get_static() -> &'static str {
    "This is static"
}
```

**⚠️ Attenzione**: non abusare di `'static`! Usalo solo quando necessario.

### Lifetime Bounds

```rust
use std::fmt::Display;

// Lifetime + trait bound
fn longest_with_display<'a, T>(
    x: &'a str,
    y: &'a str,
    ann: T,
) -> &'a str
where
    T: Display,
{
    println!("Announcement: {}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

### Esempio Completo: Text Parser

```rust
#[derive(Debug)]
struct Parser<'a> {
    input: &'a str,
    position: usize,
}

impl<'a> Parser<'a> {
    fn new(input: &'a str) -> Self {
        Parser {
            input,
            position: 0,
        }
    }
    
    // Return reference tied to input lifetime
    fn current(&self) -> &'a str {
        &self.input[self.position..]
    }
    
    // Parse next word
    fn next_word(&mut self) -> Option<&'a str> {
        let remaining = &self.input[self.position..];
        
        // Skip whitespace
        let start = remaining
            .chars()
            .position(|c| !c.is_whitespace())?;
        
        let word_start = self.position + start;
        
        // Find end of word
        let remaining = &self.input[word_start..];
        let word_len = remaining
            .chars()
            .position(|c| c.is_whitespace())
            .unwrap_or(remaining.len());
        
        let word_end = word_start + word_len;
        self.position = word_end;
        
        Some(&self.input[word_start..word_end])
    }
    
    fn is_done(&self) -> bool {
        self.position >= self.input.len()
    }
}

// Function with multiple lifetime parameters
fn find_common_prefix<'a>(s1: &'a str, s2: &'a str) -> &'a str {
    let bytes1 = s1.as_bytes();
    let bytes2 = s2.as_bytes();
    
    let mut i = 0;
    while i < bytes1.len() && i < bytes2.len() && bytes1[i] == bytes2[i] {
        i += 1;
    }
    
    &s1[..i]
}

fn main() {
    println!("=== Parser Demo ===");
    let text = "Hello Rust lifetimes are cool";
    let mut parser = Parser::new(text);
    
    println!("Parsing: \"{}\"", text);
    println!("\nWords:");
    
    while !parser.is_done() {
        if let Some(word) = parser.next_word() {
            println!("  - {}", word);
        }
    }
    
    println!("\n=== Common Prefix Demo ===");
    let s1 = "programming";
    let s2 = "programmer";
    let prefix = find_common_prefix(s1, s2);
    println!("Common prefix of '{}' and '{}': '{}'", s1, s2, prefix);
    
    // Struct with lifetime
    #[derive(Debug)]
    struct Book<'a> {
        title: &'a str,
        author: &'a str,
    }
    
    let title = String::from("The Rust Programming Language");
    let author = "Steve Klabnik";
    
    let book = Book {
        title: &title,
        author,
    };
    
    println!("\n=== Book Demo ===");
    println!("Book: {:?}", book);
    
    println!("\n✓ Lifetime operations complete!");
}
```

### Common Patterns

```rust
// 1. Return reference from input
fn first<'a>(items: &'a [i32]) -> Option<&'a i32> {
    items.first()
}

// 2. Struct holding reference
struct Wrapper<'a> {
    value: &'a str,
}

// 3. Iterator pattern
struct MyIterator<'a> {
    data: &'a [i32],
    index: usize,
}

impl<'a> Iterator for MyIterator<'a> {
    type Item = &'a i32;
    
    fn next(&mut self) -> Option<Self::Item> {
        if self.index < self.data.len() {
            let item = &self.data[self.index];
            self.index += 1;
            Some(item)
        } else {
            None
        }
    }
}
```

### Comandi Utili

```bash
# Build e run
cargo run

# Clippy (aiuta con lifetime issues)
cargo clippy

# Formattazione
cargo fmt
```

### File da Creare
- `src/main.rs` con esempi di lifetime annotations

### Test da Passare
1. ✅ Codice compila
2. ✅ Function con lifetime parameter
3. ✅ Struct con lifetime parameter
4. ✅ Comprende lifetime elision
5. ✅ Multiple lifetimes (opzionale)

### Esempio di Output Atteso

```
=== Parser Demo ===
Parsing: "Hello Rust lifetimes are cool"

Words:
  - Hello
  - Rust
  - lifetimes
  - are
  - cool

=== Common Prefix Demo ===
Common prefix of 'programming' and 'programmer': 'programm'

=== Book Demo ===
Book: Book { title: "The Rust Programming Language", author: "Steve Klabnik" }

✓ Lifetime operations complete!
```

## Requisiti
- [ ] Function con lifetime parameter
- [ ] Struct con lifetime parameter  
- [ ] impl block con lifetimes
- [ ] Comprende lifetime elision rules
- [ ] Codice compila senza lifetime errors
- [ ] Formattato con `cargo fmt`

## Risorse
- [The Rust Book - Lifetimes](https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html)
- [Rust by Example - Lifetimes](https://doc.rust-lang.org/rust-by-example/scope/lifetime.html)
- [Lifetime Elision](https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html#lifetime-elision)
- [Common Lifetime Misconceptions](https://github.com/pretzelhammer/rust-blog/blob/master/posts/common-rust-lifetime-misconceptions.md)

## Note

**Concetti chiave:**
- **Lifetime**: quanto vive una reference
- **'a syntax**: lifetime parameter
- **Borrow checker**: verifica validità lifetimes
- **Elision**: inference automatica (3 regole)
- **'static**: vive per sempre

**Best practices:**
- Lascia che il compilatore inferisca quando possibile
- Usa nomi descriptive: `'input`, `'output`, non solo `'a`, `'b`
- `'static` solo per dati veramente statici
- Preferisci owned data (`String`) a borrowed (`&str`) in struct quando possibile

**Patterns comuni:**
- **Parser/Lexer**: `struct Parser<'a> { input: &'a str }`
- **Cache**: `struct Cache<'a> { data: &'a [u8] }`
- **Iterator**: `struct Iter<'a> { items: &'a [T] }`
- **Builder**: usually doesn't need lifetimes (owns data)

**Quando servono annotations:**
- Function con multiple input references e return reference
- Struct che contiene references
- Trait implementations con references
- Quando elision rules non sono sufficienti

**Debug tips:**
- Errori lifetime sono verbose ma informativi
- Leggi il messaggio: spesso suggerisce la fix
- Usa `cargo clippy` per suggerimenti
- Visualizza con [Rust Playground](https://play.rust-lang.org/)

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
