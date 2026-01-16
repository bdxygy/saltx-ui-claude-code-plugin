# Route Examples

Example route configurations for each framework.

## Next.js App Router

```
Path: /components/login-form
File: apps/web/app/components/login-form/page.tsx
```

```tsx
import { LoginForm } from '@/components/login-form';

export default function LoginPage() {
  return <LoginForm />;
}

// With data fetching
export async function generateMetadata() {
  return {
    title: 'Login - My App'
  };
}

export default function LoginPage() {
  return (
    <div>
      <h1>Login</h1>
      <LoginForm />
    </div>
  );
}
```

## Remix

```
Path: /components/login-form
File: app/routes/components.login-form.tsx
```

```tsx
import { LoginForm } from '../components/login-form';

export default function Route() {
  return (
    <div>
      <h1>Login</h1>
      <LoginForm />
    </div>
  );
}

// With loader
export async function loader({ request }: LoaderFunctionArgs) {
  const userId = await getUserId(request);
  return { userId };
}

export default function Route() {
  const { userId } = useLoaderData();
  return <LoginForm userId={userId} />;
}
```

## React Router v7+ Framework

```
Path: /components/login-form
File: app/routes/components.login-form.tsx
```

```tsx
import { LoginForm } from '../components/login-form';

export default function Route() {
  return (
    <div>
      <h1>Login</h1>
      <LoginForm />
    </div>
  );
}

// With loader
export async function loader({ request }: LoaderFunctionArgs) {
  const userId = await getUserId(request);
  return { userId };
}

export default function Route() {
  const { userId } = useLoaderData();
  return <LoginForm userId={userId} />;
}
```

## Vue (Vue Router)

```
Path: /components/login-form
File: src/router/index.ts + src/views/LoginForm.vue
```

```typescript
// src/router/index.ts
import { createRouter, createWebHistory } from 'vue-router';
import LoginFormView from '@/views/LoginForm.vue';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/components/login-form',
      component: LoginFormView
    }
  ]
});

export default router;
```

```vue
<!-- src/views/LoginForm.vue -->
<script setup>
import LoginForm from '@/components/LoginForm.vue';
</script>

<template>
  <div>
    <h1>Login</h1>
    <LoginForm />
  </div>
</template>
```

## Nuxt

```
Path: /components/login-form
File: pages/components/login-form.vue
```

```vue
<script setup>
import LoginForm from '@/components/LoginForm.vue';
</script>

<template>
  <div>
    <h1>Login</h1>
    <LoginForm />
  </div>
</template>
```

## SvelteKit

```
Path: /components/login-form
File: src/routes/components/login-form/+page.svelte
```

```svelte
<script>
  import LoginForm from '$lib/components/LoginForm.svelte';
</script>

<div>
  <h1>Login</h1>
  <LoginForm />
</div>
```

## Angular 20+ (New Naming Convention)

```
Path: /components/login-form
File: src/app/app.routes.ts + src/app/components/login-form/*
```

```typescript
// src/app/app.routes.ts
import { Routes } from '@angular/router';
import { LoginForm } from './components/login-form/login-form';

export const routes: Routes = [
  { path: 'components/login-form', component: LoginForm }
];
```

```html
<!-- src/app/components/login-form/login-form.html -->
<h1>Login</h1>
<app-login-form></app-login-form>
```

## Angular 19- (Legacy Naming Convention)

```
Path: /components/login-form
File: src/app/app.routes.ts + src/app/components/login-form/*
```

```typescript
// src/app/app.routes.ts
import { Routes } from '@angular/router';
import { LoginFormComponent } from './components/login-form/login-form.component';

export const routes: Routes = [
  { path: 'components/login-form', component: LoginFormComponent }
];
```

```html
<!-- src/app/components/login-form/login-form.component.html -->
<h1>Login</h1>
<app-login-form></app-login-form>
```

## SolidJS

```
Path: /components/login-form
File: src/routes/components-login-form.tsx
```

```tsx
import { LoginForm } from '~/components/LoginForm';

export default function Route() {
  return (
    <div>
      <h1>Login</h1>
      <LoginForm />
    </div>
  );
}
```
