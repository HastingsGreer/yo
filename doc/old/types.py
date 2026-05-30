
import re
import sys
from dataclasses import dataclass

source = """
(defun powtwo (a) (if a (add (powtwo (sub a 1)) (powtwo (sub a 1))) 1))
(defun main () (powtwo 5)) """

source = open(sys.argv[1], "r").read()

def parse(program_file):
    program_file = re.sub(r"([A-Za-z+_=\-\?]+[0-9]*)", r"'\1',", source)
    program_file = re.sub(r"([0-9]+)", r"\1,", program_file)
    program_file = "(" + re.sub("\\)", "),", program_file) + ")"
    return eval(program_file)

program = parse(source)

import json
print(json.dumps(program, indent=2))
