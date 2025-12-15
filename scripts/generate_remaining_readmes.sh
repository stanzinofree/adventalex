#!/usr/bin/env bash
set -euo pipefail

# Script to generate structured templates for day10-30 across all languages

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Function to create README template
create_readme() {
    local lang=$1
    local day=$2
    local title=$3
    local topic=$4
    
    local day_padded=$(printf "%02d" "$day")
    local readme_path="$ROOT_DIR/$lang/day$day_padded/README.md"
    
    # Determine file extension and commands based on language
    local file_ext=""
    local build_cmd=""
    local run_cmd=""
    local fmt_cmd=""
    
    case "$lang" in
        bash)
            file_ext="sh"
            build_cmd="# No build needed"
            run_cmd="bash main.sh"
            fmt_cmd="shellcheck main.sh"
            ;;
        python)
            file_ext="py"
            build_cmd="# No build needed"
            run_cmd="python main.py"
            fmt_cmd="black main.py"
            ;;
        go)
            file_ext="go"
            build_cmd="go build"
            run_cmd="go run main.go"
            fmt_cmd="go fmt"
            ;;
        rust)
            file_ext="rs"
            build_cmd="cargo build"
            run_cmd="cargo run"
            fmt_cmd="cargo fmt"
            ;;
        zig)
            file_ext="zig"
            build_cmd="zig build-exe main.zig"
            run_cmd="zig run main.zig"
            fmt_cmd="zig fmt main.zig"
            ;;
        javascript)
            file_ext="js"
            build_cmd="# No build needed"
            run_cmd="node index.js"
            fmt_cmd="prettier --write index.js"
            ;;
    esac
    
    cat > "$readme_path" << EOF
# $title

## Obiettivo

$topic

Questa sfida ti permette di applicare i concetti fondamentali del linguaggio in uno scenario pratico.

### Contesto Pratico

In real-world development, le competenze acquisite in questa challenge sono utili per:
- Automazione di task ripetitivi
- Processing di dati e trasformazioni
- Integrazione con sistemi esterni
- Tool CLI per DevOps

### Esempio Base

