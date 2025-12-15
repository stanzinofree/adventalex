# Text Replacement

## Obiettivo

Script per **sostituire testo in file multipli**, utile per refactoring codice, update configurazioni, batch editing.

Funzionalità:
- Cerca pattern in file (regex)
- Sostituisce con nuovo testo
- Modalità dry-run (preview)
- Backup file originali
- Report modifiche effettuate

### Contesto Pratico
- Update versioni in package.json
- Replace URL in configurazioni
- Refactor nomi variabili in codice
- Update copyright headers
- Migration configurazioni

### Comandi Utili
- `sed -i 's/old/new/g' file`
- `find . -name "*.txt" -exec sed ...`
- `grep -r pattern`
- `perl -pi -e 's/old/new/g'`

### Esempio
```bash
$ ./text_replacement.sh --find "localhost" --replace "prod-server" --files "*.conf" --dry-run
Would replace in:
  nginx.conf: 3 occurrences
  app.conf: 1 occurrence

$ ./text_replacement.sh --find "localhost" --replace "prod-server" --files "*.conf"
Replaced in 2 files (4 total occurrences)
Backups created in .bak/
```

## Requisiti
- [ ] Cerca pattern in file multipli
- [ ] Sostituisce testo
- [ ] Dry-run mode
- [ ] Backup automatico
- [ ] Report modifiche

## Risorse
- `man sed`, `man find`
- [Sed Tutorial](https://www.gnu.org/software/sed/manual/)
