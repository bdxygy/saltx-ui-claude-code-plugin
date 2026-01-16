# Framework Dependency Signatures

Complete reference for detecting JavaScript frameworks from package.json dependencies.

## ReactJS

**Dependencies:**
```json
{
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
```

**Characteristics:**
- No framework-specific package
- Just react and react-dom
- File extensions: `.tsx`, `.jsx`

**Detection:**
```bash
if has_dependency "react" && has_dependency "react-dom"; then
  FRAMEWORK="reactjs"
fi
```

---

## Next.js

**Dependencies:**
```json
{
  "dependencies": {
    "next": "^15.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
```

**Characteristics:**
- Contains `next` package (v15+ is latest)
- Always includes react and react-dom
- File extensions: `.tsx`, `.jsx`
- App Router is default in Next.js 15

**Routing Detection:**
```bash
if [ -d "app" ]; then
  ROUTING="app-router"
elif [ -d "pages" ]; then
  ROUTING="pages"
fi
```

---

## Remix

**Dependencies:**
```json
{
  "dependencies": {
    "@remix-run/react": "^2.0.0",
    "@remix-run/node": "^2.0.0",
    "@remix-run/server": "^2.0.0",
    "react": "^18.2.0"
  }
}
```

**Characteristics:**
- Contains `@remix-run/*` packages
- Always includes react
- File extensions: `.tsx`, `.jsx`

**Routing:** File-based (`app/routes/`)

---

## React Router v7+ (Framework Mode)

**Dependencies:**
```json
{
  "dependencies": {
    "react-router": "^7.0.0",
    "@react-router/node": "^7.0.0",
    "@react-router/dev": "^7.0.0",
    "react": "^18.2.0"
  }
}
```

**Characteristics:**
- Contains `@react-router/dev` (framework mode indicator)
- Contains `react-router` and `@react-router/node`
- File extensions: `.tsx`, `.jsx`
- v7+ supports three modes: Declarative, Data, Framework

**Routing:** File-based (`app/routes/`)

**Framework Mode Features:**
- Loaders and actions for data fetching
- File-based routing with `app/routes/`
- SSR support with streaming
- Automatic code splitting

**Note:** v7+ supports both framework mode (file-based routing) and library mode. Check for `@react-router/dev` to detect framework mode.

---

## Vue

**Dependencies:**
```json
{
  "dependencies": {
    "vue": "^3.3.0"
  }
}
```

**Characteristics:**
- Contains `vue` package
- File extensions: `.vue`

**Routing:** Optional (`vue-router`)

---

## Nuxt

**Dependencies:**
```json
{
  "dependencies": {
    "nuxt": "^3.0.0",
    "vue": "^3.3.0"
  }
}
```

**Characteristics:**
- Contains `nuxt` package
- Always includes vue
- File extensions: `.vue`

**Routing:** File-based (`pages/`)

---

## Svelte

**Dependencies:**
```json
{
  "dependencies": {
    "svelte": "^4.0.0"
  }
}
```

**Characteristics:**
- Contains `svelte` package
- File extensions: `.svelte`

**Routing:** Optional (`svelte-routing`)

---

## SvelteKit

**Dependencies:**
```json
{
  "dependencies": {
    "@sveltejs/kit": "^2.0.0",
    "svelte": "^4.0.0"
  }
}
```

**Characteristics:**
- Contains `@sveltejs/kit` package
- Always includes svelte
- File extensions: `.svelte`

**Routing:** File-based (`src/routes/`)

---

## Angular

**Dependencies (Angular 20+):**
```json
{
  "dependencies": {
    "@angular/core": "^20.0.0",
    "@angular/common": "^20.0.0",
    "@angular/router": "^20.0.0"
  },
  "devDependencies": {
    "typescript": "^5.8.0"
  },
  "engines": {
    "node": ">=20.0.0"
  }
}
```

**Dependencies (Angular 19-):**
```json
{
  "dependencies": {
    "@angular/core": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/router": "^17.0.0"
  }
}
```

**Characteristics:**
- Contains `@angular/core` package
- Angular 20+ requires TypeScript 5.8+ and Node 20+
- Angular 20+ uses signals (`input()`, `output()`, `computed()`)
- Angular 20+ uses simplified file naming (`user.ts` vs `user.component.ts`)
- File extensions: `.ts`, `.js`

**Routing:** Angular Router

**Version Detection:**
```bash
# Check Angular version
ANGULAR_VERSION=$(grep '"@angular/core"' package.json | sed 's/.*"\^?\([0-9]*\).*/\1/')
if [ "$ANGULAR_VERSION" -ge 20 ]; then
  ANGULAR_SIGNALS="true"
  ANGULAR_NAMING="simplified"
fi
```

---

## SolidJS

**Dependencies:**
```json
{
  "dependencies": {
    "solid-js": "^1.8.0",
    "@solidjs/router": "^0.10.0"
  }
}
```

**Characteristics:**
- Contains `solid-js` package
- May include `@solidjs/router`
- File extensions: `.tsx`, `.jsx`

**Routing:** Optional (`@solidjs/router`)

---

## TypeScript Detection

