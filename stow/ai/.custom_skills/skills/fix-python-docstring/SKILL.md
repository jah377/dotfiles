---
name: fix-python-docstring
description: Definition of desired python docstring format. All python code
should use Google docstring format.
---

# Fix Python Docstring

When fixing or writing Python docstrings, use **Google docstring format**.

## General Rules

- Summary line should fit on one line and end with a period
- Use a blank line between summary and extended description
- Section headers end with a colon and are followed by an indented block
- Indent continuation lines to align with the first line of text

## Sections

Use these section headers (in this order when applicable):

| Section                   | Purpose                             |
| ------------------------- | ----------------------------------- |
| `Args:`                   | Function/method parameters          |
| `Returns:`                | Return value description            |
| `Yields:`                 | For generators (instead of Returns) |
| `Raises:`                 | Exceptions that may be raised       |
| `Attributes:`             | Class or module attributes          |
| `Example:` or `Examples:` | Usage examples                      |
| `Note:`                   | Important notes                     |
| `Todo:`                   | Future work items                   |

## Parameter Format

```
Args:
    name (type): Description of parameter.
    name (:obj:`type`, optional): Description. Defaults to None.
    *args: Variable length argument list.
    **kwargs: Arbitrary keyword arguments.
```

- Type is optional if using PEP 484 type annotations
- Multi-line descriptions must be indented to align
- Mark optional parameters with `optional` after the type

## Returns Format

```
Returns:
    type: Description of return value.
```

Or without type on same line:

```
Returns:
    Description of return value. True for success, False otherwise.
```

## Raises Format

```
Raises:
    ValueError: If param1 equals param2.
    TypeError: If param1 is not an int.
```

## Class Docstrings

- Summary line describes the class purpose
- Document public attributes in `Attributes:` section
- Document `__init__` in EITHER the class docstring OR the method (not both)
- Do not include `self` in the `Args:` section

```python
class ExampleClass:
    """Short summary of the class.

    Extended description if needed.

    Attributes:
        attr1 (str): Description of attr1.
        attr2 (int): Description of attr2.
    """
```

## Property Docstrings

Document properties in the getter method only:

```python
@property
def name(self):
    """str: Description of the property."""
    return self._name
```

## Examples Section

Use doctest format:

```
Examples:
    >>> print(example_function(4))
    [0, 1, 2, 3]
```

## References

Link to external documentation using reStructuredText:

```
See the `Google Python Style Guide`_ for more details.

.. _Google Python Style Guide:
   http://google.github.io/styleguide/pyguide.html
```
