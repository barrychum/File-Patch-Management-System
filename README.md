## Overview

This repository contains 3 Bash scripts located in the `src` folder: `cp-version.sh`, `cp-patch.sh` and `restore-patch.sh`. These scripts are designed to manage and apply patches to files, allowing for efficient version control and restoration. 

## Scripts

### `cp-patch.sh`

**Purpose:**
The `cp-patch.sh` script is used to copy a source file to a target folder. If the target file already exists, the script generates a patch file that captures the differences between the existing target file and the new source file. This patch file is stored in a `.patch` subfolder within the target directory.

**Usage:**
```bash
./cp-patch.sh <source_file> <target_folder>
```

**Arguments:**
- `<source_file>`: The path to the source file to be copied.
- `<target_folder>`: The destination folder where the source file will be copied.

**Behavior:**
- Creates a `.patch` folder in the target directory if it does not exist.
- Generates a patch file with a timestamp if the target file exists and is different from the source file.
- Copies the source file to the target folder.
- Exits with status code `2` if no differences are found (patch file not created).

### `restore-patch.sh`

**Purpose:**
The `restore-patch.sh` script is used to restore a file to a previous state by applying patch files in reverse order. The patches are located in a `.patch` subfolder within the same directory as the input file.

**Usage:**
```bash
./restore-patch.sh <input_file> [timestamp | all | last]
```

**Arguments:**
- `<input_file>`: The path to the file to be restored.
- `[timestamp | all | last]`: Optional. Specifies the mode of restoration:
  - `all` (default): Applies all patches.
  - `last`: Applies the most recent patch.
  - `timestamp`: Applies patches newer than the specified timestamp in `YYYYMMDD-HHMMSS` format.

**Behavior:**
- Checks if the input file and patch folder exist.
- Collects relevant patch files based on the specified mode.
- Confirms the list of patches to be applied with the user.
- Creates a restore file and applies patches in reverse order.

### `cp-version.sh`

**Purpose:**
The `cp-version.sh` script is used to copy a source file to a target folder. If the target file already exists, the script generates a patch file that captures the differences between the existing target file and the new source file. This patch file is stored in a `.version` subfolder within the target directory.


**Usage:**
```bash
./cp-version.sh <source_file> <target_folder>
```

**Arguments:**
- `<source_file>`: The path to the source file to be copied.
- `<target_folder>`: The destination folder where the source file will be copied.


**Behavior:**
- Creates a `.version` folder in the target directory if it does not exist.
- Generates a version file with a timestamp if the target file exists and is different from the source file.
- Copies the source file to the target folder.


## Folder Structure

```
src/
  ├── cp-version.sh
  ├── cp-patch.sh
  └── restore-patch.sh
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
