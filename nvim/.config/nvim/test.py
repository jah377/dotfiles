def add_numbers(a, b, c):  # function has too many arguments (ruff/flake8 E741)
    """This is a docstring"""
    result = a + b
    return result  # c is unused (ruff/flake8 F841)


x = 42
print("Hello world!")  # print statement is fine, but…

y = x + 5  # y is assigned but never used (ruff/flake8 F841)

if True:  # constant condition (ruff SIM108)
    print("This is always true")

foo = "bar"
if foo == "bar":  # can be simplified to `if foo is "bar":` (ruff SIM300)
    pass
