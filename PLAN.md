# DX Ecosystem Consolidation Plan

903175
192.168.0.181:42295

## Core Thesis

Three projects — OpenClaw (TypeScript), Hermes-Agent (Python), Deer-Flow (Python/TypeScript) — each have proven, battle-tested code for specific subsystems. We fork each, **surgically delete the 90% we don't need**, keep the original working code, and run it as a lightweight standalone process. dx-agent communicates with each via a simple protocol.

**No rewriting in Rust. No "AI slop" versions. We use the real code directly.**

```      
┌─────────────────────────────────────────────────────────┐
│                    dx-agent (Rust)                       │
│                                                         │
│  CLI / Gateway / Daemon / Config / Memory / Cron        │
│                                                         │
│  spawns + communicates with each fork via               │
│  JSON-RPC 2.0 over stdio                                │
└──────┬──────────────┬──────────────────┬────────────────┘
       │              │                  │
       ▼              ▼                  ▼
┌──────────────┐ ┌──────────┐ ┌──────────────────┐
│ openclaw-fork│ │hermes-frk│ │  deerflow-fork   │
│ (Node.js)    │ │ (Python) │ │    (Python)       │
│              │ │          │ │                   │
│ channels/    │ │ update/  │ │ orchestrate/      │
│ voice/       │ │          │ │ sandbox/          │
└──────────────┘ └──────────┘ └──────────────────┘
```

---

## Current State: Feature Gap Analysis

| Feature | OpenClaw | Hermes | Deer-Flow | dx-agent (current) | Action |
|---------|----------|--------|-----------|-------------------|--------|
| Channel adapters (Telegram, Discord, Slack, WhatsApp, etc.) | ✅ 24+ production, 100+ contributors | ✅ 25+ production | ⚠️ 5-6 | ⚠️ Many stubs | Run OpenClaw's channel code directly |
| Auto-update system | ❌ | ✅ Crash-recoverable, atomic swap, backup, rollback | ❌ | ❌ | Run Hermes's update code directly |
| Multi-agent orchestration (lead+subagent, parallel) | ❌ | ❌ | ✅ LangGraph-based, 26 middlewares, sandbox | ❌ | Run Deer-Flow's orchestration code directly |
| Hardware control (USB, GPIO, probe-rs) | ❌ | ❌ | ❌ | ✅ Rust native | Keep as-is |
| Single binary | ❌ | ❌ | ❌ | ✅ | Keep as-is |
| Config system | ✅ | ⚠️ | ✅ | ✅ TOML+env | Keep as-is |
| Memory backends | ⚠️ | ⚠️ | ✅ | ✅ | Keep as-is |
| Gateway (HTTP/WS) | ✅ | ✅ | ✅ | ✅ Axum | Keep as-is |
| ACP/IDE bridge | ✅ | ✅ | ❌ | ✅ acp-bridge | Keep as-is |
| Voice/Talk | ✅ | ❌ | ❌ | ❌ | Run OpenClaw's voice code directly |
| Canvas/A2UI | ✅ | ❌ | ❌ | ❌ | Run OpenClaw's canvas code directly |

---

## How It Works

Each fork is a **standalone process** that speaks JSON-RPC 2.0 over stdin/stdout.

```
dx-agent sidecar spawn  openclaw-fork
                      ──▶ openclaw-fork reads config, announces capabilities
                      ◀── {"jsonrpc":"2.0","method":"system.capabilities",
                      │     "params":{"channels":["telegram","discord",...]}}
dx-agent needs to send a Telegram message:
                      ──▶ {"jsonrpc":"2.0","id":1,"method":"channel.send",
                      │     "params":{"platform":"telegram","chat":"@user",
                      │     "text":"Hello from dx-agent!"}}
                      ◀── {"jsonrpc":"2.0","id":1,"result":{"ok":true,"msg_id":123}}

openclaw-fork receives a Discord message (inbound webhook):
                      ──▶ {"jsonrpc":"2.0","method":"channel.message",
                      │     "params":{"platform":"discord","from":"user123",
                      │     "text":"hello","channel":"general"}}
```

No shared memory. No embedded runtimes. Just processes talking JSON over pipes.

---

## Fork 1: OpenClaw — Channels + Voice

### Stripped to

