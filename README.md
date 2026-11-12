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


# Native Post-Skin Runtime API (revision 1)

`Core/NBP/NativePostSkin/Runtime.ini` provides the `NBPv1` namespace. The
package includes it from `d3dx.ini`. Ship the entire `Core` directory alongside
`d3dx.ini`; copying only the INI is no longer sufficient. No release archive
builder is maintained in this repository.

This API was tested by reloading the live Naraka installation with the current
c00f48ca subdivision Mod. It keeps the original position-deformation and normal
compute shaders, with generated per-Mod input tables. It does not identify or
modify every model automatically. The export-side table generator is provided
by MIMIBlender 1.0.84 or newer, using workspace metadata extracted by MMT 1.0.152
or newer. Use NBP-Package V0.0.4 or newer with these generated Mods.

Mods check `$\NBPv1\native_postskin_api == 1` before calling the API. This is
an integer ABI revision, separate from package release versions. A Mod requiring
this API must declare that dependency to users; this revision does not provide
an on-screen missing-runtime notification.

## Resource ownership and calls

All names below are exposed as `Resource\NBPv1\<name>`. The Mod assigns each
with `= ref Resource<its-own-name>` immediately before the synchronous call.
Mutable storage belongs to the Mod; the Runtime only holds temporary aliases.
The caller must select the intended native shader and output UAV first and must
scope the invocation to its own model. Original skinning retains the current
bone SRV by reference before the game's later passes bind different inputs.

| Call | Required resource aliases | Dispatch variables |
| --- | --- | --- |
| `CommandList\NBPv1\DeformNative` | Bones, Frames, PositionCB, PositionBatch, PositionMapping, PositionInfluences, PositionMembers, PositionOffsets | `$\NBPv1\frame_dispatch`, `$\NBPv1\vertex_dispatch` |
| `CommandList\NBPv1\RecalculateNormals` | Shadow, LimitsCB, NormalCB, NormalTriangles, NormalTargets, NormalMembers, NormalOffsets, NormalAdjacency, NormalAdjacencyOffsets | `$\NBPv1\vertex_dispatch`, `$\NBPv1\normal_dispatch` |

`DeformNative` expects the game's original 48-byte parameter CB and simulation
frame SRV in cs-cb0/cs-t4 on entry. Bones is a 64-byte structured matrix SRV.
Frames is a Mod-allocated 80-byte structured UAV/SRV holding simulation frames
plus two families of bone matrices. PositionCB replaces the native count/blend
parameters after those original parameters are consumed. The Mod's generated
signed influence weights account for the original per-vertex blend.

`RecalculateNormals` expects the Mod's main raw output UAV in cs-u0. Shadow is a
separate equally sized raw UAV/SRV; LimitsCB begins with the render vertex count.
The current helper scales shadow positions by two to compensate triangle area
for the tested four-way subdivision fixture. This fixed treatment is not a
general rule for arbitrary topology or model scales. Only normal xyz is copied
back; main positions and tangents remain untouched.

Both calls replace the game's dispatch with a manual native dispatch. All
borrowed helper slots (cs-t50, cs-t51, cs-u5 and cs-cb13) are restored. Main native
pass slots intentionally retain the call's result/bindings. Temporary Package
resource aliases and dispatch variables are cleared before returning, so the
next Mod must supply a complete call context. Boundary dump commands only take
effect during frame analysis and support runtime diagnostics.

## Compatibility boundary

API revision 1 was validated for the supplied two native shader families and
40-byte P12/N12/TA16 output. Generators must validate layout, frame count, mapping
ranges, adjacency and allocation sizes before invoking it. This package does
not fabricate bindings for arbitrary newly authored vertices. Old Mods without
these API calls keep their existing behavior.
