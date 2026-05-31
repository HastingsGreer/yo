import re
import sys

def cons_of_string(string):
    if len(string) == 0:
        return "(nil 0)"
    return "(cons " + str(ord(string[0])) + " " + cons_of_string(string[1:]) + ")"

def parse(program_file):
    program_file = program_file.split('"')
    for j in range(1, len(program_file), 2):
        program_file[j] = eval('"' + program_file[j] + '"')
        program_file[j] = "((cast String) " + cons_of_string(program_file[j]) + ")"
    program_file = "".join(program_file)

    program_file = re.sub(r"([@*{}\.\,:'\"<>\|A-Za-z+_=\-\?0-9\$]+)", r"'\1',", program_file)
    program_file = "(" + re.sub("\\)", "),", program_file) + ")"
    return eval(program_file)

def get_program():
    return parse(open(sys.argv[1], "r").read())

if __name__ == "__main__":
    print(get_program())
