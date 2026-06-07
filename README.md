# VILLAINS UI Library v3.0.0 — Premium Dark Red

Premium open-source UI library for Roblox Script Hubs with **full WindUI feature parity** + enhanced premium dark red theme & animations.

![Version](https://img.shields.io/badge/version-3.0.0-crimson)
![License](https://img.shields.io/badge/license-MIT-red)
![Platform](https://img.shields.io/badge/platform-Roblox-darkred)

## Features (Premium v3.0.0 — 100% WindUI Parity)

### Premium Visuals
- **Dark Red Premium Theme** — Glow borders, shimmer topbar, pulse open button, spring animations
- **Acrylic Blur** — Frosted glass effect (`Acrylic = true`, `ToggleAcrylic()`)
- **Video/Image/Gradient Backgrounds** — `Background = "video:..."` or gradient
- **Transparency** — Semi-transparent window panels

### Core UI
- Window, Tab, TabSection, Tag, Search Bar, User Profile, Fullscreen
- Open Button (draggable, animated), Minimize/Close
- Notify, Popup, Dialog

### Elements
- Button, Toggle, **Checkbox**, Slider, Input, Dropdown, Keybind
- **HSV Colorpicker** (with transparency slider), Code, Image, **Viewport**
- Paragraph, Section, Divider, Space, Group, HStack, VStack
- **Tooltip** & **Desc** on elements

### Advanced
- **Key System** — Static keys, KeyValidator, SaveKey, URL, API services
- **Services** — Luarmor, Platoboost, PandaDevelopment, **Junkie Development**
- **Config Manager** — Save/Load with Flag system
- **Localization** — Multi-language with `loc:` prefix
- **Icons** — `lucide:`, `rbxassetid://`, emoji support (Footagesus Icons compatible)
- **Themes** — DarkRed, BloodMoon, Crimson, Dark + custom
- **SetFont** — Custom font asset support

## Quick Start

```lua
local VillainsUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/araachann69/VILLAINSUI/refs/heads/master/dist/VillainsUI.lua"
))()

local Window = VillainsUI:CreateWindow({
    Title = "VILLAINS Hub",
    Author = "Premium Script Hub",
    Icon = "☠",
})

local Tab = Window:Tab({ Title = "Main", Icon = "⚔" })

Tab:Toggle({
    Title = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end,
})

VillainsUI:Notify({
    Title = "Loaded!",
    Content = "VILLAINS UI is ready.",
    Duration = 3,
})
```

## Run Example

```lua
loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/araachann69/VILLAINSUI/refs/heads/master/dist/VillainsUI.lua"
))()
```

## Documentation

Deploy docs to Vercel:

1. Push this repo to GitHub
2. Import on [vercel.com](https://vercel.com)
3. Set root directory to `docs`
4. Deploy

## Project Structure

```
VILLAINS-UI-LIBRARY/
├── dist/VillainsUI.lua     # Loadstring file (use this!)
├── src/                     # Source modules
├── docs/                    # Documentation site (Vercel)
├── example.lua              # Full demo
├── build.ps1                # Bundle src → dist
└── README.md
```

## Build

After editing `src/`, rebuild the loadstring bundle:

```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```

## API Overview

| Method | Description |
|--------|-------------|
| `VillainsUI:CreateWindow(config)` | Create main window |
| `VillainsUI:Notify(config)` | Show notification |
| `VillainsUI:Popup(config)` | Show popup modal |
| `Window:Tab(config)` | Create sidebar tab |
| `Tab:Button/Toggle/Slider/...` | Add UI elements |

See full documentation in the `docs/` folder.

## Theme Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Background | `#070404` | Window background |
| Primary | `#DC143C` | Accent color |
| Primary Light | `#FF2D55` | Hover/glow |
| Primary Dark | `#8B0000` | Dark accents |
| Text | `#F5E6E6` | Primary text |

## License

MIT License — see [LICENSE](LICENSE)

## Credits

Inspired by [WindUI](https://github.com/Footagesus/WindUI) by Footagesus.
