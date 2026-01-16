---
name: Turborepo Structure
description: Understand turborepo monorepo layout and conventions for proper file placement with apps/ and packages/ directories
version: 1.0.0
---

The Turborepo Structure skill provides comprehensive guidance on turborepo monorepo layout, conventions, and file placement patterns.

## When to Use This Skill

Activate this skill when:
- User asks about "turborepo structure"
- User needs "monorepo layout" guidance
- User asks about "apps packages" directories
- User mentions "turbo tasks" or task orchestration
- User asks about "turborepo conventions"
- Determining where to place components in turborepo
- Understanding import paths between apps and packages

## Standard Turborepo Layout

**Root Structure:**
```
turborepo-project/
├── apps/                    # Application packages
│   ├── web/                # Main web app
│   ├── admin/              # Admin dashboard
│   ├── mobile/             # Mobile app
│   └── storybook/          # Storybook app
├── packages/               # Shared packages
│   ├── ui/                 # Shared UI components
│   ├── config/             # Shared config (ESLint, TypeScript)
│   ├── tsconfig/           # Shared TypeScript configs
│   └── utils/              # Shared utilities
├── turbo.json              # Turborepo configuration
├── package.json            # Root package.json
└── pnpm-workspace.yaml     # Workspace config
```

## Where to Place Components

### Apps Directory

**Application-specific components** go in `apps/`:
- `apps/web/components/` - Web app only
- `apps/admin/components/` - Admin app only
- `apps/mobile/components/` - Mobile app only

**Storybook stories** go in storybook app:
- `apps/storybook/stories/` - Story stories and docs

### Packages Directory

**Shared components** go in `packages/`:
- `packages/ui/components/` - Reusable across apps
- `packages/ui/hooks/` - Shared hooks
- `packages/ui/utils/` - Shared utilities

**Decision Tree:**
```
Is component used by multiple apps?
  YES → packages/ui/components/
  NO → apps/{app-name}/components/
```

## Import Paths Between Apps and Packages

**Package Import (internal):**
```tsx
// In apps/web/components/Button.tsx
import { Icon } from '@repo/ui/icons';
import { useTheme } from '@repo/ui/hooks';
```

**App Import (cross-app):**
```tsx
// In apps/admin/components/Header.tsx
import { Button } from '../../web/components/Button';
// Not recommended - use packages instead
```

**Workspace Naming:**
```json
// package.json in packages/ui
{
  "name": "@repo/ui"
}
```

**Path Mapping:**
```json
// tsconfig.json
{
  "compilerOptions": {
    "paths": {
      "@repo/ui": ["../../packages/ui/src"],
      "@repo/ui/*": ["../../packages/ui/src/*"]
    }
  }
}
```

## Build and Task Orchestration with turbo.json

**Task Pipeline:**
```json
// turbo.json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**"]
    },
    "lint": {
      "outputs": []
    },
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

**Task Dependencies:**
```json
"build": {
  "dependsOn": ["^build"]  // Build packages before apps
}
```

**Outputs for Caching:**
```json
"outputs": [".next/**", "dist/**"]
```

**Run Specific Task:**
```bash
# Run in all apps/packages
turbo run build

# Run in specific app
turbo run build --filter=web

# Run in app and dependencies
turbo run build --filter=web...  # web + its dependencies
```

## Shared Packages Pattern

**UI Package Structure:**
```
packages/ui/
├── src/
│   ├── components/       # Shared components
│   ├── hooks/            # Shared hooks
│   ├── utils/            # Shared utilities
│   └── index.ts          # Barrel export
├── package.json
└── tsconfig.json
```

**Package Exports:**
```typescript
// packages/ui/src/index.ts
export * from './components';
export * from './hooks';
export * from './utils';
```

**Using Shared Package:**
```tsx
// apps/web/components/Button.tsx
import { Card, Input } from '@repo/ui';
```

## Workspace Configuration

**pnpm-workspace.yaml:**
```yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

**Root package.json:**
```json
{
  "name": "turbo-repo",
  "private": true,
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev",
    "lint": "turbo run lint",
    "test": "turbo run test"
  },
  "devDependencies": {
    "turbo": "latest"
  }
}
```

## Detecting Current App

**From Working Directory:**
```bash
# If in apps/web/components/
CURRENT_APP="web"
```

**From package.json:**
```json
// apps/web/package.json
{
  "name": "web"
}
```

**Validation:**
```bash
# Check if app exists
if [ -d "apps/$APP_NAME" ]; then
  echo "App exists"
else
  echo "App not found"
fi
```

## Component Placement Rules

**Page Components:**
- Place in `apps/{app}/components/` if app-specific
- Place in `packages/ui/components/` if shared

**Route Components:**
- Next.js: `apps/{app}/app/components/[name]/page.tsx`
- Remix: `apps/{app}/routes/components.[name].tsx`
- React Router: `apps/{app}/app/routes/components.[name].tsx`

**Storybook Stories:**
- Place in `apps/storybook/stories/components/`
- Reference component from its location

## File Path Patterns

**Component Files:**
```
apps/web/components/button/
├── Button.tsx
├── Button.test.tsx
├── index.ts
└── stories/
    └── Button.stories.tsx
```

**Import Pattern:**
```tsx
// Absolute import
import { Button } from '@/components/button';

// Relative import
import { Button } from './components/button';
```

**tsconfig Paths:**
```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@repo/ui": ["../packages/ui/src"]
    }
  }
}
```

## Turbo Task Patterns

**Cache Control:**
```json
{
  "pipeline": {
    "build": {
      "outputs": ["dist/**", ".next/**"]
    },
    "test": {
      "outputs": ["coverage/**"],
      "dependsOn": ["build"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

**Filter Tasks:**
```bash
# Run in changed apps
turbo run build --filter=[HEAD^1]

# Run for specific app
turbo run build --filter=web

# Run with dependencies
turbo run build --filter=web...

# Run dependent apps
turbo run test --filter=...web
```

## Best Practices

1. **App-specific code** in `apps/`
2. **Shared code** in `packages/`
3. **Use workspace names** like `@repo/ui`
4. **Configure path mapping** in tsconfig.json
5. **Use turbo filters** for targeted tasks
6. **Define outputs** for effective caching
7. **Keep dependencies** explicit in turbo.json
8. **Use `^dependsOn`** for task pipelines
9. **Version shared packages** independently
10. **Document import patterns** in README

## Common Patterns

**Monorepo Package:**
```json
// packages/ui/package.json
{
  "name": "@repo/ui",
  "version": "1.0.0",
  "main": "./src/index.ts",
  "exports": {
    ".": "./src/index.ts",
    "./components": "./src/components/index.ts"
  }
}
```

**App Reference:**
```json
// apps/web/package.json
{
  "name": "web",
  "dependencies": {
    "@repo/ui": "*"
  }
}
```

## References

- **Standard Layout**: See `references/standard-layout.md`
- **Import Paths**: See `references/import-paths.md`
- **Task Orchestration**: See `references/task-orchestration.md`
- **Example Configs**: See `examples/` directory

## Examples

- `examples/turbo.json.example` - Complete turbo.json
- `examples/package-json.example` - Package structure
