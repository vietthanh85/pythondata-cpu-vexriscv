import os.path
__dir__ = os.path.split(os.path.abspath(os.path.realpath(__file__)))[0]
data_location = os.path.join(__dir__, "verilog")
src = "https://github.com/SpinalHDL/VexRISCV.git"

# Module version
version_str = "1.0.1.post311"
version_tuple = (1, 0, 1, 311)
try:
    from packaging.version import Version as V
    pversion = V("1.0.1.post311")
except ImportError:
    pass

# Data version info
data_version_str = "1.0.1.post265"
data_version_tuple = (1, 0, 1)
try:
    from packaging.version import Version as V
    pdata_version = V("1.0.1.post265")
except ImportError:
    pass
data_git_hash = "5f0c7a7faf6b65c907a93be6e3723e297d37ee71"
data_git_describe = "v1.0.1-265-g5f0c7a7"
data_git_msg = """\

"""

# Tool version info
tool_version_str = "0.0.post46"
tool_version_tuple = (0, 0, 46)
try:
    from packaging.version import Version as V
    ptool_version = V("0.0.post46")
except ImportError:
    pass
