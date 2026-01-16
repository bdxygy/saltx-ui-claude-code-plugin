# Props Patterns Reference

Common prop patterns across frameworks and how to define them.

## String Props

### React/Next.js/Remix/React Router/SolidJS

```typescript
interface Props {
  label: string;
  placeholder?: string;
}

export function Component({ label, placeholder = "Enter text" }: Props) {
  return <input placeholder={placeholder} />;
}
```

### Vue/Nuxt

```vue
<script setup lang="ts">
interface Props {
  label: string;
  placeholder?: string;
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: "Enter text"
});
</script>

<template>
  <input :placeholder="placeholder" />
</template>
```

### Svelte/SvelteKit

```svelte
<script lang="ts">
export let label: string;
export let placeholder: string = "Enter text";
</script>

<input placeholder={placeholder} />
```

### Angular 20+ (Signals)

```typescript
import { Component, input } from '@angular/core';

@Component({...})
export class Component {
  readonly label = input.required<string>();
  readonly placeholder = input('Enter text');
}
```

```html
<input [placeholder]="placeholder()" />
```

### Angular 19- (Legacy)

```typescript
@Component({...})
export class ComponentComponent {
  @Input() label: string = '';
  @Input() placeholder: string = 'Enter text';
}
```

```html
<input [placeholder]="placeholder" />
```

## Boolean Props

### React/Next.js/Remix/React Router/SolidJS

```typescript
interface Props {
  disabled?: boolean;
  loading?: boolean;
}

export function Component({ disabled = false, loading = false }: Props) {
  return <button disabled={disabled} aria-busy={loading} />;
}
```

### Vue/Nuxt

```vue
<script setup lang="ts">
interface Props {
  disabled?: boolean;
  loading?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  loading: false
});
</script>

<template>
  <button :disabled="disabled" :aria-busy="loading" />
</template>
```

### Svelte/SvelteKit

```svelte
<script lang="ts">
export let disabled: boolean = false;
export let loading: boolean = false;
</script>

<button {disabled} aria-busy={loading} />
```

### Angular 20+ (Signals)

```typescript
import { Component, input } from '@angular/core';

@Component({...})
export class Component {
  readonly disabled = input(false);
  readonly loading = input(false);
}
```

```html
<button [disabled]="disabled()" [attr.aria-busy]="loading()" />
```

### Angular 19- (Legacy)

```typescript
@Component({...})
export class ComponentComponent {
  @Input() disabled = false;
  @Input() loading = false;
}
```

```html
<button [disabled]="disabled" [attr.aria-busy]="loading" />
```

## Enum Props

### React/Next.js/Remix/React Router/SolidJS

```typescript
type Size = 'sm' | 'md' | 'lg';
type Variant = 'primary' | 'secondary' | 'danger';

interface Props {
  size?: Size;
  variant?: Variant;
}

export function Component({ size = 'md', variant = 'primary' }: Props) {
  return <button className={`btn-${size} btn-${variant}`} />;
}
```

### Vue/Nuxt

```vue
<script setup lang="ts">
type Size = 'sm' | 'md' | 'lg';
type Variant = 'primary' | 'secondary' | 'danger';

interface Props {
  size?: Size;
  variant?: Variant;
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  variant: 'primary'
});
</script>

<template>
  <button :class="['btn', `btn-${size}`, `btn-${variant}`]" />
</template>
```

### Svelte/SvelteKit

```svelte
<script lang="ts">
export let size: 'sm' | 'md' | 'lg' = 'md';
export let variant: 'primary' | 'secondary' | 'danger' = 'primary';
</script>

<button class="btn {size} {variant}" />
```

### Angular 20+ (Signals)

```typescript
import { Component, input } from '@angular/core';

@Component({...})
export class Component {
  readonly size = input<'sm' | 'md' | 'lg'>('md');
  readonly variant = input<'primary' | 'secondary' | 'danger'>('primary');
}
```

