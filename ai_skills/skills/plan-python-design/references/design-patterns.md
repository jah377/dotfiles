<catalog>
Software design patterns organized by category. Use this as a lookup when recommending patterns in Phase 3. Each GoF pattern includes a concise Python example. Adapt these examples to the user's specific task when providing recommendations.
</catalog>

<creational_patterns>
Patterns that deal with object creation mechanisms.

<pattern name="Singleton">
**Singleton** — Ensure a class has only one instance, and provide a global point of access to it.

**When to use**: Shared resource (config, connection pool, logger) that must have exactly one instance.

```python
class DatabaseConfig:
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
            cls._instance._initialized = False
        return cls._instance

    def __init__(self):
        if self._initialized:
            return
        self.host = "localhost"
        self.port = 5432
        self._initialized = True
```

**Python idiom**: A module-level instance is often simpler than a Singleton class. Just create the instance at module scope and import it.
</pattern>

<pattern name="Factory Method">
**Factory Method** — Define an interface for creating an object, but let subclasses decide which class to instantiate.

**When to use**: Code needs to create objects but shouldn't know the exact class. Common when supporting multiple formats, protocols, or backends.

```python
from abc import ABC, abstractmethod

class Serializer(ABC):
    @abstractmethod
    def serialize(self, data: dict) -> str: ...

class JsonSerializer(Serializer):
    def serialize(self, data: dict) -> str:
        import json
        return json.dumps(data)

class XmlSerializer(Serializer):
    def serialize(self, data: dict) -> str:
        return f"<data>{''.join(f'<{k}>{v}</{k}>' for k, v in data.items())}</data>"

def create_serializer(format: str) -> Serializer:
    """Factory method."""
    serializers = {"json": JsonSerializer, "xml": XmlSerializer}
    cls = serializers.get(format)
    if cls is None:
        raise ValueError(f"Unknown format: {format}")
    return cls()
```

</pattern>

<pattern name="Abstract Factory">
**Abstract Factory** — Provide an interface for creating families of related objects without specifying concrete classes.

**When to use**: Need to create groups of related objects that must be used together (e.g., UI themes, platform-specific widgets, database dialects).

```python
from abc import ABC, abstractmethod

class Button(ABC):
    @abstractmethod
    def render(self) -> str: ...

class TextField(ABC):
    @abstractmethod
    def render(self) -> str: ...

class DarkButton(Button):
    def render(self) -> str:
        return "<button class='dark'>Click</button>"

class DarkTextField(TextField):
    def render(self) -> str:
        return "<input class='dark'/>"

class LightButton(Button):
    def render(self) -> str:
        return "<button class='light'>Click</button>"

class LightTextField(TextField):
    def render(self) -> str:
        return "<input class='light'/>"

class UIFactory(ABC):
    @abstractmethod
    def create_button(self) -> Button: ...
    @abstractmethod
    def create_text_field(self) -> TextField: ...

class DarkThemeFactory(UIFactory):
    def create_button(self) -> Button:
        return DarkButton()
    def create_text_field(self) -> TextField:
        return DarkTextField()

class LightThemeFactory(UIFactory):
    def create_button(self) -> Button:
        return LightButton()
    def create_text_field(self) -> TextField:
        return LightTextField()
```

</pattern>

<pattern name="Builder">
**Builder** — Separate the construction of a complex object from its representation.

**When to use**: Object has many optional parameters, or construction requires multiple steps that must happen in a specific order.

```python
from dataclasses import dataclass, field

@dataclass
class Query:
    table: str
    columns: list[str] = field(default_factory=lambda: ["*"])
    conditions: list[str] = field(default_factory=list)
    order_by: str | None = None
    limit: int | None = None

class QueryBuilder:
    def __init__(self, table: str):
        self._query = Query(table=table)

    def select(self, *columns: str) -> "QueryBuilder":
        self._query.columns = list(columns)
        return self

    def where(self, condition: str) -> "QueryBuilder":
        self._query.conditions.append(condition)
        return self

    def order(self, column: str) -> "QueryBuilder":
        self._query.order_by = column
        return self

    def limit(self, n: int) -> "QueryBuilder":
        self._query.limit = n
        return self

    def build(self) -> Query:
        return self._query

# Usage
query = (QueryBuilder("users")
    .select("name", "email")
    .where("active = true")
    .order("created_at")
    .limit(10)
    .build())
```

**Python idiom**: For simple cases, `@dataclass` with default values eliminates the need for a separate builder class.
</pattern>

<pattern name="Prototype">
**Prototype** — Create new objects by cloning an existing instance.

**When to use**: Object creation is expensive, or you need copies of a configured object with minor variations.

