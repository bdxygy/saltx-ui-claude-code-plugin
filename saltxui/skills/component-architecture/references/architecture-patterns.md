# Component Architecture Patterns

Common architectural patterns for component design.

## Container/Presentational Pattern

Separate data fetching logic from UI rendering.

### Container Component

**Responsibilities:**
- Data fetching
- State management
- Business logic
- Pass data to presentational component

```tsx
// Container
export function UserListContainer() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchUsers().then(data => {
      setUsers(data);
      setLoading(false);
    });
  }, []);

  if (loading) return <Spinner />;

  return <UserList users={users} />;
}
```

### Presentational Component

**Responsibilities:**
- UI rendering
- Accept props
- No data fetching
- Pure functions

```tsx
// Presentational
interface Props {
  users: User[];
}

export function UserList({ users }: Props) {
  return (
    <ul>
      {users.map(user => <li key={user.id}>{user.name}</li>)}
    </ul>
  );
}
```

---

## Compound Components

Group related components that work together.

### Pattern

```tsx
// Parent component
export function Card({ children }) {
  return <div className="card">{children}</div>;
}

// Child components
Card.Header = function Header({ children }) {
  return <div className="card-header">{children}</div>;
};

Card.Body = function Body({ children }) {
  return <div className="card-body">{children}</div>;
};

Card.Footer = function Footer({ children }) {
  return <div className="card-footer">{children}</div>;
};
```

### Usage

```tsx
<Card>
  <Card.Header>Title</Card.Header>
  <Card.Body>Content</Card.Body>
  <Card.Footer>Actions</Card.Footer>
</Card>
```

---

## Render Props

Pass rendering logic as a prop.

### Pattern

```tsx
interface Props {
  render: (data: Data) => React.ReactNode;
}

export function DataProvider({ render }: Props) {
  const data = useData();
  return render(data);
}
```

### Usage

```tsx
<DataProvider
  render={(data) => (
    <ul>
      {data.map(item => <li key={item.id}>{item.name}</li>)}
    </ul>
  )}
/>
```

---

## Higher-Order Components

Wrap component to add functionality.

### Pattern

```tsx
function withLoading<P extends object>(Component: React.ComponentType<P>) {
  return (props: P & { isLoading?: boolean }) => {
    if (props.isLoading) {
      return <Spinner />;
    }
    return <Component {...props} />;
  };
}
```

### Usage

```tsx
const UserListWithLoading = withLoading(UserList);

<UserListWithLoading isLoading={true} users={users} />
```

---

## Custom Hooks Pattern

Extract component logic into reusable hooks.

### Hook

```tsx
function useWindowSize() {
  const [size, setSize] = useState({ width: 0, height: 0 });

  useEffect(() => {
    const handleResize = () => {
      setSize({
        width: window.innerWidth,
        height: window.innerHeight
      });
    };

    window.addEventListener('resize', handleResize);
    handleResize();

    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return size;
}
```

### Usage

```tsx
export function ResponsiveComponent() {
  const { width } = useWindowSize();

  return width > 768 ? <DesktopView /> : <MobileView />;
}
```

---

## Controller/View Pattern

Separate business logic from view (similar to container/presentational).

### Controller

```tsx
export function useUserController() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);

  const fetchUsers = async () => {
    setLoading(true);
    const data = await api.getUsers();
    setUsers(data);
    setLoading(false);
  };

  const createUser = async (user: User) => {
    await api.createUser(user);
    await fetchUsers();
  };

  return { users, loading, fetchUsers, createUser };
}
```

### View

```tsx
interface Props {
  users: User[];
  loading: boolean;
  onFetchUsers: () => void;
  onCreateUser: (user: User) => void;
}

export function UserListView({ users, loading, onFetchUsers, onCreateUser }: Props) {
  return <UserList users={users} loading={loading} onRefresh={onFetchUsers} onCreate={onCreateUser} />;
}
```

---

## Composition over Inheritance

Compose components rather than extending them.

### Composition

```tsx
function BaseButton({ children, className, ...props }) {
  return (
    <button className={`btn ${className}`} {...props}>
      {children}
    </button>
  );
}

function PrimaryButton(props) {
  return <BaseButton className="btn-primary" {...props} />;
}

function LargeButton(props) {
  return <BaseButton className="btn-lg" {...props} />;
}
```

### Usage

```tsx
<PrimaryButton size="lg">Click</PrimaryButton>
```

---

## Provider Pattern

Share state or context across components.

### Provider

```tsx
const ThemeContext = createContext({});

export function ThemeProvider({ children, theme }) {
  return (
    <ThemeContext.Provider value={theme}>
      {children}
    </ThemeContext.Provider>
  );
}
```

### Consumer

```tsx
export function ThemedComponent() {
  const theme = useContext(ThemeContext);
  return <div className={theme}>Content</div>;
}
```

---

## Slot Pattern

Placeholder content that can be replaced.

### Pattern

```tsx
interface Props {
  header: React.ReactNode;
  body: React.ReactNode;
  footer?: React.ReactNode;
}

export function Layout({ header, body, footer }: Props) {
  return (
    <div className="layout">
      <header>{header}</header>
      <main>{body}</main>
      {footer && <footer>{footer}</footer>}
    </div>
  );
}
```

### Usage

```tsx
<Layout
  header={<Header />}
  body={<Content />}
  footer={<Footer />}
/>
```

---

## Best Practices

1. **Single Responsibility** - Each component does one thing well
2. **Composition over inheritance** - Compose, don't extend
3. **Props down, events up** - Unidirectional data flow
4. **Container/Presentational** - Separate concerns
5. **Custom hooks** - Extract reusable logic
6. **Compound components** - Group related components
7. **Type safety** - Use TypeScript interfaces
8. **Prop defaults** - Provide sensible defaults
9. **Component naming** - Clear, descriptive names
10. **File organization** - One component per file
