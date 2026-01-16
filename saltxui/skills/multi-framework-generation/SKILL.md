---
name: Multi-Framework Code Generation
description: Convert YAML tokens to framework-specific component code using templates for React, Next.js, Remix, React Router, Vue, Nuxt, Svelte, SvelteKit, Angular, and SolidJS
version: 1.0.0
---

The Multi-Framework Code Generation skill provides comprehensive guidance for converting SaltxUI YAML tokens into framework-specific component code.

## When to Use This Skill

Activate this skill when:
- User asks to "generate react component"
- User asks to "generate next.js component"
- User asks to "generate remix component"
- User asks to "generate vue component"
- User asks to "generate svelte component"
- User asks to "generate angular component"
- User asks to "generate solidjs component"
- User mentions "framework code generation"
- User asks to "convert tokens to code"

## Framework Support

| Framework | Template | File Extension | TypeScript |
|-----------|----------|---------------|------------|
| ReactJS | `react-ts.template` / `react-js.template` | `.tsx` / `.jsx` | Yes/No |
| Next.js | `next-ts.template` / `next-js.template` | `.tsx` / `.jsx` | Yes/No |
| Remix | `remix-ts.template` / `remix-js.template` | `.tsx` / `.jsx` | Yes/No |
| React Router v7+ | `react-router-ts.template` / `react-router-js.template` | `.tsx` / `.jsx` | Yes/No |
| Vue | `vue-ts.template` / `vue-js.template` | `.vue` | Yes/No |
| Nuxt | `nuxt-ts.template` / `nuxt-js.template` | `.vue` | Yes/No |
| Svelte | `svelte-ts.template` / `svelte-js.template` | `.svelte` | Yes/No |
| SvelteKit | `sveltekit-ts.template` / `sveltekit-js.template` | `.svelte` | Yes/No |
| Angular | `angular-ts.template` | `.ts` | Yes |
| SolidJS | `solidjs-ts.template` / `solidjs-js.template` | `.tsx` / `.jsx` | Yes/No |

## Template Variables

From YAML tokens, extract these variables:

```yaml
componentName: string          # PascalCase: "LoginForm"
componentFileName: string      # kebab-case: "login-form"
props: array                  # Component properties
styles: object                # CSS rules or Tailwind classes
variants: array               # Component variants
events: array                 # Event handlers
imports: array                # Import statements
tailwindClasses: string       # Concatenated Tailwind classes
```

## React (Functional Components)

**TypeScript:**
```tsx
import React from 'react';

interface Props {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  onClick?: () => void;
}

export function ComponentName({
  label,
  size = 'md',
  disabled = false,
  onClick
}: Props) {
  return (
    <button
      className={`tailwind-classes ${disabled ? 'opacity-50' : ''}`}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
}
```

**JavaScript:**
```jsx
import React from 'react';

export function ComponentName({
  label,
  size = 'md',
  disabled = false,
  onClick
}) {
  return (
    <button
      className={`tailwind-classes ${disabled ? 'opacity-50' : ''}`}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
}
```

## Next.js (Server Components)

**TypeScript:**
```tsx
import React from 'react';

interface Props {
  title: string;
  children: React.ReactNode;
}

export default function ComponentName({ title, children }: Props) {
  return (
    <div className="tailwind-classes">
      <h1>{title}</h1>
      {children}
    </div>
  );
}
```

**Client Component (when needed):**
```tsx
'use client';

import React from 'react';

// Same as React functional component
```

## Remix (Loader/Action Patterns)

**TypeScript:**
```tsx
import { useState } from 'react';
import type { ActionFunctionArgs, LoaderFunctionArgs } from '@remix-run/node';
import { Form, useActionData, useLoaderData } from '@remix-run/react';

interface Props {
  // component props
}

export async function loader({ request }: LoaderFunctionArgs) {
  // Data loading
  return {};
}

export async function action({ request }: ActionFunctionArgs) {
  // Form handling
  return {};
}

export default function ComponentName(props: Props) {
  const loaderData = useLoaderData();
  const actionData = useActionData();

  return (
    <div className="tailwind-classes">
      {/* Component content */}
    </div>
  );
}
```

