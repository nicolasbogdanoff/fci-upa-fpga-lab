param(
    [switch]$SkipSimulation
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot
try {
    python -m unittest discover -s models -p "test_*.py"
    if ($LASTEXITCODE -ne 0) {
        throw "Las pruebas Python fallaron."
    }

    python models\generate_thermal_vectors.py
    if ($LASTEXITCODE -ne 0) {
        throw "La generación de vectores falló."
    }

    python models\analyze_quantization.py
    if ($LASTEXITCODE -ne 0) {
        throw "El análisis de cuantización falló."
    }

    if (-not $SkipSimulation) {
        & .\sim\run_questa.ps1
        if ($LASTEXITCODE -ne 0) {
            throw "La simulación Questa falló."
        }
    }

    git diff --check
    if ($LASTEXITCODE -ne 0) {
        throw "La revisión de formato Git falló."
    }

    Write-Host "VERIFICACION LOCAL COMPLETA"
}
finally {
    Pop-Location
}