```python
import copy

class ReportTemplate:
    def __init__(self, title: str, sections: list[str], style: dict):
        self.title = title
        self.sections = sections
        self.style = style

    def clone(self) -> "ReportTemplate":
        return copy.deepcopy(self)

# Configure a base template once
base = ReportTemplate("Quarterly Report", ["Summary", "Financials"], {"font": "Arial"})

# Clone and customize
q1 = base.clone()
q1.title = "Q1 Report"

q2 = base.clone()
q2.title = "Q2 Report"
q2.sections.append("Projections")
```

</pattern>

<pattern name="Dependency Injection">
**Dependency Injection** — A class accepts the objects it requires from an injector instead of creating them directly.

**When to use**: Decoupling components for testability, swapping implementations (e.g., real vs. mock database).

```python
from typing import Protocol

class EmailSender(Protocol):
    def send(self, to: str, body: str) -> None: ...

class SmtpSender:
    def send(self, to: str, body: str) -> None:
        print(f"SMTP: sending to {to}")

class MockSender:
    def __init__(self):
        self.sent: list[tuple[str, str]] = []

    def send(self, to: str, body: str) -> None:
        self.sent.append((to, body))

class NotificationService:
    def __init__(self, sender: EmailSender):  # injected dependency
        self._sender = sender

    def notify(self, user_email: str, message: str) -> None:
        self._sender.send(user_email, message)
```

</pattern>

<pattern name="Lazy Initialization">
**Lazy Initialization** — Delay creation of an object until it is first needed.

**When to use**: Expensive resources (DB connections, large files) that may not always be used.

```python
class DataAnalyzer:
    def __init__(self, path: str):
        self._path = path
        self._data = None

    @property
    def data(self):
        if self._data is None:
            print(f"Loading {self._path}...")
            self._data = self._load(self._path)
        return self._data

    def _load(self, path: str):
        with open(path) as f:
            return f.read()
```

**Python idiom**: `functools.cached_property` does this in one line for computed attributes.
</pattern>

<pattern name="Object Pool">
**Object Pool** — Recycle expensive objects instead of creating and destroying them repeatedly.

**When to use**: Object creation is costly (DB connections, threads, large buffers) and objects are frequently needed and released.

```python
import queue

class ConnectionPool:
    def __init__(self, factory, max_size: int = 5):
        self._factory = factory
        self._pool: queue.Queue = queue.Queue(maxsize=max_size)
        for _ in range(max_size):
            self._pool.put(factory())

    def acquire(self):
        return self._pool.get()

    def release(self, conn):
        self._pool.put(conn)
```

</pattern>

<pattern name="RAII">
**RAII (Resource Acquisition Is Initialization)** — Tie resource lifetime to object lifetime.

**When to use**: Any resource that must be released (files, locks, connections, temporary directories).

```python
from contextlib import contextmanager

@contextmanager
def managed_connection(host: str):
    conn = connect(host)  # acquire
    try:
        yield conn
    finally:
        conn.close()  # release guaranteed

# Usage
with managed_connection("db.example.com") as conn:
    conn.execute("SELECT 1")
```

**Python idiom**: This is the standard Python approach via context managers (`with` statement).
</pattern>
</creational_patterns>

<structural_patterns>
Patterns that deal with object composition and relationships.

<pattern name="Adapter">
**Adapter (Wrapper)** — Convert the interface of a class into another interface clients expect.

**When to use**: Integrating third-party libraries, legacy code, or external APIs whose interface doesn't match yours.

```python
from typing import Protocol

class DataSource(Protocol):
    def fetch_records(self) -> list[dict]: ...

# Third-party class with incompatible interface
class LegacyCsvReader:
    def read_all_rows(self) -> list[list[str]]:
        return [["Alice", "30"], ["Bob", "25"]]

    def get_headers(self) -> list[str]:
        return ["name", "age"]

class CsvAdapter:
    """Adapts LegacyCsvReader to DataSource interface."""
    def __init__(self, reader: LegacyCsvReader):
        self._reader = reader

    def fetch_records(self) -> list[dict]:
        headers = self._reader.get_headers()
        return [dict(zip(headers, row)) for row in self._reader.read_all_rows()]
```

</pattern>

<pattern name="Bridge">
**Bridge** — Decouple an abstraction from its implementation so both can vary independently.

**When to use**: You have two orthogonal dimensions of variation (e.g., shape × renderer, notification × channel).

```python
from abc import ABC, abstractmethod

class Renderer(ABC):
    @abstractmethod
    def render(self, content: str) -> str: ...

class HtmlRenderer(Renderer):
    def render(self, content: str) -> str:
        return f"<div>{content}</div>"

class MarkdownRenderer(Renderer):
    def render(self, content: str) -> str:
        return f"**{content}**"

class Notification(ABC):
    def __init__(self, renderer: Renderer):
        self._renderer = renderer

    @abstractmethod
    def get_content(self) -> str: ...

    def display(self) -> str:
        return self._renderer.render(self.get_content())

class AlertNotification(Notification):
    def get_content(self) -> str:
        return "System alert!"

class InfoNotification(Notification):
    def get_content(self) -> str:
        return "FYI update"

# Mix and match: any notification type × any renderer
alert_html = AlertNotification(HtmlRenderer())
info_md = InfoNotification(MarkdownRenderer())
```

