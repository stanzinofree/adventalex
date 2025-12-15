# Log Parser

## Obiettivo

Sviluppare uno script Bash per **parsare ed estrarre informazioni da file di log**, una delle attività più comuni per SysAdmin e DevOps.

Lo script deve:
- Leggere un file di log (es. /var/log/syslog, apache access.log)
- Estrarre righe contenenti errori, warning o pattern specifici
- Contare occorrenze
- Mostrare statistiche base
- Salvare risultati in un file (opzionale)

### Contesto Pratico
Scenari reali quotidiani:
- Trovare errori in log applicativi dopo un deploy
- Analizzare access log di nginx/apache per traffico sospetto
- Cercare pattern di errore in syslog
- Debugging problemi di produzione
- Report giornalieri su errori critici
- Aggregare log da più servizi

### File da Creare
- `log_parser.sh` - Script principale

### Test da Passare
Il test verifica che lo script:
1. Sia eseguibile
2. Legga un file di log correttamente
3. Filtri righe per pattern (es. "ERROR", "WARN")
4. Conti occorrenze
5. Produca output formattato

### Comandi Utili
- `grep` - Filtra righe per pattern
- `grep -c` - Conta occorrenze
- `awk` - Elaborazione avanzata
- `sed` - Sostituzione pattern
- `sort | uniq -c` - Conta occorrenze uniche
- `tail -f` - Segue log in real-time (bonus)
- `wc -l` - Conta righe

### Esempi di Utilizzo
```bash
# Parse log per errori
$ ./log_parser.sh /var/log/app.log ERROR
Found 23 ERROR lines:
[2025-12-14 10:32:15] ERROR: Database connection failed
[2025-12-14 10:45:21] ERROR: Timeout connecting to API
...

Summary:
- Total lines: 15234
- ERROR lines: 23
- Most common: "Database connection failed" (12 times)

# Parse con multipli pattern
$ ./log_parser.sh /var/log/syslog "ERROR|WARN|CRITICAL"
ERROR: 45 occurrences
WARN: 128 occurrences
CRITICAL: 2 occurrences
```

### Suggerimenti Implementazione
1. Accetta 2 argomenti: file log e pattern
2. Verifica che il file esista e sia leggibile
3. Usa `grep -E` per regex
4. Aggiungi colori per leggibilità (opzionale)
5. Gestisci file compressi (.gz) con `zgrep` (bonus)

### Pattern Comuni da Cercare
- `ERROR|FAIL|FATAL` - Errori critici
- `WARN|WARNING` - Warning
- `404|500|502|503` - HTTP errors
- `timeout|refused|unreachable` - Network issues
- `exception|traceback` - Code errors

## Requisiti
- [ ] Legge file di log
- [ ] Filtra per pattern
- [ ] Conta occorrenze
- [ ] Output chiaro e leggibile
- [ ] Gestione errori (file non esistente)

## Vincoli
- Max 10 minuti di implementazione
- Funzionale > Perfetto
- grep/awk/sed standard

## Risorse
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
- `man grep` - Pattern matching
- `man awk` - Text processing
- [Regex Tutorial](https://regexone.com/)

## Note
Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
Questo è uno script fondamentale - salvalo e riusalo spesso!
