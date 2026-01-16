---
name: Framework Detection
description: Auto-detect the JavaScript framework used in each turborepo app using shell script and dependency signatures
version: 1.0.0
---

The Framework Detection skill provides comprehensive guidance on automatically detecting JavaScript frameworks from package.json dependencies and file patterns.

## When to Use This Skill

Activate this skill when:
- User asks to "detect framework"
- User asks "what framework" is being used
- User mentions "framework detection"
- User needs to "identify framework" of an app
- Determining framework from package.json
- Working with mixed-framework monorepos

## Shell Script Detection

**Detection Script Location:**
`/Users/budisantoso/.claude/plugins/cache/claude-plugins-official/plugin-dev/f70b65538da0/scripts/detect-framework.sh`

**Usage:**
```bash
./scripts/detect-framework.sh <app-directory>
```

**Returns:**
```bash
FRAMEWORK=react|next|remix|react-router-v7|vue|nuxt|svelte|sveltekit|angular|solidjs
TYPESCRIPT=true|false
ROUTING=app-router|file-based|vue-router|nuxt|sveltekit|angular|solid-router|none
```

## Framework Dependency Signatures

### ReactJS
**Dependencies:**
- `react`
- `react-dom`

**File Extensions:** `.tsx`, `.jsx`

**Routing:** None (uses react-router or similar)

### Next.js
**Dependencies:**
- `next`
- `react`, `react-dom`

**File Extensions:** `.tsx`, `.jsx`

**Routing:** `app-router` (App Router) or `pages` (Pages Router)

### Remix
**Dependencies:**
- `@remix-run/react`
- `@remix-run/node`
- `@remix-run/server`

**File Extensions:** `.tsx`, `.jsx`

**Routing:** `file-based` (routes/ directory)

### React Router v7+ (Framework)
**Dependencies:**
- `react-router`
- `@react-router/node`
- `@react-router/dev`

**File Extensions:** `.tsx`, `.jsx`

**Routing:** `file-based` (app/routes/ directory)

**Note:** v7+ supports both framework mode (file-based routing) and library mode

### Vue
**Dependencies:**
- `vue`

**File Extensions:** `.vue`

**Routing:** `vue-router` (optional, separate package)

### Nuxt
**Dependencies:**
- `nuxt`
- `vue`

**File Extensions:** `.vue`

**Routing:** `nuxt` (file-based in pages/)

### Svelte
**Dependencies:**
- `svelte`

**File Extensions:** `.svelte`

**Routing:** `none` (uses svelte-routing or similar)

### SvelteKit
**Dependencies:**
- `@sveltejs/kit`
- `svelte`

**File Extensions:** `.svelte`

**Routing:** `sveltekit` (file-based in routes/)

### Angular
**Dependencies:**
- `@angular/core`
- `@angular/common`

**File Extensions:** `.ts`, `.js`

**Routing:** `angular` (Angular Router)

### SolidJS
**Dependencies:**
- `solid-js`
- `@solidjs/router`

**File Extensions:** `.tsx`, `.jsx`

**Routing:** `solid-router` or `none`

## Detecting Framework from File Extensions

**Framework Detection Logic:**
```bash
if find . -name "*.tsx" -o -name "*.jsx" | grep -q .; then
  # React-based framework
  # Check specific dependencies to narrow down
fi

if find . -name "*.vue" | grep -q .; then
  # Vue-based framework
fi

if find . -name "*.svelte" | grep -q .; then
  # Svelte-based framework
fi

if find . -name "*.ts" -o -name "*.js" | grep -q .; then
  # Angular or other
fi
```

## TypeScript vs JavaScript Detection

**TypeScript Indicators:**
- `tsconfig.json` file exists
- `.ts`, `.tsx` files present
- `typescript` in devDependencies
- `@types/*` packages present

**JavaScript Indicators:**
- No `tsconfig.json`
- `.js`, `.jsx` files only
- No `typescript` dependency

**Detection:**
```bash
if [ -f "tsconfig.json" ]; then
  TYPESCRIPT=true
else
  TYPESCRIPT=false
fi
```

## Routing Detection

**Next.js App Router:**
- `app/` directory with `page.tsx` files