```html
<button [class]="'btn btn-' + size() + ' btn-' + variant()" />
```

### Angular 19- (Legacy)

```typescript
@Component({...})
export class ComponentComponent {
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() variant: 'primary' | 'secondary' | 'danger' = 'primary';
}
```

```html
<button [class]="'btn btn-' + size + ' btn-' + variant" />
```

## Array Props

### React/Next.js/Remix/React Router/SolidJS

```typescript
interface Props {
  items: string[];
  tags?: string[];
}

export function Component({ items, tags = [] }: Props) {
  return (
    <ul>
      {items.map(item => <li key={item}>{item}</li>)}
    </ul>
  );
}
```

### Vue/Nuxt

```vue
<script setup lang="ts">
interface Props {
  items: string[];
  tags?: string[];
}

const props = withDefaults(defineProps<Props>(), {
  tags: () => []
});
</script>

<template>
  <ul>
    <li v-for="item in items" :key="item">{{ item }}</li>
  </ul>
</template>
```

### Svelte/SvelteKit

```svelte
<script lang="ts">
export let items: string[];
export let tags: string[] = [];
</script>

<ul>
  {#each items as item (item)}
    <li>{item}</li>
  {/each}
</ul>
```

### Angular 20+ (Signals)

```typescript
import { Component, input } from '@angular/core';

@Component({...})
export class Component {
  readonly items = input.required<string[]>();
  readonly tags = input<string[]>([]);
}
```

```html
<ul>
  <li *ngFor="let item of items()">{{ item }}</li>
</ul>
```

### Angular 19- (Legacy)

```typescript
@Component({...})
export class ComponentComponent {
  @Input() items: string[] = [];
  @Input() tags: string[] = [];
}
```

```html
<ul>
  <li *ngFor="let item of items">{{ item }}</li>
</ul>
```

## Object Props

### React/Next.js/Remix/React Router/SolidJS

```typescript
interface User {
  id: string;
  name: string;
  email?: string;
}

interface Props {
  user: User;
  settings?: Record<string, any>;
}

export function Component({ user, settings = {} }: Props) {
  return <div>{user.name}</div>;
}
```

### Vue/Nuxt

```vue
<script setup lang="ts">
interface User {
  id: string;
  name: string;
  email?: string;
}

interface Props {
  user: User;
  settings?: Record<string, any>;
}

const props = withDefaults(defineProps<Props>(), {
  settings: () => ({})
});
</script>

<template>
  <div>{{ user.name }}</div>
</template>
```

### Svelte/SvelteKit

```svelte
<script lang="ts">
export let user: { id: string; name: string; email?: string };
export let settings: Record<string, any> = {};
</script>

<div>{user.name}</div>
```

### Angular 20+ (Signals)

```typescript
import { Component, input } from '@angular/core';

@Component({...})
export class Component {
  readonly user = input.required<{ id: string; name: string }>();
  readonly settings = input<Record<string, any>>({});
}
```

### Angular 19- (Legacy)

```typescript
@Component({...})
export class ComponentComponent {
  @Input() user!: { id: string; name: string };
  @Input() settings: Record<string, any> = {};
}
```

## Function Props (Callbacks)

### React/Next.js/Remix/React Router/SolidJS

```typescript
interface Props {
  onSubmit: (data: FormData) => void;
  onClick?: () => void;
  onChange?: (value: string) => void;
}

export function Component({ onSubmit, onClick, onChange }: Props) {
  return (
    <form onSubmit={(e) => onSubmit(new FormData(e.currentTarget))}>
      <button onClick={onClick}>Click</button>
      <input onChange={(e) => onChange(e.target.value)} />
    </form>
  );
}
```

### Vue/Nuxt

