---
name: SaltxUI MCP & YAML Processing
description: Understand how to use SaltxUI MCP tools and process its YAML token output with component markers and top-down implementation strategy
version: 1.0.0
---

The SaltxUI MCP & YAML Processing skill provides comprehensive guidance on using SaltxUI MCP server tools and processing its YAML token output for component generation.

## When to Use This Skill

Activate this skill when:
- User asks about "saltxui mcp" or "saltx ui tools"
- User needs to understand "yaml tokens"
- User mentions "parse yaml tokens" or "token conversion"
- User asks about "figma to code" workflow
- Working with SaltxUI MCP tool responses
- Processing YAML output from Figma designs
- Understanding component markers ([COMP], [STYL])

## SaltxUI MCP Tools

### Tool 1: get_guide_examples

**Purpose**: Get workflow examples and best practices

**Parameters:**
- `filter` (optional): "all", "landing-page", "dashboard", "forms", "ecommerce", "multi-registry", "composition", "figma-to-code"
- `figma_url` (optional): Figma design URL for context
- `includeBestPractices` (optional, default: true): Include workflow tips
- `includeUsagePatterns` (optional, default: true): Include usage patterns

**Returns**: Guide examples, best practices, workflow tips

**Usage**: Start here to understand available workflows

### Tool 2: get_project_registries

**Purpose**: Get project configuration and registries

**Parameters**: None

**Returns**:
- Registry names and URLs
- Framework setting
- TypeScript flag
- Component paths
- Aliases

**Usage**: Call first to understand project structure

**Example Response:**
```json
{
  "registries": ["shadcn/ui"],
  "framework": "react",
  "typescript": true,
  "componentPaths": ["src/components/ui"],
  "aliases": { "@": "./src" }
}
```

### Tool 3: get_figma_context

**Purpose**: Extract Figma design specifications and generate YAML

**Parameters:**
- `figma_file_id`: From Figma URL (e.g., "4zD0kyv2x9ao27VSridvya")
- `node_id`: From Figma URL query param (e.g., "772:27229" - convert hyphens to colons)
- `is_use_style_css` (optional, default: false): Include native CSS properties
- `is_use_tailwindcss` (optional, default: true): Generate Tailwind classes

**Returns**:
- `yaml_file`: Path to generated YAML (`.salt-ui/figma/{fileId}/{nodeId}.yaml`)
- `raw_file`: Path to raw data

**Usage**: Call after get_project_registries to extract design

**Figma URL Parsing:**
```
URL: https://www.figma.com/design/4zD0kyv2x9ao27VSridvya/Vibe?node-id=772-27229
     → figma_file_id: "4zD0kyv2x9ao27VSridvya"
     → node_id: "772:27229" (convert 772-27229 → 772:27229)
```

### Tool 4: search_items_in_registries

**Purpose**: Find components in registries

**Parameters:**
- `components` (optional): Array of component names to search
- `registries` (optional): Array of registry names to search
- `type` (optional): Filter by component type
- `category` (optional): Filter by Atomic Design category
- `limit` (optional, default: 100): Max results
- `verbose` (optional, default: false): Include detailed info
- `format` (optional, default: "json"): "table" or "json"

**Returns**: List of matching components

**Usage**: Search before installing to find matching components

### Tool 5: view_component

**Purpose**: Inspect component code and implementation details

**Parameters:**
- `components`: Array of component names or component-registry pairs
- `force` (optional, default: false): Force refresh from registry
- `verbose` (optional, default: false): Enable verbose logging
- `output` (optional): Output directory (default: ".salt-ui")
- `format` (optional, default: "json"): "table" or "json"
- `noCache` (optional, default: false): Skip caching
- `showSource` (optional, default: true): Include source location
- `showDependencies` (optional, default: true): Include dependencies

**Returns**: Cache file paths and access instructions

**Usage**: View component before installing to understand dependencies

