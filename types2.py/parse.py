import re
import sys

def parse(program_file):
    program_file = re.sub(r"([@*{}\.\,:'\"<>\|A-Za-z+_=\-\?0-9\$]+)", r"'\1',", program_file)
    program_file = "(" + re.sub("\\)", "),", program_file) + ")"
    return eval(program_file)

def get_program():
    return parse(open(sys.argv[1], "r").read())

