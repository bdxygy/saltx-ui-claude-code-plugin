# YAML Token Structure Reference

Complete specification of SaltxUI YAML token output from Figma.

## Root Structure

```yaml
component: string                    # Component name with optional marker
style: object                        # Native CSS properties (if is_use_style_css: true)
tailwindcss: array                   # Generated Tailwind classes
children: array                      # Nested components
content_text: string                 # Text content (for TEXT nodes)
```

## Component Field

The `component` field includes markers that determine implementation strategy:

### Marker Syntax

| Marker | Meaning | Implementation |
|--------|---------|----------------|
| `[COMP]` | Custom component | Build from scratch with full Tailwind |
| `[STYL]` | Registry + custom | Get from registry, apply Tailwind overrides |
| No marker | Standard component | Use from registry as-is |

### Examples

```yaml
# Build from scratch
component: "LoginForm [COMP]"

# Get from registry + custom Tailwind
component: "Button [STYL]"

# Use from registry as-is
component: "Input"
```

## Style Properties

Native CSS properties (when `is_use_style_css: true`):

```yaml
style:
  # Dimensions
  width: 403
  height: 50
  minWidth: 200
  maxWidth: 1200

  # Spacing
  padding: 16
  paddingLeft: 12
  paddingRight: 12
  paddingTop: 8
  paddingBottom: 8
  margin: 8
  gap: 16

  # Colors
  backgroundColor: "#ffffff"
  color: "#000000"
  borderColor: "#dee1e7"
  stroke: "#dee1e7"
  fill: "#ffffff"

  # Border
  borderRadius: 4
  borderWidth: 1
  borderLeftWidth: 2

  # Display
  display: flex
  flexDirection: row
  flexWrap: wrap

  # Alignment
  alignItems: center
  alignSelf: flex-start
  justifyContent: center
  justifyItems: center

  # Position
  position: relative
  top: 10
  left: 20

  # Other
  opacity: 0.5
  visibility: visible
  overflow: hidden
```

## Tailwind Classes

Generated Tailwind utility classes:

```yaml
tailwindcss:
  # Sizing
  - "w-[403px]"           # Width 403px (arbitrary value)
  - "h-[50px]"            # Height 50px
  - "min-w-[200px]"       # Min width
  - "max-w-[1200px]"      # Max width

  # Spacing
  - "p-4"                # Padding 16px
  - "px-3"               # Padding X 12px
  - "py-2"               # Padding Y 8px
  - "m-2"                # Margin 8px
  - "gap-4"              # Gap 16px

  # Colors
  - "bg-white"           # Background white
  - "bg-[#ffffff]"        # Background arbitrary color
  - "text-black"         # Text black
  - "border-gray-200"    # Border color
  - "border-[#dee1e7]"    # Border arbitrary color

  # Border
  - "rounded"            # Border radius 4px
  - "rounded-[4px]"       # Border radius arbitrary
  - "border"             # Border width 1px

  # Display
  - "flex"               # Display flex
  - "flex-row"           # Flex direction row
  - "flex-col"           # Flex direction column
  - "grid"               # Display grid
  - "block"              # Display block

  # Alignment
  - "items-center"       # Align items center
  - "items-start"        # Align items flex-start
  - "justify-center"     # Justify content center
  - "justify-between"    # Justify content space-between

  # Typography
  - "text-sm"            # Font size 14px
  - "text-base"          # Font size 16px
  - "font-medium"        # Font weight 500
  - "font-bold"          # Font weight 700

  # Other
  - "opacity-50"         # Opacity 50%
  - "hidden"             # Display none
  - "overflow-hidden"    # Overflow hidden
```

## Arbitrary Values

Arbitrary values use `-[value]` syntax:

```yaml
# Width
- "w-[403px]"           # 403 pixels
- "w-[50%]"             # 50 percent
- "w-[20rem]"           # 20 rem

# Height
- "h-[50px]"
- "h-[100vh]"

# Colors
- "bg-[#ffffff]"        # Hex color
- "bg-[rgb(255,0,0)]"   # RGB color
- "text-[rgba(0,0,0,0.5)]" # RGBA

# Spacing
- "p-[12px]"
- "gap-[8px]"

# Border radius
- "rounded-[12px]"
- "rounded-[50%]"       # Circle
```

## Children Array

Nested components:

```yaml
children:
  - component: "Button [STYL]"
    content_text: "Click me"
    tailwindcss: ["bg-blue-500", "text-white", "px-4", "py-2"]

  - component: "Input"
    tailwindcss: ["border", "rounded", "px-3", "py-2"]

  - component: "Label [COMP]"
    content_text: "Username:"
    tailwindcss: ["font-medium", "mb-2"]
    children: []
```

## Content Text

Text content for TEXT nodes:

```yaml
content_text: "Button label"
content_text: "Enter your email"
content_text: "Welcome!"
```

## Complete Example

```yaml
# LoginForm [COMP] - Build from scratch
component: "LoginForm [COMP]"
tailwindcss:
  - "flex"
  - "flex-col"
  - "gap-4"
  - "p-6"
  - "bg-white"
  - "rounded-lg"
  - "border"

children:
  # Button [STYL] - Get from registry + apply Tailwind
  - component: "Button [STYL]"
    content_text: "Submit"
    tailwindcss:
      - "bg-blue-500"
      - "text-white"
      - "px-4"
      - "py-2"
      - "rounded"

  # Input - Use from registry as-is
  - component: "Input"
    tailwindcss:
      - "border"
      - "rounded"
      - "px-3"
      - "py-2"
```

## Processing Strategy

### Top-Down Implementation

1. Start at outermost `[COMP]` component
2. Process children recursively
3. For each child:
   - `[COMP]` → Build custom
   - `[STYL]` → Get from registry + Tailwind
   - No marker → Get from registry

### Conversion Mapping

| Style Property | Tailwind Class |
|----------------|---------------|
| `display: flex` | `flex` |
| `flexDirection: column` | `flex-col` |
| `alignItems: center` | `items-center` |
| `justifyContent: center` | `justify-center` |
| `gap: 16` | `gap-4` |
| `padding: 16` | `p-4` |
| `backgroundColor: "#ffffff"` | `bg-white` |
| `borderRadius: 4` | `rounded` |

## File Location

YAML files are saved at:

```
.salt-ui/figma/{fileId}/{nodeId}.yaml
```

Example:
```
.salt-ui/figma/4zD0kyv2x9ao27VSridvya/772-27229.yaml
```

## Best Practices

1. **Use tailwindcss primary** - More reliable than style properties
2. **Check component markers** - Determines implementation strategy
3. **Process recursively** - Handle nested children properly
4. **Preserve hierarchy** - Maintain parent-child relationships
5. **Extract text content** - Use content_text for labels
6. **Handle arbitrary values** - Use `-[value]` syntax correctly
7. **Validate structure** - Ensure required fields present
8. **Cache YAML files** - Avoid re-processing same design
9. **Document custom components** - Mark `[COMP]` clearly
10. **Test conversions** - Verify Tailwind classes work correctly