```
openclaw-fork/
├── package.json              # Minimal: only channel deps (express, ws, telegram-bot-api, etc.)
├── index.mjs                 # Entry: JSON-RPC 2.0 stdio server
├── channels/
│   ├── telegram.mjs          # Original OpenClaw adapter, unchanged logic
│   ├── discord.mjs           # Original OpenClaw adapter, unchanged logic
│   ├── slack.mjs             # Original OpenClaw adapter, unchanged logic
│   ├── whatsapp.mjs          # Original OpenClaw adapter, unchanged logic
│   ├── signal.mjs            # Original OpenClaw adapter, unchanged logic
│   └── email.mjs             # Original OpenClaw adapter, unchanged logic
├── voice/
│   ├── talk.mjs              # Original OpenClaw voice code
│   └── wake.mjs              # Original OpenClaw wake word code
├── canvas/
│   └── a2ui.mjs              # Original OpenClaw canvas code
├── config.mjs                # Reads config from env / config file
├── README.md
└── LICENSE
```

**Total: ~12 files. Original OpenClaw TypeScript code, just the channel/voice/canvas parts, nothing else.**

### Deleted from original

| Deleted | Size |
|---------|------|
| Plugin SDK (21 packages) | ~thousands of files |
| Gateway server (539 files) | Entire HTTP/WS server |
| Doctor system (30+ checks) | Health check scripts |
| Security audit subsystem | 81 files |
| Companion apps (macOS, iOS, Android) | 3 entire apps |
| Onboarding wizard | Wizard/ directory |
| 120+ extensions (providers, tools, etc.) | 120+ directories |
| CLAUDE.md, AGENTS.md, VISION.md | Docs |
| CI/CD, Docker, fly.io configs | devops/ |
| npm-shrinkwrap, pnpm-lock | Lock files |
| tsconfig*, vitest, oxlint | Build config |
| src/ core (1019 files) | We only need channels/ |

### How dx-agent uses it

```rust
// crates/dx-agent-sidecars/src/openclaw.rs
pub struct OpenClawSidecar {
    process: SidecarProcess,
}

impl OpenClawSidecar {
    pub async fn spawn(config: &OpenClawConfig) -> Result<Self> {
        // node index.mjs --stdio
        let process = SidecarProcess::spawn("node", &["index.mjs", "--stdio"])?;
        // Wait for system.capabilities announcement
        let caps = process.wait_for_capabilities().await?;
        Ok(Self { process })
    }

    pub async fn send_message(&self, platform: &str, msg: OutboundMessage) -> Result<MessageId> {
        self.process.request("channel.send", json!({
            "platform": platform,
            "chat": msg.chat_id,
            "text": msg.text,
            "media": msg.media,
        })).await
    }

    pub async fn on_message(&self) -> impl Stream<Item = InboundMessage> {
        self.process.notifications()
            .filter(|n| n.method == "channel.message")
            .map(|n| InboundMessage::from_json(n.params))
    }
}
```

---

## Fork 2: Hermes — Auto-Update

### Stripped to

```
hermes-fork/
├── pyproject.tomz             # Minimal deps (requests, packaging, etc.)
├── hermes_update/
│   ├── __init__.py
│   ├── server.py              # JSON-RPC 2.0 stdio server
│   ├── check.py               # Original Hermes check_for_updates (unchanged)
│   ├── perform.py             # Original Hermes cmd_update logic (unchanged)
│   ├── resilience.py          # Original Hermes file lock, zip-slip, crash recovery (unchanged)
│   └── backup.py              # Original Hermes backup/rollback (unchanged)
├── README.md
└── LICENSE
```

**Total: ~8 files. Original Hermes Python code, just the update parts, nothing else.**

### Deleted from original

| Deleted | Size |
|---------|------|
| run_agent.py | 12k lines |
| cli.py | 11k lines |
| gateway/run.py | 19k lines |
| gateway/platforms/base.py | 5k lines |
| 25+ platform adapters | Entire platforms/ |
| ACP adapter | 11 files |
| Plugin system | plugins/ |
| Skills (built-in + optional) | skills/ + optional-skills/ |
| TUI (React + Python backend) | ui-tui/ + tui_gateway/ |
| Desktop app | apps/ |
| Batch runner | batch_runner.py |
| 17k tests | tests/ |
| Agent internals | agent/ |
| Cron | cron/ |
| Docs (multiple languages) | docs/, README.*.md |
| Docker, Nix, CI/CD | docker/, nix/, .github/ |

