# Storybook Decorators Reference

Decorators wrap stories with additional context, providers, or styling.

## Basic Decorator

```tsx
const decorator = (Story) => (
  <div style={{ padding: '20px' }}>
    <Story />
  </div>
);
```

## Common Use Cases

### Theme Provider

```tsx
import { ThemeProvider } from 'your-theme';

const withTheme = (Story) => (
  <ThemeProvider theme={theme}>
    <Story />
  </ThemeProvider>
);

export default meta;
meta.decorators = [withTheme];
```

### Global Fonts

```tsx
const withFonts = (Story) => (
  <>
    <link href="https://fonts.googleapis.com/css2?family=Inter&display=swap" rel="stylesheet" />
    <Story />
  </>
);
```

### Container Width

```tsx
const withContainer = (Story) => (
  <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
    <Story />
  </div>
);
```

### Multiple Decorators

```tsx
// Decorators apply bottom to top
const decorators = [
  (Story) => (
    <ThemeProvider theme={theme}>
      <Story />
    </ThemeProvider>
  ),
  (Story) => (
    <div style={{ padding: '20px' }}>
      <Story />
    </div>
  ),
];
```

### Story-Level Decorators

```tsx
export const DarkMode: Story = {
  decorators: [
    (Story) => (
      <ThemeProvider theme={darkTheme}>
        <Story />
      </ThemeProvider>
    ),
  ],
};
```

### Conditional Decorators

```tsx
const withMobileView = (Story, context) => {
  if (context.view === 'mobile') {
    return <div style={{ width: '375px' }}><Story /></div>;
  }
  return <Story />;
};
```

## Per-Storybook Framework

### React

```tsx
decorators: [
  (Story, context) => (
    <div className={`theme-${context.parameters.theme}`}>
      <Story />
    </div>
  ),
]
```

### Vue

```tsx
decorators: [
  (story, context) => ({
    components: { story },
    template: '<div class="theme-dark"><story /></div>',
  }),
]
```

### Svelte

```svelte
<!-- Decorator is a .svelte file -->
<script>
  import { setContext } from 'svelte';

  export let Story, context;
  setContext('theme', 'dark');
</script>

<div class="theme-dark">
  <Story />
</div>
```

### Angular

```tsx
decorators: [
  (story) => ({
    template: `
      <div class="theme-dark">
        <story-canvas />
      </div>
    `,
  }),
]
```

## Module-Level Decorators

```tsx
// .storybook/preview.tsx
export const decorators = [
  (Story) => (
    <ThemeProvider theme={theme}>
      <Story />
    </ThemeProvider>
  ),
];
```

## Best Practices

1. Keep decorators simple and focused
2. Use meaningful names for reusable decorators
3. Document decorator purpose
4. Test decorators with multiple stories
5. Consider performance impact
