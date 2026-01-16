# Framework Versions Reference (2025)

Complete reference for the latest framework versions and their key features.

## Framework Version Summary (January 2025)

| Framework | Latest Version | Key Features | Breaking Changes |
|-----------|----------------|--------------|------------------|
| **Angular** | 20.0 | Signals, simplified naming, TS 5.8, Node 20 | File naming, signals syntax |
| **Next.js** | 15.0 | App Router default, Partial Prerendering | Pages Router legacy |
| **React Router** | 7.0 | Framework mode, loaders/actions | New modes API |
| **Remix** | 2.0 | Enhanced loaders, streaming | Route file changes |
| **Vue** | 3.4 | Composition API, `<script setup>` | Options API legacy |
| **Nuxt** | 3.0 | Vue 3, server components | Nuxt 2 legacy |
| **Svelte** | 4.0 | Runes syntax (5) | Svelte 5 breaking |
| **SvelteKit** | 2.0 | Enhanced load functions | v1 format changes |
| **SolidJS** | 1.8 | Reactive primitives | Minor changes |

## Angular 20.0 (May 2025)

### Key Changes

**File Naming Convention:**
- **Old:** `user-profile.component.ts`
- **New:** `user-profile.ts`
- Applies to: components, directives, pipes, services

**Signals (Standard):**
```typescript
// Old (Legacy)
@Input() label: string = '';
@Output() click = new EventEmitter<void>();

// New (Signals)
readonly label = input.required<string>();
readonly click = output<void>();
```

**Requirements:**
- TypeScript 5.8+
- Node 20+

**Style Guide Updates:**
- Use `readonly` for properties initialized by Angular
- Use `protected` for template-only properties
- Simplified naming throughout

## Next.js 15.0 (2025)

### Key Features

**App Router (Default):**
- 80% of new projects use App Router
- React Server Components by default
- Partial Prerendering (stable)
- Server Actions for mutations

**Pages Router (Legacy):**
- Considered compatibility layer
- Still supported but not recommended for new projects

**Key Differences:**

| Feature | App Router | Pages Router |
|---------|------------|--------------|
| Server Components | ✅ Default | ❌ |
| Streaming | ✅ | Limited |
| Layouts | Nested | Manual |
| Data Fetching | async components | getServerSideProps |

## React Router v7.0 (2025)

### Three Modes

**1. Declarative Mode (Basic):**
```tsx
<BrowserRouter>
  <Routes>
    <Route path="/" element={<Home />} />
  </Routes>
</BrowserRouter>
```

**2. Data Mode (Loaders/Actions):**
```tsx
const router = createBrowserRouter([
  {
    path: "/",
    loader: loaderFn,
    Component: Home
  }
]);
```

**3. Framework Mode (Full Stack):**
- File-based routing (`app/routes/`)
- SSR with streaming
- Loaders and actions
- Vite plugin required

### Dependencies

**Framework Mode:**
```json
{
  "dependencies": {
    "react-router": "^7.0.0",
    "@react-router/node": "^7.0.0",
    "@react-router/dev": "^7.0.0"
  }
}
```

## Vue 3.4 / Nuxt 3.0

### Composition API (Standard)

```vue
<script setup lang="ts">
interface Props {
  label: string;
}

const props = defineProps<Props>();
const emit = defineEmits<{
  click: [];
}>();
</script>
```

### Key Features

- `<script setup>` is standard
- TypeScript support excellent
- Auto-imports in Nuxt
- Pinia for state management

## Svelte 4.0 / SvelteKit 2.0

### Key Features

**Runes (Svelte 5 preview):**
```svelte
<script>
let count = $state(0);
let doubled = $derived(count * 2);
</script>
```

**Standard (Svelte 4):**
```svelte
<script>
export let count = 0();
$: doubled = count * 2;
</script>
```

## SolidJS 1.8

### Reactive Primitives

```tsx
import { createSignal, createEffect } from 'solid-js';

const [count, setCount] = createSignal(0);

createEffect(() => {
  console.log(count());
});
```

## Version Detection Strategies

### Detect Angular Version

```bash
# Extract major version
ANGULAR_VERSION=$(grep '"@angular/core"' package.json | sed 's/.*"\^?\([0-9]*\).*/\1/')

# Check for signals support
if [ "$ANGULAR_VERSION" -ge 16 ]; then
  SIGNALS_SUPPORT="true"
fi

# Check for new naming (20+)
if [ "$ANGULAR_VERSION" -ge 20 ]; then
  NAMING_CONVENTION="simplified"
fi
```

### Detect Next.js Version

```bash
# Extract version
NEXT_VERSION=$(grep '"next"' package.json | sed 's/.*"\^?\([0-9]*\).*/\1/')

# Check for App Router default
if [ "$NEXT_VERSION" -ge 13 ]; then
  DEFAULT_ROUTER="app-router"
fi
```

### Detect React Router Version

```bash
# Check for framework mode
if has_dependency "@react-router/dev"; then
  ROUTER_MODE="framework"
elif has_dependency "react-router"; then
  ROUTER_VERSION=$(grep '"react-router"' package.json | sed 's/.*"\^?\([0-9]*\).*/\1/')
fi
```

## Migration Paths

### Angular 19 → 20

1. Update dependencies to v20
2. Update TypeScript to 5.8
3. Update Node to 20
4. Rename files (remove `.component` suffix)
5. Update class names (remove `Component` suffix)
6. Convert `@Input()` to `input()`
7. Convert `@Output()` to `output()`

### Next.js 14 → 15

1. Update dependencies to v15
2. Migrate Pages → App Router (if applicable)
3. Convert `getServerSideProps` to async components
4. Update data fetching patterns
5. Use Server Actions for mutations

### React Router v6 → v7

1. Update dependencies to v7
2. Choose mode (Declarative/Data/Framework)
3. For Framework Mode:
   - Install `@react-router/dev`
   - Set up Vite plugin
   - Move routes to `app/routes/`
   - Convert to loaders/actions

## Best Practices

1. **Always use latest major version** for new projects
2. **Check framework version** before generating code
3. **Use version-specific syntax** (signals vs decorators)
4. **Follow official style guides** for each framework
5. **Test on target framework version** before deployment
6. **Document version requirements** in project README
7. **Use semantic versioning** for compatibility checks

## Resources

- **Angular 20**: https://angular.dev
- **Next.js 15**: https://nextjs.org/docs
- **React Router v7**: https://reactrouter.com
- **Vue 3**: https://vuejs.org
- **SvelteKit**: https://kit.svelte.dev
- **SolidJS**: https://solidjs.com
