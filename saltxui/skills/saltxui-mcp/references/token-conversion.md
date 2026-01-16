# Component Markers and Implementation Strategy

## Markers Overview

Component markers in YAML determine how each component should be implemented:

| Marker | Symbol | Action | Registry Search | Code Generation |
|--------|--------|--------|-----------------|-----------------|
| **Custom** | `[COMP]` | Build from scratch | No | Yes, full Tailwind |
| **Styled** | `[STYL]` | Registry + Tailwind | Yes | Apply overrides |
| **Standard** | None | Use as-is | Yes | No |

## Marker Syntax

### Custom Component

```yaml
component: "LoginForm [COMP]"
```

**Characteristics:**
- Unique layout or composition
- Not available in any registry
- Requires custom implementation
- Full Tailwind styling from YAML

**Implementation:**
1. Read appropriate framework template
2. Convert YAML tokens to code structure
3. Apply all Tailwind classes
4. Handle children recursively
5. Create component file

**Example:**
```yaml
# Custom login form layout
component: "LoginForm [COMP]"
tailwindcss: ["flex", "flex-col", "gap-4", "p-6"]
children:
  - component: "Button [STYL]"
    content_text: "Submit"
  - component: "Input [STYL]"
```

### Styled Component

```yaml
component: "Button [STYL]"
```

**Characteristics:**
- Available in registry
- Needs custom Tailwind styling
- Registry component as base
- Additional Tailwind classes applied

**Implementation:**
1. Search registry for component
2. Install from registry
3. Apply Tailwind overrides from YAML
4. Use registry component with custom classes

**Example:**
```yaml
# Registry button with custom styling
component: "Button [STYL]"
tailwindcss:
  - "bg-blue-500"      # Override default
  - "text-white"       # Override default
  - "px-6"             # Custom padding
  - "py-3"             # Custom padding
  - "rounded-lg"       # Custom radius
```

### Standard Component

```yaml
component: "Input"
```

**Characteristics:**
- Available in registry
- Use exactly as provided
- No custom styling needed
- Direct registry usage

**Implementation:**
1. Search registry for component
2. Install from registry
3. Use without modifications

**Example:**
```yaml
# Standard input from registry
component: "Input"
# No tailwindcss array - use as-is
```

## Implementation Strategy

### Top-Down Processing

```
1. Start at root component (outermost [COMP])
2. For each child in hierarchy:
   a. Check marker type
   b. [COMP] → Build custom from template
   c. [STYL] or None → Search codebase first
   d. Not in codebase → Search registry
   e. Found in registry → Install and use
3. Recursively process children
```

### Decision Tree

```
Is component marked [COMP]?
├── YES → Build from scratch using template
└── NO → Search codebase for existing component
    ├── Found → Use existing component
    └── Not found → Search registry
        ├── Found → Install from registry
        │   └── [STYL]? → Apply Tailwind overrides
        └── Not found → Error: component not found
```

## Search Priority

### Codebase Search (For [STYL] or None)

1. **Check app components:**
   ```
   apps/{app}/components/{component-name}/
   ```

2. **Check shared packages:**
   ```
   packages/ui/components/{component-name}/
   ```

3. **Check aliases:**
   ```
   @/components/ui/{component-name}
   ```

### Registry Search (If not in codebase)

1. **Search default registry:**
   ```typescript
   mcp__SaltxUI-MCP__search_items_in_registries({
     components: [componentName]
   })
   ```

2. **View component details:**
   ```typescript
   mcp__SaltxUI-MCP__view_component({
     components: [{ componentName, registry }]
   })
   ```

3. **Install from registry:**
   ```typescript
   mcp__SaltxUI-MCP__add_items_from_registries({
     components: [{ componentName, registry }]
   })
   ```

## Implementation Examples

### Example 1: Simple Custom Component

```yaml
component: "Header [COMP]"
tailwindcss: ["flex", "items-center", "justify-between", "p-4", "bg-white"]
children:
  - component: "Logo [COMP]"
    content_text: "MyApp"
  - component: "Button [STYL]"
    content_text: "Login"
```

**Implementation:**
1. Build Header from template
2. Build Logo from template (child [COMP])
3. Search and install Button (child [STYL])
4. Apply Tailwind classes to all
5. Create Header.tsx with proper imports

### Example 2: Nested Components

```yaml
component: "Card [COMP]"
tailwindcss: ["bg-white", "rounded-lg", "p-6", "shadow"]
children:
  - component: "CardHeader [COMP]"
    children:
      - component: "Title [COMP]"
        content_text: "Welcome"
  - component: "CardBody [COMP]"
    children:
      - component: "Input [STYL]"
      - component: "Button [STYL]"
```

**Implementation:**
1. Build Card (root [COMP])
2. Build CardHeader (child [COMP])
3. Build Title (grandchild [COMP])
4. Build CardBody (child [COMP])
5. Install Input and Button (both [STYL])
6. Apply Tailwind at each level

### Example 3: Mixed Markers

```yaml
component: "Form [COMP]"
tailwindcss: ["flex", "flex-col", "gap-4"]
children:
  # Custom label
  - component: "FormLabel [COMP]"
    content_text: "Email:"
    tailwindcss: ["font-medium", "text-sm"]

  # Styled input
  - component: "Input [STYL]"
    tailwindcss: ["border-blue-500", "focus:ring-blue-500"]

  # Standard button
  - component: "Button"
```

**Implementation:**
1. Build Form from template
2. Build FormLabel from template
3. Install Input from registry + apply blue styling
4. Install Button from registry as-is

## Tailwind Override Strategy

### For [STYL] Components

When component has `[STYL]` marker:

1. **Install base component** from registry
2. **Apply YAML Tailwind classes** as overrides
3. **Preserve registry component structure**
4. **Add custom classes** via className prop

**Example (React):**
```tsx
// Registry component
import { Button } from '@repo/ui';

// With custom Tailwind from YAML
<Button className="bg-blue-500 text-white px-6 py-3 rounded-lg">
  Submit
</Button>
```

## Component Reference Tracking

### Tracking Installed Components

```typescript
interface ComponentReference {
  name: string;
  marker: 'COMP' | 'STYL' | null;
  source: 'custom' | 'codebase' | 'registry';
  registry?: string;
  path?: string;
  tailwindClasses: string[];
  children: ComponentReference[];
}
```

### Dependency Tree

```
LoginForm [COMP] (custom)
├── Header [COMP] (custom)
│   └── Logo [COMP] (custom)
├── Form [COMP] (custom)
│   ├── Input [STYL] (registry: shadcn/ui)
│   ├── Label [STYL] (registry: shadcn/ui)
│   └── Button [STYL] (registry: shadcn/ui)
└── Footer [COMP] (custom)
    └── Link [STYL] (registry: shadcn/ui)
```

## Best Practices

1. **Search codebase first** - Don't reinstall existing components
2. **Follow top-down order** - Process parents before children
3. **Respect markers** - `[COMP]` = build, `[STYL]` = modify, None = use
4. **Apply Tailwind correctly** - Use exact classes from YAML
5. **Handle arbitrary values** - Preserve `-[value]` syntax
6. **Maintain hierarchy** - Keep parent-child relationships
7. **Track dependencies** - Know where each component comes from
8. **Validate installation** - Verify registry components installed
9. **Cache results** - Avoid repeated searches
10. **Document custom components** - Clearly mark `[COMP]` items
