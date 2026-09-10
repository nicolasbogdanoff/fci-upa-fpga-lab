param(
    [string]$QuestaRoot = "E:\Altera\questa_fse",
    [switch]$CompileOnly
)

$ErrorActionPreference = "Stop"

# Reuse a per-user license setting even when the current shell was opened
# before the environment variable was created or changed.
if (-not $env:SALT_LICENSE_SERVER) {
    $userEnvironment = Get-ItemProperty "HKCU:\Environment" -ErrorAction SilentlyContinue
    if ($userEnvironment.SALT_LICENSE_SERVER) {
        $env:SALT_LICENSE_SERVER = [string]$userEnvironment.SALT_LICENSE_SERVER
    }
}

if (Get-Process -Name "vish" -ErrorAction SilentlyContinue) {
    throw "La GUI de Questa está usando la licencia nodelocked. Cierra Questa antes de ejecutar la regresión por consola."
}

$vlib = Join-Path $QuestaRoot "win64\vlib.exe"
$vlog = Join-Path $QuestaRoot "win64\vlog.exe"
$vsim = Join-Path $QuestaRoot "win64\vsim.exe"

foreach ($tool in @($vlib, $vlog, $vsim)) {
    if (-not (Test-Path -LiteralPath $tool)) {
        throw "No se encontró la herramienta de Questa: $tool"
    }
}

Push-Location $PSScriptRoot
try {
    if (Test-Path -LiteralPath "work") {
        Remove-Item -LiteralPath "work" -Recurse -Force
    }
    & $vlib work
    if ($LASTEXITCODE -ne 0) {
        throw "vlib terminó con código $LASTEXITCODE"
    }
    & $vlog -sv ..\rtl\fixed_point_pkg.sv ..\rtl\thermal_kernel.sv ..\rtl\thermal_kernel_stream.sv .\tb_thermal_kernel.sv .\tb_thermal_kernel_stream.sv
    if ($LASTEXITCODE -ne 0) {
        throw "vlog terminó con código $LASTEXITCODE"
    }

    if ($CompileOnly) {
        Write-Host "Compilación RTL completada correctamente."
        return
    }

    & $vsim -c tb_thermal_kernel -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) {
        throw "Questa no pudo ejecutar la simulación (código $LASTEXITCODE). Verifica SALT_LICENSE_SERVER o LM_LICENSE_FILE."
    }

    & $vsim -c tb_thermal_kernel_stream -do "run -all; quit -f"
    if ($LASTEXITCODE -ne 0) {
        throw "Questa no pudo ejecutar la simulación streaming (código $LASTEXITCODE). Verifica SALT_LICENSE_SERVER o LM_LICENSE_FILE."
    }
}
finally {
    Pop-Location
}
