def mult_func(a: int, b: int):
    return a * b


a, b, c = 1, 2, 3

# reportCallIssue: Expected 2 positional arguments
mult_func(a, b, c)
