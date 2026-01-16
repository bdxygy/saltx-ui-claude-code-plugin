#!/bin/bash

# Framework Detection Script for SaltxUI Plugin
# Usage: ./detect-framework.sh <app-directory>
# Returns: FRAMEWORK=..., TYPESCRIPT=..., ROUTING=...

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print error and exit
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Check if app directory is provided
if [ -z "$1" ]; then
    error_exit "App directory not provided. Usage: $0 <app-directory>"
fi

APP_DIR="$1"

# Check if app directory exists
if [ ! -d "$APP_DIR" ]; then
    error_exit "App directory does not exist: $APP_DIR"
fi

# Check for package.json
PACKAGE_JSON="$APP_DIR/package.json"
if [ ! -f "$PACKAGE_JSON" ]; then
    error_exit "package.json not found in: $APP_DIR"
fi

# Read package.json content
PACKAGE_CONTENT=$(cat "$PACKAGE_JSON")

# Detect TypeScript
TYPESCRIPT="false"
if [ -f "$APP_DIR/tsconfig.json" ]; then
    TYPESCRIPT="true"
elif echo "$PACKAGE_CONTENT" | grep -q '"typescript"'; then
    TYPESCRIPT="true"
fi

# Detect framework by checking dependencies
FRAMEWORK=""
ROUTING="none"

# Check dependencies function
has_dependency() {
    echo "$PACKAGE_CONTENT" | grep -q "\"$1\""
}

# Framework detection order (more specific first)
if has_dependency "next"; then
    FRAMEWORK="next"
    # Check if using App Router or Pages Router
    if [ -d "$APP_DIR/app" ]; then
        ROUTING="app-router"
    elif [ -d "$APP_DIR/pages" ]; then
        ROUTING="pages"
    else
        ROUTING="app-router"  # Default to App Router for newer Next.js
    fi

elif has_dependency "@remix-run/react" || has_dependency "@remix-run/node"; then
    FRAMEWORK="remix"
    ROUTING="file-based"

elif has_dependency "@react-router/dev" && has_dependency "react-router"; then
    # React Router v7+ framework mode
    FRAMEWORK="react-router-v7"
    ROUTING="file-based"

elif has_dependency "react-router" || has_dependency "react-router-dom"; then
    # React Router library mode (not v7+ framework)
    FRAMEWORK="reactjs"
    ROUTING="vue-router"  # Using react-router library

elif has_dependency "nuxt"; then
    FRAMEWORK="nuxt"
    ROUTING="nuxt"

elif has_dependency "vue"; then
    FRAMEWORK="vue"
    ROUTING="vue-router"  # Optional, may not be present

elif has_dependency "@sveltejs/kit"; then
    FRAMEWORK="sveltekit"
    ROUTING="sveltekit"

elif has_dependency "svelte"; then
    FRAMEWORK="svelte"
    ROUTING="none"  # svelte-routing is optional

elif has_dependency "@angular/core" || has_dependency "@angular/common"; then
    FRAMEWORK="angular"
    ROUTING="angular"

elif has_dependency "solid-js"; then
    FRAMEWORK="solidjs"
    if has_dependency "@solidjs/router"; then
        ROUTING="solid-router"
    else
        ROUTING="none"
    fi

elif has_dependency "react" && has_dependency "react-dom"; then
    FRAMEWORK="reactjs"
    ROUTING="none"  # No built-in routing

else
    # Fallback: try to detect from file structure
    if find "$APP_DIR" -name "*.tsx" -o -name "*.jsx" | grep -q .; then
        FRAMEWORK="reactjs"
        ROUTING="none"
    elif find "$APP_DIR" -name "*.vue" | grep -q .; then
        FRAMEWORK="vue"
        ROUTING="vue-router"
    elif find "$APP_DIR" -name "*.svelte" | grep -q .; then
        FRAMEWORK="svelte"
        ROUTING="none"
    else
        error_exit "Unable to detect framework. Please specify manually."
    fi
fi

# Output results
echo "FRAMEWORK=$FRAMEWORK"
echo "TYPESCRIPT=$TYPESCRIPT"
echo "ROUTING=$ROUTING"

# Optional: verbose output
if [ "$2" = "--verbose" ]; then
    echo -e "${GREEN}Framework detected:${NC} $FRAMEWORK"
    echo -e "${GREEN}TypeScript:${NC} $TYPESCRIPT"
    echo -e "${GREEN}Routing:${NC} $ROUTING"
fi
