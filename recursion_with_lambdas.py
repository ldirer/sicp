# thinking. Not super relevant in hindsight :)
print((lambda f, args: f.__call__(*args))(lambda x: x, (1,)))

# key points:
# the function needs itself as argument.
# then we need a way to bootstrap the call: we do that with a wrapping function
# basically it's replacing variable assignment.
# You need a variable? use a wrapping function, pass the thing you want in a variable as argument.
# the argument is now your variable.

# factorial
factorial = lambda n: (lambda f, args: f(f, *args))(
    lambda self, p: 1 if p < 2 else p * self(self, p - 1),
    (n,))

assert factorial(5) == 120
print("tests pass!")
