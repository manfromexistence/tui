# DX — Cross-Platform Build Guide

## Build Status — 19 Projects × 5 Targets

| # | Project | Size | Jobs | Windows x64 | Linux x64 | Linux ARM64 | macOS Intel | macOS ARM64 |
|--:|---------|:----:|:----:|:-----------:|:---------:|:-----------:|:-----------:|:-----------:|
| 1 | agent | large | 4 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 2 | build | large | 6 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 3 | check | small | 12 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 4 | cli | large | 6 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 5 | dcp | small | 12 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 6 | driven | medium | 8 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 7 | flow | medium | 8 | ✅ | ❌ | ❌ | ❌ | ❌ |
| 8 | forge | medium | 8 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 9 | i18n | small | 12 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 10 | icon | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 11 | js | very large | 4 | ✅ | ❌ | ❌ | ❌ | ❌ |
| 12 | media | medium | 8 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 13 | metasearch | medium | 8 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 14 | native | medium | 6 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 15 | providers | small | 12 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 16 | py | large | 6 | ✅ | ❌ | ❌ | ❌ | ❌ |
| 17 | serializer | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 18 | style | medium | 8 | ✅ | ✅ | ✅ | ❌ | ❌ |
| 19 | www | medium | 6 | ✅ | ✅ | ✅ | ❌ | ❌ |

**19/19 Windows x64 ✅ | 16/19 Linux x64 ✅ | 16/19 Linux ARM64 ✅ | 5/19 macOS ✅** (serializer, check, dcp, icon, cli). Blockers: flow (X11+ALSA system deps), py (tikv-jemalloc-sys cross-compile), js (nightly toolchain + complex deps). macOS needs Apple SDK for the remaining 14 projects — they link Apple frameworks (`CoreFoundation`, `Security`, `CoreServices`, `AudioUnit`) unavailable in zig's bundled SDK.

> **Linux ARM64 built 2026-06-26.** All 16 projects built via `cargo zigbuild --target aarch64-unknown-linux-gnu`. Two key fixes applied: (1) added `libc` dep to `www/related-crates/style/Cargo.toml` for Unix-platform code, (2) overrode `target-cpu=native` from `metasearch/.cargo/config.toml` for aarch64 (z3 CPU features invalid on ARM). `build` (rolldown) and `py` (uv) use custom Rust toolchain pins (1.96.0) — their ARM64 target std must be installed explicitly: `rustup target add --toolchain <triple-name> aarch64-unknown-linux-gnu`.

---

## Prerequisites

```powershell
# Install zig (required by cargo-zigbuild for cross-compilation)
scoop install zig
# or: winget install zig.zig

# Install cargo-zigbuild
cargo install cargo-zigbuild

# Add rustup targets for all desired platforms
rustup target add x86_64-unknown-linux-gnu
rustup target add aarch64-unknown-linux-gnu
rustup target add x86_64-apple-darwin
rustup target add aarch64-apple-darwin
# Windows x86_64 (x86_64-pc-windows-msvc) is already available on Windows hosts
```

## Target Platforms

| Target Triple | OS | Arch | Build Tool |
|---|---|---|---|
| `x86_64-pc-windows-msvc` | Windows | x64 (Intel/AMD) | `cargo build` (native) |
| `x86_64-unknown-linux-gnu` | Linux | x64 (Intel/AMD) | `cargo zigbuild` |
| `aarch64-unknown-linux-gnu` | Linux | ARM64 | `cargo zigbuild` |
| `x86_64-apple-darwin` | macOS | x64 (Intel) | `cargo zigbuild` |
| `aarch64-apple-darwin` | macOS | ARM64 (Apple Silicon M1–M4) | `cargo zigbuild` |

## Single-Project Build (all 5 targets)

```powershell
cd G:\Dx\<project>

# Pick jobs based on project size:
#   small    -> -j 12
#   medium   -> -j 8
#   large    -> -j 6
#   very big -> -j 4

$jobs = 12
$pkg = ""    # e.g. "-p dx-cli", "-p bun_bin"

# Windows x64
cargo build --release $pkg -j $jobs --target x86_64-pc-windows-msvc

# Linux x64, Linux ARM64, macOS Intel, macOS Apple Silicon
cargo zigbuild --release $pkg -j $jobs --target x86_64-unknown-linux-gnu
cargo zigbuild --release $pkg -j $jobs --target aarch64-unknown-linux-gnu
cargo zigbuild --release $pkg -j $jobs --target x86_64-apple-darwin
cargo zigbuild --release $pkg -j $jobs --target aarch64-apple-darwin
```

