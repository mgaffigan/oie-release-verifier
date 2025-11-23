# verify arg length
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <source_directory> <target_file>"
  exit 1
fi

# arg 1 is the source directory
SOURCE_DIR=$1
# arg 2 is the target file
TARGET_FILE=$2

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory does not exist: $SOURCE_DIR"
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
./expand.sh "$TEMP_DIR"
./normalize.sh "$TEMP_DIR"
./hash.sh "$TEMP_DIR" > "$TARGET_FILE"

# Print the hash of the hash file, but not the filename
sha256sum "$TARGET_FILE" | awk '{print $1}'