**Indicators:**
1. `tsconfig.json` file exists
2. `.ts`, `.tsx` files present
3. `typescript` in devDependencies
4. `@types/*` packages present

**Detection:**
```bash
if [ -f "tsconfig.json" ]; then
  TYPESCRIPT="true"
else
  TYPESCRIPT="false"
fi
```

---

## Detection Order

Check in this order (most specific to least specific):

1. **Next.js** - Check for `next`
2. **Remix** - Check for `@remix-run/react`
3. **React Router v7+** - Check for `@react-router/dev`
4. **SvelteKit** - Check for `@sveltejs/kit`
5. **Nuxt** - Check for `nuxt`
6. **Angular** - Check for `@angular/core`
7. **SolidJS** - Check for `solid-js`
8. **Vue** - Check for `vue`
9. **Svelte** - Check for `svelte`
10. **ReactJS** - Check for `react` and `react-dom`

---

## Framework-Specific File Patterns

| Framework | Component Files | Route Files | Style Files |
|-----------|----------------|-------------|-------------|
| ReactJS | `.tsx`, `.jsx` | N/A | `.css`, `.module.css` |
| Next.js | `.tsx`, `.jsx` | `app/*/page.tsx` | `.css`, `.module.css` |
| Remix | `.tsx`, `.jsx` | `app/routes/*.tsx` | `.css`, `.module.css` |
| React Router v7+ | `.tsx`, `.jsx` | `app/routes/*.tsx` | `.css`, `.module.css` |
| Vue | `.vue` | N/A | `<style>` block |
| Nuxt | `.vue` | `pages/*.vue` | `<style>` block |
| Svelte | `.svelte` | N/A | `<style>` block |
| SvelteKit | `.svelte` | `src/routes/*/+page.svelte` | `<style>` block |
| Angular | `.ts` | `*.routes.ts` | `*.css` |
| SolidJS | `.tsx`, `.jsx` | N/A | `.css`, `.module.css` |

---

## Routing Detection

### Next.js

```bash
# App Router (default)
if [ -d "app" ]; then
  ROUTING="app-router"
fi

# Pages Router (legacy)
if [ -d "pages" ]; then
  ROUTING="pages"
fi
```

### Remix

```bash
# Always file-based
ROUTING="file-based"
```

### React Router v7+

```bash
# Framework mode - file-based routing
if has_dependency "@react-router/dev"; then
  ROUTING="file-based"
fi

# Library mode - manual configuration
if has_dependency "react-router" && ! has_dependency "@react-router/dev"; then
  ROUTING="react-router"
fi
```

### Nuxt

```bash
# Always file-based
ROUTING="nuxt"
```

### SvelteKit

```bash
# Always file-based
ROUTING="sveltekit"
```

### Angular

```bash
# Angular Router
if has_dependency "@angular/router"; then
  ROUTING="angular"
fi
```

### SolidJS

```bash
# Solid Router
if has_dependency "@solidjs/router"; then
  ROUTING="solid-router"
else
  ROUTING="none"
fi
```

---

## Package.json Examples

### ReactJS Project

```json
{
  "name": "my-react-app",
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

### Next.js Project (v15)

```json
{
  "name": "my-next-app",
  "dependencies": {
    "next": "^15.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
```

### Remix Project

```json
{
  "name": "my-remix-app",
  "dependencies": {
    "@remix-run/react": "^2.0.0",
    "@remix-run/node": "^2.0.0",
    "@remix-run/server": "^2.0.0",
    "react": "^18.2.0"
  }
}
```

### React Router v7+ Project

```json
{
  "name": "my-react-router-app",
  "dependencies": {
    "react-router": "^7.0.0",
    "@react-router/node": "^7.0.0",
    "@react-router/dev": "^7.0.0",
    "react": "^18.2.0"
  }
}
```

### Vue Project

```json
{
  "name": "my-vue-app",
  "dependencies": {
    "vue": "^3.3.0"
  }
}
```

### Nuxt Project

```json
{
  "name": "my-nuxt-app",
  "dependencies": {
    "nuxt": "^3.0.0",
    "vue": "^3.3.0"
  }
}
```

### Svelte Project

```json
{
  "name": "my-svelte-app",
  "dependencies": {
    "svelte": "^4.0.0"
  }
}
```

### SvelteKit Project

```json
{
  "name": "my-sveltekit-app",
  "dependencies": {
    "@sveltejs/kit": "^2.0.0",
    "svelte": "^4.0.0"
  }
}
```

### Angular Project (v20)

```json
{
  "name": "my-angular-app",
  "dependencies": {
    "@angular/core": "^20.0.0",
    "@angular/common": "^20.0.0",
    "@angular/router": "^20.0.0"
  },
  "devDependencies": {
    "typescript": "^5.8.0"
  },
  "engines": {
    "node": ">=20.0.0"
  }
}
```

### Angular Project (v17-19 - Legacy)

```json
{
  "name": "my-angular-app",
  "dependencies": {
    "@angular/core": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/router": "^17.0.0"
  }
}
```

### SolidJS Project

```json
{
  "name": "my-solidjs-app",
  "dependencies": {
    "solid-js": "^1.8.0",
    "@solidjs/router": "^0.10.0"
  }
}
```
