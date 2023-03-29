"""Set up access to important employer data for IPython"""

from dataclasses import dataclass


@dataclass
class EmployerData:
    name: str


wwts = EmployerData("wwts")
