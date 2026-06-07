$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$outFile = Join-Path $root "dist\VillainsUI.lua"

$replacements = [ordered]@{
    'require\(script\.Parent\.Theme\)' = 'Import("Theme")'
    'require\(script\.Parent\.Animation\)' = 'Import("Animation")'
    'require\(script\.Parent\.Parent\.Core\.Theme\)' = 'Import("Theme")'
    'require\(script\.Parent\.Parent\.Core\.Creator\)' = 'Import("Creator")'
    'require\(script\.Parent\.Parent\.Core\.Animation\)' = 'Import("Animation")'
    'require\(script\.Parent\.Parent\.Core\.Themes\)' = 'Import("Themes")'
    'require\(script\.Parent\.Parent\.Elements\.Init\)' = 'Import("Elements")'
    'require\(script\.Parent\.Parent\.Modules\.Localization\)' = 'Import("Localization")'
    'require\(script\.Parent\.Parent\.Modules\.Config\)' = 'Import("Config")'
    'require\(script\.Parent\.Parent\.Components\.Window\)' = 'Import("Window")'
    'require\(script\.Parent\.Parent\.Components\.Notification\)' = 'Import("Notification")'
    'require\(script\.Parent\.Parent\.Components\.Popup\)' = 'Import("Popup")'
    'require\(script\.Parent\.Parent\.Components\.KeySystem\)' = 'Import("KeySystem")'
    'require\(script\.Parent\.Core\.Theme\)' = 'Import("Theme")'
    'require\(script\.Parent\.Core\.Themes\)' = 'Import("Themes")'
    'require\(script\.Parent\.Core\.Creator\)' = 'Import("Creator")'
    'require\(script\.Parent\.Core\.Animation\)' = 'Import("Animation")'
    'require\(script\.Parent\.Components\.Window\)' = 'Import("Window")'
    'require\(script\.Parent\.Components\.Notification\)' = 'Import("Notification")'
    'require\(script\.Parent\.Components\.Popup\)' = 'Import("Popup")'
    'require\(script\.Parent\.Components\.KeySystem\)' = 'Import("KeySystem")'
    'require\(script\.Parent\.Modules\.Localization\)' = 'Import("Localization")'
    'require\(script\.Parent\.Modules\.Config\)' = 'Import("Config")'
    'require\(script\.Parent\.Services\.Init\)' = 'Import("Services")'
    'require\(script\.Parent\.Platoboost\)' = 'Import("Platoboost")'
    'require\(script\.Parent\.PandaDevelopment\)' = 'Import("PandaDevelopment")'
    'require\(script\.Parent\.Luarmor\)' = 'Import("Luarmor")'
    'require\(script\.Parent\.JunkieDevelopment\)' = 'Import("JunkieDevelopment")'
    'require\(script\.Parent\.Parent\.Core\.Compat\)' = 'Import("Compat")'
    'require\(script\.Parent\.Core\.Compat\)' = 'Import("Compat")'
    'require\(script\.Parent\.Parent\.Core\.Icons\)' = 'Import("Icons")'
    'require\(script\.Parent\.Core\.Paint\)' = 'Import("Paint")'
    'require\(script\.Parent\.Core\.Icons\)' = 'Import("Icons")'
    'require\(script\.Parent\.Parent\.Components\.Tooltip\)' = 'Import("Tooltip")'
    'require\(script\.Parent\.Components\.Tooltip\)' = 'Import("Tooltip")'
}

function Convert-Module($path, $exportName) {
    $content = Get-Content (Join-Path $root $path) -Raw -Encoding UTF8
    $content = $content -replace '(?s)^--\[\[.*?\]\]\r?\n', ''
    $content = $content -replace '(?s)^--.*\r?\n', ''  # strip single-line header comments
    # Strip ANY trailing return statement (fixes ConfigManager vs Config mismatch)
    $content = $content -replace 'return\s+[\w\.]+\s*$', ''
    foreach ($key in $replacements.Keys) {
        $content = [regex]::Replace($content, $key, $replacements[$key])
    }
    return $content.Trim()
}

