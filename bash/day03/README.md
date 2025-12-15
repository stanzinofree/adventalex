# Network Connectivity Test

## Obiettivo

Creare uno script Bash per **testare la connettività di rete** verso uno o più host, essenziale per diagnostica di problemi di rete in ambienti DevOps.

Lo script deve verificare:
- Se un host è raggiungibile tramite ping
- Se una porta TCP specifica è aperta (es. 80, 443, 22)
- Tempo di risposta
- Report chiaro su successo/fallimento

### Contesto Pratico
Scenari reali dove questo script è utile:
- Verificare se un server web è raggiungibile prima di fare deploy
- Controllare se il database è raggiungibile dalla applicazione
- Diagnosticare problemi di connettività in produzione
- Script di health check pre/post deployment
- Monitoring di base senza tool esterni

### File da Creare
- `network_connectivity_test.sh` - Script principale

### Test da Passare
Il test verifica che lo script:
1. Sia eseguibile
2. Produca output non vuoto
3. Testi connettività ICMP (ping)
4. Testi connettività TCP su porta specifica
5. Mostri risultati chiari (success/fail)

### Comandi Utili
- `ping -c N host` - Invia N pacchetti ICMP
- `nc -zv host port` - Test porta TCP con netcat
- `timeout` - Limita durata comando
- `curl -I --connect-timeout 5 URL` - Test HTTP
- `telnet host port` - Test porta (alternativa a nc)

### Esempi di Utilizzo
```bash
# Test ping base
$ ./network_connectivity_test.sh google.com
Host: google.com
Ping: OK (response in 15ms)

# Test con porta
$ ./network_connectivity_test.sh example.com 443
Host: example.com
Ping: OK
Port 443: OPEN

# Test fallito
$ ./network_connectivity_test.sh 192.168.99.99 22
Host: 192.168.99.99
Ping: FAILED (timeout after 3s)
Port 22: CLOSED
```

### Suggerimenti Implementazione
1. Accetta almeno 1 argomento (hostname)
2. Opzionale: secondo argomento per porta TCP
3. Usa `ping -c 3 -W 3` per timeout di 3 secondi
4. Gestisci exit code correttamente (0=success, 1=fail)
5. Output colorato se vuoi (ANSI codes)

## Requisiti
- [ ] Test ping con timeout
- [ ] Test porta TCP (opzionale)
- [ ] Output chiaro success/fail
- [ ] Exit code corretto
- [ ] Gestione errori

## Vincoli
- Max 10 minuti di implementazione
- Funzionale > Perfetto
- Comandi portabili (ping, nc o curl)

## Risorse
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
- `man ping` - ICMP echo request
- `man nc` - Netcat per test porte
- `man timeout` - Limita durata comandi

## Note
Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
Questo script può essere espanso per monitoring multi-host in futuro.
