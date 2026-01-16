# Framework Syntax Mapping

Quick reference for converting patterns across frameworks.

## Component Definition

| Framework | Component Syntax |
|-----------|------------------|
| React | `export function Component() {}` |
| Next.js | `export default function Component() {}` |
| Remix | `export default function Component() {}` |
| React Router v7+ | `export default function Component() {}` |
| Vue | `<script setup>` with `defineProps` |
| Nuxt | `<script setup>` with `defineProps` |
| Svelte | `<script>` with `export let` |
| SvelteKit | `<script>` with `export let` |
| Angular | `@Component()` decorator |
| SolidJS | `export function Component() {}` |

## Props Definition

### React/Next.js/Remix/React Router/SolidJS

```typescript
interface Props {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
}

export function Component({ label, size = 'md', disabled }: Props) {
  return ...
}
```

### Vue/Nuxt

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
</script>
```

### Svelte/SvelteKit

```svelte
<script lang="ts">
export let label: string;
export let size: 'sm' | 'md' | 'lg' = 'md';
export let disabled: boolean = false;
</script>
```

### Angular 20+ (Signals)

```typescript
import { Component, input } from '@angular/core';

@Component({...})
export class Component {
  readonly label = input.required<string>();
  readonly size = input<'sm' | 'md' | 'lg'>('md');
  readonly disabled = input(false);
}
```

### Angular 19- (Legacy)

```typescript
@Component({...})
export class ComponentComponent {
  @Input() label: string = '';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() disabled: boolean = false;
}
```

## Event Handlers

### React/Next.js/Remix/React Router/SolidJS

```tsx
onClick={() => handleClick()}
onChange={(e) => handleChange(e)}
```

### Vue/Nuxt

```vue
@click="handleClick"
@change="handleChange"
```

### Svelte/SvelteKit

```svelte
on:click={handleClick}
on:change={handleChange}
```

### Angular

```html
(click)="handleClick()"
(change)="handleChange($event)"
```

## State Management

| Framework | State Syntax |
|-----------|-------------|
| React | `const [state, setState] = useState()` |
| Next.js | Same as React |
| Remix | Same as React |
| React Router v7+ | Same as React |
| Vue | `const state = ref()`, `const state = reactive({})` |
| Nuxt | Same as Vue |
| Svelte | `let state` (reactive by default) |
| SvelteKit | Same as Svelte |
| Angular 20+ | `signal()`, `computed()`, `effect()` |
| Angular 19- | Private fields |
| SolidJS | `const [state, setState] = createSignal()` |

## Slots/Children

| Framework | Children Pattern |
|-----------|------------------|
| React | `{children}` prop |
| Vue | `<slot>` element |
| Nuxt | `<slot>` element |
| Svelte | `<slot>` element |
| SvelteKit | `<slot>` element |
| Angular | `<ng-content>` element |
| SolidJS | `{props.children}` |

## Import Statements

### React/Next.js/Remix/React Router

```tsx
import { Component } from './Component';
import { Component } from '@/components/Component';
import { Component } from '@repo/ui';
```

### Vue/Nuxt

```vue
<script setup>
import Component from './Component.vue';
import Component from '@/components/Component.vue';
</script>
```

### Svelte/SvelteKit

```svelte
<script>
import Component from './Component.svelte';
import Component from '$lib/components/Component.svelte';
</script>
```

### Angular 20+

```typescript
import { Component } from './component';
```

### Angular 19-

```typescript
import { Component } from './component.component';
```

### SolidJS

```tsx
import { Component } from './Component';
import { Component } from '~/components/Component';
```

## Styling (All Tailwind)

### React/Next.js/Remix/React Router/SolidJS

```tsx
<div className="flex flex-col gap-4 p-6">
```

### Vue/Nuxt

```vue
<div class="flex flex-col gap-4 p-6">
```

### Svelte/SvelteKit

```svelte
<div class="flex flex-col gap-4 p-6">
```

### Angular

```html
<div class="flex flex-col gap-4 p-6">
```

## Conditional Rendering

### React/Next.js/Remix/React Router/SolidJS

```tsx
{condition && <Component />}
{condition ? <A /> : <B />}
```

### Vue/Nuxt

```vue
<Component v-if="condition" />
<template v-if="condition">
  <Component />
</template>
<A v-else-if="condition" />
<B v-else />
```

### Svelte/SvelteKit

```svelte
{#if condition}
  <Component />
{/if}
{#if condition}
  <Component />
{:else}
  <Other />
{/if}
```

### Angular

```html
<component *ngIf="condition" />
<ng-container *ngIf="condition; then aTemplate; else bTemplate"></ng-container>
```

## List Rendering

### React/Next.js/Remix/React Router/SolidJS

```tsx
{items.map(item => (
  <Item key={item.id} {...item} />
))}
```

### Vue/Nuxt

```vue
<Item
  v-for="item in items"
  :key="item.id"
  v-bind="item"
/>
```

### Svelte/SvelteKit

```svelte
{#each items as item (item.id)}
  <Item {...item} />
{/each}
```

### Angular

```html
<app-item
  *ngFor="let item of items"
  [item]="item"
></app-item>
```

## Template Reference Variables

| Framework | Ref Syntax |
|-----------|-----------|
| React | `useRef()` |
| Vue | `ref()` |
| Svelte | `bind:this` |
| Angular | `@ViewChild()` |
| SolidJS | Not needed (reactive) |

## Lifecycle Hooks

| Framework | Mount | Update | Unmount |
|-----------|-------|--------|---------|
| React | `useEffect(() => {}, [])` | `useEffect(() => {})` | Cleanup in useEffect |
| Vue | `onMounted()` | `watch()` | `onUnmounted()` |
| Svelte | `onMount()` | Reactive `$:` | `onDestroy()` |
| Angular | `ngOnInit()` | `ngOnChanges()` | `ngOnDestroy()` |
| SolidJS | `onMount(() => {})` | `createEffect()` | `onCleanup()` |

## Two-Way Binding

| Framework | Syntax |
|-----------|--------|
| React | Manual `onChange` handler |
| Vue | `v-model` |
| Svelte | `bind:value` |
| Angular | `[(ngModel)]` |
| SolidJS | Manual `onInput` handler |

## Component Export

| Framework | Export Pattern |
|-----------|---------------|
| React | `export function Component()` |
| Next.js | `export default function Page()` |
| Remix | `export default function Route()` |
| React Router v7+ | `export default function Route()` |
| Vue | `<script setup>` (auto export) |
| Nuxt | `<script setup>` (auto export) |
| Svelte | Default export |
| SvelteKit | `<script>` (auto export) |
| Angular 20+ | `@Component()` decorator, simplified class names |
| Angular 19- | `@Component()` decorator, `ComponentComponent` class names |
| SolidJS | `export function Component()` |
