# Storybook Documentation Patterns

## MDX Documentation Structure

```mdx
---
import { Meta, Canvas, Controls, Source, Stories, Subtitle, Description } from '@storybook/blocks';
import * as ComponentStories from './Component.stories';

<Meta of={ComponentStories} title="Components/Component" />

<Subtitle>Component subtitle</Subtitle>
<Description>Component description</Description>

## Examples

<Canvas of={ComponentStories} />
<Controls of={ComponentStories} />

## Stories

<Stories of={ComponentStories} />
---
```

## Documentation Blocks

### Meta Block

```mdx
<Meta of={ComponentStories} title="Components/Component" />
```

Sets component metadata and imports stories.

### Canvas Block

```mdx
<Canvas of={ComponentStories}>
  <Story of={ComponentStories.Primary} />
</Canvas>
```

Renders a story with interactive controls.

### Controls Block

```mdx
<Controls of={ComponentStories} />
```

Displays props table with interactive controls.

### Source Block

```mdx
<Source
  code={`<Component prop="value" />`}
  language="tsx"
/>
```

Displays syntax-highlighted code snippet.

### Stories Block

```mdx
<Stories of={ComponentStories} />
```

Renders all stories as tabs.

### Description Block

```mdx
<Description of={ComponentStories} />

## Custom Description

Custom markdown content here.
```

Shows component description from meta or custom content.

### Subtitle Block

```mdx
<Subtitle>Component subtitle here</Subtitle>
```

Adds subtitle below title.

## Documentation Patterns

### Pattern 1: Minimal

```mdx
---
import { Meta, Canvas, Controls } from '@storybook/blocks';
import * as ButtonStories from './Button.stories';

<Meta of={ButtonStories} />

# Button

<Canvas of={ButtonStories} />
<Controls of={ButtonStories} />
---
```

### Pattern 2: Comprehensive

```mdx
---
import { Meta, Canvas, Controls, Source, Stories, Title, Subtitle, Description, Primary } from '@storybook/blocks';
import * as FormStories from './Form.stories';

<Meta of={FormStories} />
<Title>Form Component</Title>
<Subtitle>Reusable form component with validation</Subtitle>
<Description of={FormStories} />

## Usage

### Basic Form

<Canvas of={FormStories}>
  <Story of={FormStories.Basic} />
</Canvas>

<Controls of={FormStories.Basic />

### Source Code

<Source
  code={`<Form onSubmit={handleSubmit} />`}
/>

## All Stories

<Stories of={FormStories} />
---
```

### Pattern 3: With Sections

```mdx
---
import { Meta, Canvas, Controls, Source } from '@storybook/blocks';
import * as CardStories from './Card.stories';

<Meta of={CardStories} />

# Card Component

## Examples

### Default Card

<Canvas of={CardStories}>
  <Story of={CardStories.Default} />
</Canvas>

### With Image

<Canvas of={CardStories}>
  <Story of={CardStories.WithImage} />
</Canvas>

### With Custom Styling

<Canvas of={CardStories}>
  <Story of={CardStories.CustomStyled} />
</Canvas>

## Props

<Controls of={CardStories.Default />

## Source

<Source
  code={`import { Card } from '@/components/Card';

<Card title="Title" content="Content" />`}
/>
---
```

## Auto-Generated Props

When using `tags: ['autodocs']`, Storybook automatically generates:

- Props table from TypeScript/PropTypes
- Args table from argTypes
- Controls with interactive inputs

### Enhancing Auto-Generated Props

```tsx
const meta: Meta<typeof Button> = {
  argTypes: {
    label: {
      control: 'text',
      description: 'Button label text',
      table: {
        type: { summary: 'string' },
        defaultValue: { summary: 'Button' },
      },
    },
    size: {
      control: 'select',
      options: ['sm', 'md', 'lg'],
      description: 'Button size',
    },
  },
};
```

## Design Tokens Documentation

```mdx
## Design Tokens

### Colors
- **Primary**: `#3b82f6` (blue-500)
- **Secondary**: `#64748b` (slate-500)
- **Background**: `#ffffff` (white)

### Spacing
- **Padding**: `16px` (p-4)
- **Gap**: `8px` (gap-2)

### Typography
- **Font**: Inter, sans-serif
- **Size**: `14px` (text-sm)
- **Weight**: `500` (font-medium)
```

## Accessibility Documentation

```mdx
## Accessibility

- **Keyboard Navigation**: Use Tab to focus, Enter/Space to activate
- **ARIA Labels**: Component includes proper ARIA attributes
- **Screen Reader**: Tested with NVDA and VoiceOver
- **Color Contrast**: WCAG AA compliant (4.5:1)
- **Focus Visible**: Clear focus indicator for keyboard users
```

## Best Practices

1. Always include `tags: ['autodocs']` in meta
2. Use Canvas for interactive examples
3. Use Controls for props table
4. Provide Source blocks for code examples
5. Document design tokens
6. Include accessibility notes
7. Group related stories with Canvas
8. Use meaningful section headers
9. Keep descriptions concise
10. Link to related components
