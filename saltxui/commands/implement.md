---
name: implement
description: Orchestrate complete UI implementation workflow from Figma URL using SaltxUI MCP server
argument-hint: <figma-url> [--name <component-name>] [--app <app-name>] [--framework <framework>]
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - mcp__SaltxUI-MCP__*
  - AskUserQuestion
---

You are the `/implement` command that orchestrates the complete end-to-end workflow of implementing UI designs from Figma URLs.

## Trigger

This command runs when the user executes:
```
/implement <figma-url> [--name <component-name>] [--app <app-name>] [--framework <framework>]
```

## Input Arguments

Parse the user's command input:

1. **figma-url** (required, first positional argument):
   - Full Figma design URL
   - Format: `https://www.figma.com/design/{fileId}/{name}?node-id={nodeId}`
   - Extract `figma_file_id` and `node_id` from URL

2. **--name** (optional):
   - Override component name (kebab-case)
   - If not provided, derive from Figma frame name

3. **--app** (optional):
   - Target app in turborepo (e.g., "web", "admin")
   - If not provided, detect from current working directory

4. **--framework** (optional):
   - Override framework detection
   - Options: reactjs, next, remix, react-router-v7, vue, nuxt, svelte, sveltekit, angular, solidjs

## Workflow Steps

### Step 1: Parse Figma URL and Extract Parameters

Extract from Figma URL:
- `figma_file_id`: The file identifier from URL path
- `node_id`: The node identifier from query parameter (convert hyphens to colons for API)

Example:
```
Input: https://www.figma.com/design/4zD0kyv2x9ao27VSridvya/Vibe?node-id=772-27229
Output: figma_file_id=4zD0kyv2x9ao27VSridvya, node_id=772:27229
```

### Step 2: Detect Project Structure and Framework

First, verify this is a Turborepo project:

1. Check for Turborepo indicators:
   - `apps/` directory exists
   - `turbo.json` exists
   - `pnpm-workspace.yaml` or `package.json` with `workspaces` field

2. If NOT a Turborepo project:
   - Use `AskUserQuestion` to prompt the user:
   
   ```
   Question: This project does not appear to be a Turborepo project.
   
   Options:
   - "Continue with current structure" - Create components using existing project structure
   - "Migrate to Turborepo first" - Set up Turborepo structure before implementing
   ```
   
   - If user chooses "Migrate to Turborepo first":
     - Stop implementation
     - Provide guidance on Turborepo migration
     - Suggest running `/implement` again after migration
   
   - If user chooses "Continue with current structure":
     - Proceed with existing directory structure
     - Place components in appropriate locations based on framework

3. If `--app` not provided:
   - Detect from current working directory
   - Look for `apps/` subdirectory (Turborepo) or `src/` (monorepo)
   - Check package.json location
   - Default to first app in `apps/` if ambiguous

4. If `--framework` not provided:
   - Run framework detection script: `/Users/budisantoso/.claude/plugins/cache/claude-plugins-official/plugin-dev/f70b65538da0/scripts/detect-framework.sh`
   - Parse output: `FRAMEWORK=..., TYPESCRIPT=..., ROUTING=...`

### Step 3: Call SaltxUI MCP to Fetch Design Data

Use `mcp__SaltxUI-MCP__get_figma_context` with:
- `figma_file_id`: Extracted from URL
- `node_id`: Extracted and converted from URL
- `is_use_tailwindcss`: true (Tailwind only styling)
- `is_use_style_css`: false (we only need Tailwind classes)

The MCP tool returns:
- YAML file path: `.salt-ui/figma/{fileId}/{nodeId}.yaml`
- Raw file path for reference

### Step 4: Read and Parse YAML

Read the generated YAML file and parse:
- Component names (with markers: `[COMP]`, `[STYL]`, or none)
- Tailwind classes
- Component hierarchy
- Text content
- Props and variants

### Step 5: List All Registry Components

Before searching for specific components, get the full registry listing:

Use `mcp__SaltxUI-MCP__search_items_in_registries` with:
- `registries`: ["default"] (or configured registries)
- No specific components (to get all available)

This returns:
- Total item count in registry
- Complete list of available components
- Component types (ui, lib, hook, etc.)

Example output:
```
Registry: default
Total items: 500
Available components: button, input, label, checkbox, dropdown, ...
```

This helps understand what's available before matching specific components from the Figma design.

### Step 6: Search Components in Registry

Use `mcp__SaltxUI-MCP__search_items_in_registries` to find matching components:

For each component in the YAML:
1. Extract component name (without markers `[COMP]`, `[STYL]`)
2. Search for it in the registry
3. Check if it exists and is available

Example search:
```
Components to search: button, input, label, checkbox, divider
```

Build a mapping:
- **Found in registry**: Will use `add_items_from_registries`
- **Not found**: Will build custom from scratch
- **Marked `[STYL]`**: Get from registry + apply custom Tailwind

