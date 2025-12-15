# Backup Script

## Obiettivo

Creare uno script Bash per eseguire **backup automatizzati** di directory importanti, con timestamp e rotazione, competenza essenziale per SysAdmin.

Lo script deve:
- Accettare una directory sorgente come argomento
- Creare un archivio tar.gz con timestamp nel nome
- Salvare il backup in una directory destinazione
- Verificare che il backup sia riuscito
- Opzionale: mantenere solo gli ultimi N backup (rotazione)

### Contesto Pratico
Scenari reali dove serve:
- Backup giornaliero di configurazioni (/etc)
- Backup prima di aggiornamenti critici
- Snapshot di directory di progetto
- Backup database dump files
- Archiviazione log prima di rotazione
- Disaster recovery preparation

### File da Creare
- `backup_script.sh` - Script principale

### Test da Passare
Il test verifica che lo script:
1. Sia eseguibile
2. Crei un archivio tar.gz
3. Includa timestamp nel nome file
4. Verifichi successo operazione
5. Gestisca errori (directory non esistente)

### Comandi Utili
- `tar czf` - Crea archivio compresso
- `date +%Y%m%d_%H%M%S` - Timestamp formato
- `basename`, `dirname` - Manipola path
- `mkdir -p` - Crea directory ricorsivamente
- `ls -t | tail -n +N` - Lista file ordinati per data
- `du -sh` - Dimensione archivio

### Esempi di Utilizzo
```bash
# Backup base
$ ./backup_script.sh /etc/nginx
Creating backup of /etc/nginx...
Archive: /backups/nginx_20251214_153045.tar.gz
Size: 2.3M
Status: SUCCESS

# Con rotazione (mantiene ultimi 5)
$ ./backup_script.sh /var/www/html 5
Creating backup...
Archive: /backups/html_20251214_153120.tar.gz
Cleaning old backups (keeping last 5)...
Removed: html_20251207_120000.tar.gz
Status: SUCCESS
```

### Suggerimenti Implementazione
1. Usa `tar czf` per compressione gzip
2. Nome file: `basename_$(date +%Y%m%d_%H%M%S).tar.gz`
3. Verifica exit code di tar ($? -eq 0)
4. Escludi file temporanei (*.tmp, *.log~)
5. Mostra dimensione finale con `du -sh`

### Best Practices
- Sempre verificare exit code
- Log in /var/log/backup.log (opzionale)
- Notifica via email se fallisce (avanzato)
- Test di restore periodici
- Backup su storage esterno/remoto

## Requisiti
- [ ] Crea archivio tar.gz con timestamp
- [ ] Verifica successo operazione
- [ ] Mostra dimensione archivio
- [ ] Gestione errori
- [ ] Opzionale: rotazione backup

## Vincoli
- Max 10 minuti di implementazione
- Funzionale > Perfetto
- tar/gzip standard

## Risorse
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
- `man tar` - Archiving tool
- `man date` - Timestamp formatting

## Note
Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
Script fondamentale - salvalo per uso frequente!
