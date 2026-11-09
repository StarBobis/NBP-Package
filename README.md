# NBP-Package

3Dmigoto Preconfigured For Certain Action Game.

# Requirement

- [XXMI Launcher](https://github.com/SpectrumQT/XXMI-Installer/releases/latest)
- [SSMT4](https://github.com/Perxenic-Acid/SSMT4) (model extract and shader generation)

This package only ships the configuration, the 3dmigoto DLLs are **not** included. Extract the
zip into the game folder and let the XXMI Launcher load it.

# Global Check Used

This config uses a global check instead of a manual per shader check, so you don't have to
regenerate the VSCheck list for every model you extract.

- `[ShaderRegexEnableTextureOverrides]` (`vs_4_0` - `vs_5_1`) runs `[CommandListSkin]`, which enables
  the texture overrides on `ps-t0` - `ps-t19`, `vb0` - `vb5` and `ib`.
- `[ShaderRegexCS]` (`cs_5_0`, `cs_5_1`) enables the texture overrides on `cs-cb0`, `cs-t0` - `cs-t4` and `cs-u0`.
- `[ShaderOverride_2750543abffdfcc5]` enables the `ib` override for the UI shader as well.

But keep in mind:

- Some transparency shaders may let your game die.
- The FPS decrease will be super huge.

If the game crashes or the frame rate is unusable, go back to the manual check and generate the
VSCheck in SSMT's WorkPage after the model extract when you make a mod.

# Included Tweaks

- Hide the UID lobby (`[TextureOverride_IB_d9a2222f_252_0]`).
- Hide the game UI with `Ctrl` + `U` (`[ShaderOverride_UI]`, `[ShaderOverride_UI2]`).
- Toggle the costume mods with `F6` (`$costume_mods`).

# Hotkeys

| Key | Action |
| --- | --- |
| `F6` | Toggle the costume mods (`$costume_mods`) |
| `Ctrl` + `U` | Toggle the hidden UI (`$HideUI`) |
| `F10` | Reload all the fixes and the config |
| `Ctrl` + `Alt` + `F10` | Wipe the user config |
| `F9` | Hold to show the original game |
| `Ctrl` + `F9` | Show the performance monitor |
| `Print Screen` | Take a screenshot |

The hunting keys are on the numpad, see the `[Hunting]` section of `d3dx.ini` for the full list.

# Mods

Put your mod files in the `Mods` folder and press `F10` in game to reload Mod.
Files whose name starts with `DISABLED` are skipped by the loader.

# Warning

You may get 30days account ban when you play 3Dmigoto with this game, even a forever ban is highly possible.

Take your own risk to use it.


# Notice

This package is designed to work with SSMT,don't use it manually unless you know what you are doing.
