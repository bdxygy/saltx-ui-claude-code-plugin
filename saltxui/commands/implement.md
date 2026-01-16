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

### Step 2: Detect Target App and Framework

If `--app` not provided:
- Detect from current working directory
- Look for `apps/` subdirectory
- Check package.json location
- Default to first app in `apps/` if ambiguous

If `--framework` not provided:
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

### Step 5: Show Preview and Confirm

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

### Step 6: Generate Component Code

Delegate to the Component Implementation Agent by reading its instructions and following them:

1. Read `agents/component-implementer.md`
2. Follow the agent's workflow for code generation
3. Create component files with framework-specific syntax
4. Create route files as needed
5. Use appropriate file extensions (.tsx, .jsx, .vue, .svelte, etc.)

### Step 7: Install Dependencies

After component creation:
- Identify new dependencies from generated code
- Detect package manager (npm/pnpm/yarn) from lockfile
- Show list of new dependencies
- Ask for confirmation before installing
- Run install command if confirmed

### Step 8: Generate Storybook (Optional)

Ask user: "Generate Storybook stories and documentation? (y/n)"

If yes, delegate to Storybook Generation Agent:
1. Read `agents/storybook-generator.md`
2. Follow the agent's workflow for Storybook generation
3. Create `.stories.tsx` files
4. Create `.mdx` documentation files

### Step 9: Run Verification

After implementation:
- Verify all files exist
- Check for syntax errors
- Show summary of created files

### Step 10: Show Final Summary

Display:
```
Implementation complete!

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
