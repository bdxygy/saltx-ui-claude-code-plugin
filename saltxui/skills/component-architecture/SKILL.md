---
name: Component Architecture & Routing
description: Understand page component structure and routing patterns for all supported frameworks with file-based routing, path parameters, and navigation
version: 1.0.0
---

The Component Architecture & Routing skill provides comprehensive guidance on page component structure and routing patterns for all supported frameworks.

## When to Use This Skill

Activate this skill when:
- User asks about "component architecture"
- User asks about "page component"
- User asks about "route structure"
- User mentions "component patterns"
- User asks about "page routing"
- Creating routes for page components
- Understanding framework-specific routing

## Page Component Structure

**Page Components** are components that are accessed via a URL route and represent a full page in the application.

**Reusable Components** are smaller components that compose pages and are used in multiple places.

### Page vs Reusable Components

| Aspect | Page Components | Reusable Components |
|--------|----------------|---------------------|
| Location | Route-specific directories | `components/` directory |
| Access | Via URL | Via imports |
| Composition | May use reusable components | Used by pages and other components |
| Routing | Have route files | No route files |

## Framework-Specific Routing

### Next.js (App Router)

**File Structure:**
```
apps/web/app/components/[component-name]/
└── page.tsx                   # Route component
```

**Route Pattern:**
```tsx
// apps/web/app/components/login-form/page.tsx
import { LoginForm } from '@/components/login-form';

export default function LoginPage() {
  return <LoginForm />;
}
```

**URL:** `/components/login-form`

**Dynamic Routes:**
```
app/components/[slug]/page.tsx  → /components/anything
```

### Remix

**File Structure:**
```
app/routes/components.[component-name].tsx
```

**Route Pattern:**
```tsx
// app/routes/components.login-form.tsx
import { LoginForm } from '../components/login-form';

export default function Route() {
  return <LoginForm />;
}
```

**URL:** `/components/login-form`

**Nested Routes:**
```
routes/components.tsx           # Parent
routes/components.$id.tsx       # Child (dynamic)
```

### React Router v7+ Framework

**File Structure:**
```
app/routes/components.[component-name].tsx
```

**Route Pattern:**
```tsx
// app/routes/components.login-form.tsx
import { LoginForm } from '../components/login-form';

export default function Route() {
  return <LoginForm />;
}
```

**URL:** `/components/login-form`

**File-based Routing:**
```
app/routes/
├── index.tsx                   # /
├── components.tsx              # /components
└── components.$id.tsx          # /components/:id
```

### Vue (Vue Router)

**File Structure:**
```
src/pages/components/[component-name].vue
```

**Route Configuration:**
```typescript
// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router';
import ComponentName from '@/pages/components/ComponentName.vue';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/components/component-name',
      component: ComponentName
    }
  ]
});
```

**URL:** `/components/component-name`

### Nuxt

**File Structure:**
```
pages/components/[component-name].vue
```

**Route Pattern:**
```vue
<!-- pages/components/login-form.vue -->
<template>
  <LoginForm />
</template>

<script setup>
import LoginForm from '@/components/LoginForm.vue';
</script>
```

**URL:** `/components/login-form`

**Dynamic Routes:**
```
pages/components/[slug].vue  → /components/anything
```

### Svelte

**File Structure:**
```
src/routes/components/[component-name]/
└── +page.svelte
```

**Route Pattern:**
```svelte
<!-- src/routes/components/login-form/+page.svelte -->
<script>
  import LoginForm from '$lib/components/LoginForm.svelte';
</script>

<LoginForm />
```

**URL:** `/components/login-form`

### SvelteKit

**File Structure:**
```
src/routes/components/[component-name]/
└── +page.svelte
```

**Route Pattern:**
```svelte
<!-- src/routes/components/login-form/+page.svelte -->
<script>
  import LoginForm from '$lib/components/LoginForm.svelte';
</script>

<LoginForm />
```

**URL:** `/components/login-form`

**Data Loading:**
```svelte
<!-- +page.server.js -->
export async function load({ params }) {
  return { data: await fetchData() };
}
```

### Angular 20+ (New Naming Convention)

**File Structure:**
```
src/app/components/[component-name]/
├── [component-name].ts
├── [component-name].html
├── [component-name].css
└── [component-name].spec.ts
```

**Route Configuration:**
```typescript
// src/app/app.routes.ts
import { Routes } from '@angular/router';
import { ComponentName } from './components/component-name/component-name';

export const routes: Routes = [
  {
    path: 'components/component-name',
    component: ComponentName
  }
];
```

**URL:** `/components/component-name`

### Angular 19- (Legacy Naming Convention)

**File Structure:**
```
src/app/components/[component-name]/
├── [component-name].component.ts
├── [component-name].component.html
├── [component-name].component.css
└── [component-name].component.spec.ts
```

**Route Configuration:**
```typescript
// src/app/app.routes.ts
import { Routes } from '@angular/router';
import { ComponentNameComponent } from './components/component-name/component-name.component';

export const routes: Routes = [
  {
    path: 'components/component-name',
    component: ComponentNameComponent
  }
];
```

**URL:** `/components/component-name`

### SolidJS

