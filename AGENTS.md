# DX Agents - Agent System Reference

## Overview

**Binary:** `G:\Dx\bin\dx-agent.exe` (aliased as `dx-agents`)  
**Version:** v0.8.0-beta-2  
**Source:** `G:\Dx\agent\` (Rust workspace, forked from ZeroClaw)  
**Default config:** `C:\Users\Computer\.zeroclaw\config.toml`  
**Workspace data:** `C:\Users\Computer\.zeroclaw\data`

The agent binary is a Rust-first AI agent runtime with provider routing, memory, gateway pairing, cron, skills, hardware support, and 25+ communication channels.

---

## Commands (29 total)

| Command | Description | Status |
|---------|-------------|--------|
| `quickstart` | Create your first agent end-to-end (TUI wizard) | Works - interactive |
| `agent` | Start the AI agent loop (interactive chat) | Works - needs configured agent |
| `gateway` | Manage the HTTP/WebSocket gateway server | Works |
| `acp` | Start ACP server (JSON-RPC 2.0 over stdio for IDE) | Works |
| `daemon` | Start the long-running autonomous daemon | Works |
| `service` | Manage OS service lifecycle (systemd/launchd) | Works |
| `doctor` | Run diagnostics (models, traces) | Works |
| `status` | Show system status (config, costs, channels) | Works - fully functional |
| `estop` | Emergency-stop management (kill-all, network-kill, etc.) | Works |
| `cron` | Scheduled tasks (recurring, one-shot, interval) | Works |
| `models` | Manage provider model catalogs (refresh/list/set/status) | Works - needs configured provider |
| `providers` | List and health-check AI providers | Works - fully functional |
| `channel` | Manage communication channels | Works |
| `integrations` | Browse 50+ integrations | Works |
| `skills` | Manage user-defined capabilities (SKILL.md) | Works |
| `browse` | Browse the shared workspace | Works |
| `sop` | Manage Standard Operating Procedures | Works |
| `migrate` | Import data from OpenClaw workspaces | Works |
| `auth` | Manage provider auth profiles (OAuth, tokens) | Works |
| `hardware` | Discover and introspect USB hardware | Works |
| `peripheral` | Manage hardware peripherals (flash, add, list) | Works |
| `memory` | Manage agent memory entries (list/get/stats/clear) | Works - fully functional |
| `config` | View/set/init config, dump JSON Schema | Works - fully functional |
| `update` | Check for and apply binary updates | Works |
| `self-test` | Run diagnostic self-tests (quick or full) | Works - 7/9 pass without config |
| `completions` | Generate shell completions (bash/fish/zsh/powershell/elvish) | Works |
| `desktop` | Launch companion desktop app | Works |
| `locales` | Fetch translated locale files from upstream | Works |
| `onboard` | Deprecated - use `quickstart` | Deprecated |
| `help` | Print help for any command | Works |

---

## Providers

**197 total provider entries** in the health matrix. **61 primary providers** listed in `providers list`:

### Cloud Providers
| ID | Config Key Required | Health |
|----|-------------------|--------|
| `openrouter` | needs_key | Not configured |
| `anthropic` | needs_key | Not configured |
| `openai` | not_required | Cataloged, 0 models cached |
| `gemini` | needs_key | Not configured |
| `azure` | not_required | Cataloged |
| `bedrock` | not_required | Cataloged |
| `groq` | needs_key | Not configured |
| `mistral` | needs_key | Not configured |
| `deepseek` | needs_key | Not configured |
| `xai` (Grok) | not_required | Cataloged |
| `cohere` | needs_key | Not configured |
| `together` | needs_key | Not configured |
| `fireworks` | needs_key | Not configured |
| `perplexity` | needs_key | Not configured |
| `cloudflare` | needs_key | Not configured |
| `vercel` | not_required | Cataloged |
| `openai` (cataloged) | not_required | Cataloged |
| `openai` (as "opencode") | needs_key | Not configured |
| `openai` (as "copilot") | not_required | Cataloged |
| `nvidia` | needs_key | Not configured |
| `huggingface` | needs_key | Not configured |
| `cerebras` | needs_key | Not configured |
| `sambanova` | needs_key | Not configured |
| `synthetic` | not_required | Cataloged |
| `telnyx` | not_required | Cataloged |
| `venice` | not_required | Cataloged |
| `moonshot` | not_required | Cataloged |
| `zai` | needs_key | Not configured |
| `glm` (Zhipu) | not_required | Cataloged |
| `minimax` | not_required | Cataloged |
| `qianfan` (Baidu) | not_required | Cataloged |
| `doubao` (Volcengine) | not_required | Cataloged |
| `qwen` (DashScope) | not_required | Cataloged |
| `novita` | not_required | Cataloged |
| `ai21` | not_required | Cataloged |
| `reka` | not_required | Cataloged |
| `baseten` | not_required | Cataloged |
| `nscale` | not_required | Cataloged |
| `anyscale` | not_required | Cataloged |
| `nebius` | not_required | Cataloged |
| `friendli` | not_required | Cataloged |
| `lepton` | not_required | Cataloged |
| `stepfun` | not_required | Cataloged |
| `baichuan` | not_required | Cataloged |
| `yi` (01.AI) | not_required | Cataloged |
| `hunyuan` (Tencent) | not_required | Cataloged |
| `ovh` | not_required | Cataloged |
| `avian` | not_required | Cataloged |
| `siliconflow` | not_required | Cataloged |
| `aihubmix` | not_required | Cataloged |
| `litellm` | not_required | Cataloged |
| `hyperbolic` | not_required | Cataloged |
| `deepinfra` | not_required | Cataloged |

### Local Providers (no API key needed)
| ID | Description | Health |
|----|-------------|--------|
| `ollama` | Ollama (local LLM server) | Cataloged, local_runtime |
| `lmstudio` | LM Studio | Cataloged, local_runtime |
| `llamacpp` | llama.cpp server | Cataloged, local_runtime |
| `sglang` | SGLang | Cataloged, local_runtime |
| `vllm` | vLLM | Cataloged, local_runtime |
| `osaurus` | Osaurus | Cataloged, local_runtime |
| `atomic_chat` | Atomic Chat | Cataloged, local_runtime |
| `gemini_cli` | Gemini CLI | Cataloged, local_runtime |
| `kilocli` | KiloCLI | Cataloged, local_runtime |

### Additional Health Matrix Providers (136 more)
These appear in the provider routing table but not in the primary list: bedrock-converse, vertex-ai-language-models, vertex-ai-anthropic-models, vertex-ai-mistral-models, azure-ai, azure-text, assemblyai, deepgram, elevenlabs, fal-ai, firecrawl, jina-ai, replicate, stability, tavily, voyage, wandb, watsonx, and many more.

---

## Channels (25+ supported types)

| Channel | Status |
|---------|--------|
| `cli` | Always available |
| `telegram` | Not configured |
| `discord` | Not configured |
| `slack` | Not configured |
| `whatsapp` | Not configured |
| `matrix` | Not configured |
| `imessage` | Not configured |
| `email` | Not configured |
| `webhook` | Not configured |
| `lark` | Available (needs config) |
| `dingtalk` | Available (needs config) |
| `qq` | Available (needs config) |
| `bluesky` | Available (needs config) |
| `twitter` | Available (needs config) |
| `reddit` | Available (needs config) |
| `notion` | Available (needs config) |
| `mqtt` | Available (needs config) |
| `signal` | Available (needs config) |
| `mattermost` | Available (needs config) |
| `irc` | Available (needs config) |
| `nostr` | Available (needs config) |
| `line` | Available (needs config) |
| `wechat` | Available (needs config) |
| `wecom` (WeCom) | Available (needs config) |
| `nextcloud` | Available (needs config) |
| `voice-call` | Available (needs config) |

Channel commands: `list`, `start`, `doctor`, `add`, `remove`, `bind-telegram`, `send`

---

## Config Sections (50+)

The config file has 300+ properties across sections. Key sections:

- `core` - schema_version, model_routes, locale
- `observability` - backend (prometheus/otel), log persistence
- `security` - audit, OTP, estop, WebAuthn, Nevis auth
- `runtime` - native/docker, reasoning, sandboxing
- `memory` - sqlite/postgres backend, embeddings, FTS/vector search
- `channels` - per-channel configs
- `gateway` - HTTP/WS server, pairing, rate limits
- `cron` / `scheduler` - scheduled tasks
- `skills` - skill management, creation, registry
- `providers` - model provider configs
- `agents` - per-agent definitions
- `hardware` / `peripherals` - board configs
- `browser` - headless browsing, computer use
- `web_search`, `web_fetch`, `http_request` - web tools
- `cost` - spending limits and tracking
- `backup` - automatic backups
- `proxy` - HTTP/SOCKS proxy support

View full schema: `dx-agent config schema`

---

## Self-Test Results

```
✓ 1/9 config - loaded from config.toml
✓ 2/9 workspace - writable
✓ 3/9 sqlite - memory.db opens and responds
✓ 4/9 model_providers - 61 model providers available
✗ 5/9 tools - no enabled agents configured
✓ 6/9 channels - 4 channel types, 0 configured
✗ 7/9 security - no enabled agents configured
✓ 8/9 version - v0.8.0-beta-2
✓ 9/9 web_dist_dir - not set (using auto-detect)
```

Results: 7/9 pass without any configuration. The 2 failures are expected ("no enabled agents configured") and will resolve once an agent is set up.

---

## Getting Started

```bash
# Quick interactive setup
dx-agent quickstart --model-provider ollama --agent my-agent

# Or configure manually:
dx-agent config set model_providers.ollama.my-ollama uri http://localhost:11434
dx-agent config set agents.my-agent.model_provider ollama
dx-agent config set agents.my-agent.model llama3.2

# Start an interactive session
dx-agent agent -a my-agent

# Start the daemon (gateway + channels + cron)
dx-agent daemon

# Run diagnostics
dx-agent self-test
dx-agent status
```

---

## Quick Reference

```bash
# Config
dx-agent config list                                # all properties
dx-agent config get <dotted.path>                   # single value
dx-agent config set <dotted.path> <value>           # set value
dx-agent config schema > schema.json                # dump JSON Schema

# Providers
dx-agent providers list                             # list providers
dx-agent providers health                           # health matrix
dx-agent models refresh                             # cache models

# Memory
dx-agent memory stats                               # backend health
dx-agent memory list                                # list entries

# Channels
dx-agent channel list                               # status
dx-agent channel doctor                             # health check

# Skills
dx-agent skills list                                # installed skills
dx-agent skills add <name>                          # create skill

# System
dx-agent status                                     # full status
dx-agent self-test --quick                          # quick check
dx-agent update --check                             # check updates
```
