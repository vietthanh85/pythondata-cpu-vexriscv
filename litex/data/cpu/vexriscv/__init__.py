import os.path
__dir__ = os.path.split(os.path.abspath(os.path.realpath(__file__)))[0]
data_location = os.path.join(__dir__, "verilog")
src = "https://github.com/SpinalHDL/VexRISCV.git"
git_hash = "5f0c7a7faf6b65c907a93be6e3723e297d37ee71"
git_describe = "v1.0.1-265-g5f0c7a7"
version_str = "1.0.1.post265"
version_tuple = (1, 0, 1)
try:
    from packaging.version import Version as V
    pversion = V("1.0.1.post265")
except ImportError:
    pass
