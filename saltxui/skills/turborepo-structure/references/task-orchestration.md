# Turborepo Task Orchestration

## Pipeline Configuration

### Basic Pipeline

```json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "outputs": []
    }
  }
}
```

### Pipeline Properties

| Property | Type | Description |
|----------|------|-------------|
| `dependsOn` | string[] | Tasks that must run first |
| `outputs` | string[] | Files to cache for this task |
| `cache` | boolean | Enable/disable caching |
| `persistent` | boolean | Task runs indefinitely (dev servers) |
| `inputs` | string[] | Files that affect task output |

## Dependency Management

### dependsOn Patterns

```json
{
  "pipeline": {
    // Build packages before apps
    "build": {
      "dependsOn": ["^build"]
    },

    // Test after build
    "test": {
      "dependsOn": ["build"]
    },

    // Lint has no dependencies
    "lint": {
      "dependsOn": []
    },

    // Dev depends on nothing, runs parallel
    "dev": {
      "dependsOn": []
    }
  }
}
```

### Dependency Syntax

| Syntax | Meaning |
|--------|---------|
| `"^build"` | Run build in all dependencies first |
| `["build"]` | Run build in this package |
| `["^build", "build"]` | Run build in deps, then this package |

## Output Caching

### Output Patterns

```json
{
  "pipeline": {
    "build": {
      "outputs": [
        ".next/**",
        "!.next/cache/**",
        "dist/**"
      ]
    }
  }
}
```

### Output Glob Patterns

| Pattern | Description |
|---------|-------------|
| `dist/**` | All files in dist |
| `.next/**` | All Next.js build files |
| `!.next/cache/**` | Exclude cache directory |
| `*.js` | All .js files at root |

### Cache Behavior

```json
{
  "pipeline": {
    "build": {
      "outputs": ["dist/**"],
      "cache": true  // default
    },
    "dev": {
      "cache": false  // never cache dev
    }
  }
}
```

## Task Inputs

### Input Patterns

```json
{
  "pipeline": {
    "build": {
      "inputs": [
        "src/**/*.tsx",
        "src/**/*.ts",
        "package.json"
      ]
    },
    "lint": {
      "inputs": [
        "**/*.tsx",
        "**/*.ts",
        "**/*.jsx",
        "**/*.js"
      ]
    }
  }
}
```

### Default Inputs

If not specified, Turbo defaults to:
- All files in the package
- Including `package.json`

### Custom Inputs

```json
{
  "pipeline": {
    "test": {
      "inputs": [
        "src/**/*.tsx",
        "src/**/*.ts",
        "__tests__/**/*.ts"
      ]
    }
  }
}
```

## Environment Variables

### Per-Task Environment

```json
{
  "pipeline": {
    "build": {
      "env": ["NODE_ENV", "API_URL"]
    }
  }
}
```

### Environment Mode

```json
{
  "pipeline": {
    "build": {
      "envMode": "loose"  // 'strict' | 'loose'
    }
  }
}
```

## Task Filtering

### Filter Syntax

```bash
# Run in specific package
turbo run build --filter=web

# Run in package and dependencies
turbo run build --filter=web...

# Run in dependent packages
turbo run test --filter=...web

# Run in changed packages
turbo run build --filter=[HEAD^1]

# Run by pattern
turbo run build --filter=./apps/*
```

### Filter Examples

```bash
# Build only web app
turbo run build --filter=web

# Build UI package and all dependents
turbo run build --filter=...@repo/ui

# Test all changed packages
turbo run test --filter=[HEAD^1]

# Lint all apps
turbo run lint --filter=./apps/*

# Build everything except storybook
turbo run build --filter=!storybook
```

## Common Task Configurations

### Next.js Build

```json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**"],
      "inputs": ["src/**/*.tsx", "src/**/*.ts", "public/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "outputs": []
    }
  }
}
```

### React/Vite Build

```json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    }
  }
}
```

### Package Build

```json
{
  "pipeline": {
    "build": {
      "outputs": ["dist/**", "src/**/*.ts", "src/**/*.d.ts"],
      "dependsOn": []
    }
  }
}
```

### Test Task

```json
{
  "pipeline": {
    "test": {
      "dependsOn": ["build"],
      "outputs": ["coverage/**"],
      "inputs": ["src/**/*.ts", "__tests__/**/*.ts"]
    }
  }
}
```

### Lint Task

```json
{
  "pipeline": {
    "lint": {
      "outputs": [],
      "inputs": ["**/*.ts", "**/*.tsx"]
    }
  }
}
```

## Advanced Patterns

### Monorepo with Multiple Frameworks

```json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [
        ".next/**",
        "dist/**",
        "!.next/cache/**"
      ]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

### Task Composition

```json
{
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "deploy": {
      "dependsOn": ["build"],
      "cache": false
    }
  }
}
```

### CI/CD Integration

```json
{
  "pipeline": {
    "ci": {
      "dependsOn": ["build", "test", "lint"],
      "outputs": []
    }
  }
}
```

## Best Practices

1. **Always specify outputs** for effective caching
2. **Use dependsOn** for task dependencies
3. **Set cache: false** for dev servers
4. **Use persistent: true** for long-running tasks
5. **Filter tasks** for faster builds
6. **Specify inputs** for fine-grained caching
7. **Cache by environment variables** when needed
8. **Use strict mode** for production
9. **Monitor cache hit rates**
10. **Clean cache** when tasks misbehave