**Example:**
```json
{
  "component": "button",
  "registry": "shadcn/ui",
  "cachePath": ".salt-ui/cache/shadcn/ui/button.mdx",
  "sourcePath": "src/components/ui/button"
}
```

### Tool 6: add_items_from_registries

**Purpose**: Install components from registries

**Parameters:**
- `components`: Array of component names, component-registry pairs, or enhanced specifications
- `overwrite` (optional, default: false): Overwrite existing files
- `registry` (optional): Default registry for all components

**Returns**: Installation results

**Usage**: Final step - install components to project

**Example:**
```json
{
  "components": [
    "button",
    {"componentName": "input", "registry": "shadcn/ui"}
  ]
}
```

## Workflow Sequence

```
1. get_guide_examples (optional) → Learn workflows
2. get_project_registries → Understand project structure
3. get_figma_context → Extract Figma design
4. Read YAML file → Parse component structure
5. search_items_in_registries → Find matching components
6. view_component → Inspect before installing
7. Read cache MDX files → Understand implementation
8. add_items_from_registries → FINAL: Install components
```

## YAML Token Structure

**Component Entry:**
```yaml
component: string                    # "ComponentName [COMP]" | [STYL] | no marker
style:                               # Native CSS properties
  backgroundColor: string            # "#ffffff"
  fill: string                       # Alias for backgroundColor
  width: number                      # Pixels: 403
  height: number                     # Pixels: 50
  borderRadius: number               # Pixels: 4
  borderWidth: number                # Pixels: 1
  borderColor: string                # "#dee1e7"
  stroke: string                     # Alias for borderColor
  display: string                    # "flex", "block", "grid"
  flexDirection: string              # "row", "column"
  alignItems: string                 # "center", "flex-start", "flex-end"
  justifyContent: string             # "center", "space-between"
  gap: number                        # Pixels: 16
  padding/paddingLeft/...: number    # Pixels
  visibility: string                 # "visible", "hidden"
tailwindcss:                         # Generated Tailwind utility classes
  - "w-[403px]"                      # Width with unit
  - "h-[50px]"                       # Height with unit
  - "rounded-[4px]"                  # Border-radius with unit
  - "flex"                           # Display
  - "flex-col"                       # Flex-direction
  - "items-center"                   # Align-items
  - "bg-[#ffffff]"                   # Background color
children:                            # Nested components
  - component: string                # Child component name
    content_text: string            # Text content (for TEXT nodes)
    ...                              # Recursively same structure
```

## Component Markers

| Marker | Meaning | Action |
|--------|---------|--------|
| `[COMP]` | Custom component | Build from scratch with full Tailwind |
| `[STYL]` | Registry + custom | Get from registry, apply Tailwind overrides |
| No marker | Standard component | Use from registry as-is |

**Example:**
```yaml
# Custom layout - build from scratch
component: "LoginForm [COMP]"
tailwindcss: ["flex", "flex-col", "gap-4"]
children:
  # Registry button with custom Tailwind
  - component: "Button [STYL]"
    tailwindcss: ["bg-blue-500", "text-white"]
  # Standard input - use as-is
  - component: "Input"
```

## Implementation Strategy (Top-Down)

**Step 1: Start at outermost component**
- Find root component with `[COMP]` marker
- This is your custom layout to build

**Step 2: Process children recursively**
- For each child in the hierarchy:
  - Check for `[COMP]` marker → Build custom
  - No `[COMP]` marker → Search codebase first
  - Not in codebase → Search registry
  - Found in registry → Install and use

**Step 3: Only build [COMP] components**
- Never build components without `[COMP]` marker
- Always use registry for non-marked components

**Example Workflow:**
```
LoginForm [COMP] → Build custom
  ├─ Button [STYL] → Get from registry + apply Tailwind
  ├─ Input [STYL] → Get from registry + apply Tailwind
  └─ Label [STYL] → Get from registry + apply Tailwind
```

## Extracting Props, Styles, Children

**Props:**
- Extract from component variant specifications
- Map YAML values to component props
- Handle default values from YAML

