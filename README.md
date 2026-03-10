# Bilge Development Kit (BDK)

AI coding assistant'inizi 23 uzman agent, 96 skill, 15 workflow ve otomatik guvenlik korumasi ile donatin. Claude Code ve Gemini ile calisir.

---

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Agents (23)](#agents-23)
- [Skills (96)](#skills-96)
- [Slash Commands (15)](#slash-commands-15)
- [Hooks - Automated Guardrails (4)](#hooks---automated-guardrails-4)
- [Always-On Rules (5)](#always-on-rules-5)
- [Contexts (3)](#contexts-3)
- [Scripts (6)](#scripts-6)
- [MCP Configuration](#mcp-configuration)
- [How It Works](#how-it-works)
- [Customization](#customization)
- [Statistics](#statistics)

---

## Overview

BDK, AI coding assistant'inizi "genel amacli chatbot" seviyesinden "uzman gelistirici ekibi" seviyesine cikarir.

**Ne yapar:**
- Istegi otomatik siniflandirir (soru mu, kod mu, tasarim mi?)
- Dogru uzman agent'i secer (frontend? backend? security?)
- O agent'in skill'lerini yukler (react-best-practices, api-patterns, vb.)
- Her kod ciktisinda always-on kurallari uygular (guvenlik, stil, test)
- Hooks ile tehlikeli islemleri otomatik engeller (secret leak, rm -rf)

**Ne YAPMAZ:**
- Kendi basina calistirilmaz - Claude Code veya Gemini icinde calisir
- Runtime dependency'si yoktur - tamami markdown + shell script
- Projenize kod eklemez - sadece AI assistant'in davranisini yonlendirir

---

## Quick Start

### 1. Repoyu klonla veya kopyala

```bash
# Mevcut projenize .agent klasoru olarak kopyalamak icin
git clone https://github.com/user/bilge-dev-kit.git
cp -r bilge-dev-kit/.agent your-project/.agent
```

Veya dogrudan proje kokunde kullanin:

```bash
cd your-project
# .agent/ dizinini proje kokune yerlestirin
```

### 2. Claude Code icin

Claude Code `.agent/CLAUDE.md` dosyasini otomatik olarak okur. Ek konfigurasyona gerek yoktur.

Hooks'lari etkinlestirmek icin `.agent/.claude/settings.json` dosyasinin yerinde oldugundan emin olun.

### 3. Gemini icin

Gemini `.agent/rules/GEMINI.md` dosyasini referans alir. Projenizin AI ayarlarinda bu dosyayi isaretleyin.

### 4. Kullanmaya basla

```
/brainstorm authentication system
/create user registration page
/review
/build-fix
```

---

## Architecture

```
.agent/
├── ARCHITECTURE.md              # Sistem haritasi
├── CLAUDE.md                    # Claude Code protokol kurallari
├── mcp_config.json.example      # MCP sunucu sablonu
│
├── agents/                      # 23 Uzman Agent
│   ├── orchestrator.md          #   Multi-agent koordinasyon
│   ├── frontend-specialist.md   #   Web UI/UX
│   ├── backend-specialist.md    #   API, is mantigi
│   ├── security-auditor.md      #   OWASP, zero trust
│   └── ...                      #   +19 daha
│
├── .claude/
│   ├── settings.json            # Hooks konfigurasyonu
│   └── skills/                  # 96 Domain Skill
│       ├── react-best-practices/
│       ├── api-patterns/
│       ├── clean-code/
│       └── ...
│
├── workflows/                   # 15 Slash Command
│   ├── brainstorm.md            #   /brainstorm
│   ├── create.md                #   /create
│   ├── build-fix.md             #   /build-fix
│   └── ...
│
├── rules/                       # Global Kurallar
│   ├── CLAUDE.md                #   Claude Code kurallari
│   ├── GEMINI.md                #   Gemini kurallari
│   └── common/                  #   Always-on standartlar
│       ├── git-workflow.md
│       ├── coding-style.md
│       ├── testing.md
│       ├── security.md
│       └── performance.md
│
├── contexts/                    # Mod Bazli Davranis
│   ├── dev.md                   #   Gelistirme modu
│   ├── review.md                #   Kod review modu
│   └── research.md              #   Arastirma modu
│
├── scripts/                     # Otomasyon Araclar
│   ├── hooks/                   #   Guardrail scriptleri
│   │   ├── dangerous_cmd_check.sh
│   │   ├── secret_scanner.sh
│   │   ├── lint_check.sh
│   │   └── session_save.sh
│   ├── detect_pm.py             #   PM auto-detection
│   ├── checklist.py             #   Proje dogrulama
│   ├── verify_all.py            #   Kapsamli test suite
│   ├── auto_preview.py          #   Dev server yonetimi
│   └── session_manager.py       #   Proje analizi
│
└── .shared/
    └── ui-ux-pro-max/           # UI/UX kaynaklari (CSV data)
```

### Istek Isleme Akisi

```
Kullanici Istegi
    |
    v
[1. Siniflandirma] --> Soru? Kod? Tasarim? Survey?
    |
    v
[2. Agent Secimi] --> frontend-specialist? backend-specialist? debugger?
    |
    v
[3. Skill Yukleme] --> Agent'in frontmatter'indaki skills: listesi
    |
    v
[4. Kural Uygulama] --> Always-on rules + agent-specific rules
    |
    v
[5. Hooks] --> Secret scan, lint check, session save
    |
    v
Cikti
```

---

## Agents (23)

Her agent bir `.md` dosyasidir. Icinde persona, yetenekler ve yuklenecek skill listesi vardir.

| Agent | Alan | Tipik Kullanim |
|-------|------|----------------|
| `orchestrator` | Multi-agent koordinasyon | 3+ domain iceren karmasik gorevler |
| `project-planner` | Kesif, planlama | Yeni proje baslangici, gorev kirma |
| `frontend-specialist` | Web UI/UX | React, Next.js, Tailwind |
| `backend-specialist` | API, is mantigi | Express, FastAPI, veritabani |
| `database-architect` | Sema, SQL | Migrasyon, indexleme, normalizasyon |
| `mobile-developer` | Mobil | React Native, Flutter, SwiftUI |
| `game-developer` | Oyun | Unity, Godot, Phaser |
| `ai-engineer` | AI/ML | LLM app, RAG, agent gelistirme |
| `data-engineer` | Veri | ETL, Spark, dbt, Airflow |
| `devops-engineer` | Altyapi | CI/CD, Docker, Kubernetes |
| `security-auditor` | Guvenlik | OWASP, supply chain, zero trust |
| `penetration-tester` | Saldiri | Red team, exploit gelistirme |
| `test-engineer` | Test | TDD, unit/integration/E2E |
| `qa-automation-engineer` | E2E | Playwright, Cypress, CI entegrasyon |
| `debugger` | Hata ayiklama | Root cause analysis, crash investigation |
| `performance-optimizer` | Performans | Web Vitals, profiling, bottleneck |
| `seo-specialist` | SEO | Ranking, structured data, Core Web Vitals |
| `documentation-writer` | Dokumantasyon | API docs, README, teknik rehber |
| `product-manager` | Urun | Gereksinimler, user story, PRD |
| `product-owner` | Strateji | Backlog, MVP, onceliklendirme |
| `api-designer` | API tasarimi | REST, GraphQL, gRPC |
| `code-archaeologist` | Legacy kod | Eski kod analizi, modernizasyon |
| `explorer-agent` | Kesif | Codebase tarama, deep analysis |

### Agent Nasil Calisir?

```markdown
# agents/frontend-specialist.md

---
name: frontend-specialist
skills:
  - react-best-practices
  - frontend-design
  - tailwind-patterns
  - web-design-guidelines
---

## Persona
Sen deneyimli bir frontend gelistiricisin...

## Ilkeler
1. Component-first dusun
2. Accessibility (WCAG 2.1 AA) zorunlu
...
```

Bir frontend gorevi geldiginde:
1. Claude `agents/frontend-specialist.md` dosyasini okur
2. Frontmatter'daki `skills:` listesini yukler
3. O agent'in persona ve ilkelerini uygular

---

## Skills (96)

Skill'ler agent'larin yukledigi bilgi modulleridir. Her biri bir `SKILL.md` dosyasi ve opsiyonel `scripts/`, `references/`, `assets/` klasorleri icerir.

### Kategoriler

| Kategori | Skill Sayisi | Ornekler |
|----------|-------------|----------|
| AI & LLM | 24 | `ai-engineer`, `rag-engineer`, `langchain-architecture`, `llm-evaluation` |
| Backend & API | 8 | `api-patterns`, `fastapi-pro`, `nodejs-best-practices` |
| Frontend & UI | 4 | `react-best-practices`, `tailwind-patterns`, `frontend-design` |
| Testing & Quality | 8 | `tdd-workflow`, `webapp-testing`, `code-review-checklist` |
| Security | 2 | `vulnerability-scanner`, `red-team-tactics` |
| DevOps & Infra | 9 | `deployment-procedures`, `grafana-dashboards`, `prometheus-configuration` |
| Data & ML | 5 | `data-engineer`, `ml-engineer`, `airflow-dag-patterns` |
| Architecture | 6 | `architecture`, `app-builder`, `plan-writing` |
| Code Quality | 6 | `clean-code`, `refactoring-patterns`, `code-refactoring-tech-debt` |
| Documentation | 5 | `readme`, `documentation-templates`, `writing-skills` |
| Python | 3 | `python-patterns`, `python-packaging`, `python-testing-patterns` |
| Rust | 1 | `rust-pro` |
| Shell/CLI | 3 | `bash-linux`, `powershell-windows`, `linux-shell-scripting` |
| Mobile & Game | 2 | `mobile-design`, `game-development` |
| SEO | 2 | `seo-fundamentals`, `geo-fundamentals` |
| Caching & Performance | 2 | `caching-patterns`, `performance-profiling` |
| Agent Behavior | 3 | `behavioral-modes`, `parallel-agents`, `mcp-builder` |
| Build | 1 | `build-fix` |
| Database | 1 | `database-design` |
| Brainstorming | 1 | `brainstorming` |

---

## Slash Commands (15)

`/komut` yazarak tetiklenen workflow'lar:

| Komut | Aciklama | Ornek Kullanim |
|-------|----------|----------------|
| `/brainstorm` | Fikir kesfi. 3+ opsiyon, artilari/eksileri, oneri. | `/brainstorm auth system` |
| `/create` | Sifirdan feature/component olusturma. | `/create user profile page` |
| `/debug` | Sistematik hata ayiklama. | `/debug login 500 error` |
| `/deploy` | Deployment sureci yonetimi. | `/deploy production` |
| `/enhance` | Mevcut kodu iyilestirme. | `/enhance search performance` |
| `/orchestrate` | Birden fazla agent'i koordine etme. | `/orchestrate full-stack auth` |
| `/plan` | Gorevi alt gorevlere kirma. | `/plan e-commerce MVP` |
| `/preview` | Dev server baslat/durdur. | `/preview start 3000` |
| `/refactor` | Sistematik yeniden yapilandirma. | `/refactor extract auth service` |
| `/review` | Kod review (guvenlik, performans, stil). | `/review` |
| `/security` | Guvenlik denetimi. | `/security full scan` |
| `/status` | Proje durumu kontrolu. | `/status` |
| `/test` | Test suite calistirma. | `/test unit` |
| `/ui-ux-pro-max` | 50 farkli stilde UI tasarimi. | `/ui-ux-pro-max dashboard` |
| `/build-fix` | Build hatalarini otomatik tespit ve cozum. | `/build-fix` |

### Ek Skill Komutlari

| Komut | Aciklama |
|-------|----------|
| `/brainstorming` | Sokratik sorgulama + 3 zorunlu soru + multi-agent design review |
| `/simplify` | Degistirilen kodu kalite ve verimlilik icin gozden gecirme |
| `/loop` | Bir komutu tekrarlayan araliklarla calistirma (`/loop 5m /status`) |

---

## Hooks - Automated Guardrails (4)

Hooks, Claude Code'un yerlesik hook sistemini kullanarak otomatik calisir. Kullanici mudahalesi gerekmez.

Konfigurasyon: `.agent/.claude/settings.json`

| Hook | Olay | Tetikleyici | Ne Yapar |
|------|------|------------|----------|
| `dangerous_cmd_check.sh` | PreToolUse | Bash komutlari | `rm -rf /`, `git push --force`, `DROP TABLE` gibi yikici komutlari engeller |
| `secret_scanner.sh` | PreToolUse | Write, Edit | AWS key, OpenAI key, JWT, Stripe key gibi secret pattern'leri tarar |
| `lint_check.sh` | PostToolUse | Edit, Write | Dosya degisikliginden sonra ESLint/Ruff/JSON syntax kontrolu yapar |
| `session_save.sh` | Stop | Her session sonu | Session context ozetini memory'ye kaydeder |

### Hook Calisma Mantigi

```
Kullanici: "rm -rf /" iceren komut calistir
    |
    v
[PreToolUse:Bash hook tetiklenir]
    |
    v
dangerous_cmd_check.sh --> Pattern eslesti!
    |
    v
Exit code 2 + stderr mesaji --> ENGELLENDI
    |
    v
Claude'a geri bildirim: "Bu komut yikici, alternatif oneriyorum..."
```

---

## Always-On Rules (5)

`rules/common/` altindaki kurallar her kod ciktisina otomatik uygulanir:

| Kural | Icerik |
|-------|--------|
| **git-workflow.md** | Conventional Commits (`feat(scope): desc`), branch naming (`feature/`, `fix/`), PR standartlari |
| **coding-style.md** | camelCase (JS/TS), snake_case (Python), PascalCase (class), import sirasi, max 300 satir/dosya |
| **testing.md** | Yeni feature = test zorunlu, AAA pattern, %80 unit / %60 integration coverage, test pyramid |
| **security.md** | Secret ASLA hardcode edilmez, OWASP top 10 korumalari, dependency audit her deploy oncesi |
| **performance.md** | LCP < 2.5s, INP < 200ms, CLS < 0.1, JS bundle < 200KB gzip, N+1 query yasak |

---

## Contexts (3)

Gorev tipine gore davranis ayarlari:

| Context | Ne Zaman | Davranis |
|---------|----------|----------|
| **dev.md** | Yeni kod yazarken, prototip | Hizli iterasyon, debug-friendly, hot reload |
| **review.md** | PR review, kod inceleme | SOLID checklist, breaking change tespiti, severity seviyeleri |
| **research.md** | Teknoloji karsilastirma, analiz | Tablo formati, evidence-based, pros/cons, kaynak gosterme |

---

## Scripts (6)

### Validation & Verification

```bash
# Hizli dogrulama (gelistirme sirasinda)
python .agent/scripts/checklist.py .
# Kontrol eder: Security, Lint, Schema, Test, UX, SEO

# Kapsamli dogrulama (deploy oncesi)
python .agent/scripts/verify_all.py . --url http://localhost:3000
# Ek kontroller: Lighthouse, Playwright E2E, Bundle, Mobile, i18n
```

### Dev Server

```bash
python .agent/scripts/auto_preview.py start [port]   # Dev server baslat
python .agent/scripts/auto_preview.py stop            # Durdur
python .agent/scripts/auto_preview.py status          # Durum kontrol
```

### Project Analysis

```bash
python .agent/scripts/session_manager.py status .     # Proje durumu
python .agent/scripts/session_manager.py info .       # Tech stack bilgisi
```

### Package Manager Detection

```bash
python .agent/scripts/detect_pm.py                    # Tespit edilen PM (npm/yarn/pnpm/bun)
python .agent/scripts/detect_pm.py --install          # Install komutu
python .agent/scripts/detect_pm.py --run dev           # Run komutu
python .agent/scripts/detect_pm.py --test             # Test komutu
python .agent/scripts/detect_pm.py --json             # Tum komutlar JSON
```

Tespit sirasi: lockfile > package.json `packageManager` > `CLAUDE_PACKAGE_MANAGER` env var > npm fallback

---

## MCP Configuration

Ornek MCP sunucu konfigurasyonu `.agent/mcp_config.json.example` dosyasinda:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--api-key", "YOUR_API_KEY"]
    },
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"]
    }
  }
}
```

Kullanmak icin `mcp_config.json.example` dosyasini `mcp_config.json` olarak kopyalayin ve API key'lerinizi girin. `.gitignore` `mcp_config.json` dosyasini zaten haric tutar.

---

## How It Works

### 1. Istek Siniflandirma (TIER 0)

Her istek oncelikle siniflandirilir:

| Tip | Tetikleyici | Sonuc |
|-----|------------|-------|
| QUESTION | "ne", "nasil", "acikla" | Metin yanit |
| SURVEY | "analiz et", "listele" | Explore agent ile analiz |
| SIMPLE CODE | "duzelt", "ekle" (tek dosya) | Inline edit |
| COMPLEX CODE | "olustur", "implement et" | Plan dosyasi + multi-agent |
| DESIGN | "tasarla", "UI", "dashboard" | Plan + design agent |

### 2. Sokratik Kapi (Brainstorming)

Karmasik isteklerde Claude otomatik olarak durur ve soru sorar:

```
Kullanici: "E-commerce sitesi yap"

Claude (brainstorming skill aktif):
- Tek satici mi, cok satici mi? (Mimari karari)
- Odeme yontemi? (Stripe vs LemonSqueezy - maliyet/karmasiklik)
- Fiziksel mi dijital mi? (Kargo API vs indirme linkleri)
```

Minimum 3 soru sorulur. Cevap alinmadan kodlamaya baslanmaz.

### 3. Agent Routing

```
Frontend gorevi --> frontend-specialist.md
                        |
                        v
                   skills: [react-best-practices, frontend-design, tailwind-patterns]
                        |
                        v
                   Her skill'in SKILL.md'si yuklenir
                        |
                        v
                   Agent persona + skill bilgisi ile cikti uretilir
```

### 4. Multi-Agent Orchestration

3+ domain iceren gorevlerde `orchestrator` agent devreye girer:

```
/orchestrate full-stack auth
    |
    v
Orchestrator:
  1. project-planner --> Plan olustur
  2. backend-specialist --> API endpoints
  3. frontend-specialist --> Login UI
  4. security-auditor --> Auth review
  5. test-engineer --> Test suite
```

---

## Customization

### Yeni Agent Ekleme

`agents/` dizinine yeni `.md` dosyasi ekleyin:

```markdown
---
name: my-custom-agent
skills:
  - clean-code
  - testing-patterns
---

## Persona
...

## Ilkeler
...
```

### Yeni Skill Ekleme

`.claude/skills/my-skill/SKILL.md` olusturun:

```markdown
---
name: my-skill
description: "Skill aciklamasi"
user-invocable: false
---

# Skill Basligi

Skill icerigi...
```

### Yeni Workflow Ekleme

`workflows/my-command.md` olusturun:

```markdown
---
description: Komut aciklamasi
---

# /my-command

$ARGUMENTS

## Behavior
...
```

### Hook Ekleme/Cikarma

`.claude/settings.json` dosyasini duzenleyin. Yeni hook eklemek icin ilgili event'e yeni bir entry ekleyin. Hooks'u tamamen kapatmak icin:

```json
{
  "disableAllHooks": true
}
```

---

## Statistics

| Metrik | Deger |
|--------|-------|
| Agents | 23 |
| Skills | 96 |
| Workflows | 15 |
| Scripts | 6 |
| Hooks | 4 |
| Always-On Rules | 5 |
| Contexts | 3 |
| Desteklenen Diller | Python, TypeScript, JavaScript, Rust, Go, Java, C++, Swift |
| Desteklenen Frameworkler | React, Next.js, FastAPI, Express, Django, Flutter, Unity, Godot |
| Desteklenen Platformlar | Claude Code, Gemini |

---

## Requirements

- **Claude Code** veya **Google Gemini** (AI assistant olarak)
- **Python 3.8+** (script'ler icin)
- **bash** (hook script'leri icin)
- **jq** (hook'larda JSON parsing icin - opsiyonel ama onerilen)

---

## License

MIT