</pattern>

<pattern name="Composite">
**Composite** — Compose objects into tree structures; treat individual objects and compositions uniformly.

**When to use**: Tree-structured data (file systems, org charts, UI components, nested categories).

```python
from abc import ABC, abstractmethod

class FileSystemItem(ABC):
    def __init__(self, name: str):
        self.name = name

    @abstractmethod
    def size(self) -> int: ...

class File(FileSystemItem):
    def __init__(self, name: str, size: int):
        super().__init__(name)
        self._size = size

    def size(self) -> int:
        return self._size

class Directory(FileSystemItem):
    def __init__(self, name: str):
        super().__init__(name)
        self.children: list[FileSystemItem] = []

    def add(self, item: FileSystemItem) -> None:
        self.children.append(item)

    def size(self) -> int:
        return sum(child.size() for child in self.children)

# Usage
root = Directory("root")
root.add(File("readme.md", 100))
src = Directory("src")
src.add(File("main.py", 500))
root.add(src)
print(root.size())  # 600
```

</pattern>

<pattern name="Decorator">
**Decorator** — Attach additional responsibilities to an object dynamically, keeping the same interface.

**When to use**: Adding behavior (logging, caching, auth checks, retries) without modifying existing classes.

```python
from typing import Protocol

class DataSource(Protocol):
    def read(self) -> str: ...
    def write(self, data: str) -> None: ...

class FileDataSource:
    def __init__(self, path: str):
        self._path = path

    def read(self) -> str:
        with open(self._path) as f:
            return f.read()

    def write(self, data: str) -> None:
        with open(self._path, "w") as f:
            f.write(data)

class EncryptionDecorator:
    def __init__(self, source: DataSource):
        self._source = source

    def read(self) -> str:
        data = self._source.read()
        return self._decrypt(data)

    def write(self, data: str) -> None:
        self._source.write(self._encrypt(data))

    def _encrypt(self, data: str) -> str:
        return data[::-1]  # trivial example

    def _decrypt(self, data: str) -> str:
        return data[::-1]

# Stack decorators
source = EncryptionDecorator(FileDataSource("data.txt"))
```

**Python idiom**: For function-level decoration, use Python's `@decorator` syntax. The OOP Decorator pattern is for wrapping objects.
</pattern>

<pattern name="Facade">
**Facade** — Provide a simplified interface to a complex subsystem.

**When to use**: Subsystem has many classes/steps; callers need a simple high-level API.

```python
class VideoConverter:
    """Facade over a complex video processing subsystem."""

    def convert(self, input_path: str, output_format: str) -> str:
        # Hides complexity of codec selection, bitrate, temp files, etc.
        source = VideoFile(input_path)
        codec = CodecFactory.get_codec(output_format)
        buffer = BitrateReader.read(source, codec)
        result = AudioMixer.fix(buffer)
        output_path = f"{input_path.rsplit('.', 1)[0]}.{output_format}"
        result.save(output_path)
        return output_path
```

</pattern>

<pattern name="Flyweight">
**Flyweight** — Share common state among many objects to reduce memory usage.

**When to use**: Large number of similar objects where most state is shared (text characters, game tiles, icons).

```python
class TreeType:
    """Shared state (flyweight). Created once per unique combination."""
    def __init__(self, species: str, color: str, texture: str):
        self.species = species
        self.color = color
        self.texture = texture

class TreeFactory:
    _cache: dict[tuple, TreeType] = {}

    @classmethod
    def get_type(cls, species: str, color: str, texture: str) -> TreeType:
        key = (species, color, texture)
        if key not in cls._cache:
            cls._cache[key] = TreeType(species, color, texture)
        return cls._cache[key]

class Tree:
    """Unique state per instance. References shared flyweight."""
    def __init__(self, x: int, y: int, tree_type: TreeType):
        self.x = x
        self.y = y
        self.type = tree_type
```

</pattern>

<pattern name="Proxy">
**Proxy** — Provide a surrogate or placeholder to control access to another object.

**When to use**: Lazy loading, access control, logging, caching, or remote object access.

```python
from typing import Protocol

class Image(Protocol):
    def display(self) -> str: ...

class HighResImage:
    def __init__(self, path: str):
        self._path = path
        self._data = self._load(path)  # expensive

    def _load(self, path: str) -> bytes:
        print(f"Loading {path} from disk...")
        return b"image_data"

    def display(self) -> str:
        return f"Displaying {self._path}"

class LazyImageProxy:
    """Defers loading until display() is actually called."""
    def __init__(self, path: str):
        self._path = path
        self._image: HighResImage | None = None

    def display(self) -> str:
        if self._image is None:
            self._image = HighResImage(self._path)
        return self._image.display()
```

