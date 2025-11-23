# Open Integration Engine release verification toolkit

This repo houses the scripts to verify Open Integration Engine release validity.

The script generates a hash file from a directory by expanding all `.jar` files, normalizing version-specific content (like javadocs and version properties), and computing SHA hashes of all files. You can then compare the hash files from a reference build and a release to verify they match.

## Requirements
1. `bash`
2. `unzip` (for extracting JAR files)

## Usage
Run `./verify.sh <source_directory> <target_file>`

Example:
```bash
./verify.sh engine/ engine-hashes.txt
./verify.sh oie/ oie-hashes.txt
diff engine-hashes.txt oie-hashes.txt
```

Where:
- `<source_directory>` is the directory containing JAR files to hash
- `<target_file>` is the output file where hashes will be written

The script also prints the SHA-256 hash of the generated hash file, which can be used for quick comparison.

## Preparing Directories

Before running the verification script, you'll need to:

1. **Clone and build the reference directory** (e.g., the engine at a specific commit):
   ```bash
   git clone --depth=1 git@github.com:OpenIntegrationEngine/engine.git engine
   cd engine
   # Build the project according to its build instructions
   cd ..
   ```

2. **Extract the release to verify**:
   ```bash
   curl -L -o release.tar.gz "https://github.com/OpenIntegrationEngine/engine/releases/download/v4.5.2/oie_unix_4_5_2.tar.gz"
   tar xzf release.tar.gz
   ```

3. **Run the verification**:
   ```bash
   ./verify.sh engine/server/setup/ build-hashes.txt
   ./verify.sh oie/ oie-hashes.txt
   # Compare the hashes
   diff build-hashes.txt oie-hashes.txt
   ```

## Environment Variables

- `VERBOSE` - Set to any value to enable verbose output during JAR extraction
- `IGNORE_JAVADOCS` - Set to any value to exclude the `docs` directory from hashing
