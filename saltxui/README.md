# SaltxUI Plugin

Orchestrate the complete end-to-end workflow of implementing UI designs from Figma URLs using the SaltxUI MCP server.

## Features

- **Figma Integration**: Accept Figma URLs and extract design specifications
- **Framework-Agnostic**: Auto-detect framework from package.json (ReactJS, Next.js, Remix, React Router v7+, Vue, Nuxt, Svelte, SvelteKit, Angular, SolidJS)
- **Code Generation**: Generate framework-specific component code with routes
- **Turborepo Support**: Proper file placement in turborepo structure
- **Storybook Integration**: Generate CSF3 stories and documentation
- **Tailwind-First**: Extract and apply Tailwind classes from Figma designs

## Installation

```bash
# Clone this plugin to your project
cp -r saltxui /path/to/your-project/.claude-plugins/

# Or install globally
cp -r saltxui ~/.claude/plugins/saltxui
```

## Prerequisites

- **Figma Token**: Get your Figma personal access token from https://www.figma.com/developers/api#access-tokens
- **Turborepo project structure**: Apps and packages layout
- **Tailwind CSS**: Configured in your project
- **salt-ui.config.json**: Project configuration with Figma token

### Setting up salt-ui.config.json

The MCP server reads your Figma token from `salt-ui.config.json` in your project root:

```json
{
  "framework": "react",
  "typescript": true,
  "registry": "https://ui.shadcn.com/r/styles/new-york/{name}.json",
  "figma-token": "figd_your_figma_token_here",
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils"
  }
}
```

**Note:**
- The plugin automatically installs the SaltxUI MCP server (`@saltx-ui/mcp@beta`) via npx when first loaded
- The MCP server reads the `figma-token` from your `salt-ui.config.json`
- Keep `salt-ui.config.json` private (it's in .gitignore)

## Configuration

Create `.claude/implement.local.md` in your project:

```yaml
---
# App Settings
default_app: "web"
available_apps:
  - web
  - admin
  - mobile

# Framework Settings
framework_detection: "auto"
framework_detection_script: "./scripts/detect-framework.sh"

# Path Settings
component_path: "components"
storybook_app: "storybook"
stories_path: "stories/components"

# Code Generation
styling: "tailwind"
create_types_file: false
auto_install_deps: false
overwrite_behavior: "ask"

# Storybook Settings
storybook_format: "csf3"
auto_props: true
include_docs: true
---
```

## Usage

### Command

```bash
/implement https://www.figma.com/design/xyz/component
/implement https://www.figma.com/design/xyz/component --name custom-button
/implement https://www.figma.com/design/xyz/component --app admin --framework vue
```

### Agent

Agents are invoked by commands via the Task tool for specialized tasks:

| Agent | Purpose | Invoked By |
|------|---------|------------|
| `component-implementer` | Generates framework-specific code | `/implement` Step 11, `/revise` |
| `storybook-generator` | Creates stories and docs | `/implement` Step 13 |

## Components

| Type | Name | Purpose |
|------|------|---------|
| Command | `/implement` | Full workflow command |
| Agent | `component-implementer` | Generates framework-specific code |
| Agent | `storybook-generator` | Creates stories and docs |
| Skill | `storybook-patterns` | Storybook best practices |
| Skill | `turborepo-structure` | Turborepo layout conventions |
| Skill | `saltxui-mcp` | SaltxUI MCP tools and YAML |
| Skill | `framework-detection` | Framework auto-detection |
| Skill | `multi-framework-generation` | Code generation patterns |
| Skill | `component-architecture` | Component routing patterns |
| Hook | `pre-write-validation` | Validate before writing |
| Hook | `post-implementation-verification` | Verify after creation |

## Supported Frameworks

- ReactJS (`.tsx` / `.jsx`)
- Next.js App Router (`.tsx` / `.jsx`)
- Remix (`.tsx` / `.jsx`)
- React Router v7+ Framework (`.tsx` / `.jsx`)
- Vue (`.vue`)
- Nuxt (`.vue`)
- Svelte (`.svelte`)
- SvelteKit (`.svelte`)
- Angular (`.ts` / `.js`)
- SolidJS (`.tsx` / `.jsx`)

## Workflow

1. Receive Figma URL
2. Call SaltxUI MCP to fetch design data
3. Parse YAML token output
4. Detect target app and framework
5. Show preview and confirm
6. Generate component code with routes
7. Install dependencies
8. Generate Storybook stories and docs
9. Verify implementation

## License

MIT