</pattern>

<pattern name="Delegation">
**Delegation** — Extend a class by composition instead of subclassing.

**When to use**: Prefer composition over inheritance; delegate behavior to contained objects.

```python
class Printer:
    def print_message(self, msg: str) -> None:
        print(msg)

class Logger:
    def __init__(self, printer: Printer):
        self._printer = printer  # delegate

    def log(self, msg: str) -> None:
        self._printer.print_message(f"[LOG] {msg}")
```

</pattern>
</structural_patterns>

<behavioral_patterns>
Patterns that deal with communication between objects.

<pattern name="Chain of Responsibility">
**Chain of Responsibility** — Pass a request along a chain of handlers until one handles it.

**When to use**: Multiple handlers can process a request; the handler isn't known in advance (middleware, validation pipelines, event handling).

```python
from abc import ABC, abstractmethod

class Handler(ABC):
    def __init__(self):
        self._next: Handler | None = None

    def set_next(self, handler: "Handler") -> "Handler":
        self._next = handler
        return handler

    def handle(self, request: dict) -> str | None:
        if self._next:
            return self._next.handle(request)
        return None

class AuthHandler(Handler):
    def handle(self, request: dict) -> str | None:
        if not request.get("authenticated"):
            return "Auth failed"
        return super().handle(request)

class RateLimitHandler(Handler):
    def handle(self, request: dict) -> str | None:
        if request.get("rate_exceeded"):
            return "Rate limited"
        return super().handle(request)

class BusinessHandler(Handler):
    def handle(self, request: dict) -> str | None:
        return "Request processed"

# Build chain
auth = AuthHandler()
auth.set_next(RateLimitHandler()).set_next(BusinessHandler())
result = auth.handle({"authenticated": True, "rate_exceeded": False})
```

</pattern>

<pattern name="Command">
**Command** — Encapsulate a request as an object, enabling parameterization, queueing, logging, and undo.

**When to use**: Undo/redo, task queues, macro recording, transactional operations.

```python
from abc import ABC, abstractmethod

class Command(ABC):
    @abstractmethod
    def execute(self) -> None: ...
    @abstractmethod
    def undo(self) -> None: ...

class InsertTextCommand(Command):
    def __init__(self, document: list[str], position: int, text: str):
        self._doc = document
        self._pos = position
        self._text = text

    def execute(self) -> None:
        self._doc.insert(self._pos, self._text)

    def undo(self) -> None:
        self._doc.pop(self._pos)

class CommandHistory:
    def __init__(self):
        self._history: list[Command] = []

    def execute(self, cmd: Command) -> None:
        cmd.execute()
        self._history.append(cmd)

    def undo_last(self) -> None:
        if self._history:
            self._history.pop().undo()
```

**Python idiom**: For simple commands without undo, a callable (function or lambda) often suffices.
</pattern>

<pattern name="Interpreter">
**Interpreter** — Define a representation for a grammar and an interpreter that uses it.

**When to use**: Domain-specific languages, rule engines, expression evaluators, query parsers.

```python
from abc import ABC, abstractmethod

class Expression(ABC):
    @abstractmethod
    def interpret(self, context: dict[str, bool]) -> bool: ...

class Variable(Expression):
    def __init__(self, name: str):
        self.name = name

    def interpret(self, context: dict[str, bool]) -> bool:
        return context.get(self.name, False)

class And(Expression):
    def __init__(self, left: Expression, right: Expression):
        self.left = left
        self.right = right

    def interpret(self, context: dict[str, bool]) -> bool:
        return self.left.interpret(context) and self.right.interpret(context)

class Or(Expression):
    def __init__(self, left: Expression, right: Expression):
        self.left = left
        self.right = right

    def interpret(self, context: dict[str, bool]) -> bool:
        return self.left.interpret(context) or self.right.interpret(context)

# "is_admin AND (has_ticket OR is_oncall)"
expr = And(Variable("is_admin"), Or(Variable("has_ticket"), Variable("is_oncall")))
print(expr.interpret({"is_admin": True, "has_ticket": False, "is_oncall": True}))  # True
```

</pattern>

<pattern name="Iterator">
**Iterator** — Access elements of a collection sequentially without exposing its internals.

**When to use**: Custom collections, lazy evaluation, streaming data.

```python
class PaginatedAPI:
    """Iterates over paginated API results transparently."""
    def __init__(self, base_url: str, page_size: int = 100):
        self._url = base_url
        self._page_size = page_size

    def __iter__(self):
        page = 0
        while True:
            results = self._fetch(page)
            if not results:
                break
            yield from results
            page += 1

    def _fetch(self, page: int) -> list[dict]:
        # HTTP call to API
        ...
```

**Python idiom**: Implement `__iter__` and `__next__`, or use a generator function. Python's iterator protocol is the native expression of this pattern.
</pattern>

<pattern name="Mediator">
**Mediator** — Centralize complex communication between objects so they don't reference each other directly.