## Automated Build All Script

Run `build-universal.ps1` from `G:\Dx`:

```powershell
.\build-universal.ps1
```

This builds all 19 projects for all 5 targets and places them in `G:\Dx\bin`.

## Binary Output Convention

Each project's binaries land in `G:\Dx\bin` with the naming pattern:

```
<dx-binary-name>-<target-triple>[.exe]
```

| Project | Binary in `target/release/` | Name in `bin/` |
|---|---|---|
| agent | `dx-agent.exe` | `dx-agent` |
| build | `dx-build.exe` | `dx-build` |
| check | `dx-check.exe` | `dx-check` |
| cli | `dx.exe` | `dx` |
| dcp | `dcp.exe` | `dx-dcp` |
| driven | `driven.exe` | `dx-driven` |
| flow | `flow.exe` | `dx-flow` |
| forge | `dx-forge.exe` | `dx-forge` |
| i18n | `dx-i18n.exe` | `dx-i18n` |
| icon | `icon.exe` | `dx-icon` |
| js | `js.exe` | `dx-js` |
| media | `media.exe` | `dx-media` |
| metasearch | `metasearch.exe` | `dx-metasearch` |
| native | `native.exe` | `dx-native` |
| providers | `dx-providers.exe` | `dx-providers` |
| py | `dx-py-package-manager.exe` | `dx-py-package-manager` |
| serializer | `dx-serialize.exe` | `dx-serialize` |
| style | `dx-style.exe` | `dx-style` |
| www | `dx-www.exe` | `dx-www` |

## Platform-Specific Fixes Applied

### `dcp/Cargo.toml` — libc dependency scope

The `kqueue.rs` reactor uses `libc` on macOS, but the dependency was originally scoped only to Linux:

```toml
# Before (broken on macOS):
[target.'cfg(target_os = "linux")'.dependencies]
libc = "0.2"

# After (works on Linux + macOS):
[target.'cfg(any(target_os = "linux", target_os = "macos"))'.dependencies]
libc = "0.2"
```

### `dcp/src/reactor/kqueue.rs` — borrow checker fix in `modify()`

The original code held a mutable borrow on `self.registrations` while calling `self.kevent_register()`, triggering `E0502`. Fixed by extracting `fd` before the mutable access:

```rust
// Before:
let reg = self.registrations.get_mut(&token)...;
self.kevent_register(reg.fd, ...)?;  // error: cannot borrow *self as immutable

// After:
let fd = self.registrations.get(&token)...?.fd;
self.kevent_register(fd, ...)?;
let reg = self.registrations.get_mut(&token)...;
reg.interest = interest;
```

### `www/related-crates/style/Cargo.toml` — missing `libc` dependency

The `src/platform/unix.rs` file imports `libc` for Unix targets, but the dependency was absent:

```toml
# Added:
libc = "0.2"
```

### `metasearch/.cargo/config.toml` — `target-cpu=native` blocks ARM64 cross-compile

Setting `target-cpu=native` globally causes cargo-zigbuild to pass `-mcpu=native` to zig's C compiler, which maps to the host CPU (e.g., `znver3` on AMD Zen 3). This is invalid for ARM64 targets. Fixed by adding target-specific overrides:

```toml
[target.aarch64-unknown-linux-gnu]
rustflags = []

[target.aarch64-unknown-linux-musl]
rustflags = []
```

Projects with custom `rust-toolchain.toml` pins (build → 1.96.0, js → nightly, py → 1.96.0) require the target std to be installed for that specific toolchain:

```powershell
rustup target add --toolchain 1.96.0-x86_64-pc-windows-msvc aarch64-unknown-linux-gnu
```

If downloads fail due to network issues, try a mirror:

```powershell
$env:RUSTUP_DIST_SERVER = "https://mirrors.tuna.tsinghua.edu.cn/rustup"
```

## General Rust Build Tips

- Use `-j 12` (or your CPU core count) for parallel compilation.
- The `ring` crate is the most common reason cross-compilation fails without `cargo-zigbuild` — it needs a C compiler for its platform-specific assembly.
- If you get `xcrun` warnings for macOS targets on Windows, they are harmless — zig's linker still produces valid binaries.