### Step 7: Discover Existing Components in Current Project

Before adding components from the registry, discover what already exists in the current project:

**Use Glob to search for existing component files:**

```bash
# Search for common component file patterns
# Adjust based on detected framework

# For React/Next.js/Remix/SolidJS:
find . -name "*.tsx" -o -name "*.jsx" | grep -E "(components|ui)" | head -50

# For Vue/Nuxt:
find . -name "*.vue" | grep -E "(components|ui)" | head -50

# For Svelte/SvelteKit:
find . -name "*.svelte" | grep -E "(components|ui)" | head -50

# For Angular:
find . -name "*.ts" | grep -E "(component)" | grep -v ".spec." | head -50
```

**Analyze discovered components:**

1. **Extract component names** from file paths:
   - Remove file extensions
   - Convert to consistent naming convention
   - Build a list of existing component names

2. **Categorize by type**:
   - UI components (buttons, inputs, etc.)
   - Layout components (containers, wrappers)
   - Feature components (forms, cards)
   - Business logic components

3. **Build existing component registry**:
```javascript
existingComponents = {
  button: { path: "apps/web/components/ui/Button.tsx", type: "ui" },
  input: { path: "apps/web/components/ui/Input.tsx", type: "ui" },
  "data-table": { path: "apps/web/components/table/DataTable.tsx", type: "feature" },
  // ... more components
}
```

**Compare with Figma components:**

For each component from the Figma design:
1. **Check if exists locally** (case-insensitive, partial matching)
2. **Match against existing component registry**
3. **Prioritization order**:
   - **FIRST**: Existing local component (use instead of registry)
   - **SECOND**: Registry component (if no local match)
   - **LAST**: Custom build (if no local or registry match)

**Create component sourcing map:**

```
Component: Button
  → Found locally at: apps/web/components/ui/Button.tsx
  → Decision: USE LOCAL (skip registry)

Component: TextField
  → Not found locally
  → Found in registry: input
  → Decision: USE REGISTRY

Component: CustomDashboard
  → Not found locally
  → Not in registry
  → Marker: [COMP]
  → Decision: BUILD CUSTOM
```

**Update component mapping from Step 6:**

```javascript
// Before: Only considered registry
componentMap = {
  button: "registry",
  input: "registry",
  custom-widget: "custom"
}

// After: Prioritizes existing local components
componentMap = {
  button: "local",           // Changed: Use existing local component
  input: "registry",         // Same: No local match, use registry
  "custom-widget": "custom"  // Same: Build custom
}
```

**Show discovery summary to user:**

```
Discovery Results:

Found 25 existing components in current project:
- Button (ui)
- Input (ui)
- Card (feature)
- Modal (ui)
- ... 21 more

Figma components (8):
✓ Button - USE LOCAL (apps/web/components/ui/Button.tsx)
✓ Input - USE LOCAL (apps/web/components/ui/Input.tsx)
→ TextField - USE REGISTRY (input)
→ Checkbox - USE REGISTRY (checkbox)
→ CustomWidget - BUILD CUSTOM [COMP]
→ Badge - BUILD CUSTOM [COMP] (not in registry)
→ Label - USE REGISTRY (label)
→ Divider - USE REGISTRY (divider)

Summary:
- 2 components from local project
- 4 components from registry
- 2 components to build custom

Proceed with implementation?
```

**Benefits of this approach:**

1. **Avoids duplicates** - Won't re-add components that already exist
2. **Consistency** - Uses existing project's component variants
3. **Faster** - Skips unnecessary registry downloads
4. **Context-aware** - Respects project's existing design system

### Step 8: View Registry Component Details

For components that will be sourced from the registry (not local):

Before adding, inspect components found in registry:

Use `mcp__SaltxUI-MCP__view_component` for each component to:
- View the component's source code
- Check its dependencies
- Understand its implementation
- Verify it matches requirements

The view tool returns a cache file path containing:
- Complete source code with syntax highlighting
- File structure and component metadata
- Dependencies and registry information

Example:
```
Viewing components: button, input, label
Cache files: .salt-ui/default/button.mdx
```

### Step 8: Show Preview and Confirm

Before creating files, show the user a preview:

```
Found X component(s) from Figma design:

Components to create:
- [ComponentName] in apps/{app}/components/...

Framework: {framework}
TypeScript: {yes/no}

Routes to create:
- {route-path}

Files to create:
- {file-list}
- {file-list}

Dependencies to install:
- {dep-list}

Proceed? (y/n)
```

Use `AskUserQuestion` to get confirmation before proceeding.

### Step 10: Add Registry Components (Skip Local)

Before generating custom code, install components found in registry:

**IMPORTANT**: Skip components that already exist locally (from Step 7 discovery).

Use `mcp__SaltxUI-MCP__add_items_from_registries` with:
- Only components NOT found locally
- Components that were found in registry search
- Components without `[COMP]` marker (standard components)
- Components with `[STYL]` marker (will be customized with Tailwind)

