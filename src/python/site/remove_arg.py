import sys

program, first, *rest = sys.argv
args = []
result = 1
for arg in rest:
    if arg == first:
        result = 0
    else:
        quoted = f'"{arg}"'
        args.append(quoted)
print(" ".join(args))
sys.exit(result)