**File Structure:**
```
src/routes/components/[component-name].tsx
```

**Route Pattern:**
```tsx
// src/routes/components/login-form.tsx
import { LoginForm } from '~/components/LoginForm';

export default function Route() {
  return <LoginForm />;
}
```

**URL:** `/components/login-form`

**Using solid-app-router:**
```tsx
import { Router, Routes, Route } from '@solidjs/router';

<Router>
  <Routes>
    <Route path="/components/login-form" component={LoginForm} />
  </Routes>
</Router>
```

## Route Parameter Handling

### Next.js
```tsx
// app/components/[id]/page.tsx
export default function Page({ params }: { params: { id: string } }) {
  return <div>ID: {params.id}</div>;
}
```

### Remix
```tsx
// routes/components.$id.tsx
export function loader({ params }: LoaderFunctionArgs) {
  return { id: params.id };
}

export default function Route() {
  const { id } = useLoaderData();
  return <div>ID: {id}</div>;
}
```

### React Router v7+
```tsx
// app/routes/components.$id.tsx
export function loader({ params }: LoaderFunctionArgs) {
  return { id: params.id };
}

export default function Route() {
  const { id } = useLoaderData();
  return <div>ID: {id}</div>;
}
```

### Vue/Nuxt
```vue
<script setup>
const route = useRoute();
const id = route.params.id;
</script>
```

### SvelteKit
```svelte
<!-- +page.svelte -->
<script>
export let data; // from load function
</script>
```

```javascript
// +page.server.js or +page.js
export async function load({ params }) {
  return { id: params.id };
}
```

### Angular
```typescript
@Component({
  // ...
})
export class ComponentComponent implements OnInit {
  constructor(private route: ActivatedRoute) {}

  ngOnInit() {
    this.route.paramMap.subscribe(params => {
      const id = params.get('id');
    });
  }
}
```

### SolidJS
```tsx
import { useParams } from '@solidjs/router';

export default function Route() {
  const params = useParams();
  return <div>ID: {params.id}</div>;
}
```

## Export Patterns

### React/Next.js/Remix/React Router
```typescript
// Named export
export function ComponentName() {}

// Default export
export default function ComponentName() {}

// Barrel export (index.ts)
export { ComponentName } from './ComponentName';
```

### Vue/Nuxt
```vue
<!-- Single File Component - auto export -->
<script setup>
// Component definition
</script>
```

### Svelte/SvelteKit
```svelte
<!-- Single File Component - auto export -->
<script>
// Component definition
</script>
```

### Angular 20+ (Signals)
```typescript
import { Component, input, output } from '@angular/core';

@Component({
  selector: 'app-component-name',
  // ...
})
export class ComponentName {
  readonly label = input.required<string>();
  readonly click = output<void>();
}
```

### Angular 19- (Legacy)
```typescript
import { Component, Input, Output } from '@angular/core';

@Component({
  selector: 'app-component-name',
  // ...
})
export class ComponentNameComponent {
  @Input() label: string = '';
  @Output() click = new EventEmitter<void>();
}
```

### SolidJS
```tsx
// Named export
export function ComponentName() {}

// Default export
export default function ComponentName();
```

## Composition vs Inheritance

**Composition (Preferred):**
```tsx
// Use composition to build complex components
export function Page() {
  return (
    <Layout>
      <Header />
      <Content />
      <Footer />
    </Layout>
  );
}
```

**Compound Components:**
```tsx
// Parent component with multiple parts
export function Card({ children }) {
  return <div className="card">{children}</div>;
}

Card.Header = function Header({ children }) {
  return <div className="card-header">{children}</div>;
};

Card.Body = function Body({ children }) {
  return <div className="card-body">{children}</div>;
};

// Usage
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>Content</Card.Body>
</Card>
```

## Container/Presentational Separation

**Container Component:**
```tsx
// Handles data fetching, state
export function LoginFormContainer() {
  const [state, dispatch] = useReducer(reducer, initialState);
  const handleSubmit = (data) => dispatch({ type: 'SUBMIT', data });

  return <LoginForm onSubmit={handleSubmit} {...state} />;
}
```

**Presentational Component:**
```tsx
// Only handles UI
interface Props {
  onSubmit: (data) => void;
  error?: string;
  loading?: boolean;
}

export function LoginForm({ onSubmit, error, loading }: Props) {
  return (
    <form onSubmit={onSubmit}>
      {/* Form fields */}
    </form>
  );
}
```

## Best Practices

1. **Page components** in route directories
2. **Reusable components** in components/ directory
3. **Follow framework conventions** for routing
4. **Use composition** over inheritance
5. **Keep routes flat** when possible
6. **Group related routes** in folders
7. **Use barrel exports** for clean imports
8. **Separate concerns** - container vs presentational
9. **Handle errors** at route level
10. **Load data** in loaders/load functions

## References

- **Page Components**: See `references/page-components.md`
- **Routing Patterns**: See `references/routing-patterns.md`
- **Architecture Patterns**: See `references/architecture-patterns.md`
- **Route Examples**: See `examples/route-examples.md`

## Examples

- `examples/route-examples.md` - Framework-specific route examples