### How dx-agent uses it

```rust
// crates/dx-agent-sidecars/src/hermes.rs
pub struct HermesSidecar {
    process: SidecarProcess,
}

impl HermesSidecar {
    pub async fn spawn(config: &HermesConfig) -> Result<Self> {
        // python -m hermes_update.server --stdio
        let process = SidecarProcess::spawn("python", &["-m", "hermes_update.server", "--stdio"])?;
        Ok(Self { process })
    }

    pub async fn check_update(&self) -> Result<Option<UpdateInfo>> {
        self.process.request("update.check", json!({})).await
    }

    pub async fn perform_update(&self) -> Result<UpdateProgress> {
        // Streams progress events as JSON-RPC notifications
        self.process.stream_request("update.perform", json!({}),
            |event| match event.method {
                "update.progress" => /* report progress */,
                "update.done" => /* complete */,
                "update.failed" => /* error */,
            }
        ).await
    }
}
```

---

## Fork 3: Deer-Flow — Multi-Agent Orchestration

### Stripped to

```
deerflow-fork/
├── pyproject.toml              # Minimal deps (langgraph, httpx, pydantic, etc.)
├── deerflow_server/
│   ├── __init__.py
│   ├── server.py               # JSON-RPC 2.0 stdio server
│   ├── harness/                # Original Deer-Flow harness code, stripped
│   │   ├── __init__.py
│   │   ├── agents/
│   │   │   ├── lead_agent.py   # Original lead agent (unchanged)
│   │   │   └── middlewares.py  # Original 26 middlewares (unchanged)
│   │   ├── subagents/
│   │   │   ├── executor.py     # Original subagent executor (unchanged)
│   │   │   └── registry.py     # Original subagent registry (unchanged)
│   │   ├── sandbox/
│   │   │   ├── local.py        # Original local sandbox (unchanged)
│   │   │   └── docker.py       # Original Docker sandbox (unchanged)
│   │   ├── tools/
│   │   │   └── task_tool.py    # Original task delegation tool (unchanged)
│   │   └── runtime/
│   │       └── run_manager.py  # Original run manager (unchanged)
│   └── contracts/
│       └── status_contract.json # Original cross-component contract (unchanged)
├── README.md
└── LICENSE
```

**Total: ~15 files. Original Deer-Flow Python code, just the orchestration parts, nothing else.**

### Deleted from original

| Deleted | Size |
|---------|------|
| FastAPI Gateway (4 files) | app/ |
| Next.js frontend (entire directory) | frontend/ |
| Nginx config | docker/nginx/ |
| Provisioner (Kubernetes) | provisioner/ |
| Config YAML (nested sections) | config.yaml |
| Alembic migrations | persistence/ |
| TUI (Textual) | tui/ |
| Community integrations | community/ |
| MCP client code | mcp/ |
| Models (provider adapters) | models/ |
| Skills | skills/ |
| Docs (multiple languages) | docs/, README.*.md |
| Docker compose, CI/CD | docker/, .github/ |

### How dx-agent uses it

```rust
// crates/dx-agent-sidecars/src/deerflow.rs
pub struct DeerFlowSidecar {
    process: SidecarProcess,
}

impl DeerFlowSidecar {
    pub async fn spawn(config: &DeerFlowConfig) -> Result<Self> {
        // python -m deerflow_server.server --stdio
        let process = SidecarProcess::spawn("python", &[
            "-m", "deerflow_server.server", "--stdio"
        ])?;
        Ok(Self { process })
    }

    pub async fn delegate(&self, task: TaskSpec) -> Result<TaskHandle> {
        self.process.request("orchestrate.delegate", json!({
            "task": task.description,
            "tools": task.tools,
            "max_concurrency": 3,
        })).await
    }

    pub async fn poll_result(&self, handle: &TaskHandle) -> Result<Option<TaskResult>> {
        self.process.request("orchestrate.poll", json!({
            "task_id": handle.id
        })).await
    }

    pub async fn stream_events(&self, handle: &TaskHandle) -> impl Stream<Item = OrchestrationEvent> {
        // Receive orchestration.event notifications from sidecar
        self.process.notifications()
            .filter(|n| n.method == "orchestration.event")
            .map(|n| OrchestrationEvent::from_json(n.params))
    }
}
```