```vue
<script setup lang="ts">
interface Props {
  onSubmit: (data: FormData) => void;
  onClick?: () => void;
  onChange?: (value: string) => void;
}

const props = defineProps<Props>();
const emit = defineEmits<{
  submit: [data: FormData];
  click: [];
  change: [value: string];
}>();

const handleSubmit = (e: Event) => {
  emit('submit', new FormData(e.target as HTMLFormElement));
};
</script>

<template>
  <form @submit="handleSubmit">
    <button @click="$emit('click')">Click</button>
    <input @input="$emit('change', $event.target.value)" />
  </form>
</template>
```

### Svelte/SvelteKit

```svelte
<script lang="ts">
export let onSubmit: (data: FormData) => void;
export let onClick: () => void = () => {};
export let onChange: (value: string) => void = () => {};

const dispatch = createEventDispatcher();

function handleSubmit(e: Event) {
  onSubmit(new FormData(e.target as HTMLFormElement));
}
</script>

<form on:submit={handleSubmit}>
  <button on:click={onClick}>Click</button>
  <input on:change={(e) => onChange(e.target.value)} />
</form>
```

### Angular 20+ (Signals)

```typescript
import { Component, input, output } from '@angular/core';

@Component({...})
export class Component {
  readonly onSubmit = input.required<(data: FormData) => void>();
  readonly onClick = output<void>();
  readonly onChange = output<string>();

  handleClick() {
    this.onClick.emit();
  }

  handleChange(value: string) {
    this.onChange.emit(value);
  }
}
```

```html
<form (submit)="onSubmit($event)">
  <button (click)="handleClick()">Click</button>
  <input (input)="handleChange($event.target.value)" />
</form>
```

### Angular 19- (Legacy)

```typescript
@Component({...})
export class ComponentComponent {
  @Input() onSubmit!: (data: FormData) => void;
  @Output() onClick = new EventEmitter<void>();
  @Output() onChange = new EventEmitter<string>();

  handleClick() {
    this.onClick.emit();
  }

  handleChange(value: string) {
    this.onChange.emit(value);
  }
}
```

```html
<form (submit)="onSubmit($event)">
  <button (click)="handleClick()">Click</button>
  <input (input)="handleChange($event.target.value)" />
</form>
```

## Children Props

### React/Next.js/Remix/React Router/SolidJS

```typescript
interface Props {
  children: React.ReactNode;
  header?: React.ReactNode;
  footer?: React.ReactNode;
}

export function Component({ children, header, footer }: Props) {
  return (
    <div>
      {header && <header>{header}</header>}
      <main>{children}</main>
      {footer && <footer>{footer}</footer>}
    </div>
  );
}
```

### Vue/Nuxt

```vue
<script setup lang="ts">
interface Props {
  header?: any;
  footer?: any;
}

defineProps<Props>();
defineSlots<{
  default(props: {}): any;
  header(props: {}): any;
  footer(props: {}): any;
}>();
</script>

<template>
  <div>
    <slot name="header" />
    <slot />
    <slot name="footer" />
  </div>
</template>
```

### Svelte/SvelteKit

```svelte
<script lang="ts">
export let header: any = null;
export let footer: any = null;
</script>

<div>
  {#if header}
    <slot name="header" />
  {/if}
  <slot />
  {#if footer}
    <slot name="footer" />
  {/if}
</div>
```

### Angular 20+ (Signals)

```typescript
import { Component, input } from '@angular/core';

@Component({...})
export class Component {
  readonly header = input<any>(null);
  readonly footer = input<any>(null);
}
```

```html
<div>
  <ng-content select="header" />
  <ng-content />
  <ng-content select="footer" />
</div>
```

### Angular 19- (Legacy)

```typescript
@Component({...})
export class ComponentComponent {
  @ContentChild('header') headerRef!: ElementRef;
  @ContentChild('footer') footerRef!: ElementRef;
}
```

```html
<div>
  <ng-content select="header" />
  <ng-content />
  <ng-content select="footer" />
</div>
```
