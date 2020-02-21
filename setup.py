import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

import subprocess
try:
    VERSION = subprocess.check_output(['git', 'describe'])
except subprocess.CalledProcessError as e:
    print(e)
    VERSION = "0.0.?"


setuptools.setup(
    name="litex-data-vexriscv",
    version=VERSION,
    author="LiteX Authors",
    author_email="author@example.com",
    description="Data required to use VexRISCV with LiteX",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/litex-hub/litex-data-vexriscv",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.5',
)
