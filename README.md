# EE-271-Lab6

Task - Design and program a Tug-Of-War game for two players with the following requirements:

       1. The left and right players will use KEY3 and KEY0 respectively to control their "tugs"
       2. LEDRs [9-1] will serve as our playing field - when KEY3 is pressed the light will move
          one to the left and when KEY0 is pressed it will move one to the right
       3. HEX0 shows the ID of the player that wins (1 or 2)
       4. When the game is reset - only the center light should be lit 

Side Note: Make sure to take care of metastability by using two D-flip flops in series to clean up glitches