**Next.js Pages Router:**
- `pages/` directory

**Remix:**
- `app/routes/` directory

**React Router v7+:**
- `app/routes/` directory

**Vue Router:**
- `src/router/` directory

**Nuxt:**
- `pages/` directory

**SvelteKit:**
- `src/routes/` directory

**Angular:**
- `app.routes.ts` or routing configuration

**Solid Router:**
- `src/routes/` directory or `@solidjs/router` dependency

## Framework-Specific Import Paths

**React/Next.js:**
```tsx
import { Component } from '@/components/Component';
import { Component } from '../../components/Component';
```

**Vue:**
```vue
<script setup>
import Component from '@/components/Component.vue';
</script>
```

**Svelte:**
```svelte
<script>
import Component from '$lib/components/Component.svelte';
</script>
```

**Angular:**
```typescript
import { Component } from './component.component';
```

**SolidJS:**
```tsx
import { Component } from '~/components/Component';
```

## Handling Mixed-Framework Monorepos

**Detection by App:**
```bash
for app in apps/*/; do
  detect-framework.sh "$app"
done
```

**Result:**
```
apps/web: FRAMEWORK=next TYPESCRIPT=true
apps/admin: FRAMEWORK=vue TYPESCRIPT=true
apps/mobile: FRAMEWORK=react TYPESCRIPT=false
```

**Configuration:**
```yaml
# .claude/implement.local.md
apps:
  web:
    framework: "auto"
  admin:
    framework: "vue"
  mobile:
    framework: "react"
```

## Framework-Specific Patterns

### ReactJS Patterns
- Functional components with hooks
- `useState`, `useEffect`
- JSX syntax

### Next.js Patterns
- Server Components (`async` components)
- `generateMetadata` for metadata
- App Router: `app/` directory
- Pages Router: `pages/` directory

### Remix Patterns
- Loader and action functions
- `useLoaderData`, `useActionData`
- File-based routing in `app/routes/`

### React Router v7+ Patterns
- `loader` and `action` functions
- File-based routing in `app/routes/`
- SSR support with streaming

### Vue Patterns
- Composition API with `<script setup>`
- Options API
- `ref`, `reactive`, `computed`

### Nuxt Patterns
- File-based routing in `pages/`
- `useAsyncData`, `useFetch`
- Auto-imports

### Svelte Patterns
- Reactive syntax with `$`
- `onMount`, `afterUpdate`
- Directives: `bind:`, `on:`

### SvelteKit Patterns
- `+page.svelte`, `+layout.svelte`
- `load` functions
- Form actions with `+page.server.js`

### Angular Patterns
- Component decorators (`@Component`)
- Services with `@Injectable`
- NgModule or standalone

### SolidJS Patterns
- Reactive primitives: `createSignal`, `createEffect`
- JSX syntax
- `createMemo`, `createResource`

## Detection Script Reference

**Complete Script:**
See `/Users/budisantoso/.claude/plugins/cache/claude-plugins-official/plugin-dev/f70b65538da0/scripts/detect-framework.sh`

**Usage in Commands:**
```bash
# Detect framework for current app
FRAMEWORK=$(./scripts/detect-framework.sh apps/web | grep FRAMEWORK | cut -d= -f2)

# Detect TypeScript
TYPESCRIPT=$(./scripts/detect-framework.sh apps/web | grep TYPESCRIPT | cut -d= -f2)
```

## Best Practices

1. **Auto-detect from package.json** - Most reliable method
2. **Validate with file structure** - Confirm with directory patterns
3. **Handle monorepos** - Detect per app, not globally
4. **Support overrides** - Allow manual framework specification
5. **Check TypeScript** - Separate flag for TS vs JS
6. **Detect routing** - Important for file placement
7. **Cache results** - Avoid repeated detection
8. **Provide clear output** - Return all three values (FRAMEWORK, TYPESCRIPT, ROUTING)

## References

- **Framework Signatures**: See `references/framework-signatures.md`
- **Framework Versions**: See `references/framework-versions.md` (Latest versions and features)
- **Example Output**: See `examples/detection-examples.md`

## Examples

- `scripts/detect-framework.sh` - Complete detection script
- `examples/detection-examples.md` - Detection output examples
