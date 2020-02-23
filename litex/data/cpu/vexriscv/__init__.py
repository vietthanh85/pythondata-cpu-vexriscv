import os.path
__dir__ = os.path.split(os.path.abspath(os.path.realpath(__file__)))[0]
data_location = os.path.join(__dir__, "verilog")
src = "https://github.com/enjoy-digital/VexRiscv-verilog.git"
git_hash = "8baad219885a47f65959a9cd4870691e84678db4"
git_describe = "v0.0-54-g8baad21"
version_str = "0.0.post54"
version_tuple = (0, 0)
try:
    from packaging.version import Version as V
    pversion = V("0.0.post54")
except ImportError:
    pass