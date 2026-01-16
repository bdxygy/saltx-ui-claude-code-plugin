# Turborepo Import Paths

## Path Types

### Relative Imports

```tsx
// Same directory
import { Button } from './Button';

// Parent directory
import { Header } from '../Header';

// Nested directory
import { Icon } from './icons/Star';
```

### Absolute Imports (@/)

```tsx
// Configured in tsconfig.json paths
import { Button } from '@/components/Button';
import { utils } from '@/lib/utils';
```

### Workspace Imports (@repo/)

```tsx
// Import from shared packages
import { Button } from '@repo/ui/components';
import { formatDate } from '@repo/utils';
import { config } from '@repo/config';
```

## tsconfig.json Configuration

### App Level (apps/web/tsconfig.json)

```json
{
  "extends": "@repo/tsconfig/base.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@components/*": ["./src/components/*"],
      "@lib/*": ["./src/lib/*"]
    }
  },
  "references": [
    { "path": "../../packages/ui" },
    { "path": "../../packages/utils" }
  ]
}
```

### Package Level (packages/ui/tsconfig.json)

```json
{
  "extends": "@repo/tsconfig/base.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    },
    "composite": true,
    "declaration": true,
    "declarationMap": true
  }
}
```

### Root Level (tsconfig.json)

```json
{
  "files": [],
  "references": [
    { "path": "./apps/web" },
    { "path": "./apps/admin" },
    { "path": "./packages/ui" },
    { "path": "./packages/utils" }
  ]
}
```

## Common Import Patterns

### Importing Components

```tsx
// From shared package
import { Button, Input, Card } from '@repo/ui';

// From app-specific components
import { Header } from '@/components/Header';

// Relative import (same directory)
import { Button } from './Button';
```

### Importing Hooks

```tsx
// From shared package
import { useTheme, useAuth } from '@repo/ui/hooks';

// From app-specific hooks
import { useLocalStorage } from '@/hooks/useLocalStorage';
```

### Importing Utilities

```tsx
// From shared package
import { cn, formatDate } from '@repo/utils';

// From app-specific utilities
import { api } from '@/lib/api';
```

### Importing Types

```tsx
// From shared package
import type { ButtonProps } from '@repo/ui';

// From app-specific types
import type { User } from '@/types/user';
```

## Package Exports Configuration

### packages/ui/package.json

```json
{
  "name": "@repo/ui",
  "exports": {
    ".": "./src/index.ts",
    "./components/*": "./src/components/*",
    "./hooks": "./src/hooks/index.ts",
    "./utils": "./src/utils/index.ts"
  }
}
```

### packages/ui/src/index.ts

```typescript
// Barrel export for the package
export * from './components';
export * from './hooks';
export * from './utils';
```

## Resolving Imports

### TypeScript Resolution

TypeScript resolves imports in this order:
1. `paths` configuration in tsconfig.json
2. `baseUrl` relative to current file
3. `node_modules` (including workspace packages)

### Example Resolution

```tsx
import { Button } from '@repo/ui';

// Resolves to:
// 1. Check tsconfig.json paths for @repo/ui
// 2. Find packages/ui/package.json
// 3. Load packages/ui/src/index.ts
```

## Cross-Package Imports

### UI Package → Utils Package

```tsx
// packages/ui/src/components/Button.tsx
import { cn } from '@repo/utils';
```

### Config Package Usage

```tsx
// apps/web/eslint.config.js
const config = require('@repo/config/eslint');
```

## Module Resolution Issues

### Common Problems

**Problem:** Cannot find module '@repo/ui'

**Solution:** Ensure `@repo/ui` is in tsconfig.json `paths` and package is listed in `references`

**Problem:** Module not found during build

**Solution:** Ensure package is built before importing (use `composite: true`)

**Problem:** Different types between packages

**Solution:** Ensure consistent TypeScript version and tsconfig settings

## Best Practices

1. **Use workspace imports** for shared packages: `@repo/ui`
2. **Use absolute imports** for app code: `@/components`
3. **Use relative imports** for local files: `./Button`
4. **Configure paths** in tsconfig.json for all apps
5. **Export from index** in package root
6. **Use composite mode** for packages
7. **Build dependencies** first
8. **Keep paths consistent** across workspace
9. **Document import patterns** in team docs
10. **Test imports** after reorganization
