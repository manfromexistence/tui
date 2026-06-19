param(
    [switch]$Json
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$excludeNames = @('trash', 'node_modules', 'target', 'target-debug', '.next', 'dist', 'coverage', '.cache', '.tmp', '.turbo', '.pytest_cache', '__pycache__')
$includeRelativePaths = @(
    '.gitattributes',
    '.github',
    '.gitignore',
    '.rgignore',
    'AGENTS.md',
    'CHANGELOG.md',
    'CURRENT_STATUS.md',
    'DX.md',
    'DX_LANE_PASS_SYSTEM.md',
    'DX_MANAGER_MEMORY.md',
    'PLAN.md',
    'README.md',
    'TODO.md',
    '.dx\launch-workspace.toml',
    'docs\policies',
    'docs\superpowers',
    'dx',
    'scripts'
)

function Get-BackupClass {
    param([Parameter(Mandatory = $true)][string]$Path)

    $name = Split-Path -Leaf $Path
    if ($name -in $excludeNames) {
        return 'exclude'
    }

    $relative = $Path.Substring($root.Length).TrimStart('\')
    foreach ($include in $includeRelativePaths) {
        if ($relative.Equals($include, [System.StringComparison]::OrdinalIgnoreCase) -or
            $relative.StartsWith("$include\", [System.StringComparison]::OrdinalIgnoreCase)) {
            return 'include'
        }
    }

    if (Test-Path -LiteralPath (Join-Path $Path '.git')) {
        return 'git-remote'
    }

    return 'review'
}

$rows = foreach ($item in Get-ChildItem -LiteralPath $root -Force | Sort-Object FullName) {
    if ($item.Name -eq '.git') {
        continue
    }

    [pscustomobject]@{
        path = $item.FullName
        name = $item.Name
        backupClass = Get-BackupClass -Path $item.FullName
    }
}

if ($Json) {
    $rows | ConvertTo-Json -Depth 5
} else {
    $rows | Format-Table name, backupClass, path -AutoSize
}
