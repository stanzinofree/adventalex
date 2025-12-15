# Struct Methods

## Obiettivo

Imparare a definire **metodi su struct** in Go, capire la differenza critica tra **value receivers** e **pointer receivers**, e quando usare ciascuno. I metodi sono il modo in cui Go implementa comportamenti object-oriented senza classi.

### Contesto Pratico

I metodi in Go sono fondamentali per:
- **Organizzazione codice**: raggruppare comportamenti correlati
- **Incapsulamento**: nascondere dettagli interni di una struct
- **Interfacce**: i metodi permettono polymorphism via interfaces
- **Domain modeling**: rappresentare entità con stato e comportamento

Casi d'uso reali:
- `http.Server` con metodo `ListenAndServe()`
- `sql.DB` con metodi `Query()`, `Exec()`, `Close()`
- Custom business logic: `Order.Calculate()`, `User.Validate()`
- Data transformations: `Config.Parse()`, `Report.Generate()`

### Sintassi Base: Metodi su Struct

```go
package main

import "fmt"

type Rectangle struct {
    Width  float64
    Height float64
}

// Metodo con value receiver
func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

// Metodo con pointer receiver
func (r *Rectangle) Scale(factor float64) {
    r.Width *= factor
    r.Height *= factor
}

func main() {
    rect := Rectangle{Width: 10, Height: 5}
    
    fmt.Println("Area:", rect.Area())  // 50
    
    rect.Scale(2)  // Modifica rect
    fmt.Println("After scale - Width:", rect.Width)   // 20
    fmt.Println("After scale - Height:", rect.Height) // 10
}
```

**Sintassi metodo:**
```go
func (receiver ReceiverType) MethodName(params) returnType {
    // body
}
```

### Value Receiver vs Pointer Receiver

**Differenza CRITICA:**

```go
package main

import "fmt"

type Counter struct {
    Count int
}

// Value receiver: riceve COPIA della struct
func (c Counter) IncrementByValue() {
    c.Count++  // Modifica la COPIA, non l'originale
    fmt.Println("Inside IncrementByValue:", c.Count)
}

// Pointer receiver: riceve PUNTATORE alla struct
func (c *Counter) IncrementByPointer() {
    c.Count++  // Modifica l'ORIGINALE
    fmt.Println("Inside IncrementByPointer:", c.Count)
}

func main() {
    counter := Counter{Count: 0}
    
    fmt.Println("Initial:", counter.Count)  // 0
    
    counter.IncrementByValue()
    fmt.Println("After value:", counter.Count)  // 0 (non modificato!)
    
    counter.IncrementByPointer()
    fmt.Println("After pointer:", counter.Count)  // 1 (modificato!)
}
```

**Output:**
```
Initial: 0
Inside IncrementByValue: 1
After value: 0          ← COPIA modificata, originale invariato
Inside IncrementByPointer: 1
After pointer: 1        ← Originale modificato
```

### Quando Usare Pointer Receiver

**Usa pointer receiver `(t *Type)` quando:**
1. **Devi modificare** la struct
2. La struct è **grande** (copia costosa)
3. **Consistenza**: se alcuni metodi usano pointer, usali tutti

**Usa value receiver `(t Type)` quando:**
1. La struct è **piccola** (pochi field, tipi base)
2. Il metodo **non modifica** lo stato
3. La struct è **immutabile** per design

```go
package main

import (
    "fmt"
    "math"
)

// Piccola struct immutabile → value receiver
type Point struct {
    X, Y float64
}

func (p Point) Distance(other Point) float64 {
    dx := p.X - other.X
    dy := p.Y - other.Y
    return math.Sqrt(dx*dx + dy*dy)
}

// Struct grande/modificabile → pointer receiver
type Player struct {
    Name     string
    Health   int
    Position Point
    Inventory []string
}

func (p *Player) TakeDamage(damage int) {
    p.Health -= damage
    if p.Health < 0 {
        p.Health = 0
    }
}

func (p *Player) MoveTo(newPos Point) {
    p.Position = newPos
}

func (p *Player) PickupItem(item string) {
    p.Inventory = append(p.Inventory, item)
}

func main() {
    p1 := Point{X: 0, Y: 0}
    p2 := Point{X: 3, Y: 4}
    fmt.Println("Distance:", p1.Distance(p2))  // 5.0
    
    player := Player{
        Name:   "Hero",
        Health: 100,
        Position: Point{X: 0, Y: 0},
    }
    
    player.TakeDamage(30)
    player.MoveTo(Point{X: 10, Y: 20})
    player.PickupItem("Sword")
    
    fmt.Printf("Player: %s | HP: %d | Pos: %+v | Items: %v\n",
        player.Name, player.Health, player.Position, player.Inventory)
}
```

