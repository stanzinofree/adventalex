# User Management

## Obiettivo

Creare uno script Bash per **gestire utenti e gruppi** del sistema, utile per automazione setup server e gestione accessi.

Lo script deve permettere di:
- Creare nuovi utenti con home directory
- Aggiungere utenti a gruppi specifici
- Verificare se un utente esiste
- Mostrare informazioni utente (gruppi, home, shell)
- Opzionale: disabilitare/eliminare utenti

### Contesto Pratico
Quando serve:
- Onboarding nuovi sviluppatori su server condivisi
- Setup automatico server con utenti predefiniti
- Gestione accessi applicazioni (user dedicati)
- Audit utenti e permessi
- Provisioning automatico con Ansible/Puppet

### File da Creare
- `user_management.sh` - Script principale

### Test da Passare
1. Script eseguibile
2. Verifica esistenza utente
3. Crea utente (simulato o con sudo)
4. Mostra gruppi utente
5. Output formattato

### Comandi Utili
- `id username` - Info utente
- `useradd`, `usermod`, `userdel` - Gestione utenti (richiede root)
- `groups username` - Gruppi utente
- `getent passwd username` - Verifica esistenza
- `grep ^username: /etc/passwd` - Info da /etc/passwd

### Esempio Output
```bash
$ ./user_management.sh check alex
User: alex
Status: EXISTS
UID: 1001
Groups: alex, docker, sudo
Home: /home/alex
Shell: /bin/bash

$ ./user_management.sh create deploy
Creating user: deploy
Home: /home/deploy
Groups: deploy, www-data
Status: CREATED
```

## Requisiti
- [ ] Verifica esistenza utente
- [ ] Mostra info utente
- [ ] Gestisce operazioni base
- [ ] Output chiaro
- [ ] Gestione permessi (sudo se necessario)

## Risorse
- `man useradd`, `man usermod`
- `/etc/passwd`, `/etc/group`
- [Bash Manual](https://www.gnu.org/software/bash/manual/)

## Note
Attenzione: operazioni su utenti richiedono privilegi root.
Lo script può simulare o chiedere sudo quando necessario.
