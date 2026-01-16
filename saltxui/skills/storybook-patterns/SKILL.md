---
name: Storybook Patterns
description: Guide Storybook story and documentation creation following CSF3 best practices with auto-generated props, variants, and comprehensive documentation
version: 1.0.0
---

The Storybook Patterns skill provides comprehensive guidance for creating Storybook stories and documentation following CSF3 (Component Story Format 3) standards.

## When to Use This Skill

Activate this skill when:
- User asks about "storybook story format"
- User mentions "csf3"
- User needs "storybook documentation" patterns
- User asks about "story variants"
- User wants to "generate storybook story"
- Creating `.stories.tsx` or `.stories.mdx` files
- Defining story controls, args, or decorators
- Writing component documentation for Storybook

## CSF3 Format Overview

CSF3 (Component Story Format 3) is the standard format for Storybook stories using default exports and named exports.

**Basic Structure:**
```tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

// Meta: Component configuration
const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
  tags: ['autodocs'],
  argTypes: {
    // control definitions
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

// Stories: Named exports for each variant
export const Default: Story = {
  args: {
    // story args
  },
};
```

## Writing Effective Story Variants

Create 3-5 variants per component:

**1. Default Story:**
```tsx
export const Default: Story = {
  args: {
    label: 'Button',
    size: 'md',
  },
};
```

**2. Size Variants:**
```tsx
export const Small: Story = {
  args: { size: 'sm' },
};

export const Medium: Story = {
  args: { size: 'md' },
};

export const Large: Story = {
  args: { size: 'lg' },
};
```

**3. State Variants:**
```tsx
export const Disabled: Story = {
  args: { disabled: true },
};

export const Loading: Story = {
  args: { loading: true },
};
```

**4. Composition Variants:**
```tsx
export const WithIcon: Story = {
  args: {
    icon: <SearchIcon />,
    label: 'Search',
  },
};
```

## Using Controls, Args, and Decorators

**Controls (ArgTypes):**
Auto-generate from TypeScript types:

```tsx
argTypes: {
  label: {
    control: 'text',
    description: 'Button label text',
  },
  size: {
    control: 'select',
    options: ['sm', 'md', 'lg'],
    description: 'Button size',
  },
  disabled: {
    control: 'boolean',
    description: 'Disable the button',
  },
  onClick: {
    action: 'clicked',
    description: 'Click handler',
  },
}
```

**Control Types:**
- `text` - String input
- `number` - Number input
- `boolean` - Toggle
- `select` - Dropdown (requires `options`)
- `radio` - Radio buttons (requires `options`)
- `check` - Multi-select (requires `options`)
- `color` - Color picker
- `date` - Date picker
- `object` - JSON editor
- `action` - Event handler logging

**Args:**
Override default props for specific story:

```tsx
export const Custom: Story = {
  args: {
    label: 'Custom Label',
    size: 'lg',
    variant: 'primary',
  },
};
```

**Decorators:**
Wrap stories with providers or themes:

```tsx
decorators: [
  (Story) => (
    <ThemeProvider theme={theme}>
      <Story />
    </ThemeProvider>
  ),
],
```

## Documentation (.mdx) Patterns

**Frontmatter:**
```yaml
---
import { Meta, Canvas, Controls, Source, Stories } from '@storybook/blocks';
import * as ButtonStories from './Button.stories';

<Meta of={ButtonStories} title="Components/Button" />
---
```

**Description:**
```markdown
# Button

Button component for user actions.

## Usage

```tsx
import { Button } from '@/components/Button';

<Button label="Click me" size="md" />
```
```

**Props Table:**
```markdown
<Controls of={ButtonStories} />
```

**Stories Display:**
```markdown
## Examples

<Canvas of={ButtonStories}>
  <Story of={ButtonStories.Default} />
  <Story of={ButtonStories.Small} />
  <Story of={ButtonStories.Large} />
</Canvas>
```

**Source Code:**
```markdown
### Default Implementation

<Source
  code={`<Button label="Submit" size="md" />`}
/>
```

## Composition Patterns for Complex Components

**Compound Components:**
```tsx
// Card.stories.tsx
export const WithHeaderAndFooter: Story = {
  render: () => (
    <Card>
      <Card.Header>Title</Card.Header>
      <Card.Body>Content</Card.Body>
      <Card.Footer>Actions</Card.Footer>
    </Card>
  ),
};
```

**Multiple Components:**
```tsx
// Form.stories.tsx
export const CompleteForm: Story = {
  render: () => (
    <Form>
      <FormField label="Username">
        <Input />
      </FormField>
      <FormField label="Password">
        <Input type="password" />
      </FormField>
      <Button>Submit</Button>
    </Form>
  ),
};
```

**Template Pattern:**
```tsx
const Template: Story = {
  render: (args) => <Button {...args} />,
};

export const Default = Template.bind({});
Default.args = { label: 'Button' };

export const Primary = Template.bind({});
Primary.args = { variant: 'primary' };
```

## Auto-Generated Props from TypeScript

Extract props from TypeScript interfaces:

```tsx
// Component
interface ButtonProps {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  onClick?: () => void;
}

// Stories - Auto-generate controls
const meta: Meta<ButtonProps> = {
  argTypes: {
    label: { control: 'text' },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
    },
    disabled: { control: 'boolean' },
    onClick: { action: 'clicked' },
  },
};
```

**Inference Rules:**
- `string` → `text` control
- `number` → `number` control
- `boolean` → `boolean` control
- `enum` → `select` with enum values
- `function` → `action`
- `union type` → `select` with options

## Storybook Parameters

**Layout:**
```tsx
parameters: {
  layout: 'centered', // 'centered' | 'fullscreen' | 'padded'
}
```

**Docs:**
```tsx
parameters: {
  docs: {
    description: {
      component: 'Component description',
    },
    page: () => (
      <div>
        <Title />
        <Description />
        <Primary />
        <Controls />
        <Stories />
      </div>
    ),
  },
}
```

**Viewport:**
```tsx
parameters: {
  viewport: {
    viewports: {
      mobile: '375x667',
      tablet: '768x1024',
      desktop: '1920x1080',
    },
  },
}
```

## Best Practices

1. **Use `tags: ['autodocs']`** for automatic documentation
2. **Create descriptive titles**: `Components/Button` not `Button`
3. **Provide 3-5 variants** per component
4. **Auto-generate controls** from TypeScript when possible
5. **Use `action`** for event handlers to log interactions
6. **Add descriptions** to controls for better UX
7. **Group related stories** with folders: `Components/Forms/Button`
8. **Use decorators** for providers and themes
9. **Keep stories simple** - focus on one aspect per story
10. **Document edge cases** and error states

## Framework-Specific Formats

**React:**
```tsx
import type { Meta, StoryObj } from '@storybook/react';
```

**Vue:**
```tsx
import type { Meta, StoryObj } from '@storybook/vue3';
```

**Svelte:**
```svelte
<script>
  import { Meta, Story, Template, Canvas } from '@storybook/addon-svelte-csf';
</script>
```

**Angular:**
```tsx
import type { Meta, StoryObj } from '@storybook/angular';
```

**SolidJS:**
```tsx
import type { Meta, StoryObj } from '@storybook/solid';
```

## References

- **CSF3 Specification**: See `references/csf3-format.md`
- **Common Decorators**: See `references/decorators.md`
- **Documentation Patterns**: See `references/documentation-patterns.md`
- **Example Stories**: See `examples/` directory

## Examples

- `examples/basic-story.stories.tsx` - Simple component story
- `examples/with-controls.stories.tsx` - Full argTypes example
- `examples/with-docs.stories.mdx` - Complete documentation
