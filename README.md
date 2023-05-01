# LCTES23-WIP: Towards Automated Identification of Layering Violations in Embedded Applications

This is a tool to detect layering violations in embedded applications. The tool uses LLVM and requires a bitcode file of the target application.

Specifically, given a bitcode file, our tool will generate the list of all NCMAs (a type of layering violations).

## Using Docker
> Instructions to use our pre-built docker container.

We have created a docker container having all the necessary tools and data required to run our tool and reproduce the results of our paper.

### Setup
<!-- Setup instructions for docker and docker pull and run-->

### Running on a Bitcode file.
<!--Inside the docker..what to do?-->

### Reproducing Results
<!--Inside the docker..what to do?.-->


## Standalone Installation

> Instructions for standalone installation outside docker on Ubuntu 20.04 desktop OS.
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


### Step-by-Step Instructions
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
├── apps                     # Repositories of applications
├── toolchain                # Compilation toolchain for Arm
├── whole-program-llvm       # Our fork of wllvm
├── bin-wrapper              # Wrapper for wllvm
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
#### Installing our fork of wllvm
``` bash
sudo pip install -e artifact/whole-program-llvm
```
This installs wllvm in /usr/local/bin.

#### Add arm-none-eabi-gcc to PATH
`export PATH=$RTOSExploration/toolchain/gcc-arm-none-eabi-10.3-2021.10/bin:$PATH`

#### Scripts for generating bitcode
The directory `artifact/apps` contains repositories for each app in the dataset.
Each repo contains a bash script `gen-wllvm.sh` that generates bitcode for this repo.
It's necessary to read official documentations of applications to setup the development environment. Don't expect `gen-wllvm.sh` will magically work out-of-the-box.

<!---
| Repository | Build instructions |
| --- | --- |
| Amazfitbip | https://github.com/RTOSExploration/Amazfitbip-FreeRTOS/blob/wllvm/gen-wllvm.sh |
| Avem | https://github.com/RTOSExploration/Avem/blob/wllvm/gen-wllvm.sh |
| Cicada-FW | https://github.com/RTOSExploration/Cicada-FW/blob/wllvm/gen-wllvm.sh |
| coreMQTT-Agent | https://github.com/RTOSExploration/coreMQTT-Agent-Demos/blob/wllvm/gen-wllvm.sh |
| Embedded-GUI-for-MT2523 | https://github.com/RTOSExploration/Embedded-GUI-for-MT2523/blob/wllvm/gen-wllvm.sh |
| esp-idf-examples | https://github.com/RTOSExploration/esp-build/blob/main/gen-wllvm.sh |
| InfiniTime | https://github.com/RTOSExploration/InfiniTime/blob/wllvm/gen-wllvm.sh |
|  mbed-os | https://github.com/RTOSExploration/mbed-os-gen-wllvm/blob/main/gen-wllvm.sh |
| nrf52-keyboard | https://github.com/RTOSExploration/nrf52-keyboard/blob/wllvm/gen-wllvm.sh |
| nuttx | https://github.com/RTOSExploration/nuttx-gen-wllvm/blob/main/gen-wllvm.sh |
| phoenix-rtos | https://github.com/RTOSExploration/phoenix-rtos-project/tree/wllvm |
| RP2040-FreeRTOS | https://github.com/RTOSExploration/RP2040-FreeRTOS/blob/wllvm/gen-wllvm.sh |
|  STM32_BASE | https://github.com/RTOSExploration/STM32_Base_Project/blob/wllvm/gen-wllvm.sh |
| zephyr-samples | https://github.com/RTOSExploration/zephyr-build/blob/main/gen-wllvm.sh |
--->