**When to use**: Many-to-many relationships between components (chat rooms, form validation, air traffic control, event buses).

```python
class EventBus:
    """Mediator that decouples publishers from subscribers."""
    def __init__(self):
        self._handlers: dict[str, list] = {}

    def subscribe(self, event: str, handler) -> None:
        self._handlers.setdefault(event, []).append(handler)

    def publish(self, event: str, data=None) -> None:
        for handler in self._handlers.get(event, []):
            handler(data)

# Components communicate through the mediator, not each other
bus = EventBus()
bus.subscribe("order_placed", lambda order: print(f"Inventory: reserve {order}"))
bus.subscribe("order_placed", lambda order: print(f"Email: confirm {order}"))
bus.publish("order_placed", {"id": 123, "item": "widget"})
```

</pattern>

<pattern name="Memento">
**Memento** — Capture and restore an object's state without violating encapsulation.

**When to use**: Undo systems, save/load state, checkpoints, transaction rollback.

```python
from dataclasses import dataclass, asdict
import copy

@dataclass
class EditorState:
    content: str
    cursor_pos: int
    selection: tuple[int, int] | None = None

class Editor:
    def __init__(self):
        self._state = EditorState(content="", cursor_pos=0)

    def save(self) -> EditorState:
        return copy.deepcopy(self._state)

    def restore(self, state: EditorState) -> None:
        self._state = copy.deepcopy(state)

    def type_text(self, text: str) -> None:
        self._state.content += text
        self._state.cursor_pos += len(text)

# Usage with undo stack
editor = Editor()
history: list[EditorState] = []
history.append(editor.save())
editor.type_text("Hello")
history.append(editor.save())
editor.type_text(" World")
editor.restore(history[-1])  # undo last change
```

</pattern>

<pattern name="Observer">
**Observer (Publish-Subscribe)** — When one object changes state, all dependents are notified automatically.

**When to use**: Event systems, reactive data binding, model-view synchronization, plugin notifications.

```python
from typing import Protocol

class Observer(Protocol):
    def update(self, event: str, data: dict) -> None: ...

class Observable:
    def __init__(self):
        self._observers: list[Observer] = []

    def attach(self, observer: Observer) -> None:
        self._observers.append(observer)

    def notify(self, event: str, data: dict) -> None:
        for observer in self._observers:
            observer.update(event, data)

class PriceTracker(Observable):
    def __init__(self):
        super().__init__()
        self._price = 0.0

    def set_price(self, price: float) -> None:
        self._price = price
        self.notify("price_changed", {"price": price})

class AlertSystem:
    def update(self, event: str, data: dict) -> None:
        if data["price"] > 100:
            print(f"ALERT: Price is {data['price']}")
```

</pattern>

<pattern name="State">
**State** — Allow an object to alter its behavior when its internal state changes.

**When to use**: Object behavior depends on its state, and state transitions have defined rules (order processing, UI states, game states, workflow engines).

```python
from abc import ABC, abstractmethod

class OrderState(ABC):
    @abstractmethod
    def ship(self, order: "Order") -> None: ...
    @abstractmethod
    def cancel(self, order: "Order") -> None: ...

class PendingState(OrderState):
    def ship(self, order: "Order") -> None:
        print("Shipping order...")
        order.state = ShippedState()

    def cancel(self, order: "Order") -> None:
        print("Cancelling order...")
        order.state = CancelledState()

class ShippedState(OrderState):
    def ship(self, order: "Order") -> None:
        print("Already shipped")

    def cancel(self, order: "Order") -> None:
        print("Cannot cancel shipped order")

class CancelledState(OrderState):
    def ship(self, order: "Order") -> None:
        print("Cannot ship cancelled order")

    def cancel(self, order: "Order") -> None:
        print("Already cancelled")

class Order:
    def __init__(self):
        self.state: OrderState = PendingState()

    def ship(self) -> None:
        self.state.ship(self)

    def cancel(self) -> None:
        self.state.cancel(self)
```

</pattern>

<pattern name="Strategy">
**Strategy** — Define a family of algorithms, encapsulate each one, and make them interchangeable.

**When to use**: Multiple algorithms for the same task; the choice depends on runtime conditions (sorting, pricing, compression, routing).

```python
from typing import Protocol

class PricingStrategy(Protocol):
    def calculate(self, base_price: float) -> float: ...

class RegularPricing:
    def calculate(self, base_price: float) -> float:
        return base_price

class MemberPricing:
    def calculate(self, base_price: float) -> float:
        return base_price * 0.9

class BulkPricing:
    def calculate(self, base_price: float) -> float:
        return base_price * 0.75

class ShoppingCart:
    def __init__(self, strategy: PricingStrategy):
        self._strategy = strategy

    def total(self, prices: list[float]) -> float:
        return sum(self._strategy.calculate(p) for p in prices)

cart = ShoppingCart(MemberPricing())
print(cart.total([100.0, 200.0]))  # 270.0
```

