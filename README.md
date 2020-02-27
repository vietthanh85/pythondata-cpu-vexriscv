# litex-data-cpu-vexriscv

Non-Python data files required to use the vexriscv with
[LiteX](https://github.com/enjoy-digital/litex.git).

The data files can be found under the Python module `litex.data.cpu.vexriscv`. The
`litex.data.cpu.vexriscv.location` value can be used to find the files on the file system.
For example;

```python
import litex.data.cpu.vexriscv

my_data_file = "abc.txt"

with open(os.path.join(litex.data.cpu.vexriscv.location, my_data_file)) as f:
    print(f.read())
```



The data files are generated from https://github.com/SpinalHDL/VexRISCV.git and place in the directory
[litex/data/cpu/vexriscv/verilog](litex/data/cpu/vexriscv/verilog].


## Installing

## Manually

You can install the package manually, however this is **not** recommended.

```
git clone https://github.com/litex-hub/litex-data-cpu-vexriscv.git
cd litex-data-cpu-vexriscv
sudo python setup.py install
```

## Using [pip](https://pip.pypa.io/)

You can use [pip](https://pip.pypa.io/) to install the data package directly
from github using;

```
pip install --user git+https://github.com/litex-hub/litex-data-cpu-vexriscv.git
```

If you want to install for the whole system rather than just the current user,
you need to remove the `--user` argument and run as sudo like so;

```
sudo pip install git+https://github.com/litex-hub/litex-data-cpu-vexriscv.git
```

You can install a specific revision of the repository using;
```
pip install --user git+https://github.com/litex-hub/litex-data-cpu-vexriscv.git@<tag>
pip install --user git+https://github.com/litex-hub/litex-data-cpu-vexriscv.git@<branch>
pip install --user git+https://github.com/litex-hub/litex-data-cpu-vexriscv.git@<hash>
```

### With `requirements.txt` file

Add to your Python `requirements.txt` file using;
```
-e git+https://github.com/litex-hub/litex-data-cpu-vexriscv.git
```

To use a specific revision of the repository, use the following;
```
-e https://github.com/litex-hub/litex-data-cpu-vexriscv.git@<hash>
```
