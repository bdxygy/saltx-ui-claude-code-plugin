# CSF3 (Component Story Format 3) Specification

CSF3 is the standard format for Storybook stories using default exports and named exports.

## Core Structure

```tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

// Meta: Default export with component metadata
const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
  tags: ['autodocs'],
  argTypes: {
    // Control definitions
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

// Stories: Named exports for each variant
export const Default: Story = {
  args: {
    // Story args
  },
};
```

## Required Exports

1. **default export** - The Meta object (component configuration)
2. **Named exports** - Each story variant (Primary, Secondary, etc.)

## Meta Properties

```tsx
const meta: Meta<typeof Component> = {
  // Required
  component: Component,
  title: 'Category/ComponentName',  // Hierarchical title

  // Optional
  tags: ['autodocs', 'skip-playwright'],  // Tags for story behavior
  parameters: {
    layout: 'centered',  // 'centered' | 'fullscreen' | 'padded'
    docs: {
      description: {
        component: 'Component description',
      },
    },
  },
  argTypes: {
    // Control definitions
  },
  decorators: [
    (Story) => (
      <ThemeProvider theme={theme}>
        <Story />
      </ThemeProvider>
    ),
  ],
};
```

## Story Properties

```tsx
export const StoryName: Story = {
  // Story args override component defaults
  args: {
    prop: 'value',
  },

  // Render function for custom rendering
  render: (args) => <Component {...args} />,

  // Story-specific parameters
  parameters: {
    backgrounds: {
      default: 'dark',
    },
  },

  // Story-specific decorators
  decorators: [
    (Story) => (
      <div style={{ padding: '20px' }}>
        <Story />
      </div>
    ),
  ],
};
```

## TypeScript Types

```tsx
// For function components
const meta: Meta<typeof Component>

// For class components
const meta: Meta<PropTypes<typeof Component>>

// Story type
type Story = StoryObj<typeof Component>
```

## Auto-Docs Tags

| Tag | Behavior |
|-----|----------|
| `'autodocs'` | Auto-generate documentation page |
| `'skip-playwright'` | Skip Playwright tests |
| `'skip-vitest'` | Skip Vitest tests |

## Best Practices

1. Use TypeScript for type safety
2. Always include `tags: ['autodocs']`
3. Provide descriptive titles with categories
4. Use argTypes for control definitions
5. Create 3-5 story variants per component
6. Use Template pattern for similar stories
