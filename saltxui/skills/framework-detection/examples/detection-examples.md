# Framework Detection Examples

## Output Format

The detection script outputs three environment variables:

```bash
FRAMEWORK=react|next|remix|react-router-v7|vue|nuxt|svelte|sveltekit|angular|solidjs
TYPESCRIPT=true|false
ROUTING=app-router|file-based|vue-router|nuxt|sveltekit|angular|solid-router|none
```

## Example Scenarios

### Example 1: Next.js TypeScript App Router

**Input:** `apps/web` package.json
```json
{
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0"
  }
}
```

**Output:**
```bash
FRAMEWORK=next
TYPESCRIPT=true
ROUTING=app-router
```

### Example 2: Vue JavaScript

**Input:** `apps/admin` package.json
```json
{
  "dependencies": {
    "vue": "^3.3.0"
  }
}
```

**Output:**
```bash
FRAMEWORK=vue
TYPESCRIPT=false
ROUTING=vue-router
```

### Example 3: Remix TypeScript

**Input:** `app` package.json
```json
{
  "dependencies": {
    "@remix-run/react": "^2.0.0",
    "@remix-run/node": "^2.0.0"
  }
}
```

**Output:**
```bash
FRAMEWORK=remix
TYPESCRIPT=true
ROUTING=file-based
```

### Example 4: React Router v7+ Framework

**Input:** package.json
```json
{
  "dependencies": {
    "react-router": "^7.0.0",
    "@react-router/node": "^7.0.0",
    "@react-router/dev": "^7.0.0"
  }
}
```

**Output:**
```bash
FRAMEWORK=react-router-v7
TYPESCRIPT=true
ROUTING=file-based
```

### Example 5: SvelteKit

**Input:** package.json
```json
{
  "dependencies": {
    "@sveltejs/kit": "^2.0.0",
    "svelte": "^4.0.0"
  }
}
```

**Output:**
```bash
FRAMEWORK=sveltekit
TYPESCRIPT=true
ROUTING=sveltekit
```

### Example 6: Angular 20+

**Input:** package.json
```json
{
  "dependencies": {
    "@angular/core": "^20.0.0",
    "@angular/router": "^20.0.0"
  },
  "devDependencies": {
    "typescript": "^5.8.0"
  }
}
```

**Output:**
```bash
FRAMEWORK=angular
TYPESCRIPT=true
ROUTING=angular
ANGULAR_VERSION=20
ANGULAR_SIGNALS=true
ANGULAR_NAMING=simplified
```

### Example 7: Angular 19- (Legacy)

**Input:** package.json
```json
{
  "dependencies": {
    "@angular/core": "^17.0.0",
    "@angular/router": "^17.0.0"
  }
}
```

**Output:**
```bash
FRAMEWORK=angular
TYPESCRIPT=true
ROUTING=angular
ANGULAR_VERSION=17
```

### Example 8: SolidJS with Router

**Input:** package.json
```json
{
  "dependencies": {
    "solid-js": "^1.8.0",
    "@solidjs/router": "^0.10.0"
  }
}
```

**Output:**
```bash
FRAMEWORK=solidjs
TYPESCRIPT=true
ROUTING=solid-router
```

## Usage in Commands

```bash
# Detect framework for specific app
./detect-framework.sh apps/web

# Parse output
RESULT=$(./detect-framework.sh apps/web)
FRAMEWORK=$(echo "$RESULT" | grep FRAMEWORK | cut -d= -f2)
TYPESCRIPT=$(echo "$RESULT" | grep TYPESCRIPT | cut -d= -f2)
ROUTING=$(echo "$RESULT" | grep ROUTING | cut -d= -f2)

# Use values
echo "Detected: $FRAMEWORK (TS: $TYPESCRIPT, Routing: $ROUTING)"
```

## Error Cases

### Missing package.json

```bash
$ ./detect-framework.sh /invalid/path
Error: package.json not found in: /invalid/path
```

### Unknown Framework

```bash
$ ./detect-framework.sh apps/unknown
Error: Unable to detect framework
```
