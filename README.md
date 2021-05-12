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

VGA NOT OUTPUTTING ANYTHING
2.  Tried probing each output for the top level module and it seems to output the correct display from lab6 and 
    all the signals are correct. However, it still doesn't output to the display at all. 
3. Tried grounding everything on the upduino and it doesn't change the output
4.  Tried to use different upduinos and connectors and it didn't change anything. 
5.  Lab6 uploaded to the upduino which worked before doesn't work now.
6.  Tried changing the video capture usb display ports and it also doesn't solve the issue. 
7.  SOLUTION: The solution was that the VGA column and row count for the sync is off by 1 so the timing was off and it is happening later than expected.
So we need to make sure that the lines are in the correct places. 

VGA NOT OUTPUTTING THE BRICKS
8.  Works when the brick ram was not included but when it is it doesn't work. RAM doesn't work properly.
9.  We had to make a separate RAM instantiation in the top level for it to work/simplify it. 

VGA NOT OUTPUTTING THE CORRECT ROW AND COL 
10. we think it is caused by a glitch since there is a spike on hsync compared to vsync
11. tried doing the lab6 vga and it doesn't work even though it worked before 
12. tried making it a process in order to latch it so it doesn't glitch but it still glitches
13. tried to take the top 5 from row and col and it still doesn't work and doesnt display anything on screen.
14. it is able to display when it is set to equal but it is only 1 pixel which can barely be seen on the screen.
15. hsync and vsync needs to be in a process so it doesn't have the glitch. This solves the glitch issue.
16. SOLUTION: The NES wasn't working because the latch and clock signals weren't included in the top module. SOLUTION: After adding a latch and clock signals to the top module everything worked well as needed. 

CANNON DOES NOT MOVE CORRECTLY AND NES DOESN’T WORK
17. Cannon does not move from NES inputs
18. Tried to reconnect everything to the pins
19. Tried to change the pins and reconnect the wires.
20. SOLUTION: Missing the latch and clk wires from the nes to the upduino so those are added in and also changed the pcf file for the pins and it works. 

BRICKS NOT DELETING
21. Bricks did not delete when the cannonball hits where the bricks are so we added a variable so in the frame_clk process which is the game clock it will access the ram and change it so it will display the new game board with the brick being deleted. 
22. We tried to concatenate the ram blocks to change from 1 to 0 to “delete” the brick based on the 20-bit column. This was done on the row clock which sends data during the blank time of each row. This did not work as the compiler threw type errors for trying to concatenate.
Doing this also caused other errors that are not exactly clear from the build log so concatenating will just not work. 
23. Tried to just use bit masking in order to change the ram block to delete the bricks. This worked but it was messing up the row and sometimes didn’t delete anything. This was due to the fact that it was done in the row clock since the row clock loads the next row on the blank time of the row which is not the right timing for the brick to delete. 
24. SOLUTION: Use bit masking to delete the bricks and do it for the frame clock process in top.vhdl. This is so it shows up frame by frame rather than when it is writing. The frame clock process is the blank time when it goes to the next frame so it loads the new image with the brick. This happens 60 times a second. 

CANNON OVERFLOW ON COLUMN TO THE LEFT
25. The cannon went past the visible area on the screen.
26. Tried to switch the row for the moving of the cannon in case it was just flipped.
27. This did not work and just continued to be able to move past the visible area. 
28. SOLUTION: Since the position is a 10 bit number, we capped the position of how left it can which is 640 pixels so 10d”640”. Before it was just at all 1s for the ten digit position so it is much larger than what is actually visible. 

CANNON WILL NOT LOOK LIKE A CANNON
29. Tried adding in another smaller square for the nozzle of the cannon.
30. It didn’t appear at all even though we added it in like the other components.
31. SOLUTION: Realized that adding means go down and subtracting is going up so once that is fixed, it shows up. 

CANNON DOES NOT FIRE PROPERLY
32. The cannon was firing too fast and was not smooth
33. Tried changing the frame clock to be lower and this was able to make the cannon movement to be smoother instead of teleporting by 32pixels. Did not fix the firing issue
34. Made it so it starts from where the cannon position is once the user presses the fire and goes up when the user releases. This causes the cannonball to shoot 4-24 times based on how long the fire button was pressed. 
35. Decided to make a frame counter based on the clock to not have the fire button cause so many cannonballs to be outputted. 
36. Only ended up lowering the ball firing to 4 and did not make it only shoot 1. 
37. Tried a different firing solution by setting the ball to the top beginning and only reset to the cannon position and go up once the fire button is pressed. So it will start above the visible area of the screen and then once the fire button is pressed it goes to the cannon position and once the fire button is released it goes up until it hits the 0th row. 
38. SOLUTION:  Decided to make it so the cannonball only shoots when  the fire button is held. Once it releases, it would go back to where the cannon is at as a reset. This makes it so it will only shoot once at a time and also have automatic fire. 
---

# Reflection
Overall, we were able to create a functioning game that is able to be controlled
using the vga controller. It is able to move left and right and shoot the bricks
and delete or destroy them in the process if the position of the cannonball is the same as the bricks. 
---