**Styles:**
- Primary: Use `tailwindcss` array
- Fallback: Map `style` properties to Tailwind

**Children:**
- Parse `children` array recursively
- Handle `content_text` for TEXT nodes
- Maintain component hierarchy

## Style to Tailwind Mapping

```yaml
# Display
display: flex              → "flex"
flexDirection: column      → "flex-col"
flexDirection: row         → "flex-row"

# Alignment
alignItems: center         → "items-center"
alignItems: flex-start     → "items-start"
justifyContent: center     → "justify-center"
justifyContent: space-between → "justify-between"

# Sizing
width: 403                 → "w-[403px]"
height: 50                → "h-[50px]"
maxWidth: 1200            → "max-w-[1200px]"

# Spacing
padding: 16               → "p-4" or "p-[16px]"
paddingLeft: 16           → "pl-4" or "pl-[16px]"
gap: 16                   → "gap-4" or "gap-[16px]"
margin: 8                 → "m-2" or "m-[8px]"

# Colors
backgroundColor: "#ffffff" → "bg-white" or "bg-[#ffffff]"
color: "#000000"          → "text-black" or "text-[#000000]"
borderColor: "#dee1e7"    → "border-gray-200" or "border-[#dee1e7]"

# Border
borderRadius: 4           → "rounded" or "rounded-[4px]"
borderWidth: 1            → "border"
```

## Error Handling for MCP Calls

**Common Errors:**
1. **figma-token missing or invalid** → Configure in salt-ui.config.json
2. **Node not found** → Verify figma_file_id and node_id from URL
3. **Rate limit** → Wait 60 seconds before retrying
4. **MCP server not running** → Start SaltxUI MCP server

**Handling:**
```typescript
try {
  const result = await mcp__SaltxUI-MCP__get_figma_context({
    figma_file_id,
    node_id
  });
} catch (error) {
  if (error.message.includes('figma-token')) {
    return 'Please configure figma-token in salt-ui.config.json';
  }
  if (error.message.includes('Node not found')) {
    return 'Invalid Figma URL. Check file_id and node_id.';
  }
}
```

## YAML File Location

**Generated Path:**
```
.salt-ui/figma/{fileId}/{nodeId}.yaml
Example: .salt-ui/figma/4zD0kyv2x9ao27VSridvya/772-27229.yaml
```

**Reading YAML:**
```typescript
import { readFileSync } from 'fs';
import yaml from 'js-yaml';

const yamlPath = '.salt-ui/figma/4zD0kyv2x9ao27VSridvya/772-27229.yaml';
const yamlContent = readFileSync(yamlPath, 'utf8');
const data = yaml.load(yamlContent);
```

## Cache MDX Files

**After view_component:**
- Files cached at `.salt-ui/cache/{registry}/{component}.mdx`
- Read these files to understand implementation
- Check dependencies and imports

**Reading Cache:**
```typescript
const cachePath = '.salt-ui/cache/shadcn/ui/button.mdx';
const content = readFileSync(cachePath, 'utf8');
```

## Best Practices

1. **Follow workflow sequence**: get_guide → get_project → get_figma → search → view → add
2. **Parse Figma URL correctly**: Convert hyphens to colons in node_id
3. **Respect component markers**: [COMP] = build, [STYL] = registry + style, none = registry
4. **Implement top-down**: Start at outermost [COMP] component
5. **Search codebase first**: Before checking registry
6. **View before install**: Use view_component to understand dependencies
7. **Read cache files**: Understand implementation before using
8. **Handle errors gracefully**: Provide helpful error messages
9. **Use Tailwind primary**: Extract from tailwindcss array
10. **Maintain hierarchy**: Process children recursively

## References

- **MCP Tools**: See `references/mcp-tools.md`
- **YAML Structure**: See `references/yaml-structure.md`
- **Token Conversion**: See `references/token-conversion.md`
- **Example YAML**: See `examples/yaml-output.example.yaml`

## Examples

- `examples/yaml-output.example.yaml` - Complete YAML structure
