# Vectors

## Obiettivo

Padroneggiare **`Vec<T>`**, la collezione dinamica più usata in Rust. Vec è l'equivalente di ArrayList (Java), vector (C++), slice (Go), o list (Python), ma con ownership semantics e zero-cost abstractions.

### Contesto Pratico

`Vec<T>` è la struttura dati fondamentale per:
- **Liste dinamiche**: dimensione variabile a runtime
- **Buffer**: accumulare dati da stream, file, network
- **Stack/Queue**: implementare strutture dati custom
- **Batch processing**: processare collezioni di dati

Caratteristiche:
- **Growable**: aggiungi/rimuovi elementi dinamicamente
- **Heap-allocated**: gestione automatica della memoria
- **Contiguous**: elementi in memoria contigua (cache-friendly)
- **Owned**: Vec possiede i suoi elementi

In produzione:
- Log processing: `Vec<LogEntry>`
- API responses: `Vec<User>`
- File parsing: `Vec<String>` per righe
- Buffers: `Vec<u8>` per byte data

### Creazione Vectors

```rust
fn main() {
    // Vec vuoto (tipo inferito)
    let mut v1: Vec<i32> = Vec::new();
    
    // Vec vuoto con tipo esplicito
    let mut v2 = Vec::<String>::new();
    
    // Con macro vec!
    let v3 = vec![1, 2, 3, 4, 5];
    
    // Con capacità iniziale (ottimizzazione)
    let mut v4 = Vec::with_capacity(100);
    
    // Da iterator
    let v5: Vec<i32> = (1..=10).collect();
    
    // Riempito con valore default
    let v6 = vec![0; 10];  // [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    
    println!("v3: {:?}", v3);
    println!("v5: {:?}", v5);
    println!("v6: {:?}", v6);
}
```

### Aggiungere/Rimuovere Elementi

```rust
fn main() {
    let mut v = Vec::new();
    
    // Push (aggiunge in coda)
    v.push(1);
    v.push(2);
    v.push(3);
    println!("After push: {:?}", v);  // [1, 2, 3]
    
    // Pop (rimuove da coda, ritorna Option)
    if let Some(last) = v.pop() {
        println!("Popped: {}", last);  // 3
    }
    println!("After pop: {:?}", v);  // [1, 2]
    
    // Insert (inserisce a indice)
    v.insert(1, 99);
    println!("After insert: {:?}", v);  // [1, 99, 2]
    
    // Remove (rimuove a indice)
    let removed = v.remove(1);
    println!("Removed: {}", removed);  // 99
    println!("After remove: {:?}", v);  // [1, 2]
    
    // Extend (aggiunge iterabile)
    v.extend([3, 4, 5]);
    println!("After extend: {:?}", v);  // [1, 2, 3, 4, 5]
    
    // Clear (rimuove tutto)
    v.clear();
    println!("After clear: {:?}", v);  // []
}
```

### Accesso agli Elementi

```rust
fn main() {
    let v = vec![10, 20, 30, 40, 50];
    
    // Indexing (panic se out of bounds!)
    let third = v[2];
    println!("Third element: {}", third);  // 30
    
    // get() - ritorna Option (safe!)
    match v.get(2) {
        Some(value) => println!("Third: {}", value),
        None => println!("Out of bounds"),
    }
    
    // get() con indice invalido
    match v.get(100) {
        Some(value) => println!("Value: {}", value),
        None => println!("Index 100 is out of bounds"),
    }
    
    // first() e last()
    if let Some(first) = v.first() {
        println!("First: {}", first);
    }
    
    if let Some(last) = v.last() {
        println!("Last: {}", last);
    }
}
```

**Differenza `[]` vs `.get()`:**
- `v[i]` → panic se out of bounds
- `v.get(i)` → ritorna `Option<&T>` (safe)

### Iterazione

```rust
fn main() {
    let v = vec![1, 2, 3, 4, 5];
    
    // Iterate by reference (immutable)
    println!("Immutable iteration:");
    for num in &v {
        println!("{}", num);
    }
    
    // Iterate by mutable reference
    let mut v2 = vec![1, 2, 3];
    println!("\nMutable iteration:");
    for num in &mut v2 {
        *num *= 2;  // Dereferenzia e modifica
    }
    println!("Modified: {:?}", v2);  // [2, 4, 6]
    
    // Iterate by value (consuma il vec!)
    let v3 = vec![1, 2, 3];
    println!("\nConsume iteration:");
    for num in v3 {
        println!("{}", num);
    }
    // println!("{:?}", v3);  // ❌ ERRORE: v3 mosso
    
    // Enumerate (con indice)
    let v4 = vec!["a", "b", "c"];
    for (i, value) in v4.iter().enumerate() {
        println!("{}: {}", i, value);
    }
}
```

