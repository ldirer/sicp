import math


def gen_integers():
    """infinite generator of integers"""
    i = 0
    while True:
        yield i
        i += 1


def integrate(s):
    # this doesn't exactly represent a power series, there is no constant term
    for i, s_i in enumerate(s):
        yield (1 / (i + 1)) * s_i


integers = gen_integers()
exp_series_ground_truth = (1 / math.factorial(i) for i in integers)


def take(series, n):
    return [term for term, _ in zip(series, range(n))]


take(exp_series_ground_truth, 10)


# generators in Python have the 'lazy' feature we want for streams: this is good!
# they don't have the 'memory' though, we'd need to build that.
def exp_series():
    yield 1
    yield from integrate(exp_series())


print(take(exp_series(), 10))


def cosine():
    yield 1
    for term in integrate(sine()):
        yield -term


def sine():
    yield 0
    yield from integrate(cosine())


print(take(cosine(), 10))
print(take(sine(), 10))


def evaluate(series, x, n_terms=100):
    return sum(term * x ** i for i, term in enumerate(take(series, n_terms)))


print("expected:", math.sqrt(2) / 2)
print("actual:", evaluate(sine(), math.pi / 4))

print("expected:", math.sqrt(2) / 2)
print("actual:", evaluate(cosine(), math.pi / 4))

print("expected:", math.sqrt(3) / 2)
print("actual:", evaluate(cosine(), math.pi / 6))


# could also start with the "ones" stream as in SICP. Adding streams, etc.
