# Arrays & Slices

## Obiettivo

Comprendere **array e slice** in Zig, strutture dati fondamentali con dimensione conosciuta a compile-time o runtime.

Implementare:
- Array a dimensione fissa
- Slice dinamiche
- Iterazione su collezioni
- Manipolazione (append, slice, concatenazione)
- Array multidimensionali

### Contesto Pratico
In Zig:
- Array = dimensione fissa, compile-time
- Slice = view in un array, runtime
- Nessun bound checking a runtime (debug mode sì)
- Performance predicibile

### Differenze Array vs Slice
```zig
// Array - size fissa
const array: [5]i32 = .{1, 2, 3, 4, 5};

// Slice - view dinamica
const slice: []const i32 = &array;
const sub_slice = slice[1..4]; // {2, 3, 4}
```

### File da Creare
- `main.zig`

### Test da Passare
1. Dichiara array fissi
2. Crea slice da array
3. Itera con for loop
4. Accede a elementi
5. Gestisce bounds

### Esempi Codice
```zig
const std = @import("std");

pub fn main() void {
    // Array fisso
    const numbers = [_]i32{10, 20, 30, 40, 50};
    
    // Slice
    const slice = numbers[1..4]; // {20, 30, 40}
    
    // Iterazione
    for (numbers) |num| {
        std.debug.print("{} ", .{num});
    }
    
    // Con indice
    for (numbers, 0..) |num, i| {
        std.debug.print("[{}]={} ", .{i, num});
    }
}
```

## Requisiti
- [ ] Array fissi e slice
- [ ] Iterazione con for
- [ ] Accesso elementi
- [ ] Sub-slicing
- [ ] Output dimostrativo

## Risorse
- [Zig Arrays](https://ziglang.org/documentation/master/#Arrays)
- [Zig Slices](https://ziglang.org/documentation/master/#Slices)
- [Zig Learn - Arrays](https://ziglearn.org/chapter-1/#arrays)
