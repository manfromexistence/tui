# DX Flow Achievements

`flow` is the local-first AI runtime and input layer for DX. It is designed to
make local model routing, voice input, text refinement, host control, and embeddable
Rust APIs available to Zed, Codex-like tools, DX Agents, browser/WASM hosts,
mobile shells, and future Friday surfaces.

## Position

Flow is not only a dictation experiment. It is a reusable Rust library surface
for AI-assisted input and local runtime control across many hosts: desktop,
mobile, browser extensions, Tauri, Flutter, editor forks, servers, Raspberry Pi
class devices, and low-end Windows machines.

Professional positioning:

> Flow is DX's embeddable local AI/input runtime layer, combining model-role
> routing, dictation, text refinement, safe host-control plans, browser/WASM planning,
> and host adapters for Zed, Codex-style tasks, and ZeroClaw/DX Agents-style
> runtimes.

That statement keeps the difference between implemented library surfaces and live
host verification clear. Flow can be described as a production-focused local-first runtime, but
specific model quality, voice, WebGPU, and host-integration wording still require
current receipts or focused runtime verification.

## What Flow Has Already Achieved

| Area | Achievement |
| --- | --- |
| Library-first architecture | Centers the product on reusable Rust APIs instead of one UI or one transport, with `src/experience` owning most product-facing surfaces. |
| Local runtime | Defines `FlowLocalRuntime` for chat, STT, TTS, transcript cleanup, synthesis, and local model selection without forcing an HTTP sidecar. |
| Host adapters | Provides `ZedFlowAdapter`, `CodexFlowAdapter`, and `ZeroClawFlowAdapter` shapes so existing Rust hosts can integrate only the Flow features they need. |
| Dictation handoff | Provides a focused `flow-dictate` host for Zed Agent composer voice handoff, with Parakeet as the default STT model and Whisper Tiny GGML as an explicit file-mode opt-in path. |
| Local model roles | Documents low-latency role assignments for helper, tool-routing, coding/UI-edit, smart chat, backup, UI-generation, and vision experiments on the current Windows machine. |
| text refinement and typing | Owns grammar correction, style rewrites, snippet expansion, dictionary normalization, spoken formatting cleanup, text refinement plans, and editor-assist planning. |
| Activation and always-on strategy | Treats wake commands, keyboard shortcuts, always-hot wake/VAD workstreams, unload-on-idle, battery/thermal backoff, and low-end module selection as integrated product surfaces. |
| Safe host control | Models permission gates, command routing, audit logs, consent plans, native control execution, clipboard automation, and host-facing action plans instead of silent desktop control. |
| Browser/WASM workstream | Adds `flow-browser-core`, browser capability planning, browser-pack manifests, WebGPU-gated multimodal plans, local-only settings, and browser extension release packaging. |
| Production bundle surfaces | Defines production config, bundle manifests, release summaries, validated command matrices, missing model paths, browser artifact paths, and host-targeted defaults. |
| Cross-platform intent | Documents Windows, macOS, Linux, Android, iOS, browser/WASM, server, mobile, and embedded host plans without forcing a single runtime shell. |

## validation To Check

Use these files and commands before repeating exact wording:

| validation | Purpose |
| --- | --- |
| `flow/README.md` | Main product story, active scope, local model roles, implemented APIs, activation, always-on strategy, browser workstream, and verification boundaries. |
| `flow/DX.md` | release-work notes, DX/Zed dictation handoff, focused host path, STT model boundary, and unclaimed live verification. |
| `flow/AGENTS.md` | Local model role policy, UI model eval guidance, and warning not to overclaim failed UI clone validation. |
| `flow/Cargo.toml` | Package identity, library and binary targets, browser core workspace member, STT feature gate, and serializer/rkyv/memmap dependencies. |
| `flow/src/experience/*` | Product-facing library modules for activation, typing, dictation, host control, permissions, overlay, audio, lifecycle, persistence, and host kits. |
| `flow/src/runtime/*` | Local runtime, broker, catalog, and model selection surfaces. |
| `flow/src/zed/adapter.rs` | Zed-specific adapter surface. |
| `flow/src/codex/adapter.rs` | Codex-style adapter surface. |
| `flow/src/zeroclaw/adapter.rs` | ZeroClaw/DX Agents-style adapter surface. |
| `flow/src/bin/flow-dictate.rs` | Focused dictation host used by the Zed handoff. |
| `flow/tools/flow-dictation-host/README.md` | Dictation host packaging and handoff details. |
| `flow/crates/flow-browser-core` | Rust/WASM browser orchestration surface. |
| `cargo check` | Preferred lightweight code verification when Flow source is touched. |

## Public Positioning Boundary

Safe internal statement:

> Flow is the embeddable local AI/input runtime layer for DX, with local model
> routing, dictation/text refinement APIs, safe host-control plans, browser/WASM
> planning, and adapters for Zed, Codex-style tasks, and DX Agents-style hosts.

Safe public wording after refreshed checks:

> The current Flow crate exposes the documented local runtime, host adapters,
> dictation host, browser core, production bundle, and permission/audit
> contracts with current `cargo check` or targeted verification for the touched workstream.

Unsafe statement without more verification:

> Every voice, TTS, browser/WebGPU, mobile, OS-control, local model, and
> provider-routing workflow is live-proven across all target platforms.

The strongest current result is embeddable architecture plus low-end local
runtime planning. The remaining verification work is governed Nemotron smoke verification,
live Zed microphone capture, audible Kokoro playback, browser/WebGPU runtime
verification, mobile-host verification, and current checks for any source changes.

## Next Documentation Pass

The `forge` page now documents the DX source and media version-control layer
that turns tool output, packages, assets, and external remotes into governed
project history. The next folder should be `serializer`, because Serializer is
the token- and runtime-efficient data layer behind DX receipts, manifests,
caches, and AI context packaging.
