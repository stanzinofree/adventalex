# File Permissions Checker

## Obiettivo

Creare uno script Bash che **verifichi i permessi** di file e directory, utile per audit di sicurezza o troubleshooting.

Lo script deve accettare un percorso come argomento e mostrare:
- Se il file/directory esiste
- Il tipo (file, directory, link simbolico)
- I permessi in formato numerico (es. 755) e simbolico (es. rwxr-xr-x)
- Il proprietario e gruppo
- Se è leggibile, scrivibile, eseguibile dall'utente corrente

### Contesto Pratico
Quando lavori come DevOps/SysAdmin, spesso devi verificare rapidamente:
- Perché un'applicazione non riesce a leggere un file di configurazione
- Perché uno script non è eseguibile
- Chi possiede un file critico
- Se i permessi sono troppo permissivi (security issue)

Questo script ti permette di fare queste verifiche in modo rapido e leggibile.

### File da Creare
- `file_permissions_checker.sh` - Script principale

### Test da Passare
Il test verifica che lo script:
1. Sia eseguibile
2. Produca output non vuoto
3. Gestisca correttamente i casi di file esistente/non esistente
4. Mostri i permessi in formato leggibile
5. Identifichi correttamente il tipo di file

### Comandi Utili
- `ls -l` - Mostra permessi in formato lungo
- `stat` - Informazioni dettagliate su file
- `test -r/-w/-x` - Verifica permessi
- `whoami` - Utente corrente
- `id` - Informazioni utente e gruppi

### Esempio di Output Atteso
```bash
$ ./file_permissions_checker.sh /etc/passwd

File: /etc/passwd
Type: regular file
Permissions: 644 (rw-r--r--)
Owner: root:root
Current user can read: yes
Current user can write: no
Current user can execute: no
```

## Requisiti
- [ ] Accetta path come argomento
- [ ] Mostra tipo, permessi, owner
- [ ] Verifica permessi per utente corrente
- [ ] Output chiaro e leggibile

## Vincoli
- Max 10 minuti di implementazione
- Funzionale > Perfetto
- Usa comandi standard Unix

## Risorse
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/)
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
- `man test` - Operatori di test file
- `man stat` - Informazioni file

## Note
Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
