# Variables & Types

## Obiettivo

Imparare a dichiarare e usare **variabili e tipi** in Zig, comprendendo il sistema di tipi sicuro e le differenze tra var/const.

Il programma deve:
- Dichiarare variabili di tipi diversi (int, float, bool, string)
- Usare `var` (mutabile) e `const` (immutabile)
- Stampare valori con type inference
- Dimostrare conversioni di tipo
- Usare tipi opzionali `?T`

### Contesto Pratico
Zig ha un sistema di tipi molto rigoroso che previene errori comuni:
- Nessuna conversione implicita (no int to float automatico)
- Null safety con optional types
- Compile-time type checking
- Zero overhead abstractions

### File da Creare
- `main.zig` - Programma principale

### Test da Passare
1. Zig compiler presente
2. Compilazione senza errori
3. Output mostra diversi tipi
4. Dimostra var vs const
5. Usa optional types

### Concetti da Esplorare
```zig
const std = @import("std");

pub fn main() void {
    // Integer types
    const x: i32 = 42;
    var y: u8 = 255;
    
    // Type inference
    const name = "Zig"; // []const u8
    
    // Optional types
    var maybe_value: ?i32 = null;
    maybe_value = 100;
    
    // Print con formatting
    std.debug.print("x={}, name={s}\n", .{x, name});
}
```

### Tipi Comuni in Zig
- `i8`, `i16`, `i32`, `i64` - Signed integers
- `u8`, `u16`, `u32`, `u64` - Unsigned integers
- `f32`, `f64` - Floating point
- `bool` - Boolean
- `[]const u8` - String slice
- `?T` - Optional type

## Requisiti
- [ ] Dichiara variabili di tipi diversi
- [ ] Usa var e const correttamente
- [ ] Dimostra optional types
- [ ] Output formattato
- [ ] Compila senza warning

## Risorse
- [Zig Language Reference - Types](https://ziglang.org/documentation/master/#Types)
- [Zig Learn - Variables](https://ziglearn.org/chapter-1/)
- [Zig Standard Library](https://ziglang.org/documentation/master/std/)

## Note
Zig non ha null implicito - devi usare ?T per valori nullable!