---

## Sidecar Protocol

### JSON-RPC 2.0 over stdin/stdout

All three forks use the same protocol. This means dx-agent has a single `SidecarProcess` implementation that works for all of them.

```rust
// crates/dx-agent-sidecars/src/protocol.rs
pub struct SidecarProcess {
    stdin: BufWriter<ChildStdin>,
    stdout: BufReader<ChildStdout>,
    pending: HashMap<u64, oneshot::Sender<Response>>,
    next_id: AtomicU64,
}

impl SidecarProcess {
    /// Spawn any executable that speaks JSON-RPC 2.0 over stdio
    pub fn spawn(program: &str, args: &[&str]) -> Result<Self>;

    /// Send a request, wait for response
    pub async fn request(&self, method: &str, params: Value) -> Result<Value>;

    /// Send a request, receive a stream of notifications
    pub async fn stream_request(
        &self, method: &str, params: Value,
        on_event: Box<dyn Fn(Notification)>,
    ) -> Result<Value>;

    /// Receive inbound notifications (channel messages, orchestration events)
    pub fn notifications(&self) -> impl Stream<Item = Notification>;
}
```

### Protocol details

```json
// Request (dx-agent → fork)
{"jsonrpc":"2.0","id":1,"method":"channel.send",
 "params":{"platform":"telegram","chat":"@user","text":"Hello"}}

// Response (fork → dx-agent)
{"jsonrpc":"2.0","id":1,"result":{"ok":true,"msg_id":123}}

// Error
{"jsonrpc":"2.0","id":1,"error":{"code":-32000,"message":"Channel not configured"}}

// Notification (fork → dx-agent, no id = fire-and-forget)
{"jsonrpc":"2.0","method":"channel.message",
 "params":{"platform":"discord","from":"user123","text":"hello"}}

// Startup capability announcement
{"jsonrpc":"2.0","method":"system.capabilities",
 "params":{"name":"openclaw","version":"2026.6.10",
           "features":["channel.telegram","channel.discord","voice.talk","canvas.a2ui"]}}
```

### Method catalog

| Namespace | Methods | Provider |
|-----------|---------|----------|
| `channel.*` | send, edit, delete, list, connect, disconnect | OpenClaw |
| `voice.*` | talk, wake, mute, transcript | OpenClaw |
| `canvas.*` | render, update, resize, close | OpenClaw |
| `update.*` | check, perform, status, rollback | Hermes |
| `orchestrate.*` | delegate, poll, cancel, result | Deer-Flow |
| `sandbox.*` | create, exec, read, write, destroy | Deer-Flow |
| `system.*` | capabilities, health, metrics, shutdown | All |

---

## dx-agent Crate Layout

Only one new crate needed — the sidecar protocol handler:

```
crates/dx-agent-sidecars/
├── Cargo.toml
├── src/
│   ├── lib.rs
│   ├── protocol.rs               # SidecarProcess: JSON-RPC 2.0 over stdio
│   ├── openclaw.rs               # OpenClawSidecar: spawn, channel methods, voice, canvas
│   ├── hermes.rs                 # HermesSidecar: spawn, update methods
│   └── deerflow.rs               # DeerFlowSidecar: spawn, orchestrate methods
└── tests/
    ├── test_protocol.rs
    └── test_openclaw.rs
```

Existing crates get thin wrappers:

```
crates/dx-agent-runtime/
├── src/
│   ├── update.rs                 # [NEW] delegates to HermesSidecar
│   ├── orchestrate.rs            # [NEW] delegates to DeerFlowSidecar
│   └── channels/
│       └── sidecar.rs            # [NEW] delegates to OpenClawSidecar
```

---

## Cargo.toml Changes

```toml
# New workspace member
[workspace]
members = [
    "crates/dx-agent-sidecars",
    # ... existing crates
]

# Feature gates
[features]
sidecar-openclaw = ["dx-agent-sidecars/openclaw"]
sidecar-hermes = ["dx-agent-sidecars/hermes"]
sidecar-deerflow = ["dx-agent-sidecars/deerflow"]
sidecar-all = [
    "sidecar-openclaw",
    "sidecar-hermes",
    "sidecar-deerflow",
]
```

