#!/usr/bin/env python3
import os

from litex.data.cpu import vexriscv

print("Found vexriscv @ version", vexriscv.version_str, "("+vexriscv.git_hash+")")
print("Data is in", vexriscv.data_location)
assert os.path.exists(vexriscv.data_location)
print("It contains:\n -", end=" ")
print("\n - ".join(os.listdir(vexriscv.data_location)))
