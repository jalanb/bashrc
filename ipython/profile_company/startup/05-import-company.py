"""Set up access to important employer data for IPython"""


class EmployersVariables(object):
    """Holder of interesting attributes"""

    def __init__(self):
        pass


work = EmployersVariables()
print(f"dir(work): {work.__dict__.keys()}")
