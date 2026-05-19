
import re
import sys
from dataclasses import dataclass

source = """
(defun powtwo (a) (if a (add (powtwo (sub a 1)) (powtwo (sub a 1))) 1))
(defun main () (powtwo 5)) """

source = open(sys.argv[1], "r").read()
program_file = re.sub(r"([A-Za-z+_=\-\?]+[0-9]*)", r"'\1',", source)
program_file = re.sub(r"([0-9]+)", r"\1,", program_file)
program_file = "(" + re.sub("\\)", "),", program_file) + ")"
program = eval(program_file)


print(program)
