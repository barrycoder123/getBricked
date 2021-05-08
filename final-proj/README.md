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

# Debugging

---
VHDL DIDN'T COMPILE
1.  When the the vhdl doesn't compile due to "can't find ice fdti usb device"  after "make" try this:
        sudo /home/willy/fpga-toolchain/bin/iceprog top.bin
    This is due to the fact that iceprog is not in the folder.  

VGA NOT OUPUTTING ANYTHING
2.  Tried probing each output for the top level module and it seems to output the correct display from lab6 and 
    all the signals are correct. However, it still doesn't output to the display at all. 

3.  Tried grounding everything on the upduino and it doesn't change the output

4.  Tried to use different upduinos and connectors and it doesn't change anything. 

5.  Lab6 uploaded to the upduino which worked before doesn't work now.

6.  Tried changing the video capture usb display ports and it also doesn't solve the issue. 

7.  The solution was that the VGA column and row count for the sync is off by 1 so the timing was off and it is happening later than expected.
    So we need to make sur that the lines are in the correct places. 

VGA Not ouputting the blocks
8.  Works when the brick ram was not included but when it is it doesn't work. RAM doesn't work properly.

9.  We had to make a separate RAM instantiation in the top level for it to work/simplify it. 

VGA not outputting the defined row and col
10. we think it is caused by a glitch since there is a spike on hsync compared to vsync

11. tried doing the lab6 vga and it doesnt work even though it worked before 

12. tried making it a process in order to latch it so it doesnt glitch but it still glitches

13. tried to take the top 5 from row and col and it still doesn't work and doesnt display anything on screen.

14. it is able to display when it is set to equal but it is only 1 pixel which can barely be seen on the screen.
SOLUTION
15. hsync and vsync needs to be in a process so it doesn't have the glitch. This solves the glitch issue.
---

# Reflection

---
