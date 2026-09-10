# TorchUMM - two-part package

This is the finished TorchUMM project ZIP, split into two almost equal files for sharing. The included Windows helper reassembles the original ZIP. No compiler or additional software installation is needed.

## How to put it back together

1. Put these four files in the same folder, keeping their names:
   - `TorchUMM-main.zip.001`
   - `TorchUMM-main.zip.002`
   - `Reassemble.cmd`
   - `Reassemble.ps1`
2. Double-click `Reassemble.cmd`.
3. Wait for the success message. The helper creates `TorchUMM-main.zip` in that folder.
4. Right-click the rebuilt ZIP and select **Extract All**.

Keep this README with the package when sharing it. The two numbered parts cannot be opened individually. Both parts are required. Allow about 36 MB of additional free space to rebuild the ZIP, plus about 67 MB to extract the project.

## Package details

| File | Size |
| --- | ---: |
| `TorchUMM-main.zip.001` | 17,631,566 bytes (about 17.6 MB) |
| `TorchUMM-main.zip.002` | 17,631,565 bytes (about 17.6 MB) |
| Reassembled `TorchUMM-main.zip` | 35,263,131 bytes (about 35.3 MB) |

The helper checks each part's size and SHA-256 checksum before joining them, then verifies the complete ZIP against the finished original. It leaves an existing, different output file alone. Running it again after a successful rebuild verifies the existing ZIP.

Original ZIP SHA-256:

```text
C25670A6D46D184C3CE9FC93629454A20AB0D5612CE56004C261FA4B3ECE29BF
```

## Troubleshooting

- **Missing part:** put both numbered files next to the helper, without renaming them.
- **Incomplete or changed part:** copy that part again, then rerun the helper.
- **A different output file already exists:** move that existing file to another folder before rebuilding.
- **Scripts blocked by your organization's policy:** ask your administrator about running the helper. It uses Windows PowerShell and needs no administrator privileges.

For a terminal without the double-click launcher's pause:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Reassemble.ps1
```

Reassembly restores the original archive byte for byte. It does not build, install, or run TorchUMM; use the project's own README after extraction for those steps.