### Method Set: Value vs Pointer

**Regola importante:**

```go
type MyStruct struct {
    Value int
}

func (m MyStruct) ValueMethod() {
    fmt.Println("Value method")
}

func (m *MyStruct) PointerMethod() {
    fmt.Println("Pointer method")
}

func main() {
    // Value struct
    v := MyStruct{Value: 1}
    v.ValueMethod()    // ✅ OK
    v.PointerMethod()  // ✅ OK (Go automaticamente fa &v)
    
    // Pointer struct
    p := &MyStruct{Value: 2}
    p.ValueMethod()    // ✅ OK (Go automaticamente dereferenzia)
    p.PointerMethod()  // ✅ OK
}
```

**Go è smart:** converte automaticamente tra `v` e `&v` quando chiami metodi.

**ATTENZIONE con interfaces:**
```go
type Incrementer interface {
    Increment()
}

type Counter struct {
    Count int
}

func (c *Counter) Increment() {  // Pointer receiver
    c.Count++
}

func main() {
    var i Incrementer
    
    c := Counter{Count: 0}
    i = c   // ❌ ERRORE: Counter non implementa Incrementer
            // Solo *Counter implementa Incrementer!
    
    i = &c  // ✅ OK: *Counter implementa Incrementer
    i.Increment()
}
```

### Metodi su Tipi Custom

Non solo struct! Puoi definire metodi su qualsiasi tipo custom:

```go
package main

import (
    "fmt"
    "strings"
)

// Custom type basato su string
type EmailAddress string

func (e EmailAddress) IsValid() bool {
    return strings.Contains(string(e), "@")
}

func (e EmailAddress) Domain() string {
    parts := strings.Split(string(e), "@")
    if len(parts) == 2 {
        return parts[1]
    }
    return ""
}

// Custom type basato su slice
type Playlist []string

func (p Playlist) Contains(song string) bool {
    for _, s := range p {
        if s == song {
            return true
        }
    }
    return false
}

func (p *Playlist) Add(song string) {
    if !p.Contains(song) {
        *p = append(*p, song)
    }
}

func main() {
    email := EmailAddress("user@example.com")
    fmt.Println("Valid:", email.IsValid())    // true
    fmt.Println("Domain:", email.Domain())    // example.com
    
    var playlist Playlist
    playlist.Add("Song A")
    playlist.Add("Song B")
    playlist.Add("Song A")  // Duplicato, non aggiunto
    
    fmt.Println("Playlist:", playlist)  // [Song A Song B]
}
```

### Esempio Completo: Bank Account

```go
package main

import (
    "fmt"
    "time"
)

type Transaction struct {
    Amount    float64
    Type      string  // "deposit" or "withdraw"
    Timestamp time.Time
}

type BankAccount struct {
    AccountNumber string
    Owner         string
    Balance       float64
    Transactions  []Transaction
}

// Constructor function (common pattern in Go)
func NewBankAccount(accountNumber, owner string, initialBalance float64) *BankAccount {
    return &BankAccount{
        AccountNumber: accountNumber,
        Owner:         owner,
        Balance:       initialBalance,
        Transactions:  []Transaction{},
    }
}

// Pointer receiver: modifica stato
func (ba *BankAccount) Deposit(amount float64) error {
    if amount <= 0 {
        return fmt.Errorf("deposit amount must be positive")
    }
    
    ba.Balance += amount
    ba.Transactions = append(ba.Transactions, Transaction{
        Amount:    amount,
        Type:      "deposit",
        Timestamp: time.Now(),
    })
    
    return nil
}

func (ba *BankAccount) Withdraw(amount float64) error {
    if amount <= 0 {
        return fmt.Errorf("withdraw amount must be positive")
    }
    if amount > ba.Balance {
        return fmt.Errorf("insufficient funds: balance %.2f, requested %.2f",
            ba.Balance, amount)
    }
    
    ba.Balance -= amount
    ba.Transactions = append(ba.Transactions, Transaction{
        Amount:    amount,
        Type:      "withdraw",
        Timestamp: time.Now(),
    })
    
    return nil
}

// Value receiver: non modifica, solo legge
func (ba BankAccount) GetBalance() float64 {
    return ba.Balance
}

func (ba BankAccount) GetStatement() string {
    statement := fmt.Sprintf("=== Account Statement ===\n")
    statement += fmt.Sprintf("Account: %s\n", ba.AccountNumber)
    statement += fmt.Sprintf("Owner: %s\n", ba.Owner)
    statement += fmt.Sprintf("Current Balance: $%.2f\n\n", ba.Balance)
    
    statement += "Recent Transactions:\n"
    for i, tx := range ba.Transactions {
        sign := "+"
        if tx.Type == "withdraw" {
            sign = "-"
        }
        statement += fmt.Sprintf("%d. %s %s$%.2f (%s)\n",
            i+1,
            tx.Timestamp.Format("2006-01-02 15:04"),
            sign,
            tx.Amount,
            tx.Type,
        )
    }
    
    return statement
}

func main() {
    // Crea account
    account := NewBankAccount("ACC-001", "Alice Johnson", 1000.0)
    
    fmt.Printf("Initial balance: $%.2f\n\n", account.GetBalance())
    
    // Operazioni
    account.Deposit(500)
    fmt.Println("Deposited $500")
    
    err := account.Withdraw(200)
    if err != nil {
        fmt.Println("Error:", err)
    } else {
        fmt.Println("Withdrew $200")
    }
    
    err = account.Withdraw(2000)
    if err != nil {
        fmt.Println("Error:", err)  // Insufficient funds
    }
    
    account.Deposit(150)
    
    // Statement
    fmt.Println("\n" + account.GetStatement())
}
```