$header = @'
--[[
    VILLAINS UI LIBRARY v3.0.1 - DARK RED PREMIUM
    Premium Roblox UI Library for Script Hubs

    local VillainsUI = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/YOUR_USERNAME/VILLAINS-UI-LIBRARY/main/dist/VillainsUI.lua"
    ))()
]]

return (function()
    if not Color3.fromHex then
        function Color3.fromHex(hex)
            hex = string.gsub(hex, "#", "")
            return Color3.new(
                tonumber(string.sub(hex, 1, 2), 16) / 255,
                tonumber(string.sub(hex, 3, 4), 16) / 255,
                tonumber(string.sub(hex, 5, 6), 16) / 255
            )
        end
    end

    local Modules = {}
    local function Import(name)
        return Modules[name]
    end

'@

$modules = @(
    @{ Path = "src\Core\Compat.lua"; Name = "Compat"; Export = "Compat" },
    @{ Path = "src\Core\Theme.lua"; Name = "Theme"; Export = "Theme" },
    @{ Path = "src\Core\Themes.lua"; Name = "Themes"; Export = "Themes" },
    @{ Path = "src\Core\Animation.lua"; Name = "Animation"; Export = "Animation" },
    @{ Path = "src\Core\Icons.lua"; Name = "Icons"; Export = "Icons" },
    @{ Path = "src\Core\Creator.lua"; Name = "Creator"; Export = "Creator" },
    @{ Path = "src\Core\Paint.lua"; Name = "Paint"; Export = "Paint" },
    @{ Path = "src\Services\Luarmor.lua"; Name = "Luarmor"; Export = "Luarmor" },
    @{ Path = "src\Services\Platoboost.lua"; Name = "Platoboost"; Export = "Platoboost" },
    @{ Path = "src\Services\PandaDevelopment.lua"; Name = "PandaDevelopment"; Export = "PandaDevelopment" },
    @{ Path = "src\Services\JunkieDevelopment.lua"; Name = "JunkieDevelopment"; Export = "JunkieDevelopment" },
    @{ Path = "src\Services\Init.lua"; Name = "Services"; Export = "Services" },
    @{ Path = "src\Components\Tooltip.lua"; Name = "Tooltip"; Export = "Tooltip" },
    @{ Path = "src\Elements\Init.lua"; Name = "Elements"; Export = "Elements" },
    @{ Path = "src\Modules\Localization.lua"; Name = "Localization"; Export = "Localization" },
    @{ Path = "src\Modules\Config.lua"; Name = "Config"; Export = "ConfigManager" },
    @{ Path = "src\Components\Notification.lua"; Name = "Notification"; Export = "Notification" },
    @{ Path = "src\Components\Popup.lua"; Name = "Popup"; Export = "Popup" },
    @{ Path = "src\Components\KeySystem.lua"; Name = "KeySystem"; Export = "KeySystem" },
    @{ Path = "src\Components\Window.lua"; Name = "Window"; Export = "Window" },
    @{ Path = "src\Init.lua"; Name = "VillainsUI"; Export = "VillainsUI" }
)

$body = ""
foreach ($mod in $modules) {
    $src = Convert-Module $mod.Path $mod.Export
    $body += "    Modules[`"$($mod.Name)`"] = (function()`n"
    $body += ($src -split "`r?`n" | ForEach-Object { "        $_" }) -join "`n"
    $body += "`n        return $($mod.Export)`n    end)()`n`n"
}

$footer = @'
    return Import("VillainsUI")
end)()
'@

[System.IO.File]::WriteAllText($outFile, $header + $body + $footer, [System.Text.UTF8Encoding]::new($false))

# Validate: no duplicate return statements in module closures
$built = Get-Content $outFile -Raw
$dupes = [regex]::Matches($built, 'return\s+\w+\s*\r?\n\s+return\s+\w+')
if ($dupes.Count -gt 0) {
    Write-Error "Build validation failed: $($dupes.Count) duplicate return statement(s) found in bundle!"
    exit 1
}

Write-Host "Built $outFile ($((Get-Item $outFile).Length) bytes) - validated OK"