## React Router v7+ (Framework Mode)

**TypeScript:**
```tsx
import { useState } from 'react';
import type { LoaderFunctionArgs, ActionFunctionArgs } from 'react-router';

export async function loader({ request }: LoaderFunctionArgs) {
  // Data loading
  return {};
}

export async function action({ request }: ActionFunctionArgs) {
  // Form handling
  return {};
}

export default function ComponentName({ /* props */ }) {
  // Component implementation
  return (
    <div className="tailwind-classes">
      {/* Component content */}
    </div>
  );
}
```

## Vue (Composition API)

**TypeScript:**
```vue
<script setup lang="ts">
interface Props {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  disabled: false
});

const emit = defineEmits<{
  click: [];
}>();

const handleClick = () => {
  emit('click');
};
</script>

<template>
  <button
    :class="['tailwind-classes', { 'opacity-50': disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    {{ label }}
  </button>
</template>
```

**JavaScript:**
```vue
<script setup>
const props = defineProps({
  label: String,
  size: {
    type: String,
    default: 'md'
  },
  disabled: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['click']);

const handleClick = () => {
  emit('click');
};
</script>

<template>
  <button
    :class="['tailwind-classes', { 'opacity-50': disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    {{ label }}
  </button>
</template>
```

## Svelte

**TypeScript:**
```svelte
<script lang="ts">
export let label: string;
export let size: 'sm' | 'md' | 'lg' = 'md';
export let disabled: boolean = false;

const dispatch = createEventDispatcher();

function handleClick() {
  dispatch('click');
}
</script>

<button
  class="tailwind-classes {disabled ? 'opacity-50' : ''}"
  {disabled}
  on:click={handleClick}
>
  {label}
</button>
```

**JavaScript:**
```svelte
<script>
export let label;
export let size = 'md';
export let disabled = false;

function handleClick() {
  dispatch('click');
}
</script>

<button
  class="tailwind-classes {disabled ? 'opacity-50' : ''}"
  {disabled}
  on:click={handleClick}
>
  {label}
</button>
```

## Angular (Signals - Angular 17+)

**Angular 20+ (New file naming, no .component suffix):**

*File: `component-name.ts`*
```typescript
import { Component, input, output, computed } from '@angular/core';

@Component({
  selector: 'app-component-name',
  templateUrl: './component-name.html',
  styleUrls: ['./component-name.css']
})
export class ComponentNameComponent {
  // Input signals (required)
  readonly label = input.required<string>();
  readonly size = input<'sm' | 'md' | 'lg'>('md');
  readonly disabled = input(false);

  // Output signals
  readonly click = output<void>();

  // Computed signals
  readonly classes = computed(() => {
    return [
      'tailwind-classes',
      this.disabled() ? 'opacity-50' : ''
    ].filter(Boolean).join(' ');
  });

  handleClick(): void {
    this.click.emit();
  }
}
```

**Angular 17-19 (Signals with .component suffix):**

*File: `component-name.component.ts`*
```typescript
import { Component, input, output, computed } from '@angular/core';

@Component({
  selector: 'app-component-name',
  templateUrl: './component-name.component.html',
  styleUrls: ['./component-name.component.css']
})
export class ComponentNameComponent {
  readonly label = input.required<string>();
  readonly size = input<'sm' | 'md' | 'lg'>('md');
  readonly disabled = input(false);
  readonly click = output<void>();
}
```

**Template:**
```html
<button
  [class]="classes()"
  [disabled]="disabled()"
  (click)="handleClick()"
>
  {{ label() }}
</button>
```

**Angular 16- (Legacy decorators with .component suffix):**
```typescript
import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-component-name',
  templateUrl: './component-name.component.html',
  styleUrls: ['./component-name.component.css']
})
export class ComponentNameComponent {
  @Input() label: string = '';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;

  @Output() click = new EventEmitter<void>();

  handleClick(): void {
    this.click.emit();
  }
}
```

## SolidJS

