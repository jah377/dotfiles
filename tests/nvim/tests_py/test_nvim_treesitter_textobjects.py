"""
Guide to nvim-tresitter-textobjects keybindings

Text objects:
    - Functions    : 'af'/'if'
    - Classes      : 'ac'/'ic'
    - Parameters   : 'aa'/'ia'
    - Conditionals : 'ai'/'ii'
    - Loops        : 'al'/'il'
    - Comments     : 'a/'

Text objects with with operaors:
    - d (delete)
    - y (yank)
    - c (change)
    - v (visual select)

Additional movement keybindings:
    - Functions
        - ']m' : start of next
        - ']M' : end of next
        - '[m' : start of previous
        - '[M' : end of previous
    - Classes
        - ']c' : start of next
        - ']C' : end of next
        - '[c' : start of previous
        - '[C' : end of previous
    - Parameters
        - ']a' : start of next
        - ']A' : end of next
        - '[a' : start of previous
        - '[A' : end of previous
        - <leader>a : swap with next
        - <leader>A : swap with previous
    - <leader>a : swap parameters
    - <leader>A : swap parameter

NOTE: Use 'v' operator to get best sense of functionality
"""

# Function Text Objects
# >> 'af' (outer), 'if' (inner)


def calculate_sum(a: int, b: int) -> int:
    out = a + b
    return out


# Class Text Objects
# >> 'ac' (outer), 'ic' (inner)


class CalculateSum:
    def __init__(self, a: int, b: int):
        self.a = a
        self.b = b

    def return_sum(self) -> int:
        """'af' works for methods as well"""
        c = self.a + self.b
        return c


# Parameter Text Objects
# >> 'aa' (outer), 'ia' (inner)
# NOTE: 'aa' selects trailing comma


def concat_strs(s1: str, s2: str, s3: str) -> str:
    out = s1 + s2 + s3
    return out


# Conditional Text Objects
# >> 'ai' (outer), 'ii' (inner)


def check_roi(roi: int) -> None:
    # Calling 'ii' here selects 'roi>0'
    if roi > 0:
        # Calling 'ii' here selects 'print(...)'
        print("We made money!")
    else:
        print("Sad, we lost money")


# Loop Text Objects
# >> 'al' (outer), 'il' (inner)


def test_loop(lst: list) -> None:
    for idx, item in enumerate(lst):
        new_idx = idx + 10
        print(f"{new_idx}: {item}")


# Comments Text Objects
# >> 'a/'
# NOTE: Seems to only work on a single line


def test_comment(a: int) -> int:
    """
    This is a docstring
    """
    # This is a comment
    # That explains the setup process
    # and configuration
    return a
