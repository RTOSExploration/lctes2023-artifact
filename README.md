# LCTES23-WIP: Towards Automated Identification of Layering Violations in Embedded Applications

## Getting Started Guide
<!-- Contain instructions on how to set up (including, for example, a pointer to the VM player software, its version, and passwords if needed) and test your artifact. Anyone following this guide should be able to handle the rest of your artifact easily. -->

The following instructions install the development environment of HalVD (our static analysis tool) and run it on a sample application.
### Installing LLVM 14 on Ubuntu 20.04
On Ubuntu Bionic, you can [install modern
LLVM](https://blog.kowalczyk.info/article/k/how-to-install-latest-clang-6.0-on-ubuntu-16.04-xenial-wsl.html)
from the official [repository](http://apt.llvm.org/):

```bash
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt-add-repository "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-14 main"
sudo apt-get update
sudo apt-get install -y llvm-14 llvm-14-dev llvm-14-tools clang-14
```
This will install all the required header files, libraries and tools in
`/usr/lib/llvm-14/`.

### Compiling HalVD
```bash
cd artifact/HalVD
export LLVM_DIR=/usr/lib/llvm-14/
mkdir build
cd build
cmake -DLT_LLVM_INSTALL_DIR=$LLVM_DIR ..
make
```
### Running HalVD on a bitcode file
For example, to run HalVD on InfiniTime, change working directory to `artifact/HalVD`, then execute
``` bash
$LLVM_DIR/bin/opt -load-pass-plugin build/lib/libFindMMIOFunc.so -load-pass-plugin build/lib/libFindHALBypass.so --passes='print<hal-bypass>' --disable-output ../bitcode-db/InfiniTime/pinetime-app-1.10.0.out.bc 2> InfiniTime.analysis
```
The result will be in `artifact/HalVD/InfiniTime.analysis`.


## Step-by-Step Instructions
<!-- Detail how your artifact can be evaluated. Include appropriate references to the relevant sections of your paper.

Explain how to reproduce experiments or other activities supporting your paper’s conclusions. Write this for readers who are deeply interested in your work and are studying to improve or compare against it. If your artifact runs for more than a few minutes, point this out and explain how to run it on smaller inputs. -->

### Directory structure of artifact
``` bash
artifact/
├── bitcode-db               # Dataset of applications
│   ├── Amazfitbip           # An application or a type of applications
│   │   ├── *.bc             # Bitcode file of an app
│   │   ├── *.bc.analysis    # HalVD's analysis result for this app
│   │   └── summary.txt      # Summary of results for all apps in this sub directory
│   ├── ...                  # More applications
│   ├── summarize.sh         # Bash script to generate the summaries
│   └── summary.txt          # Summary of results for all apps in the dataset (Table 1 in paper)
└── HalVD                    # The static analysis tool
```

### Reproduce Results of HalVD in finding NCMAs (Table 1 in paper)
#### Run HalVD on all bitcode files in dataset
Compile HalVD following the above instructions, then execute
``` bash
cd artifact/HalVD
export RTOSExploration=/abs/path/to/artifact
./run.sh # Takes 70 sec on a 20-core CPU
```
Note that results may be slightly different between runs due to the random algorithms in HalVD.

#### Summarize the results
``` bash
cd artifact/bitcode-db
./summarize.sh
```
The summary report will be in `artifact/bitcode-db/summary.txt`.

### Generate bitcode yourself
| Repository | Build instructions |
| --- | --- |
| Amazfitbip | |
| Avem | |
| Cicada-FW | |
| coreMQTT-Agent | |
| Embedded-GUI-for-MT2523 | |
| esp-idf-examples | |
| InfiniTime | |
|  mbed-os | |
| nrf52-keyboard | |
| nuttx | |
| phoenix-rtos | |
| RP2040-FreeRTOS | |
|  STM32_BASE | |
| zephyr-samples | |