**Python idiom**: For simple strategies, pass a callable instead of a class:

```python
def member_pricing(price: float) -> float:
    return price * 0.9

total = sum(member_pricing(p) for p in prices)
```

</pattern>

<pattern name="Template Method">
**Template Method** — Define the skeleton of an algorithm in a base class, deferring specific steps to subclasses.

**When to use**: Multiple variants of an algorithm share the same structure but differ in specific steps (data pipelines, report generators, test frameworks).

```python
from abc import ABC, abstractmethod

class DataPipeline(ABC):
    def run(self, source: str) -> dict:
        """Template method — defines the algorithm structure."""
        raw = self.extract(source)
        clean = self.transform(raw)
        result = self.load(clean)
        return result

    @abstractmethod
    def extract(self, source: str) -> list[dict]: ...

    @abstractmethod
    def transform(self, data: list[dict]) -> list[dict]: ...

    def load(self, data: list[dict]) -> dict:
        """Default implementation; override if needed."""
        return {"records": len(data), "data": data}

class CsvPipeline(DataPipeline):
    def extract(self, source: str) -> list[dict]:
        import csv
        with open(source) as f:
            return list(csv.DictReader(f))

    def transform(self, data: list[dict]) -> list[dict]:
        return [{k: v.strip() for k, v in row.items()} for row in data]

class ApiPipeline(DataPipeline):
    def extract(self, source: str) -> list[dict]:
        import requests
        return requests.get(source).json()

    def transform(self, data: list[dict]) -> list[dict]:
        return [row for row in data if row.get("active")]
```

</pattern>

<pattern name="Visitor">
**Visitor** — Add new operations to existing object structures without modifying the classes.

**When to use**: Need to perform many unrelated operations on a structure of objects; adding methods to each class would bloat them (AST processing, document export, tax calculations).

```python
from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def accept(self, visitor: "ShapeVisitor"): ...

class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def accept(self, visitor: "ShapeVisitor"):
        return visitor.visit_circle(self)

class Rectangle(Shape):
    def __init__(self, width: float, height: float):
        self.width = width
        self.height = height

    def accept(self, visitor: "ShapeVisitor"):
        return visitor.visit_rectangle(self)

class ShapeVisitor(ABC):
    @abstractmethod
    def visit_circle(self, circle: Circle): ...
    @abstractmethod
    def visit_rectangle(self, rect: Rectangle): ...

class AreaCalculator(ShapeVisitor):
    def visit_circle(self, circle: Circle) -> float:
        import math
        return math.pi * circle.radius ** 2

    def visit_rectangle(self, rect: Rectangle) -> float:
        return rect.width * rect.height

class SvgExporter(ShapeVisitor):
    def visit_circle(self, circle: Circle) -> str:
        return f'<circle r="{circle.radius}"/>'

    def visit_rectangle(self, rect: Rectangle) -> str:
        return f'<rect width="{rect.width}" height="{rect.height}"/>'
```

</pattern>

<pattern name="Null Object">
**Null Object** — Provide a default object instead of null references.

**When to use**: Eliminate null checks throughout the code; provide safe default behavior.

```python
from typing import Protocol

class Logger(Protocol):
    def log(self, message: str) -> None: ...

class FileLogger:
    def log(self, message: str) -> None:
        print(f"[LOG] {message}")

class NullLogger:
    def log(self, message: str) -> None:
        pass  # silently does nothing

class Service:
    def __init__(self, logger: Logger | None = None):
        self._logger = logger or NullLogger()

    def process(self) -> None:
        self._logger.log("Processing started")  # no null check needed
```

</pattern>

<pattern name="Specification">
**Specification** — Combine business rules as composable boolean predicates.

**When to use**: Complex, recombinable filtering or validation logic (product eligibility, access control, search filters).

```python
from abc import ABC, abstractmethod

class Specification(ABC):
    @abstractmethod
    def is_satisfied_by(self, item) -> bool: ...

    def __and__(self, other: "Specification") -> "Specification":
        return AndSpec(self, other)

    def __or__(self, other: "Specification") -> "Specification":
        return OrSpec(self, other)

    def __invert__(self) -> "Specification":
        return NotSpec(self)

class AndSpec(Specification):
    def __init__(self, a: Specification, b: Specification):
        self._a, self._b = a, b
    def is_satisfied_by(self, item) -> bool:
        return self._a.is_satisfied_by(item) and self._b.is_satisfied_by(item)

class OrSpec(Specification):
    def __init__(self, a: Specification, b: Specification):
        self._a, self._b = a, b
    def is_satisfied_by(self, item) -> bool:
        return self._a.is_satisfied_by(item) or self._b.is_satisfied_by(item)

class NotSpec(Specification):
    def __init__(self, spec: Specification):
        self._spec = spec
    def is_satisfied_by(self, item) -> bool:
        return not self._spec.is_satisfied_by(item)

# Usage
class InStock(Specification):
    def is_satisfied_by(self, product) -> bool:
        return product.quantity > 0

class PriceBelow(Specification):
    def __init__(self, max_price: float):
        self._max = max_price
    def is_satisfied_by(self, product) -> bool:
        return product.price < self._max

affordable_available = InStock() & PriceBelow(50.0)
```

