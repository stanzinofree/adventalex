# CSV Parser

## Obiettivo

Creare uno script per **leggere, filtrare e processare file CSV**, essenziale per data processing e report automation.

Lo script deve:
- Leggere file CSV
- Filtrare righe per criteri
- Estrarre colonne specifiche
- Calcolare statistiche (count, sum, avg)
- Output formattato o nuovo CSV

### Contesto Pratico
- Processare export database
- Filtrare log in formato CSV
- Generare report da dati grezzi
- ETL semplice senza tool pesanti
- Data cleanup e validation

### Comandi Utili
- `awk -F',' '{print $1,$3}'`
- `cut -d',' -f1,3`
- `grep` con pattern su colonne
- `sort`, `uniq`
- `bc` per calcoli

### Esempio
```bash
$ cat users.csv
name,age,city
Alice,30,Rome
Bob,25,Milan

$ ./csv_parser.sh users.csv age '>28'
Found 1 rows:
Alice,30,Rome

$ ./csv_parser.sh users.csv --column city --count
Milan: 1
Rome: 1
```

## Requisiti
- [ ] Legge CSV con header
- [ ] Filtra per colonna e valore
- [ ] Estrae colonne specifiche
- [ ] Calcola statistiche base
- [ ] Output formattato

## Risorse
- `man awk`, `man cut`
- [CSV processing in Bash](https://www.gnu.org/software/gawk/manual/gawk.html)
