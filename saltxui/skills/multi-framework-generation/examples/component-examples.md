# Multi-Framework Component Examples

## Button Component Examples

Same button component implemented across all frameworks.

### React (TypeScript)

```tsx
import React from 'react';

interface ButtonProps {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  variant?: 'primary' | 'secondary' | 'danger';
  disabled?: boolean;
  onClick?: () => void;
}

export function Button({
  label,
  size = 'md',
  variant = 'primary',
  disabled = false,
  onClick
}: ButtonProps) {
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  };

  const variantClasses = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-600 text-white hover:bg-gray-700',
    danger: 'bg-red-600 text-white hover:bg-red-700'
  };

  return (
    <button
      className={`
        ${sizeClasses[size]} ${variantClasses[variant]}
        rounded font-medium transition
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
}
```

### Next.js (TypeScript)

```tsx
'use client';

import React from 'react';

interface ButtonProps {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  variant?: 'primary' | 'secondary' | 'danger';
  disabled?: boolean;
  onClick?: () => void;
}

export default function Button({
  label,
  size = 'md',
  variant = 'primary',
  disabled = false,
  onClick
}: ButtonProps) {
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  };

  const variantClasses = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-600 text-white hover:bg-gray-700',
    danger: 'bg-red-600 text-white hover:bg-red-700'
  };

  return (
    <button
      className={`
        ${sizeClasses[size]} ${variantClasses[variant]}
        rounded font-medium transition
        ${disabled ? 'opacity-50 cursor-not-allowed' : ''}
      `}
      onClick={onClick}
      disabled={disabled}
    >
      {label}
    </button>
  );
}
```

### Vue (TypeScript)

```vue
<script setup lang="ts">
interface Props {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  variant?: 'primary' | 'secondary' | 'danger';
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md',
  variant: 'primary',
  disabled: false
});

const emit = defineEmits<{
  click: [];
}>();

const sizeClasses = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-base',
  lg: 'px-6 py-3 text-lg'
};

const variantClasses = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700',
  secondary: 'bg-gray-600 text-white hover:bg-gray-700',
  danger: 'bg-red-600 text-white hover:bg-red-700'
};

const handleClick = () => {
  if (!props.disabled) {
    emit('click');
  }
};
</script>

<template>
  <button
    :class="[
      'rounded font-medium transition',
      sizeClasses[size],
      variantClasses[variant],
      { 'opacity-50 cursor-not-allowed': disabled }
    ]"
    :disabled="disabled"
    @click="handleClick"
  >
    {{ label }}
  </button>
</template>
```

### Svelte (TypeScript)

```svelte
<script lang="ts">
export let label: string;
export let size: 'sm' | 'md' | 'lg' = 'md';
export let variant: 'primary' | 'secondary' | 'danger' = 'primary';
export let disabled: boolean = false;

const dispatch = createEventDispatcher();

const sizeClasses = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-base',
  lg: 'px-6 py-3 text-lg'
};

const variantClasses = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700',
  secondary: 'bg-gray-600 text-white hover:bg-gray-700',
  danger: 'bg-red-600 text-white hover:bg-red-700'
};

function handleClick() {
  if (!disabled) {
    dispatch('click');
  }
}
</script>

<button
  class="rounded font-medium transition {sizeClasses[size]} {variantClasses[variant]} {disabled ? 'opacity-50 cursor-not-allowed' : ''}"
  {disabled}
  on:click={handleClick}
>
  {label}
</button>
```

### Angular 20+ (Signals, TypeScript)

```typescript
import { Component, input, output, computed } from '@angular/core';

@Component({
  selector: 'app-button',
  template: `
    <button
      [class]="classes()"
      [disabled]="disabled()"
      (click)="handleClick()"
    >
      {{ label() }}
    </button>
  `,
  styles: [`
    .px-3 { padding-left: 0.75rem; padding-right: 0.75rem; }
    .py-1.5 { padding-top: 0.375rem; padding-bottom: 0.375rem; }
    .px-4 { padding-left: 1rem; padding-right: 1rem; }
    .py-2 { padding-top: 0.5rem; padding-bottom: 0.5rem; }
    .px-6 { padding-left: 1.5rem; padding-right: 1.5rem; }
    .py-3 { padding-top: 0.75rem; padding-bottom: 0.75rem; }
    .text-sm { font-size: 0.875rem; }
    .text-base { font-size: 1rem; }
    .text-lg { font-size: 1.125rem; }
    .rounded { border-radius: 0.25rem; }
    .font-medium { font-weight: 500; }
    .transition { transition-property: all; }
    .bg-blue-600 { background-color: #2563eb; }
    .text-white { color: white; }
    .hover\:bg-blue-700:hover { background-color: #1d4ed8; }
    .opacity-50 { opacity: 0.5; }
    .cursor-not-allowed { cursor: not-allowed; }
  `]
})
export class Button {
  readonly label = input.required<string>();
  readonly size = input<'sm' | 'md' | 'lg'>('md');
  readonly variant = input<'primary' | 'secondary' | 'danger'>('primary');
  readonly disabled = input(false);