---

## Config

```toml
# ~/.config/dx-agent/config.toml

[sidecars.openclaw]
enabled = false
path = "C:\\Dx\\repos\\openclaw-fork"     # or auto-discover on PATH
node_path = "C:\\Program Files\\nodejs\\node.exe"
features = ["channels", "voice", "canvas"]
channels = ["telegram", "discord", "slack"]

[sidecars.hermes]
enabled = false
path = "C:\\Dx\\repos\\hermes-fork"
python_path = "C:\\Python313\\python.exe"
update_policy = "notify"                  # "notify" | "auto" | "confirm"
update_channel = "stable"

[sidecars.deerflow]
enabled = false
path = "C:\\Dx\\repos\\deerflow-fork"
python_path = "C:\\Python313\\python.exe"
max_concurrent = 3
```

---

## Implementation Phases

### Phase 0: Create the Forks (1 week)

- [ ] OpenClaw: delete everything except `channels/`, `voice/`, `canvas/` code + `index.mjs` stdio server
- [ ] Hermes: delete everything except `hermes_update/` code + `server.py` stdio server
- [ ] Deer-Flow: delete everything except `deerflow_server/` code + `server.py` stdio server
- [ ] Verify each fork runs standalone: `node index.mjs --stdio` / `python -m server --stdio`
- [ ] Push to `github.com/millercarla211-ctrl/<fork>`
- [ ] Update `G:\Dx\agent\inspirations/` with stripped versions

### Phase 1: Sidecar Protocol + Hermes (2 weeks)

- [ ] Create `crates/dx-agent-sidecars/` with `SidecarProcess` (JSON-RPC 2.0 stdio)
- [ ] Implement `HermesSidecar` wrapping update.check / update.perform
- [ ] Wire into CLI: `dx-agent update --check`, `dx-agent update`
- [ ] Wire into daemon: periodic check, notification if update available
- [ ] Windows + Linux tested

### Phase 2: OpenClaw Channels (2-3 weeks)

- [ ] Implement `OpenClawSidecar` spawning `node index.mjs --stdio`
- [ ] Wire channel.send / channel.message into dx-agent's channel infrastructure
- [ ] `dx-agent channel add --telegram --token xxx`
- [ ] `dx-agent channel send --telegram @user "hello"` → routes through OpenClaw's real code
- [ ] Inbound message routing: Telegram DM → dx-agent agent loop
- [ ] Test with real Telegram, Discord, Slack credentials

### Phase 3: Deer-Flow Orchestration (2-3 weeks)

- [ ] Implement `DeerFlowSidecar` spawning `python -m deerflow_server.server --stdio`
- [ ] Implement delegate / poll / cancel methods
- [ ] Wire into agent runtime: long-running tasks route through Deer-Flow's real orchestration
- [ ] Wire `orchestration.event` notifications into dx-agent's event stream
- [ ] Test with multi-step research tasks

### Phase 4: Integration (1 week)

- [ ] `dx-agent daemon` optionally starts all 3 sidecars
- [ ] Graceful degradation: missing sidecar = missing feature, not crash
- [ ] `dx-agent doctor --sidecars` shows health of each fork
- [ ] Unified logging: sidecar stderr → dx-agent's log
- [ ] Restart policy: auto-restart on crash (max 3 in 60s)

---

## What It Looks Like When Working

```bash
# User installs dx-agent
cargo build --features sidecar-all

# User configures one fork
dx-agent sidecar setup openclaw --path C:\Dx\repos\openclaw-fork
# → Config written, testing connection... OK
# → Capabilities: channel.telegram, channel.discord, channel.slack, voice.talk

# User adds a channel
dx-agent channel add telegram --token 123:abc
# → Delegates to OpenClaw's real Telegram adapter
# → OpenClaw's production-tested code handles auth, webhook, rate limiting

# User sends a message
dx-agent channel send --telegram @user "Hello"
# → Routes through OpenClaw's real sendMessage() code

# User updates dx-agent
dx-agent update --check
# → Delegates to Hermes's real check_for_updates()
dx-agent update
# → Hermes's real cmd_update() runs: backup → download → atomic swap → done

# User runs a complex task
dx-agent agent -a research --task "Analyze Q2 financials"
# → Delegates to Deer-Flow's real lead agent + parallel subagents
# → Deer-Flow's real 26 middleware chain processes the task
# → Real-time streaming of orchestration events
```

