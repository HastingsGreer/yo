import re


def parse(program_file):
    program_file = re.sub(r"#.*$", "", program_file)
    program_file = re.sub(r"([A-Za-z+_=\-\?]+[0-9]*)", r"'\1',", program_file)
    program_file = re.sub(r"([0-9]+)", r"\1,", program_file)
    program_file = re.sub(r"\,\'", r"'", program_file)
    program_file = "(" + re.sub("\\)", "),", program_file) + ")"
    return eval(program_file)