  readonly click = output<void>();

  readonly sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  };

  readonly variantClasses = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-600 text-white hover:bg-gray-700',
    danger: 'bg-red-600 text-white hover:bg-red-700'
  };

  readonly classes = computed(() => {
    return [
      'rounded font-medium transition',
      this.sizeClasses[this.size()],
      this.variantClasses[this.variant()],
      this.disabled() ? 'opacity-50 cursor-not-allowed' : ''
    ].join(' ');
  });

  handleClick() {
    if (!this.disabled()) {
      this.click.emit();
    }
  }
}
```

### Angular 19- (Legacy, TypeScript)

```typescript
import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-button',
  template: `
    <button
      [class]="[
        'rounded font-medium transition',
        sizeClasses[size],
        variantClasses[variant],
        disabled ? 'opacity-50 cursor-not-allowed' : ''
      ]"
      [disabled]="disabled"
      (click)="handleClick()"
    >
      {{ label }}
    </button>
  `,
  styles: [`
    .px-3 { padding-left: 0.75rem; padding-right: 0.75rem; }
    .py-1.5 { padding-top: 0.375rem; padding-bottom: 0.375rem; }
    .px-4 { padding-left: 1rem; padding-right: 1rem; }
    .py-2 { padding-top: 0.5rem; padding-bottom: 0.5rem; }
    .px-6 { padding-left: 1.5rem; padding-right: 1.5rem; }
    .py-3 { padding-top: 0.75rem; padding-bottom: 0.75rem; }
    .text-sm { font-size: 0.875rem; }
    .text-base { font-size: 1rem; }
    .text-lg { font-size: 1.125rem; }
    .rounded { border-radius: 0.25rem; }
    .font-medium { font-weight: 500; }
    .transition { transition-property: all; }
    .bg-blue-600 { background-color: #2563eb; }
    .text-white { color: white; }
    .hover\:bg-blue-700:hover { background-color: #1d4ed8; }
    .opacity-50 { opacity: 0.5; }
    .cursor-not-allowed { cursor: not-allowed; }
  `]
})
export class ButtonComponent {
  @Input() label: string = '';
  @Input() size: 'sm' | 'md' | 'lg' = 'md';
  @Input() variant: 'primary' | 'secondary' | 'danger' = 'primary';
  @Input() disabled = false;

  @Output() click = new EventEmitter<void>();

  sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  };

  variantClasses = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-600 text-white hover:bg-gray-700',
    danger: 'bg-red-600 text-white hover:bg-red-700'
  };

  handleClick() {
    if (!this.disabled) {
      this.click.emit();
    }
  }
}
```

### SolidJS (TypeScript)

```tsx
import { Component } from 'solid-js';

interface ButtonProps {
  label: string;
  size?: 'sm' | 'md' | 'lg';
  variant?: 'primary' | 'secondary' | 'danger';
  disabled?: boolean;
  onClick?: () => void;
}

export function Button(props: ButtonProps) {
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-base',
    lg: 'px-6 py-3 text-lg'
  };

  const variantClasses = {
    primary: 'bg-blue-600 text-white hover:bg-blue-700',
    secondary: 'bg-gray-600 text-white hover:bg-gray-700',
    danger: 'bg-red-600 text-white hover:bg-red-700'
  };

  return (
    <button
      class={
        `${sizeClasses[props.size || 'md']} ${variantClasses[props.variant || 'primary']} rounded font-medium transition ${props.disabled ? 'opacity-50 cursor-not-allowed' : ''}`
      }
      onClick={props.onClick}
      disabled={props.disabled}
    >
      {props.label}
    </button>
  );
}
```