### Metodi Utili

```rust
fn main() {
    let mut v = vec![3, 1, 4, 1, 5, 9, 2, 6];
    
    // Length
    println!("Length: {}", v.len());
    
    // Is empty
    if !v.is_empty() {
        println!("Vec is not empty");
    }
    
    // Contains
    if v.contains(&5) {
        println!("Contains 5");
    }
    
    // Sort
    v.sort();
    println!("Sorted: {:?}", v);
    
    // Reverse
    v.reverse();
    println!("Reversed: {:?}", v);
    
    // Dedup (rimuove duplicati consecutivi, serve sort prima!)
    v.sort();
    v.dedup();
    println!("Deduplicated: {:?}", v);
    
    // Retain (filtra in-place)
    v.retain(|&x| x > 3);
    println!("Retained > 3: {:?}", v);
}
```

### Capacity Management

```rust
fn main() {
    let mut v = Vec::new();
    
    println!("Initial - len: {}, capacity: {}", v.len(), v.capacity());
    
    // Push aumenta capacity quando necessario (raddoppia)
    for i in 1..=10 {
        v.push(i);
        println!("After push {} - len: {}, capacity: {}", 
            i, v.len(), v.capacity());
    }
    
    // Reserve (garantisce capacità minima)
    v.reserve(100);
    println!("After reserve - len: {}, capacity: {}", v.len(), v.capacity());
    
    // Shrink to fit (riduce capacità a len)
    v.shrink_to_fit();
    println!("After shrink - len: {}, capacity: {}", v.len(), v.capacity());
    
    // with_capacity (pre-alloca)
    let v2 = Vec::with_capacity(1000);
    println!("Pre-allocated - len: {}, capacity: {}", v2.len(), v2.capacity());
}
```

**Performance tip:** se conosci la dimensione finale, usa `with_capacity()` per evitare riallocazioni.

### Slicing

```rust
fn main() {
    let v = vec![1, 2, 3, 4, 5];
    
    // Slice (borrow parziale)
    let slice = &v[1..4];  // [2, 3, 4]
    println!("Slice: {:?}", slice);
    
    // Shortcuts
    let start = &v[..3];   // [1, 2, 3]
    let end = &v[3..];     // [4, 5]
    let all = &v[..];      // [1, 2, 3, 4, 5]
    
    // Metodi su slice
    let sum: i32 = slice.iter().sum();
    println!("Sum of slice: {}", sum);
}
```

### Vec di Struct

```rust
#[derive(Debug)]
struct Person {
    name: String,
    age: u32,
}

fn main() {
    let mut people = Vec::new();
    
    people.push(Person {
        name: String::from("Alice"),
        age: 30,
    });
    
    people.push(Person {
        name: String::from("Bob"),
        age: 25,
    });
    
    // Iterate
    for person in &people {
        println!("{} is {} years old", person.name, person.age);
    }
    
    // Filter e collect
    let adults: Vec<&Person> = people
        .iter()
        .filter(|p| p.age >= 18)
        .collect();
    
    println!("\nAdults: {:?}", adults);
}
```

### Functional Programming con Vec

```rust
fn main() {
    let numbers = vec![1, 2, 3, 4, 5];
    
    // map: trasforma ogni elemento
    let doubled: Vec<i32> = numbers.iter()
        .map(|x| x * 2)
        .collect();
    println!("Doubled: {:?}", doubled);
    
    // filter: filtra elementi
    let even: Vec<i32> = numbers.iter()
        .filter(|x| *x % 2 == 0)
        .copied()  // Da &i32 a i32
        .collect();
    println!("Even: {:?}", even);
    
    // fold: riduce a singolo valore
    let sum: i32 = numbers.iter().sum();
    println!("Sum: {}", sum);
    
    // Chain operations
    let result: Vec<i32> = numbers.iter()
        .filter(|x| *x > 2)
        .map(|x| x * x)
        .collect();
    println!("Filtered & squared: {:?}", result);
}
```

### Esempio Completo: Todo List

