a = 1


def f():
    b = a + 1
    a = 5
    return a + b


f()

# ---------------------------------------------------------------------------
# UnboundLocalError                         Traceback (most recent call last)
# Input In [3], in <cell line: 1>()
# ----> 1 f()
#
# Input In [2], in f()
#       1 def f():
# ----> 2     b = a + 1
#       3     a = 5
#
# UnboundLocalError: local variable 'a' referenced before assignment
