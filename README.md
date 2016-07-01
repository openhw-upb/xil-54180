# ZYNQ-based HD EMG prosthesis controller

Zynq-based processing of 256 EMG channels for robust control of a state-of-the-art multi-movement prosthesis. Hardware acceleration with Vivado HLS.

XIL-54180: Entry for Xilinx Open Hardware 2016.

[Youtube Video](https://youtu.be/RZGHkCOCRC4)

- Board used: ZedBoard ZYNQ-7020 evaluation board
- Vivado Version: Vivado HLS 2016.1

## Directory structure ##

    - bin/                    -- precompiled binaries
    - doc/                    -- Project report
    - data/                   -- Sample data
    - hw/                     -- bitstream
    - sd_image/               -- SD card image
    - src/                    
        + src/c/              -- software sources
        + src/vhdl/           -- vhdl hardware sources
        + src/hls/            -- Vivado HLS projects


## Testing the project with prebuild binary/bitstream: ##

### [Step 1.1:] Setup SD card ###
Option A:

    - use existing SD card that boots Linux on ZedBoard
    - copy following files to SD card
        + bin/lda (precompiled binary)
        + hw/lda.bit (bitstream)
        + bin/reconos_init.sh (ReconOS init script)
        + bin/mreconos.ko (ReconOS kernel object)

Option B:

    - write SD card image to SD card (all content on SD card will be lost)
        + $  gunzip -c /sd_image/sdcard_lda.img.gz | dd of=/dev/sdX (replace /dev/sdX with correct device)

### [Step 1.2:] Run LDA classification on ZedBoard ###
    - insert SD card to ZedBoard, start the board
    - connect to ZedBoard via UART
        + e.g.: $ picocom -b 115200 /dev/ttyACM0
    - load bitstream:
        + $ cat lda.bit > /dev/xdevcfg
    - load ReconOS kernel modules  
        + $ ./reconos_init.sh
    - start lda program with TCP/IP server
        + $ ./lda <Port-no> <Window-Size> <Window-Shift> <Threshold> <#Channels> <#Classes>
        + e.g.: $ ./lda 8888 150 1 0 192 8
    - switch to Linux host
    - start client in training mode to send training data:
        + $ ./client <server-ip> <port-no> <nbr columns> <filename> <T: train or C: classify> <new class after x samples>
        + e.g.: $ ./bin/client 192.168.1.2 8888 192 data/192ch_train.csv T 1000
    - wait for training to be finished
    - start client in testing mode to send test data:
        + $ ./client <server-ip> <port-no> <nbr columns> <filename> <T: train or C: classify> <new class after x samples>
        + e.g.: $ ./bin/client 192.168.1.2 8888 192 data/192ch_test.csv C 1000
    - observe stdout: classified movement class as debug output

## Building the system from source: ##

### [Step 2.1:] Setup SD card ###

Option A:
    - use existing SD card that boots Linux on ZedBoard

Option B:

    - write SD card image to SD card (all content on SD card will be lost)
        + $  gunzip -c /sd_image/sdcard_lda.img.gz | dd of=/dev/sdX (replace /dev/sdX with correct device)

### [Step 2.2:] Build system from source ###
    - build software:
        + $ cd src/c
        + $ export CROSS_COMPILE=/path/to/arm-xilinx-linux-gnueabi-
        + $ make
    - synthesize HLS core
        + open src/hls/fe_{mav,ssc,wfl,zc} HLS project
        + run HLS synthesis
    - generate bitstream:
        + $ cd src/vhdl
        + $ xps -nw system
        + $ run bits
    - copy files to SD card
        + src/c/lda/lda (lda binary)
        + src/vhdl/implementation/system.bit (bitstream)
        + bin/reconos_init.sh (ReconOS init script)
        + bin/mreconos.ko (ReconOS kernel object)

### [Step 2.1:] Run system on ZedBoard ###
    - insert SD card to ZedBoard, start the board
    - connect to ZedBoard via UART
        + e.g.: $ picocom -b 115200 /dev/ttyACM0
    - load bitstream:
        + $ cat lda.bit > /dev/xdevcfg
    - load ReconOS kernel modules:
        + $ ./reconos_init.sh
    - start lda program with TCP/IP server
        + $ ./lda <Port-no> <Window-Size> <Window-Shift> <Threshold> <#Channels> <#Classes>
        + e.g.: $ ./lda 8888 150 1 0 192 8
    - switch to linux host
    - start client in training mode to send training data:
        + $ ./client <server-ip> <port-no> <nbr columns> <filename> <T: train or C: classify> <new class after x samples>
        + e.g.: $ ./bin/client 192.168.1.2 8888 192 data/192ch_train.csv T 1000
    - wait for training to be finished
    - start client in testing mode to send test data:
        + $ ./client <server-ip> <port-no> <nbr columns> <filename> <T: train or C: classify> <new class after x samples>
        + e.g.: $ ./bin/client 192.168.1.2 8888 192 data/192ch_test.csv C 1000
    - observe stdout: classified movement class as debug output 