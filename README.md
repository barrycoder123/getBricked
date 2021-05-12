---
# ES4 Final Project : Brick Breaker
---
* Authors: Willy Lin, Ibrahima Barry, James Eidson, Zach Osman
* Files: 
 1. 
 2.
 3.

* [Link to google drive](https://drive.google.com/drive/folders/1haWPJueKWg5tmvnxV2E9WMC4ghSwM9Vv?usp=sharing)

* Program Description: 

---

# Design

---

# Testing

---
This is the command use if the library is not appearing:
    export GHDL_PREFIX=/home/willy/fpga-toolchain/lib/ghdl/

GHDL is used to check for issues within the code using the open source FPGA.
This command was used to find errors:

    ghdl -a --std=08 *.vhdl 

First, the brick generation of one row was implemented for testing before generating the rest of the game board. Then we set up the rest of the game board to test if it works. After, we started implementing the cannonball/cannon. 

---

# Reflection
Overall, we were able to create a functioning game that is able to be controlled
using the vga controller. It is able to move left and right and shoot the bricks
and delete or destroy them in the process if the position of the cannonball is the same as the bricks. 
---
