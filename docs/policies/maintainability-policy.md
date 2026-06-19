# Maintainability Policy

The DX ecosystem should optimize for small, readable, professional files that another strong engineer can continue without decoding generated clutter.

## File Size

- Warn above 1,000 lines for hand-authored source files.
- Require a split plan above 2,000 lines.
- Treat files listed in `maintainability-baseline.json` as tracked debt, not acceptable precedent. They must not grow past the captured baseline without an updated split plan.
- Generated files must live under a clearly documented generated-output path.

## Naming

Use product and domain language. Avoid joke, temporary, or unprofessional names in commands, files, tests, and public output.

When a public command already exists with an unprofessional name, introduce a professional successor first and keep a compatibility alias only when removing the old command would break users.

Forbidden in production names unless explicitly allowlisted:

- `vibe`
- `tmp`
- `final-final`
- `test2`
- `newnew`

## Placeholders

Production paths must not silently pretend unfinished behavior works. Use explicit unsupported errors, feature gates, or tracked blockers.

## Tests

Large contract tests should be split by behavior area. Test filenames should describe the contract, not the implementation accident.
