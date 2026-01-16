# SaltxUI MCP Tools Reference

Complete documentation of all SaltxUI MCP server tools.

## Tool 1: get_guide_examples

Get workflow examples and best practices for using the MCP tools.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `filter` | string | No | "all" | Filter by category |
| `figma_url` | string | No | - | Figma URL for context |
| `includeBestPractices` | boolean | No | true | Include best practices |
| `includeUsagePatterns` | boolean | No | true | Include usage patterns |

**Filter Options:**
- `"all"` - All examples
- `"landing-page"` - Landing page workflows
- `"dashboard"` - Dashboard workflows
- `"forms"` - Form component workflows
- `"ecommerce"` - E-commerce workflows
- `"multi-registry"` - Multiple registry workflows
- `"composition"` - Component composition workflows
- `"figma-to-code"` - Figma to code workflows

**Returns:**
```json
{
  "examples": [...],
  "bestPractices": [...],
  "usagePatterns": [...]
}
```

**Usage:**
```typescript
const result = await mcp__SaltxUI-MCP__get_guide_examples({
  filter: "figma-to-code",
  figma_url: "https://www.figma.com/design/xyz/...",
  includeBestPractices: true,
  includeUsagePatterns: true
});
```

---

## Tool 2: get_project_registries

Get project configuration and available registries.

**Parameters:** None

**Returns:**
```json
{
  "registries": [
    {
      "name": "shadcn/ui",
      "url": "https://ui.shadcn.com/r/styles/new-york/",
      "components": ["button", "input", "card", ...]
    }
  ],
  "framework": "react",
  "typescript": true,
  "componentPaths": {
    "components": "src/components/ui",
    "lib": "src/lib",
    "utils": "src/lib/utils"
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "lib": "@/lib",
    "ui": "@/components/ui"
  }
}
```

**Usage:**
```typescript
const config = await mcp__SaltxUI-MCP__get_project_registries();
console.log('Framework:', config.framework);
console.log('Registry:', config.registries[0].name);
```

---

## Tool 3: get_figma_context

Extract Figma design specifications and generate YAML.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `figma_file_id` | string | Yes | - | From Figma URL path |
| `node_id` | string | Yes | - | From Figma URL query (convert hyphens to colons) |
| `is_use_style_css` | boolean | No | false | Include native CSS properties |
| `is_use_tailwindcss` | boolean | No | true | Generate Tailwind classes |

**Figma URL Parsing:**
```
URL: https://www.figma.com/design/4zD0kyv2x9ao27VSridvya/Vibe?node-id=772-27229
     → figma_file_id: "4zD0kyv2x9ao27VSridvya"
     → node_id: "772:27229" (convert hyphens to colons)
```

**Returns:**
```json
{
  "yaml_file": ".salt-ui/figma/4zD0kyv2x9ao27VSridvya/772-27229.yaml",
  "raw_file": ".salt-ui/figma/4zD0kyv2x9ao27VSridvya/772-27229.raw"
}
```

**Usage:**
```typescript
const figmaData = await mcp__SaltxUI-MCP__get_figma_context({
  figma_file_id: "4zD0kyv2x9ao27VSridvya",
  node_id: "772:27229",
  is_use_tailwindcss: true,
  is_use_style_css: false
});

// Read the generated YAML
const yaml = fs.readFileSync(figmaData.yaml_file, 'utf8');
```

---

## Tool 4: search_items_in_registries

Find components in available registries.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `components` | string[] | No | - | Component names to search |
| `registries` | string[] | No | - | Registry names to search (default: all) |
| `type` | string | No | - | Filter by component type |
| `category` | string | No | - | Filter by Atomic Design category |
| `limit` | number | No | 100 | Max results |
| `verbose` | boolean | No | false | Include detailed info |
| `format` | string | No | "json" | "table" or "json" |

**Returns:**
```json
{
  "results": [
    {
      "name": "button",
      "registry": "shadcn/ui",
      "type": "ui",
      "category": "atoms",
      "path": "src/components/ui/button"
    }
  ]
}
```

**Usage:**
```typescript
const results = await mcp__SaltxUI-MCP__search_items_in_registries({
  components: ["button", "input"],
  limit: 10,
  verbose: true
});
```