</pattern>
</behavioral_patterns>

<concurrency_patterns>
Patterns that deal with multi-threaded and parallel programming.

- **Active Object** — Decouple method execution from method invocation; each object resides in its own thread of control
- **Double-Checked Locking** — Reduce the overhead of acquiring a lock by first testing the locking criterion without holding the lock
- **Monitor Object** — An object whose methods are subject to mutual exclusion, preventing multiple threads from concurrently executing them
- **Read-Write Lock** — Allow concurrent read access to a resource but require exclusive access for write operations

<pattern name="Thread Pool">
**Thread Pool** — Create a pool of worker threads to execute tasks concurrently.

**When to use**: I/O-bound work (HTTP requests, file operations, DB queries) that can run in parallel.

```python
from concurrent.futures import ThreadPoolExecutor, as_completed

def fetch_url(url: str) -> dict:
    import urllib.request
    with urllib.request.urlopen(url) as resp:
        return {"url": url, "status": resp.status}

urls = ["https://example.com", "https://example.org"]

with ThreadPoolExecutor(max_workers=5) as pool:
    futures = {pool.submit(fetch_url, url): url for url in urls}
    for future in as_completed(futures):
        result = future.result()
        print(f"{result['url']}: {result['status']}")
```

**Python idiom**: Use `ThreadPoolExecutor` for I/O-bound work, `ProcessPoolExecutor` for CPU-bound work. Both share the same `concurrent.futures` interface.
</pattern>

<pattern name="Reactor">
**Reactor** — Event loop that dispatches I/O events to handlers asynchronously.

**When to use**: High-concurrency I/O (web servers, chat systems, API aggregators) where thread-per-connection doesn't scale.

```python
import asyncio

async def fetch(session, url: str) -> dict:
    async with session.get(url) as resp:
        return {"url": url, "status": resp.status}

async def main():
    import aiohttp
    async with aiohttp.ClientSession() as session:
        tasks = [fetch(session, url) for url in urls]
        results = await asyncio.gather(*tasks)
        for r in results:
            print(f"{r['url']}: {r['status']}")

asyncio.run(main())
```

**Python idiom**: Python's `asyncio` is a Reactor implementation. Use `async/await` for I/O-bound concurrency when you need thousands of concurrent operations.
</pattern>
</concurrency_patterns>

<functional_patterns>
Patterns rooted in functional programming that manage data flow and error handling.

<pattern name="Monad (Result/Option)">
**Monad (Result/Option)** — Wrap values in a context (success/failure, present/absent) and chain operations safely.

**When to use**: Sequential operations that can each fail; replacing nested try/except or None-checking with composable pipelines.

```python
from dataclasses import dataclass
from typing import TypeVar, Generic, Callable

T = TypeVar("T")
U = TypeVar("U")
E = TypeVar("E")


@dataclass(frozen=True)
class Ok(Generic[T]):
    value: T
    ok: bool = True


@dataclass(frozen=True)
class Err(Generic[E]):
    error: E
    ok: bool = False


Result = Ok[T] | Err[E]


def map_result(result: Result[T, E], fn: Callable[[T], U]) -> Result[U, E]:
    if result.ok:
        return Ok(fn(result.value))
    return result


def flat_map(result: Result[T, E], fn: Callable[[T], Result[U, E]]) -> Result[U, E]:
    if result.ok:
        return fn(result.value)
    return result


# Usage — compose operations safely
def parse_json(raw: str) -> Result[dict, str]:
    import json
    try:
        return Ok(json.loads(raw))
    except json.JSONDecodeError as e:
        return Err(str(e))


def validate(data: dict) -> Result[dict, str]:
    if "name" not in data:
        return Err("missing 'name'")
    return Ok(data)


def save(data: dict) -> Result[int, str]:
    return Ok(1)  # return saved ID


result = flat_map(flat_map(parse_json('{"name": "Alice"}'), validate), save)
```

**Python idiom**: For simple cases, raising exceptions is more Pythonic than Result types. Use Result/Option patterns when composing many fallible steps in data pipelines or when exceptions would obscure control flow.
</pattern>

<pattern name="Pipeline / Middleware">
**Pipeline / Middleware** — Process a request through a chain of composable middleware functions, each able to act before and after the next.

**When to use**: HTTP middleware, data transformation pipelines, plugin systems where each step can wrap the next.

