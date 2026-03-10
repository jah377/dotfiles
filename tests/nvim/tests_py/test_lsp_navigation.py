"""
Guide to LSP navigation and preview keybindings

Defaults (Neovim 0.10+):
    - K       : Hover info (type, docstring)
    - CTRL-S  : Signature help [insert mode]
    - CTRL-]  : Jump to definition (tag-style)
    - CTRL-O  : Return to previous position

Diagnostic Navigation:
    - [d : Previous diagnostic
    - ]d : Next diagnostic

Navigation (preview in floating window, <Esc> to close):
    - <leader>ld : Preview definition
    - <leader>lD : Preview declaration
    - <leader>lR : Preview references
    - <leader>lI : Preview implementation
    - <leader>lt : Type definition (Telescope)

Symbols:
    - <leader>ls : Document symbols (Telescope)
    - <leader>lS : Workspace symbols (Telescope)

Actions:
    - <leader>la : Code action
    - <leader>ln : Rename symbol
    - <leader>lf : Format range [visual mode]

Diagnostics:
    - <leader>lq : Send diagnostics to quickfix

Info:
    - <leader>lk : Signature help

Call Hierarchy:
    - <leader>lc : Incoming calls
    - <leader>lC : Outgoing calls

Meta:
    - <leader>lx : Restart LSP
    - <leader>lT : Toggle diagnostics
"""

from typing import Protocol


# =============================================================================
# Test: Go to Definition / Preview Definition
# >> Place cursor on 'helper_function' call and use <leader>ld
# =============================================================================


def helper_function(x: int) -> int:
    """Multiply input by 2."""
    return x * 2


def main_function() -> int:
    result = helper_function(5)
    return result


# =============================================================================
# Test: Find References
# >> Place cursor on 'CONSTANT' and use <leader>lR
# =============================================================================

CONSTANT = 42


def use_constant_once() -> int:
    return CONSTANT + 1


def use_constant_twice() -> int:
    return CONSTANT * 2


def use_constant_thrice() -> int:
    return CONSTANT - 10


# =============================================================================
# Test: Find Implementations
# >> Place cursor on 'process' method in Protocol and use <leader>lI
# =============================================================================


class DataProcessor(Protocol):
    def process(self, data: str) -> str: ...


class UpperProcessor:
    def process(self, data: str) -> str:
        return data.upper()


class LowerProcessor:
    def process(self, data: str) -> str:
        return data.lower()


class ReverseProcessor:
    def process(self, data: str) -> str:
        return data[::-1]


# =============================================================================
# Test: Type Definition
# >> Place cursor on 'processor' parameter and use <leader>lt
# =============================================================================


def run_processor(processor: DataProcessor, data: str) -> str:
    return processor.process(data)


# =============================================================================
# Test: Document Symbols
# >> Use <leader>ls to see all symbols in this file
# =============================================================================


class Calculator:
    def __init__(self, initial: int = 0):
        self.value = initial

    def add(self, x: int) -> "Calculator":
        self.value += x
        return self

    def subtract(self, x: int) -> "Calculator":
        self.value -= x
        return self

    def multiply(self, x: int) -> "Calculator":
        self.value *= x
        return self


# =============================================================================
# Test: Hover Info (K) and Signature Help (<leader>lk)
# >> Place cursor on 'complex_function' call and press K
# >> Place cursor inside parentheses and use <leader>lk
# =============================================================================


def complex_function(
    name: str,
    count: int,
    multiplier: float = 1.0,
    prefix: str = "",
) -> str:
    """
    Format a repeated string with optional prefix.

    Args:
        name: The string to repeat
        count: Number of repetitions
        multiplier: Scaling factor for count
        prefix: Optional prefix for output

    Returns:
        Formatted string with repetitions
    """
    actual_count = int(count * multiplier)
    repeated = name * actual_count
    return f"{prefix}{repeated}"


result = complex_function("test", 3, multiplier=2.0)


# =============================================================================
# Test: Rename Symbol
# >> Place cursor on 'old_name' and use <leader>ln
# =============================================================================


def old_name(x: int) -> int:
    return x + 1


a = old_name(1)
b = old_name(2)
c = old_name(3)


# =============================================================================
# Test: Code Action
# >> Place cursor on the unused import and use <leader>la
# =============================================================================

from typing import List  # noqa: F401 (unused, for testing code actions)


# =============================================================================
# Test: Incoming/Outgoing Calls
# >> Place cursor on 'middle_function' and use <leader>lc / <leader>lC
# =============================================================================


def leaf_function() -> int:
    return 1


def middle_function() -> int:
    return leaf_function() + leaf_function()


def root_function() -> int:
    return middle_function() * 2


# =============================================================================
# Test: Diagnostics Navigation
# >> Use [d and ]d to jump between diagnostic errors below
# =============================================================================


def type_error_demo(x: int) -> str:
    return x  # type: ignore[return-value]


def another_error(y: str) -> int:
    return y  # type: ignore[return-value]
