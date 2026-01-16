# Turborepo Standard Layout

## Directory Structure

```
turborepo-project/
├── apps/                    # Application packages
│   ├── web/                # Main web application
│   ├── admin/              # Admin dashboard
│   ├── mobile/             # Mobile application
│   └── storybook/          # Storybook application
├── packages/               # Shared packages
│   ├── ui/                 # Shared UI components
│   ├── config/             # Shared configuration (ESLint, TypeScript)
│   ├── tsconfig/           # Shared TypeScript configs
│   └── utils/              # Shared utilities
├── turbo.json              # Turborepo configuration
├── package.json            # Root package.json
└── pnpm-workspace.yaml     # pnpm workspace configuration
```

## Apps Directory

Application packages are deployed independently and contain app-specific code.

### Example: apps/web

```
apps/web/
├── public/                 # Static assets
├── src/
│   ├── app/               # Next.js App Router
│   ├── components/        # App-specific components
│   └── lib/               # App-specific utilities
├── package.json
├── tsconfig.json
└── next.config.js
```

**Package naming:**
- Use simple names: `web`, `admin`, `mobile`
- No scope prefix for apps

## Packages Directory

Shared packages contain reusable code used by multiple apps.

### Example: packages/ui

```
packages/ui/
├── src/
│   ├── components/        # Shared UI components
│   │   ├── button/
│   │   ├── input/
│   │   └── card/
│   ├── hooks/             # Shared hooks
│   ├── utils/             # Shared utilities
│   └── index.ts           # Barrel export
├── package.json
└── tsconfig.json
```

**Package naming:**
- Use scope prefix: `@repo/ui`
- Define in package.json: `"name": "@repo/ui"`

## Root Configuration Files

### turbo.json

```json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**"]
    },
    "lint": {
      "outputs": []
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

### package.json (Root)

```json
{
  "name": "turbo-repo",
  "version": "0.0.0",
  "private": true,
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev",
    "lint": "turbo run lint",
    "test": "turbo run test",
    "clean": "turbo run clean"
  },
  "devDependencies": {
    "turbo": "latest"
  },
  "workspaces": [
    "apps/*",
    "packages/*"
  ]
}
```

### pnpm-workspace.yaml

```yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

### tsconfig.json (Root)

```json
{
  "files": [],
  "references": [
    { "path": "./apps/web" },
    { "path": "./apps/admin" },
    { "path": "./packages/ui" }
  ]
}
```

## Package.json Patterns

### App Package (apps/web)

```json
{
  "name": "web",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "latest",
    "react": "latest",
    "react-dom": "latest",
    "@repo/ui": "*"
  },
  "devDependencies": {
    "@repo/tsconfig": "*",
    "typescript": "latest"
  }
}
```

### Shared Package (packages/ui)

```json
{
  "name": "@repo/ui",
  "version": "0.1.0",
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "exports": {
    ".": "./src/index.ts",
    "./components/*": "./src/components/*",
    "./hooks": "./src/hooks/index.ts",
    "./utils": "./src/utils/index.ts"
  },
  "scripts": {
    "lint": "eslint src",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "react": "latest",
    "tailwindcss": "latest"
  },
  "devDependencies": {
    "@repo/tsconfig": "*",
    "typescript": "latest"
  }
}
```

### Config Package (packages/config)

```json
{
  "name": "@repo/config",
  "version": "0.1.0",
  "main": "./index.js",
  "dependencies": {
    "eslint": "latest",
    "typescript": "latest",
    "@typescript-eslint/eslint-plugin": "latest",
    "@typescript-eslint/parser": "latest"
  }
}
```

## Workspace Dependencies

### Internal Dependencies

Apps and packages can depend on other workspace packages:

```json
{
  "dependencies": {
    "@repo/ui": "*",
    "@repo/utils": "*",
    "@repo/config": "*"
  }
}
```

The `*` version tells pnpm to use the workspace version.

### External Dependencies

Always specify versions for external packages:

```json
{
  "dependencies": {
    "react": "^18.2.0",
    "next": "^14.0.0"
  }
}
```

## File Placement Rules

### App-Specific Code

Place in `apps/{app-name}/`:
- Page components
- App-specific business logic
- App-specific styling
- App configurations

### Shared Code

Place in `packages/{package-name}/`:
- Reusable UI components
- Shared utilities
- Shared hooks
- Shared types
- Configuration packages

### Decision Tree

```
Is code used by multiple apps?
├── YES → packages/{category}/
└── NO → apps/{app-name}/
```

## Import Patterns

### Within App

```tsx
// Relative import
import { Button } from './components/Button';
import { utils } from '../lib/utils';

// Absolute import (if configured)
import { Button } from '@/components/Button';
```

### From App to Package

```tsx
// Import from shared package
import { Button } from '@repo/ui/components';
import { formatDate } from '@repo/utils';
```

### Between Packages

```tsx
// UI package importing utils
import { cn } from '@repo/utils';
```

## Path Mapping

### tsconfig.json (apps/web)

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@repo/ui": ["../../packages/ui/src"],
      "@repo/ui/*": ["../../packages/ui/src/*"],
      "@repo/utils": ["../../packages/utils/src"]
    }
  }
}
```

## Best Practices

1. **Use workspace scope** for packages: `@repo/*`
2. **Keep apps independent**: Each app should be deployable separately
3. **Share via packages**: Use packages/ for truly shared code
4. **Version packages together**: Use `*` for workspace dependencies
5. **Configure turbo.json**: Define task dependencies and outputs
6. **Use workspaces**: Configure in pnpm-workspace.yaml or package.json
7. **Reference packages**: Use TypeScript project references
8. **Separate concerns**: Apps = deployable, Packages = reusable
9. **Document dependencies**: Clearly document inter-package dependencies
10. **Test boundaries**: Test packages independently from apps