```python
from typing import Any, Callable

# Middleware signature: receives context and a next() callback
Middleware = Callable[["Context", Callable], Any]


class Context:
    def __init__(self, data: dict):
        self.data = data
        self.response: Any = None


class Pipeline:
    def __init__(self):
        self._middlewares: list[Middleware] = []

    def use(self, middleware: Middleware) -> "Pipeline":
        self._middlewares.append(middleware)
        return self

    def execute(self, context: Context) -> None:
        index = 0

        def next_fn():
            nonlocal index
            if index < len(self._middlewares):
                mw = self._middlewares[index]
                index += 1
                mw(context, next_fn)

        next_fn()


# Example middleware
def logging_middleware(ctx: Context, next_fn: Callable) -> None:
    print(f"Request: {ctx.data}")
    next_fn()
    print(f"Response: {ctx.response}")


def auth_middleware(ctx: Context, next_fn: Callable) -> None:
    if not ctx.data.get("authenticated"):
        ctx.response = "Unauthorized"
        return  # short-circuit, don't call next
    next_fn()


def handler_middleware(ctx: Context, next_fn: Callable) -> None:
    ctx.response = {"status": "ok", "result": 42}


# Compose
pipe = Pipeline().use(logging_middleware).use(auth_middleware).use(handler_middleware)
ctx = Context({"authenticated": True, "user": "alice"})
pipe.execute(ctx)
```

**Python idiom**: For simple linear transforms, a list of functions applied with `functools.reduce` is often enough. The full middleware pattern is most valuable when each step needs to wrap (before/after) the remaining chain.
</pattern>
</functional_patterns>

<anti_patterns>
Common design anti-patterns to recognize and avoid.

| Anti-Pattern | Problem | Solution |
|---|---|---|
| **God Object** | One class handles everything — thousands of lines, dozens of responsibilities | Split into focused classes, each with a single responsibility (SRP) |
| **Spaghetti Code** | Tangled, unstructured dependencies with no clear module boundaries | Apply SRP, extract modules, define clear interfaces between components |
| **Golden Hammer** | Applying one favorite pattern/tool everywhere regardless of fit | Choose the right pattern per problem; no pattern is universally best |
| **Premature Optimization** | Optimizing code before measuring where bottlenecks actually are | Profile first (`cProfile`, `line_profiler`), then optimize the hot path |
| **Lava Flow** | Dead or experimental code left in production because nobody dares remove it | Delete dead code; version control preserves history if needed |
| **Boat Anchor** | Keeping unused code/abstractions "in case we need it later" | YAGNI — delete it; rebuild if actually needed |
</anti_patterns>

<decision_guide>
Quick decision tree for selecting a pattern category.

```
Need to create objects?
├── Complex construction with many optional parts → Builder
├── Family of related objects used together → Abstract Factory
├── Subclass or config decides which type → Factory Method
├── Clone a configured prototype → Prototype
├── Single shared instance → Singleton (prefer module-level instance)
└── Decouple creation from usage → Dependency Injection

Need to structure objects?
├── Make incompatible interfaces work together → Adapter
├── Add behavior dynamically without subclassing → Decorator
├── Simplify a complex subsystem → Facade
├── Control access, lazy-load, or cache → Proxy
├── Two independent dimensions of variation → Bridge
├── Tree structures treated uniformly → Composite
└── Share state across many similar objects → Flyweight

Need to manage behavior?
├── Notify dependents on state change → Observer
├── Swap algorithms at runtime → Strategy
├── Encapsulate actions for undo/queue → Command
├── State-dependent behavior with transitions → State
├── Pass request through handler chain → Chain of Responsibility
├── Define algorithm skeleton, vary steps → Template Method
├── Add operations to structures without modifying them → Visitor
└── Composable boolean business rules → Specification

Need to handle concurrency?
├── I/O-bound parallel work → Thread Pool
├── CPU-bound parallel work → Process Pool
└── High-concurrency async I/O → Reactor (asyncio)
```
</decision_guide>

<python_specific_notes>
Python idioms that affect pattern choice:

- **First-class functions** — Strategy and Command patterns often simplify to passing callables instead of class hierarchies
- **Protocols and ABCs** — Use `typing.Protocol` for structural subtyping or `abc.ABC` for nominal subtyping when defining pattern interfaces
- **Dataclasses** — Builder pattern often simplifies to `@dataclass` with defaults and optional fields
- **Context managers** — RAII maps directly to `__enter__`/`__exit__` or `contextlib.contextmanager`
- **Decorators (language feature)** — The Decorator pattern can be implemented with Python decorators for function-level concerns
- **Generators** — Iterator pattern maps directly to generator functions
- **`__init_subclass__`** — Can replace explicit Factory/Registry patterns for plugin-style extensibility
- **Module-level singletons** — Python modules are singletons; a module-level instance often replaces the Singleton pattern
- **`functools.cached_property`** — Lazy initialization in one line
- **`match` statement (3.10+)** — Can replace Visitor pattern for simple cases with structural pattern matching
</python_specific_notes>
