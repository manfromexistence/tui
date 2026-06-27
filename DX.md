# DX — Cross-Platform Build Guide

## Build Status — 19 Projects × 5 Targets

| # | Project | Size | Jobs | Windows x64 | Linux x64 | Linux ARM64 | macOS Intel | macOS ARM64 |
|--:|---------|:----:|:----:|:-----------:|:---------:|:-----------:|:-----------:|:-----------:|
| 1 | agent | large | 4 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2 | build | large | 6 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3 | check | small | 12 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 4 | cli | large | 6 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 5 | dcp | small | 12 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 6 | driven | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 7 | flow | medium | 8 | ✅ | ❌ | ❌ | ❌ | ❌ |
| 8 | forge | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 9 | i18n | small | 12 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 10 | icon | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 11 | js | very large | 4 | ✅ | ❌ | ❌ | ❌ | ❌ |
| 12 | media | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 13 | metasearch | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 14 | native | medium | 6 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 15 | providers | small | 12 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 16 | py | large | 6 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 17 | serializer | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 18 | style | medium | 8 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 19 | www | medium | 6 | ✅ | ✅ | ✅ | ✅ | ✅ |

**19/19 Windows x64 ✅ | 17/19 Linux x64 ✅ | 17/19 Linux ARM64 ✅ | 17/19 macOS x64 ✅ | 17/19 macOS ARM64 ✅**. Build date: 2026-06-26.

---

## DX Config Ecosystem — 20 Projects × 6 Questions

Which tools have/read the extensionless `dx` LLM-format config file, and which use `.dx/` receipts/serializer/machine cache infrastructure.

| # | Project | Has `dx` file? | Has `.dx/` dir? | Reads `dx` for config? | Uses `.dx/` paths? | Uses `.sr`? | Uses `.machine`? |
|--:|---------|:--------------:|:----------------:|:----------------------:|:-------------------:|:-----------:|:----------------:|
| 1 | agent | no | no | no | no | no | no |
| 2 | agent-zeroclaw | no | no | no | no | no | no |
| 3 | build | no | YES | no | no | no | no |
| 4 | check | YES | YES | **YES** — `llm_to_document` for web audit targets | **YES** — `.dx/` approved cache paths | no | **YES** — scans `.dx/*.machine` |
| 5 | cli | `dx.toml` | no | **partial** — parses as TOML, skips LLM-format | **YES** — receipts, cache, bridge paths | **YES** — `.dx/check/*.sr` contracts | **YES** — `.dx/serializer/*.machine` |
| 6 | dcp | no | no | no | no | no | no |
| 7 | driven | no | no | no | no | no | no |
| 8 | flow | no | no | no | no | no | no |
| 9 | forge | no | no | no | **YES** — scans `.dx/*.machine` for dx-status | no | **YES** — reads `.machine` files |
| 10 | i18n | no | no | no | no | no | no |
| 11 | icon | no | no | no | no | no | no |
| 12 | js | no | YES | no | no | no | no |
| 13 | media | no | no | no | no | no | no |
| 14 | metasearch | no | YES | no | no | no | no |
| 15 | native | no | no | no | no | no | no |
| 16 | providers | no | no | no | no | no | no |
| 17 | py (package-manager) | no | no | no | no | no | no |
| 18 | serializer | no | no | no | **YES** — `.dx/serializer/mappings.dx` | **YES** — generates `.sr` files | **YES** — generates `.machine` files |
| 19 | style | no | YES | no | no | no | no |
| 20 | www | no | YES | **YES** — `from_dx_str()` for user project config | **YES** — `.dx/cache` dir | no | no |

**Key findings:**
- Only **2 tools** correctly parse the `dx` LLM-format config: **www** (for user projects) and **check** (for web audit targets)
- **cli** reads `dx` files but as TOML; actively **skips** LLM-format ones via `looks_like_project_serializer_config()`
- **5 tools** have `.dx/` directories on disk: build, check, js, metasearch, style, www — but only check, forge, cli, serializer, and www actively use them in code
- **Serializer** is the infrastructure owner: generates `.sr` receipts and `.machine` caches consumed by check, cli, and forge
- **16/20 tools** do not read any `dx` config at all

Windows: all 19 ✅. Linux: flow (C++ stdlib/gomp linkage with zig), js (windows-only). macOS: flow (ort prebuilts unavailable for x86_64-apple-darwin; try `ort-tract` backend; aarch64 also fails with CoreML/C++17 linkage), js (windows-only).

### Linux cross-compilation notes
- flow needs `--no-default-features` (X11/ALSA gating already in Cargo.toml), but fails with:
  - `libgomp.so` found in multiple locations (llama-cpp-sys-2, ort download cache, rustup sysroot) causing linker conflicts
  - `std::filesystem` undefined symbol from `ort_sys` — zig's C++ stdlib lacks C++17 filesystem support
- js (windows-only) — not attempted
- py previously blocked by `tikv-jemalloc-sys` — fixed by `--no-default-features --features "uv-distribution/static"`
- All others build cleanly with `cargo zigbuild`

### macOS cross-compilation notes
All macOS Intel (x86_64-apple-darwin) and ARM64 (aarch64-apple-darwin) builds completed 2026-06-26 — **17/19** both targets.
- **SDKROOT**: `G:\osxcross\target\SDK\MacOSX11.3.sdk`
- **Deployment target**: `MACOSX_DEPLOYMENT_TARGET=10.15`
- **Framework symlinks**: macOS SDK 7z extraction breaks `Headers`, `Versions/Current`, `Modules` symlinks in frameworks (0-byte files). Fix: recursive copy from `Versions/A/` for all 1460+ `.framework` dirs.
- **Key fixes**: `whisper.cpp` CMakeLists.txt modified to skip `FIND_PACKAGE(Accelerate FATAL_ERROR)` (cross-compile can't find macOS frameworks via `find_library`); `ggml/src/CMakeLists.txt` has Metal backend disabled (`ggml_add_backend(METAL)`); empty `libclang_rt.osx.a` stub placed in cargo-zigbuild deps to satisfy linker; `llama-cpp-sys-2/build.rs` modified to skip `clang_rt.osx` linking on Windows host
- **Blockers**:
  - flow: `ort` crate has no prebuilt binaries for `x86_64-apple-darwin`; aarch64 also fails with undefined CoreML symbols (`MLPredictionOptions`) requiring `-framework CoreML`, plus C++17 `std::filesystem` linkage issues
  - js: windows-only
- **Toolchain pins**: build (1.96.0), py (1.96.0) need `rustup target add --toolchain <ver>-x86_64-pc-windows-msvc <triple>`

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
| cli | `dx.exe` | `dx-cli` |
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

Setting `target-cpu=native` globally causes cargo to pass `-C target-cpu=znver3` on AMD hosts, which is invalid for ARM64 targets (the `ring` crate fails on unrecognized CPU features). Cargo merges global `[build].rustflags` with per-target flags (does not replace). Fixed by moving `target-cpu=native` from global `[build]` to per-target `[target.x86_64-*]` only, with empty lists for ARM64 targets:

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
