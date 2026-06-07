$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$wrapperSrc = Join-Path $root "src\VillainsUI.wrapper.lua"
$outFile = Join-Path $root "dist\VillainsUI.lua"
$fullOut = Join-Path $root "dist\VillainsUI.full.lua"

# Primary dist = WindUI-based wrapper (executor-safe)
$wrapper = Get-Content $wrapperSrc -Raw -Encoding UTF8
$header = @"
--[[
    VILLAINS UI LIBRARY v3.1.0 — Premium Dark Red
    Core: WindUI (Footagesus/WindUI)

    local loadfn = loadstring or load
    local VillainsUI = loadfn(game:HttpGet(
        "https://raw.githubusercontent.com/araachann69/VILLAINSUI/refs/heads/master/dist/VillainsUI.lua"
    ))()
]]

"@

[System.IO.File]::WriteAllText($outFile, $header + $wrapper.Trim(), [System.Text.UTF8Encoding]::new($false))
Write-Host "Built wrapper $outFile ($((Get-Item $outFile).Length) bytes)"

# Optional: build full custom bundle (legacy)
$legacyBuild = $false
if ($legacyBuild) {
    # ... legacy module bundler kept for dev reference
}

Write-Host "Done - dist/VillainsUI.lua uses WindUI core (recommended for executors)"