---

## What We Did NOT Take

| Feature | Project | Rationale |
|---------|---------|-----------|
| Plugin SDK + ClawHub | OpenClaw | 21 packages of plugin infrastructure we don't need |
| Gateway server | OpenClaw | 539 files — dx-agent has its own Axum gateway |
| Doctor system | OpenClaw | 30+ checks — dx-agent has doctor |
| Companion apps | OpenClaw | macOS/iOS/Android apps — not our target |
| Onboarding wizard | OpenClaw | One-time use, not worth keeping |
| 120+ extensions | OpenClaw | Irrelevant providers, tools, integrations |
| ACP adapter | Hermes | dx-agent already has acp-bridge |
| Profile isolation | Hermes | Not needed in single-user setup |
| Plugin system | Hermes | WASM plugins cover this |
| Curator system | Hermes | Skill lifecycle mgmt — overkill for us |
| 17k tests | Hermes | We test our integration, not their internals |
| FastAPI Gateway | Deer-Flow | 4 files — dx-agent has its own gateway |
| Next.js frontend | Deer-Flow | Entire directory — we don't need web UI |
| Nginx + Provisioner | Deer-Flow | Infrastructure we don't run |
| LangGraph dependency in dx-agent | Deer-Flow | Stays in the Python fork where it belongs |
| 4-service topology | Deer-Flow | We communicate via stdio, not docker-compose |
| TUI | Deer-Flow | dx-agent has TUI via existing crates |
| Alembic migrations | Deer-Flow | We use our own DB schema |
| MCP client code | Deer-Flow | We implement our own in Rust if needed |
| Config hot-reload | Deer-Flow | Nice-to-have, not worth the complexity |

---

## File Manifest

### New Rust crate

```
crates/dx-agent-sidecars/
├── Cargo.toml
├── src/
│   ├── lib.rs
│   ├── protocol.rs
│   ├── openclaw.rs
│   ├── hermes.rs
│   └── deerflow.rs
└── tests/
    ├── test_protocol.rs
    └── test_integration.rs
```

### Fork repositories (standalone, original code)

```
repos/
├── openclaw-fork/        # ~12 files, Node.js
│   ├── package.json
│   ├── index.mjs
│   ├── channels/
│   │   ├── telegram.mjs
│   │   ├── discord.mjs
│   │   ├── slack.mjs
│   │   ├── whatsapp.mjs
│   │   ├── signal.mjs
│   │   └── email.mjs
│   ├── voice/
│   │   ├── talk.mjs
│   │   └── wake.mjs
│   ├── canvas/
│   │   └── a2ui.mjs
│   └── config.mjs
│
├── hermes-fork/          # ~8 files, Python
│   ├── pyproject.toml
│   ├── hermes_update/
│   │   ├── __init__.py
│   │   ├── server.py
│   │   ├── check.py
│   │   ├── perform.py
│   │   ├── resilience.py
│   │   └── backup.py
│   └── README.md
│
└── deerflow-fork/        # ~15 files, Python
    ├── pyproject.toml
    ├── deerflow_server/
    │   ├── __init__.py
    │   ├── server.py
    │   ├── harness/
    │   │   ├── agents/
    │   │   │   ├── lead_agent.py
    │   │   │   └── middlewares.py
    │   │   ├── subagents/
    │   │   │   ├── executor.py
    │   │   │   └── registry.py
    │   │   ├── sandbox/
    │   │   │   ├── local.py
    │   │   │   └── docker.py
    │   │   ├── tools/
    │   │   │   └── task_tool.py
    │   │   └── runtime/
    │   │       └── run_manager.py
    │   └── contracts/
    │       └── status_contract.json
    └── README.md
```

### Modified existing files

```
crates/dx-agent/Cargo.toml         # +dx-agent-sidecars member, +sidecar-* features
crates/dx-agent-runtime/src/lib.rs # +update, orchestrate modules
dx-agent/src/main.rs               # +update subcommand
AGENTS.md                          # Updated
```
