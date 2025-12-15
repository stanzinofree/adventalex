# Process Monitor

## Obiettivo

Sviluppare uno script per **monitorare e gestire processi** di sistema, trovare processi per nome/pattern e opzionalmente terminarli.

Lo script mostra:
- Processi in esecuzione filtrati per nome
- PID, CPU%, memoria, comando
- Opzione per killare processi specifici
- Alert se processo usa troppa CPU/RAM

### Contesto Pratico
- Trovare e killare processi zombie
- Monitoring uso risorse applicazioni
- Troubleshooting server lento
- Kill processi stuck/hang
- Health check servizi

### Comandi Utili
- `ps aux | grep pattern`
- `pgrep -f pattern`
- `pkill -f pattern`
- `top -b -n 1`
- `kill -9 PID`

### Esempio
```bash
$ ./process_monitor.sh nginx
PID    CPU%  MEM%   CMD
1234   2.5   1.2    nginx: master process
1235   0.1   0.8    nginx: worker process
Total: 2 processes found
```

## Requisiti
- [ ] Filtra processi per nome/pattern
- [ ] Mostra PID, CPU, memoria
- [ ] Opzione per kill (con conferma)
- [ ] Gestione errori

## Risorse
- `man ps`, `man kill`
- `man pgrep`, `man pkill`