\`\`\`$file_ext
// Implementa la soluzione qui
// Segui le best practices del linguaggio
\`\`\`

### Comandi Utili

\`\`\`bash
# Build
$build_cmd

# Run
$run_cmd

# Format
$fmt_cmd
\`\`\`

### File da Creare
- \`main.$file_ext\` - Implementazione principale

### Test da Passare
1. ✅ Build/compile success
2. ✅ Run success  
3. ✅ Functionality implemented
4. ✅ Code formatted
5. ✅ Best practices followed

## Requisiti
- [ ] Implementa la funzionalità richiesta
- [ ] Gestisci casi edge e errori
- [ ] Scrivi codice leggibile e manutenibile
- [ ] Aggiungi commenti dove necessario
- [ ] Testa il codice manualmente
- [ ] Codice formattato correttamente

## Risorse
- Documentazione ufficiale del linguaggio
- Tutorial e guide online
- STUDY.md per context aggiuntivo

## Note

**Tips:**
- Inizia con una soluzione semplice, poi migliora
- Focalizzati su funzionalità > ottimizzazione prematura
- Testa frequentemente durante lo sviluppo
- Max 10 minuti - priorità a codice funzionante

Consulta STUDY.md per dettagli aggiuntivi su questa sfida.
EOF
    
    echo "Created: $readme_path"
}

# Main execution
echo "=== Generating README templates for day10-30 ==="

# Bash topics
create_readme "bash" 10 "Log Analyzer" "Parse log, contare errori"
create_readme "bash" 11 "File Watcher" "inotifywait per modifiche file"
create_readme "bash" 12 "Backup Script" "tar/rsync backup automatico"
create_readme "bash" 13 "Process Monitor" "ps/top per monitorare processi"
create_readme "bash" 14 "Cron Task" "Scheduling con cron job"
create_readme "bash" 15 "SSH Automation" "Comandi remoti via SSH"
create_readme "bash" 16 "Docker Helper" "Script per docker build/run"
create_readme "bash" 17 "Git Helper" "Automation git workflow"
create_readme "bash" 18 "System Info" "Raccogliere info sistema"
create_readme "bash" 19 "Network Check" "ping/curl health check"
create_readme "bash" 20 "DB Backup" "mysqldump/pg_dump automation"
create_readme "bash" 21 "Service Manager" "systemctl wrapper"
create_readme "bash" 22 "Config Parser" "Parse .env/.ini file"
create_readme "bash" 23 "Report Generator" "Generare report HTML/CSV"
create_readme "bash" 24 "Security Scanner" "Check permissions/vulnerabilities"
create_readme "bash" 25 "Deploy Script" "Full deploy automation"
create_readme "bash" 26 "Log Rotation" "Rotate e compress logs"
create_readme "bash" 27 "Alert System" "Email/Slack notifications"
create_readme "bash" 28 "Benchmark Tool" "Performance measurement"
create_readme "bash" 29 "Infrastructure Check" "Health check infra"
create_readme "bash" 30 "DevOps Dashboard" "CLI dashboard con rich/click"

echo "✓ Bash templates complete"

# Python topics  
create_readme "python" 10 "Log Analyzer" "Parse log, contare errori"
create_readme "python" 11 "File System Walker" "os.walk, trovare file"
create_readme "python" 12 "Text Report Generator" "Report formattato"
create_readme "python" 13 "Web Scraper" "BeautifulSoup scraping"
create_readme "python" 14 "Data Validator" "Validare dati con pydantic"
create_readme "python" 15 "API Client" "requests per API consumption"
create_readme "python" 16 "Database ORM" "SQLAlchemy basics"
create_readme "python" 17 "Testing" "pytest unit tests"
create_readme "python" 18 "CLI Tool" "Click per CLI app"
create_readme "python" 19 "FastAPI Server" "REST API con FastAPI"
create_readme "python" 20 "Background Tasks" "Celery/RQ tasks"
create_readme "python" 21 "Docker Integration" "docker-py automation"
create_readme "python" 22 "Monitoring" "Prometheus metrics"
create_readme "python" 23 "Config Management" "dynaconf/python-decouple"
create_readme "python" 24 "Logging" "structlog per logging"
create_readme "python" 25 "Data Processing" "pandas data pipeline"
create_readme "python" 26 "Async I/O" "asyncio per concurrent ops"
create_readme "python" 27 "Scheduler" "APScheduler per task"
create_readme "python" 28 "Performance" "Profiling e optimization"
create_readme "python" 29 "Infrastructure as Code" "Terraform/CloudFormation"
create_readme "python" 30 "DevOps Dashboard" "CLI tool status infra"

echo "✓ Python templates complete"

# Go topics
create_readme "go" 10 "HTTP Client" "net/http GET/POST"
create_readme "go" 11 "REST API" "HTTP server con routing"
create_readme "go" 12 "Database" "database/sql con SQLite"
create_readme "go" 13 "Configuration" "viper per config"
create_readme "go" 14 "Testing" "testing package"
create_readme "go" 15 "Logging" "zerolog/zap structured logging"
create_readme "go" 16 "Channels" "Goroutines e channels"
create_readme "go" 17 "WaitGroup" "Sincronizzazione goroutine"
create_readme "go" 18 "HTTP Server" "net/http server base"
create_readme "go" 19 "HTTP Client" "GET/POST requests"
create_readme "go" 20 "HTTP Handlers" "Routing, middleware"
create_readme "go" 21 "Context" "context.Context timeout/cancel"
create_readme "go" 22 "CLI Tool Cobra" "CLI con cobra"
create_readme "go" 23 "Config File" "Viper configurazioni"
create_readme "go" 24 "Database" "database/sql SQLite/PostgreSQL"
create_readme "go" 25 "Testing" "Unit test testing package"
create_readme "go" 26 "Logging" "structured logging zerolog/zap"
create_readme "go" 27 "Docker Builder" "Dockerfile multi-stage Go"
create_readme "go" 28 "REST API" "API con gin/echo"
create_readme "go" 29 "Worker Pool" "Pattern worker canali"
create_readme "go" 30 "DevOps CLI" "Tool per deploy/monitoring"

echo "✓ Go templates complete"

# Rust topics
create_readme "rust" 10 "Collections" "HashMap, HashSet"
create_readme "rust" 11 "Iterator" "Iterator trait custom"
create_readme "rust" 12 "File I/O" "std::fs read/write"
create_readme "rust" 13 "Command Line" "std::env args parsing"
create_readme "rust" 14 "Error Handling" "thiserror/anyhow"
create_readme "rust" 15 "Serialization" "serde JSON/YAML"
create_readme "rust" 16 "Testing" "Unit e integration test"
create_readme "rust" 17 "Modules" "mod, pub, use"
create_readme "rust" 18 "Regex" "Regex processing"
create_readme "rust" 19 "Async Basics" "async/await tokio"
create_readme "rust" 20 "File Watcher" "notify file changes"
create_readme "rust" 21 "CSV Processing" "csv crate parsing"
create_readme "rust" 22 "HTTP Server" "axum/actix-web server"
create_readme "rust" 23 "Database" "sqlx PostgreSQL/SQLite"
create_readme "rust" 24 "Testing" "Unit + integration test"
create_readme "rust" 25 "Error Handling" "thiserror/anyhow"
create_readme "rust" 26 "Concurrency" "Thread, Arc, Mutex"
create_readme "rust" 27 "CLI Tool" "clap + serde"
create_readme "rust" 28 "Performance" "Benchmark, optimization"
create_readme "rust" 29 "Cross-compilation" "Build Linux/macOS/Windows"
create_readme "rust" 30 "DevOps Tool" "CLI infra management"

echo "✓ Rust templates complete"

# Zig topics
create_readme "zig" 10 "Pointers" "Puntatori, slice pointers"
create_readme "zig" 11 "Optionals" "?T optional values"
create_readme "zig" 12 "ArrayList" "std.ArrayList dynamic array"
create_readme "zig" 13 "HashMap" "std.HashMap"
create_readme "zig" 14 "File I/O" "std.fs read/write"
create_readme "zig" 15 "Testing" "test blocks, expect()"
create_readme "zig" 16 "Generics" "Generic functions/types"
create_readme "zig" 17 "Comptime" "Compile-time execution"
create_readme "zig" 18 "Build System" "build.zig"
create_readme "zig" 19 "Modules" "Import/export packages"
create_readme "zig" 20 "Async" "async/await"
create_readme "zig" 21 "C Interop" "Chiamare funzioni C"
create_readme "zig" 22 "CLI Parser" "Argomenti std.process"
create_readme "zig" 23 "JSON Parser" "std.json parse/stringify"
create_readme "zig" 24 "HTTP Client" "std.http.Client"
create_readme "zig" 25 "File Watcher" "Polling directory"
create_readme "zig" 26 "Binary Tool" "Process file binari"
create_readme "zig" 27 "Network Socket" "TCP socket client"
create_readme "zig" 28 "Performance Tool" "Benchmark, comptime"
create_readme "zig" 29 "Cross-platform" "Build per OS diversi"
create_readme "zig" 30 "System Tool" "Tool DevOps complete"

echo "✓ Zig templates complete"

# JavaScript topics
create_readme "javascript" 10 "JSON Processing" "Parse, stringify, validation"
create_readme "javascript" 11 "HTTP Requests" "fetch/axios API calls"
create_readme "javascript" 12 "Express Server" "REST API con Express"
create_readme "javascript" 13 "Environment Variables" ".env con dotenv"
create_readme "javascript" 14 "CLI Tool" "commander.js CLI app"
create_readme "javascript" 15 "Database" "SQLite con better-sqlite3"
create_readme "javascript" 16 "Testing" "Jest unit tests"
create_readme "javascript" 17 "Logging" "winston logger"
create_readme "javascript" 18 "Validation" "joi/zod schema validation"
create_readme "javascript" 19 "Web Scraper" "cheerio web scraping"
create_readme "javascript" 20 "Task Queue" "Bull queue jobs"
create_readme "javascript" 21 "Cron Jobs" "node-cron scheduling"
create_readme "javascript" 22 "GraphQL" "Apollo Server GraphQL API"
create_readme "javascript" 23 "WebSocket" "Socket.io real-time"
create_readme "javascript" 24 "Stream Processing" "Node.js streams"
create_readme "javascript" 25 "Docker Integration" "dockerode automation"
create_readme "javascript" 26 "Monitoring" "prom-client metrics"
create_readme "javascript" 27 "Performance" "Profiling, optimization"
create_readme "javascript" 28 "Security" "helmet, rate-limiting"
create_readme "javascript" 29 "Deployment" "PM2 process manager"
create_readme "javascript" 30 "Full Stack CLI" "Complete DevOps tool"

echo "✓ JavaScript templates complete"

echo ""
echo "=== Summary ==="
echo "Generated 126 README templates (21 days × 6 languages)"
echo "All files created successfully!"