This installs pre-built components from the registry, reducing custom code generation while avoiding duplicates of existing local components.

**Example of what to skip:**

```javascript
// From Step 7 discovery results
skipComponents = [
  "button",  // Found locally at apps/web/components/ui/Button.tsx
  "input",   // Found locally at apps/web/components/ui/Input.tsx
]

// Only add these from registry
addFromRegistry = [
  "textfield",  // Not found locally, in registry
  "checkbox",   // Not found locally, in registry
  "label",      // Not found locally, in registry
]
```

### Step 11: Generate Custom Component Code

For components marked `[COMP]` or not found in registry:

Delegate to the Component Implementation Agent by reading its instructions and following them:

1. Read `agents/component-implementer.md`
2. Follow the agent's workflow for code generation
3. Create component files with framework-specific syntax
4. Create route files as needed
5. Use appropriate file extensions (.tsx, .jsx, .vue, .svelte, etc.)
6. Apply Tailwind classes from YAML for `[STYL]` components

### Step 12: Install Dependencies

After component creation:
- Identify new dependencies from generated code
- Detect package manager (npm/pnpm/yarn) from lockfile
- Show list of new dependencies
- Ask for confirmation before installing
- Run install command if confirmed

### Step 13: Generate Storybook (Optional)

Use `AskUserQuestion` to prompt the user:

```
Question: Generate Storybook stories and documentation for the implemented components?

Options:
- "Yes, generate stories and docs" - Create .stories.tsx and .mdx files
- "No, skip for now" - Complete implementation without Storybook
```

If user chooses to generate:

1. Read `agents/storybook-generator.md`
2. Follow the agent's workflow for Storybook generation
3. Create `.stories.tsx` files with CSF3 format
4. Create `.mdx` documentation files with component docs
5. Verify stories are valid for the target framework

If user chooses to skip:
- Note that Storybook can be added later
- Provide guidance on manual Storybook setup if needed

### Step 14: Run Verification

After implementation:
- Verify all files exist
- Check for syntax errors
- Show summary of created files

### Step 15: Show Final Summary

Created files:
- apps/web/components/login-form/LoginForm.tsx
- apps/web/app/components/login-form/page.tsx
- apps/storybook/stories/components/login-form/LoginForm.stories.tsx

Next steps:
- Review generated code
- Run tests: npm test
- View in Storybook: npm run storybook
```

## Error Handling

If any step fails:
- Stop immediately
- Show clear error message with context
- Offer rollback option: "Delete created files? (y/n)"
- Provide helpful next steps

## Configuration

Read settings from `.claude/implement.local.md` if it exists:
- `default_app`: Default app for component placement
- `framework_detection`: Auto/manual/hybrid
- `styling`: Always "tailwind"
- `overwrite_behavior`: ask/skip/suffix
- `auto_install_deps`: Whether to install without asking
- `storybook_format`: csf3
- `auto_props`: true/false
- `include_docs`: true/false

## Integration with Agents

This command orchestrates three agents:

1. **Orchestrator Agent** (`agents/orchestrator.md`): Overall workflow coordination
2. **Component Implementation Agent** (`agents/component-implementer.md`): Code generation
3. **Storybook Generation Agent** (`agents/storybook-generator.md`): Documentation

When delegating to agents, read their system prompts and follow their instructions.

## Skills to Reference

When implementing specific aspects, reference these skills:
- `skills/saltxui-mcp/`: SaltxUI MCP tools and YAML processing
- `skills/framework-detection/`: Framework detection patterns
- `skills/multi-framework-generation/`: Framework-specific code generation
- `skills/turborepo-structure/`: Turborepo file placement
- `skills/component-architecture/`: Routing and page components
- `skills/storybook-patterns/`: Storybook CSF3 format

## Hooks

Hooks run automatically:
- **Pre-write validation**: Validates code before writing (blocking)
- **Post-implementation verification**: Verifies files after creation (non-blocking)

These are configured in `hooks/hooks.json` and run automatically.

## Example Usage

```bash
# Basic usage
/implement https://www.figma.com/design/4zD0kyv2x9ao27VSridvya/Vibe?node-id=772-27229

# With custom name
/implement https://www.figma.com/design/4zD0kyv2x9ao27VSridvya/Vibe?node-id=772-27229 --name custom-button

# With app and framework override
/implement https://www.figma.com/design/4zD0kyv2x9ao27VSridvya/Vibe?node-id=772-27229 --app admin --framework vue
```

## Tips

- Always show preview before creating files
- Respect user's `overwrite_behavior` setting
- Use `/Users/budisantoso/.claude/plugins/cache/claude-plugins-official/plugin-dev/f70b65538da0` for portable paths
- Ask for confirmation at key decision points
- Provide clear progress updates during workflow
- Handle errors gracefully with helpful messages
