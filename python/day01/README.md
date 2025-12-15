# Hello + Environment

## Obiettivo

Creare un programma Python che stampi informazioni sull'**ambiente Python** e sistema, verificando che il setup sia corretto.

Il programma deve mostrare:
- Versione Python (sys.version)
- Informazioni piattaforma (os, arch)
- Path eseguibile Python
- Variabili ambiente chiave
- Directory di lavoro corrente

### Contesto Pratico
Primo script che ogni sviluppatore Python scrive:
- Verifica installazione Python corretta
- Debug problemi di ambiente
- Documentazione setup per team
- CI/CD environment check
- Troubleshooting path e import issues

### File da Creare
- `hello_environment.py` (o simile)

### Test da Passare
1. Python3 installato
2. Script eseguibile
3. Esecuzione senza errori
4. Output contiene versione Python
5. Output contiene info piattaforma

### Concetti da Usare
```python
import sys
import os
import platform

# Versione Python
print(f"Python: {sys.version}")

# Piattaforma
print(f"OS: {platform.system()} {platform.release()}")
print(f"Arch: {platform.machine()}")

# Path
print(f"Executable: {sys.executable}")
print(f"Working dir: {os.getcwd()}")

# Environment
print(f"PATH: {os.environ.get('PATH', 'N/A')}")
```

### Output Atteso
```
=== Python Environment Info ===
Python: 3.11.5
OS: Darwin 23.0.0
Arch: arm64
Executable: /usr/local/bin/python3
Working dir: /Users/alex/projects
PATH: /usr/local/bin:/usr/bin:...
```

## Requisiti
- [ ] Stampa versione Python
- [ ] Mostra info piattaforma
- [ ] Mostra path eseguibile
- [ ] Formattazione chiara
- [ ] Esegue senza errori

## Risorse
- [Python Docs - sys module](https://docs.python.org/3/library/sys.html)
- [Python Docs - os module](https://docs.python.org/3/library/os.html)
- [Python Docs - platform](https://docs.python.org/3/library/platform.html)

## Note
Script base ma essenziale per ogni progetto Python!