### Comandi Utili

```bash
# Esegui
go run main.go

# Build
go build -o methods main.go

# Formattazione
go fmt main.go

# Controlla errori comuni
go vet main.go
```

### File da Creare
- `main.go` - Programma con struct e metodi (value e pointer receivers)

### Test da Passare
1. ✅ Build success
2. ✅ Definisci almeno una struct con metodi
3. ✅ Usa sia value receiver che pointer receiver
4. ✅ Dimostra differenza tra value/pointer receiver
5. ✅ Almeno un metodo modifica lo stato (pointer)
6. ✅ Error handling (opzionale)
7. ✅ gofmt compliant

### Esempio di Output Atteso

```
=== Rectangle Demo ===
Area: 50.00
Perimeter: 30.00
After scaling 2x:
Area: 200.00
Perimeter: 60.00

=== Bank Account Demo ===
Initial balance: $1000.00

Deposited $500
Withdrew $200
Error: insufficient funds: balance 1300.00, requested 2000.00

=== Account Statement ===
Account: ACC-001
Owner: Alice Johnson
Current Balance: $1450.00

Recent Transactions:
1. 2025-01-15 10:30 +$500.00 (deposit)
2. 2025-01-15 10:30 -$200.00 (withdraw)
3. 2025-01-15 10:30 +$150.00 (deposit)
```

## Requisiti
- [ ] Definisci almeno una struct
- [ ] Implementa almeno 2 metodi
- [ ] Usa value receiver per almeno un metodo
- [ ] Usa pointer receiver per almeno un metodo
- [ ] Dimostra che pointer receiver modifica stato
- [ ] Commenti per spiegare scelta value vs pointer
- [ ] `go fmt` applied

## Risorse
- [Go Tour - Methods](https://go.dev/tour/methods/1)
- [Go Tour - Pointer Receivers](https://go.dev/tour/methods/4)
- [Effective Go - Methods](https://go.dev/doc/effective_go#methods)
- [Go by Example - Methods](https://gobyexample.com/methods)
- [FAQ - Should I define methods on values or pointers?](https://go.dev/doc/faq#methods_on_values_or_pointers)

## Note

**Best Practices:**
- **Consistenza**: se alcuni metodi usano pointer receiver, usali tutti (anche se non modificano)
- **Default a pointer**: in caso di dubbio, usa pointer receiver
- Struct grandi (> 2-3 fields) → pointer receiver
- Struct immutabili piccole (Point, Color) → value receiver
- Constructor pattern: `func NewType() *Type` ritorna pointer

**Quando il compilatore si lamenta:**
- "cannot use value as pointer in interface" → serve pointer receiver
- Il metodo non modifica la struct → stai usando value receiver

**Method naming conventions:**
- Nomi brevi e descrittivi: `Get()`, `Set()`, `Update()`
- No prefisso "Get" se ovvio: `Balance()` non `GetBalance()`
- Verbi per azioni: `Calculate()`, `Validate()`, `Parse()`

Consulta STUDY.md per esempi specifici e best practices Go.