---

## Tool 5: view_component

Inspect component code and implementation details.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `components` | array | Yes | - | Component names or component-registry pairs |
| `force` | boolean | No | false | Force refresh from registry |
| `verbose` | boolean | No | false | Enable verbose logging |
| `output` | string | No | ".salt-ui" | Output directory |
| `format` | string | No | "json" | "table" or "json" |
| `noCache` | boolean | No | false | Skip caching |
| `showSource` | boolean | No | true | Include source location |
| `showDependencies` | boolean | No | true | Include dependencies |

**Component Input Format:**
```json
{
  "components": [
    "button",
    { "componentName": "input", "registry": "shadcn/ui" }
  ]
}
```

**Returns:**
```json
{
  "results": [
    {
      "component": "button",
      "registry": "shadcn/ui",
      "cachePath": ".salt-ui/cache/shadcn/ui/button.mdx",
      "sourcePath": "src/components/ui/button"
    }
  ]
}
```

**Usage:**
```typescript
const viewResult = await mcp__SaltxUI-MCP__view_component({
  components: [
    { "componentName": "button", "registry": "shadcn/ui" }
  ],
  verbose: true
});

// Read the cached MDX file
const content = fs.readFileSync(viewResult.results[0].cachePath, 'utf8');
```

---

## Tool 6: add_items_from_registries

Install components from registries to project.

**Parameters:**
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `components` | array | Yes | - | Component names, component-registry pairs, or enhanced specs |
| `overwrite` | boolean | No | false | Overwrite existing files |
| `registry` | string | No | - | Default registry for all components |

**Component Input Format:**
```json
{
  "components": [
    "button",
    { "componentName": "input", "registry": "shadcn/ui" },
    {
      "componentName": "card",
      "registry": "shadcn/ui",
      "path": "src/components/custom",
      "type": "atoms"
    }
  ]
}
```

**Returns:**
```json
{
  "installed": [
    {
      "component": "button",
      "registry": "shadcn/ui",
      "path": "src/components/ui/button",
      "files": ["button.tsx", "button.test.tsx"]
    }
  ],
  "failed": []
}
```

**Usage:**
```typescript
const installResult = await mcp__SaltxUI-MCP__add_items_from_registries({
  components: [
    "button",
    "input",
    { "componentName": "card", "registry": "shadcn/ui" }
  ],
  overwrite: false
});

console.log('Installed:', installResult.installed.length);
console.log('Failed:', installResult.failed.length);
```

---

## Workflow Sequence

```
1. get_guide_examples (optional)
   ↓ Learn workflows and best practices

2. get_project_registries
   ↓ Understand project structure and registries

3. get_figma_context
   ↓ Extract Figma design to YAML

4. Read YAML file
   ↓ Parse component structure

5. search_items_in_registries
   ↓ Find matching components

6. view_component
   ↓ Inspect before installing

7. Read cache MDX files
   ↓ Understand implementation

8. add_items_from_registries
   ↓ FINAL: Install components
```

---

## Error Handling

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `figma-token missing` | Token not configured | Add to salt-ui.config.json |
| `Node not found` | Invalid node_id | Check Figma URL |
| `Rate limit exceeded` | Too many requests | Wait 60 seconds |
| `Component not found` | Invalid component name | Check registry |
| `Server not running` | MCP server down | Start MCP server |

### Error Response Format

```json
{
  "error": {
    "code": "FIGMA_TOKEN_MISSING",
    "message": "figma-token not found in salt-ui.config.json",
    "details": "Please add your Figma token to salt-ui.config.json"
  }
}
```

---

## Best Practices

1. **Call get_project_registries first** to understand project
2. **Parse Figma URL correctly** - convert hyphens to colons in node_id
3. **Search before viewing** - verify component exists
4. **View before installing** - understand dependencies
5. **Read cache files** - get full implementation details
6. **Handle errors gracefully** - provide helpful messages
7. **Use is_use_tailwindcss: true** - for Tailwind-only output
8. **Set is_use_style_css: false** - unless you need native CSS
9. **Check install results** - verify success/failure
10. **Cache results** - avoid repeated calls