```rust
#[derive(Debug, Clone)]
struct Todo {
    id: u32,
    title: String,
    completed: bool,
}

struct TodoList {
    todos: Vec<Todo>,
    next_id: u32,
}

impl TodoList {
    fn new() -> Self {
        TodoList {
            todos: Vec::new(),
            next_id: 1,
        }
    }
    
    fn add(&mut self, title: String) {
        self.todos.push(Todo {
            id: self.next_id,
            title,
            completed: false,
        });
        self.next_id += 1;
    }
    
    fn complete(&mut self, id: u32) -> Result<(), String> {
        match self.todos.iter_mut().find(|t| t.id == id) {
            Some(todo) => {
                todo.completed = true;
                Ok(())
            }
            None => Err(format!("Todo {} not found", id)),
        }
    }
    
    fn remove(&mut self, id: u32) -> Result<(), String> {
        let pos = self.todos.iter()
            .position(|t| t.id == id)
            .ok_or_else(|| format!("Todo {} not found", id))?;
        
        self.todos.remove(pos);
        Ok(())
    }
    
    fn list(&self) {
        println!("\n=== Todo List ===");
        if self.todos.is_empty() {
            println!("No todos!");
            return;
        }
        
        for todo in &self.todos {
            let status = if todo.completed { "✓" } else { " " };
            println!("[{}] {}: {}", status, todo.id, todo.title);
        }
    }
    
    fn stats(&self) {
        let total = self.todos.len();
        let completed = self.todos.iter()
            .filter(|t| t.completed)
            .count();
        let pending = total - completed;
        
        println!("\n=== Stats ===");
        println!("Total: {}, Completed: {}, Pending: {}", 
            total, completed, pending);
    }
}

fn main() {
    let mut list = TodoList::new();
    
    // Add todos
    list.add("Learn Rust".to_string());
    list.add("Build project".to_string());
    list.add("Write tests".to_string());
    
    list.list();
    
    // Complete some
    list.complete(1).unwrap();
    list.complete(3).unwrap();
    
    list.list();
    list.stats();
    
    // Remove one
    list.remove(2).unwrap();
    
    list.list();
    list.stats();
    
    println!("\n✓ Vec operations complete!");
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
- `src/main.rs` con esempi di `Vec<T>`

### Test da Passare
1. ✅ Codice compila
2. ✅ Crea Vec con `Vec::new()` e `vec![]`
3. ✅ Push/pop elementi
4. ✅ Accesso con `[]` e `.get()`
5. ✅ Iterazione (immutable e mutable)
6. ✅ Metodi funzionali (map, filter, collect)

### Esempio di Output Atteso

```
=== Todo List ===
[ ] 1: Learn Rust
[ ] 2: Build project
[ ] 3: Write tests

=== Todo List ===
[✓] 1: Learn Rust
[ ] 2: Build project
[✓] 3: Write tests

=== Stats ===
Total: 3, Completed: 2, Pending: 1

=== Todo List ===
[✓] 1: Learn Rust
[✓] 3: Write tests

=== Stats ===
Total: 2, Completed: 2, Pending: 0

✓ Vec operations complete!
```

## Requisiti
- [ ] Crea Vec con diverse tecniche
- [ ] Push/pop elementi
- [ ] Accesso elementi (indexing e `.get()`)
- [ ] Iterazione (immutable/mutable)
- [ ] Usa metodi: sort, filter, map (opzionale)
- [ ] Vec di struct custom (opzionale)
- [ ] Formattato con `cargo fmt`

## Risorse
- [The Rust Book - Vectors](https://doc.rust-lang.org/book/ch08-01-vectors.html)
- [Rust by Example - Vectors](https://doc.rust-lang.org/rust-by-example/std/vec.html)
- [std::vec::Vec](https://doc.rust-lang.org/std/vec/struct.Vec.html)
- [Iterator trait](https://doc.rust-lang.org/std/iter/trait.Iterator.html)

## Note

**Concetti chiave:**
- **Vec<T>**: owned, growable, heap-allocated
- **Capacity**: len vs capacity (ottimizzazione)
- **Indexing**: `[]` panic, `.get()` safe
- **Iteration**: `&vec`, `&mut vec`, `vec` (consume)
- **Slicing**: `&vec[start..end]`

**Best practices:**
- Usa `with_capacity()` se conosci dimensione
- Preferisci `.get()` a `[]` per accesso safe
- Itera con `&vec` per non consumare
- Usa functional methods (map, filter) per trasformazioni
- `collect()` richiede type annotation o context

**Errori comuni:**
- `v[i]` out of bounds → panic (usa `.get(i)`)
- Iterare con `for x in vec` consuma vec
- Dimenticare `&mut` per modifica durante iterazione
- `.iter()` vs `.into_iter()` vs `&vec`

**Performance tips:**
- Vec è cache-friendly (memoria contigua)
- `with_capacity()` evita riallocazioni
- `shrink_to_fit()` riduce memoria (trade-off)
- Capacity cresce esponenzialmente (amortized O(1) push)

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
