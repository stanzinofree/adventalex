# String Processing

## Obiettivo

Imparare a **manipolare stringhe** in Python usando metodi built-in e regex, skill fondamentale per parsing e data processing.

Funzionalità da implementare:
- Manipolazione base (upper, lower, strip, split)
- Formattazione (f-strings, format)
- Pattern matching con regex
- Validazione input
- Estrazione informazioni da testo

### Contesto Pratico
Operazioni quotidiane:
- Parsing log files
- Validazione email/URL
- Data cleaning
- Estrazione dati da testo non strutturato
- API response processing

### File da Creare
- `string_processing.py`

### Test da Passare
1. Manipolazione stringhe base
2. Regex pattern matching
3. Validazione formato
4. Estrazione dati
5. Output formattato

### Esempi Codice
```python
import re

# String methods
text = "  Hello World  "
print(text.strip().lower())  # "hello world"

# F-strings
name = "Alice"
age = 30
print(f"{name} is {age} years old")

# Regex
email = "user@example.com"
if re.match(r'^[\w\.-]+@[\w\.-]+\.\w+$', email):
    print("Valid email")

# Extraction
text = "Price: $19.99"
price = re.search(r'\$(\d+\.\d+)', text)
if price:
    print(f"Found: {price.group(1)}")
```

### Operazioni Comuni
- `str.split()`, `str.join()`
- `str.replace()`, `str.find()`
- `str.startswith()`, `str.endswith()`
- `re.match()`, `re.search()`, `re.findall()`
- F-strings: `f"{var}"`

## Requisiti
- [ ] String manipulation
- [ ] Regex pattern matching
- [ ] Validazione input
- [ ] Formattazione output
- [ ] Gestione edge cases

## Risorse
- [Python String Methods](https://docs.python.org/3/library/stdtypes.html#string-methods)
- [Python re module](https://docs.python.org/3/library/re.html)
- [Regex101](https://regex101.com/) - Regex tester

## Note
Mastering strings è essenziale - usato in quasi ogni script Python!
