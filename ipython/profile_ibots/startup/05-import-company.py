"""Set up access to important employer data for IPython"""

from dataclasses import dataclass

from bots.issues import issues

@dataclass
class EmployerData:
    name: str

wwts = EmployerData('wwts')


def issue_branch(issue):
    name = issues.one(issue).branch_name()
    print(name)
