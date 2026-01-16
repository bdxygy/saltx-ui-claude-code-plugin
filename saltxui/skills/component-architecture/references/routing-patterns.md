# Routing Patterns Reference

Complete routing patterns for all supported frameworks.

## Next.js (App Router)

### File Structure

```
apps/web/app/
├── layout.tsx              # Root layout
├── page.tsx                # Home page (/)
├── about/
│   └── page.tsx            # About page (/about)
├── components/
│   ├── button/
│   │   └── page.tsx        # (/components/button)
│   └── [slug]/             # Dynamic route
│       └── page.tsx        # (/components/[slug])
└── api/                    # API routes
```

### Route Definition

```tsx
// apps/web/app/components/login-form/page.tsx
import { LoginForm } from '@/components/login-form';

export default function LoginPage() {
  return <LoginForm />;
}
```

### Dynamic Routes

```tsx
// apps/web/app/components/[slug]/page.tsx
export default function ComponentPage({ params }: { params: { slug: string } }) {
  return <Component name={params.slug} />;
}
```

---

## Remix

### File Structure

```
app/
├── root.tsx                # Root route (/)
├── routes/
│   ├── components.tsx      # (/components)
│   ├── components_
│   │   └── $slug.tsx        # (/components/:slug)
│   └── components.login-form.tsx  # (/components/login-form)
```

### Route Definition

```tsx
// app/routes/components.login-form.tsx
import { LoginForm } from '../components/login-form';

export default function Route() {
  return <LoginForm />;
}
```

### Data Loading

```tsx
// app/routes/components.$slug.tsx
export async function loader({ params }: LoaderFunctionArgs) {
  const component = await fetchComponent(params.slug);
  return { component };
}

export default function Route() {
  const { component } = useLoaderData();
  return <Component {...component} />;
}
```

---

## React Router v7+ (Framework Mode)

### File Structure

```
app/
├── routes.tsx              # Route configuration (optional)
├── routes/
│   ├── index.tsx           # Home (/)
│   ├── components.tsx      # (/components)
│   ├── components_
│   │   └── $slug.tsx       # (/components/:slug)
│   └── components.login-form.tsx  # (/components/login-form)
└──/
```

### Route Definition

```tsx
// app/routes/components.login-form.tsx
import { LoginForm } from '../components/login-form';

export default function Route() {
  return <LoginForm />;
}
```

### Data Loading

```tsx
// app/routes/components.$slug.tsx
export async function loader({ params }: LoaderFunctionArgs) {
  const component = await fetchComponent(params.slug);
  return { component };
}

export default function Route() {
  const { component } = useLoaderData();
  return <Component {...component} />;
}
```

---

## Vue (Vue Router)

### File Structure

```
src/
├── router/
│   └── index.ts           # Route configuration
├── views/
│   └── Components.vue     # Page component
└── components/            # Reusable components
```

### Route Configuration

```typescript
// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router';
import Components from '@/views/Components.vue';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/components',
      component: Components
    },
    {
      path: '/components/:slug',
      component: () => import('@/views/ComponentDetail.vue')
    }
  ]
});

export default router;
```

### Dynamic Routes

```typescript
{
  path: '/components/:slug',
  component: () => import('@/views/ComponentDetail.vue'),
  props: route => ({ slug: route.params.slug })
}
```

---

## Nuxt

### File Structure

```
pages/
├── index.vue               # Home (/)
├── components/
│   ├── index.vue           # (/components)
│   └── [slug].vue          # (/components/:slug)
└── login-form.vue          # (/login-form)
```

### Route Definition

```vue
<!-- pages/components/index.vue -->
<script setup>
import LoginForm from '@/components/LoginForm.vue';
</script>

<template>
  <LoginForm />
</template>
```

### Dynamic Routes

```vue
<!-- pages/components/[slug].vue -->
<script setup>
const route = useRoute();
const slug = route.params.slug;
</script>

<template>
  <Component :name="slug" />
</template>
```

---

## SvelteKit

### File Structure

```
src/
├── routes/
│   ├── +page.svelte        # Home (/)
│   ├── components/
│   │   ├── +page.svelte    # (/components)
│   │   └── [slug]/
│   │       └── +page.svelte  # (/components/:slug)
│   └── login-form/
│       └── +page.svelte
└── lib/
    └── components/         # Reusable components
```

### Route Definition

```svelte
<!-- src/routes/components/+page.svelte -->
<script>
  import { LoginForm } from '$lib/components/LoginForm.svelte';
</script>

<LoginForm />
```

### Data Loading

```svelte
<!-- src/routes/components/[slug]/+page.svelte -->
<script>
  import { Component } from '$lib/components/Component.svelte';

  export async function load({ params }) {
    const component = await fetchComponent(params.slug);
    return { component };
  }
</script>

<Component {...component} />
```

---

## Angular 20+ (New Naming Convention)

### File Structure (Angular 20+)

```
src/app/
├── app.routes.ts          # Route configuration
├── components/
│   ├── button/
│   │   └── button.ts
│   ├── button.html
│   ├── button.css
│   └── login-form/
│       ├── login-form.ts
│       ├── login-form.html
│       └── login-form.css
└── [slug]/
    └── [slug].ts  # Route handler
```

### Route Configuration

```typescript
// src/app/app.routes.ts
import { Routes } from '@angular/router';
import { LoginComponent } from './components/login-form/login-form';
import { ButtonComponent } from './components/button/button';

export const routes: Routes = [
  { path: 'components/login-form', component: LoginComponent },
  { path: 'components/:slug', component: ButtonComponent }
];
```

### Lazy Loading

```typescript
export const routes: Routes = [
  {
    path: 'components/:slug',
    loadComponent: () => import('./components/[slug]/[slug]')
  }
];
```

## Angular 19- (Legacy Naming Convention)

### File Structure (Angular 19-)

```
src/app/
├── app.routes.ts          # Route configuration
├── components/
│   ├── button/
│   │   └── button.component.ts
│   └── login-form/
│       └── login-form.component.ts
└── components/
    └── [slug]/
        └── [slug].component.ts  # Route handler
```

---

## SolidJS

### File Structure

```
src/
├── routes/
│   ├── index.tsx           # Home (/)
│   ├── components.tsx      # (/components)
│   └── components_
│       └── [slug].tsx     # (/components/:slug)
└── components/            # Reusable components
```

### Router Configuration

```tsx
// src/App.tsx
import { Router } from '@solidjs/router';
import Components from './routes/components';
import ComponentDetail from './routes/components_[slug]';

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" component={Home} />
        <Route path="/components" component={Components} />
        <Route path="/components/:slug" component={ComponentDetail} />
      </Routes>
    </Router>
  );
}
```

### Route Definition

```tsx
// src/routes/components_[slug].tsx
import { useParams } from '@solidjs/router';
import { Component } from '../components/Component';

export default function ComponentDetail() {
  const params = useParams();
  return <Component name={params.slug} />;
}
```

---

## Route Parameter Summary

| Framework | Route Pattern | Param Access |
|-----------|--------------|--------------|
| Next.js | `[slug]/page.tsx` | `params.slug` |
| Remix | `.$slug.tsx` | `params.slug` |
| React Router v7+ | `.$slug.tsx` | `params.slug` |
| Vue | `/:slug` in config | `$route.params.slug` |
| Nuxt | `[slug].vue` | `$route.params.slug` |
| SvelteKit | `[slug]/+page.svelte` | `params.slug` in `load()` |
| Angular | `:slug` in path | `ActivatedRoute.snapshot.params.slug` |
| SolidJS | `:[slug]` in path | `useParams().slug` |
