# Archive Manifest Schema

Archive manifests are JSONL files written before move or deletion review. Each line describes one filesystem item.

## Fields

- `schemaVersion`: current value is `1`.
- `generatedAt`: local timestamp when the entry was written.
- `path`: current absolute path.
- `originalPath`: original absolute path when known.
- `archivePath`: archive target path when known.
- `name`: item name.
- `itemType`: `source-repo`, `rebuildable-artifact`, `receipt-record`, `pinned-tool`, `trash-payload`, `junction-reference`, or `unknown`.
- `lastWriteTimeUtc`: filesystem last write timestamp.
- `directChildCount`: immediate child count for directories.
- `directFileBytes`: total bytes of immediate files only.
- `gitMarkerType`: `directory`, `file`, or `none`.
- `gitdirTarget`: target recorded by a `.git` file when present.
- `staleGitdirTarget`: whether that target is missing.
- `junctionTarget`: reparse-point target when available.
- `retentionClass`: `source`, `archive-review`, `receipt`, `tooling`, or `unknown`.
- `backupClass`: `git-remote`, `manifest-only`, `cloud-snapshot`, `local-only`, or `exclude`.
- `restoreCommand`: suggested restore command.
- `deleteApproved`: always `false` when written by inventory scripts.

Manifests are validation, not permission to delete.
