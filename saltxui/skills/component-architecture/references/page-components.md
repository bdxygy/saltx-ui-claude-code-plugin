# Page Components vs Reusable Components

## Page Components

**Definition:** Components that are accessed via a URL route and represent a full page in the application.

**Characteristics:**
- Connected to route
- May fetch data (loaders, hooks)
- Composed of reusable components
- Longer-lived
- Framework-specific routing

**Examples:** Dashboard, Settings, Profile, HomePage

### Page Component Structure

```
Page Component
├── Header (reusable)
├── Sidebar (reusable)
├── Main Content Area
│   ├── Form (reusable)
│   ├── Table (reusable)
│   └── Card (reusable)
└── Footer (reusable)
```

## Reusable Components

**Definition:** Smaller components that can be used in multiple places and are typically part of a page or other components.

**Characteristics:**
- Not directly routed
- Accept props for customization
- Can be composed together
- Shorter-lived
- Framework-agnostic (mostly)

**Examples:** Button, Input, Card, Modal, Dropdown

### Reusable Component Structure

```
Button Component
├── Label/Children
├── Icon (optional)
└── State (disabled, loading)
```

## Decision Tree

```
Is component accessed via URL?
├── YES → Page Component
│   ├── Create route file
│   └── Place in routes/ directory
└── NO → Reusable Component
    └── Place in components/ directory
```

## Composition Patterns

### Compound Components

```
Page (Page Component)
└── Layout (Reusable Compound Component)
    ├── Header (Reusable)
    ├── Sidebar (Reusable)
    └── Content (Slot for page content)
```

### Container/Presentational

```
Page (Container)
├── Data fetching logic
├── State management
└── Component (Presentational)
    └── UI rendering
```

## Best Practices

1. **Keep pages focused** - Page components should compose, not implement UI
2. **Make components reusable** - Design for multiple use cases
3. **Clear separation** - Pages for routing, components for UI
4. **Props interface** - Components accept props, pages may fetch data
5. **File placement** - Pages in routes/, components in components/
