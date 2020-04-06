#!/usr/bin/env python3
import os

from litex.data.cpu import vexriscv

print("Found vexriscv @ version", vexriscv.version_str, "(with data", vexriscv.data_version_str, ")")
print()
print("Data is in", vexriscv.data_location)
assert os.path.exists(vexriscv.data_location)
print("Data is version", vexriscv.data_version_str, vexriscv.data_git_hash)
print("-"*75)
print(vexriscv.data_git_msg)
print("-"*75)
print()
print("It contains:")
for root, dirs, files in os.walk(vexriscv.data_location):
    dirs.sort()
    for f in sorted(files):
        path = os.path.relpath(os.path.join(root, f), vexriscv.data_location)
        print(" -", path)
