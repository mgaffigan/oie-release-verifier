# Get our script directory so sibling scripts resolve regardless of cwd
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# verify arg length
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <source_directory> <target_file>"
  exit 1
fi

# arg 1 is the source directory
SOURCE_DIR=$1
# arg 2 is the target file
TARGET_FILE=$2
REFERENCE_FILE="$SCRIPT_DIR/refhash"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory does not exist: $SOURCE_DIR"
  exit 1
fi

if [ ! -f "$REFERENCE_FILE" ]; then
  echo "Reference hash file does not exist: $REFERENCE_FILE" >&2
  exit 1
fi

# make a temp dir to hold the tar contents
TEMP_DIR=$(mktemp -d)
if [ ! -d "$TEMP_DIR" ]; then
  echo "Failed to create temp directory"
  exit 1
fi

# Cleanup temp directory on exit (success or failure)
cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Copy source directory contents to temp dir
cp -r "$SOURCE_DIR"/* "$TEMP_DIR"/
"$SCRIPT_DIR/expand.sh" "$TEMP_DIR"
"$SCRIPT_DIR/normalize.sh" "$TEMP_DIR"
"$SCRIPT_DIR/hash.sh" "$TEMP_DIR" > "$TARGET_FILE"

# Verify the hash of the generated hash file against refhash
REFERENCE_HASH=$(sha256sum "$REFERENCE_FILE" | awk '{print $1}')
ACTUAL_HASH=$(sha256sum "$TARGET_FILE" | awk '{print $1}')

if [ "$ACTUAL_HASH" != "$REFERENCE_HASH" ]; then
  echo "Hash mismatch: expected $REFERENCE_HASH but got $ACTUAL_HASH" >&2
  diff -u "$REFERENCE_FILE" "$TARGET_FILE" >&2 || true
  exit 1
fi

echo "$ACTUAL_HASH"
