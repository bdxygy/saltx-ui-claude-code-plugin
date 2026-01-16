#!/bin/bash

# detect-lines.sh
# Detect line count and file size for YAML files to determine reading strategy
# Usage: ./detect-lines.sh <file-path>
#
# Outputs:
# - FILE_SIZE: File size in bytes
# - LINE_COUNT: Number of lines in file
# - STRATEGY: Recommended reading strategy
# - CHUNK_SIZE: Recommended chunk size based on file scale
# - USE_GREP_FIRST: Whether to use Grep-first approach

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}INFO:${NC} $1"
}

print_success() {
    echo -e "${GREEN}SUCCESS:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}WARNING:${NC} $1"
}

print_error() {
    echo -e "${RED}ERROR:${NC} $1"
}

# Check if file path provided
if [ $# -eq 0 ]; then
    print_error "File path is required"
    echo "Usage: $0 <file-path>"
    echo ""
    echo "Example:"
    echo "  $0 .salt-ui/figma/4zD0kyv2x9ao27VSridvya/772-27196_raw.yaml"
    echo "  $0 /path/to/large_file.yaml"
    exit 1
fi

FILE_PATH="$1"

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    print_error "File not found: $FILE_PATH"
    exit 1
fi

# Get file size in bytes
if command -v stat >/dev/null 2>&1; then
    # macOS
    FILE_SIZE=$(stat -f%z "$FILE_PATH" 2>/dev/null)
    # Fallback to GNU stat if macOS stat fails
    if [ -z "$FILE_SIZE" ]; then
        FILE_SIZE=$(stat -c%s "$FILE_PATH" 2>/dev/null)
    fi
else
    print_error "stat command not found"
    exit 1
fi

# Get line count
if command -v wc >/dev/null 2>&1; then
    LINE_COUNT=$(wc -l < "$FILE_PATH" 2>/dev/null)
else
    print_error "wc command not found"
    exit 1
fi

# Format file size for human readability
format_size() {
    local size=$1
    if [ "$size" -ge 1048576 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $size/1048576}" )MB"
    elif [ "$size" -ge 1024 ]; then
        echo "$(awk "BEGIN {printf \"%.2f\", $size/1024}" )KB"
    else
        echo "${size}B"
    fi
}

# Determine reading strategy
determine_strategy() {
    local file_size=$1
    local line_count=$2
    local use_chunked=false
    local use_grep_first=false
    local chunk_size=500
    local reason=""

    # Check if file is large
    if [ "$file_size" -gt 102400 ] || [ "$line_count" -gt 10000 ]; then
        use_chunked=true
        use_grep_first=true
        reason="Large file detected"

        # Determine chunk size based on line count
        if [ "$line_count" -lt 10000 ]; then
            chunk_size=500
            reason="${reason} (< 10K lines)"
        elif [ "$line_count" -lt 50000 ]; then
            chunk_size=1000
            reason="${reason} (10K-50K lines)"
        elif [ "$line_count" -lt 100000 ]; then
            chunk_size=2000
            reason="${reason} (50K-100K lines)"
        else
            chunk_size=2500
            reason="${reason} (100K+ lines)"
        fi
    else
        use_chunked=false
        use_grep_first=false
        chunk_size=0
        reason="Small file"
    fi

    echo "$use_chunked|$use_grep_first|$chunk_size|$reason"
}

# Main output
print_info "Analyzing file: $FILE_PATH"

# Display file info
echo ""
echo "File Information:"
echo "  Path: $FILE_PATH"
echo "  Size: $(format_size $FILE_SIZE) ($FILE_SIZE bytes)"
echo "  Lines: $LINE_COUNT"

# Determine strategy
IFS='|' read -r USE_CHUNKED USE_GREP_FIRST CHUNK_SIZE STRATEGY_REASON <<< "$(determine_strategy "$FILE_SIZE" "$LINE_COUNT")"

echo ""
echo "Reading Strategy:"
echo "  Strategy: $STRATEGY_REASON"

if [ "$USE_CHUNKED" = "true" ]; then
    echo "  Chunked Reading: ${GREEN}Yes${NC}"
    echo "  Grep-First: ${GREEN}Yes${NC}"
    echo "  Chunk Size: ${GREEN}$CHUNK_SIZE lines${NC}"

    # Calculate number of chunks
    NUM_CHUNKS=$(( (LINE_COUNT + CHUNK_SIZE - 1) / CHUNK_SIZE ))
    echo "  Estimated Chunks: $NUM_CHUNKS"
else
    echo "  Chunked Reading: ${YELLOW}No${NC}"
    echo "  Grep-First: ${YELLOW}No${NC}"
    echo "  Recommendation: Read entire file at once"
fi

# Output machine-readable values for scripting
echo ""
echo "Machine-Readable Output:"
echo "FILE_SIZE=$FILE_SIZE"
echo "LINE_COUNT=$LINE_COUNT"
echo "USE_CHUNKED=$USE_CHUNKED"
echo "USE_GREP_FIRST=$USE_GREP_FIRST"
echo "CHUNK_SIZE=$CHUNK_SIZE"
echo "STRATEGY_REASON=\"$STRATEGY_REASON\""

# Exit with appropriate code
if [ "$USE_CHUNKED" = "true" ]; then
    exit 0  # Large file detected
else
    exit 0  # Small file
fi
