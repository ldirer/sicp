the_empty_stream = []


def ones():
    # representing a stream as (car, cdr). It forces 'consumption' of a value, similar to SICP implementation.
    return 1, ones


def is_snull(stream):
    return stream == the_empty_stream


def scar(stream):
    return stream[0]


def scdr(stream):
    return stream[1]()


def take(stream, n):
    if n == 0:
        return the_empty_stream
    return scar(stream), lambda: take(scdr(stream), n - 1)


class Stream:
    """A wrapping class to provide iteration"""

    def __init__(self, stream):
        self.stream = stream

    def __iter__(self):
        while not is_snull(self.stream):
            yield scar(self.stream)
            self.stream = scdr(self.stream)


sones = Stream(take(ones(), 10))


# Exponential coefficient stream using integration
# 1 + x + x2/2 + x3/3*2 + ...
def integrate(stream):
    def gen(current_stream, n):
        return scar(current_stream) / n, lambda: gen(scdr(current_stream), n + 1)

    return gen(stream, 1)


# Define the exponential stream
def exponential_coefficients():
    return 1, lambda: integrate(exponential_coefficients())


# Helpers
def scale_stream(stream, factor):
    if is_snull(stream):
        return stream
    return scar(stream) * factor, lambda: scale_stream(scdr(stream), factor)


def negate_stream(stream):
    return scale_stream(stream, -1)


# Set up mutual references for cosine and sine streams
def cosine_coefficients():
    return 1, lambda: negate_stream(integrate(sine_coefficients()))


def sine_coefficients():
    return 0, lambda: integrate(cosine_coefficients())


# Take the first 10 coefficients for each
exp_stream = Stream(take(exponential_coefficients(), 10))
cos_stream = Stream(take(cosine_coefficients(), 10))
sin_stream = Stream(take(sine_coefficients(), 10))

# Print the coefficients
print("Exponential series coefficients:")
for v in exp_stream:
    print(v)

print("\nCosine series coefficients:")
for v in cos_stream:
    print(v)

print("\nSine series coefficients:")
for v in sin_stream:
    print(v)