**TypeScript:**
```tsx
import { Component } from 'solid-js';

interface Props {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  onClick?: () => void;
}

export function ComponentName(props: Props) {
  return (
    <button
      class={`tailwind-classes ${props.disabled ? 'opacity-50' : ''}`}
      onClick={props.onClick}
      disabled={props.disabled}
    >
      {props.label}
    </button>
  );
}
```

## Converting Common Patterns

### Props Definition

| Framework | Props Pattern |
|-----------|--------------|
| React TS | `interface Props { ... }` |
| React JS | PropTypes or comments |
| Next.js | Same as React |
| Remix | Same as React |
| React Router | Same as React |
| Vue TS | `interface Props` with `defineProps<Props>()` |
| Vue JS | `defineProps({ ... })` |
| Svelte TS | `export let prop: type` |
| Svelte JS | `export let prop` |
| Angular TS (17+) | `readonly prop = input<type>()` or `input.required<type>()` |
| Angular TS (16-) | `@Input() prop: type` |
| SolidJS TS | `interface Props { ... }` |

### Event Handlers

| Framework | Event Pattern |
|-----------|--------------|
| React | `onClick`, `onChange` |
| Vue | `@click`, `@change` |
| Svelte | `on:click`, `on:change` |
| Angular | `(click)`, `(change)` |
| SolidJS | `onClick`, `onChange` |

### State Management

| Framework | State Pattern |
|-----------|--------------|
| React | `useState`, `useReducer` |
| Vue | `ref`, `reactive` |
| Svelte | `let` (reactive by default) |
| Angular (17+) | `signal()`, `computed()`, `effect()` |
| Angular (16-) | Private fields |
| SolidJS | `createSignal` |

### Slots vs Children

| Framework | Children Pattern |
|-----------|-----------------|
| React | `{children}` prop |
| Vue | `<slot>` |
| Svelte | `<slot>` |
| Angular | `<ng-content>` |
| SolidJS | `{props.children}` |

## Styling Patterns

**All frameworks use Tailwind classes:**
```tsx
className="flex flex-col items-center gap-4 p-6"
```

**Arbitrary values from YAML:**
```tsx
className="w-[403px] h-[50px] bg-[#ffffff] rounded-[4px]"
```

## Framework-Specific Syntax Differences

### Import Statements

| Framework | Import Pattern |
|-----------|---------------|
| React | `import { Component } from './Component'` |
| Vue | `import Component from './Component.vue'` |
| Svelte | `import Component from './Component.svelte'` |
| Angular 20+ | `import { Component } from './component'` |
| Angular 19- | `import { Component } from './component.component'` |
| SolidJS | `import { Component } from './Component'` |

### Component Export

| Framework | Export Pattern |
|-----------|---------------|
| React | `export function Component() {}` |
| Vue | `<script setup>` - auto export |
| Svelte | Default export |
| Angular | `@Component()` decorator |
| SolidJS | `export function Component() {}` |

## Template System

**Simple Variable Replacement:**
```typescript
const componentName = "LoginForm";
const tailwindClasses = "flex flex-col gap-4";
const template = `
  export function ${componentName}() {
    return <div className="${tailwindClasses}"></div>;
  }
`;
```

**From YAML:**
```yaml
# Input YAML
component: "LoginForm"
tailwindcss:
  - "flex"
  - "flex-col"
  - "gap-4"

# Extracted variables
componentName = "LoginForm"
tailwindClasses = "flex flex-col gap-4"
```

## References

- **Framework Syntax Mapping**: See `references/framework-syntax-mapping.md`
- **Props Patterns**: See `references/props-patterns.md`
- **Template Files**: See `templates/` directory
- **Templates Available**: `react-ts.template`, `next-ts.template`, `remix-ts.template`, `react-router-ts.template`, `vue-ts.template`, `svelte-ts.template`, `solidjs-ts.template`, `angular-ts.template`

## Examples

- `templates/react-ts.template` - React TypeScript template
- `templates/vue-ts.template` - Vue TypeScript template
- `templates/angular-ts.template` - Angular TypeScript template
- `examples/component-examples.md` - Framework-specific examples
