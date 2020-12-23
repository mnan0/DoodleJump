# AssemblyProject

This is a version of the Doodle Jump game using MIPS Assembly. It was made for the final assessment of CSC258 at the University of Toronto and received a perfect score.

**Setup:**

1. Download MARS from the above repository. It has file name *Mars_Updated.jar*. You will need at least JDK 8 installed on your machine. MARS is a free IDE for MIPS Assembly programming, developed by [Kenneth Vollmar and Pete Sanderson](http://courses.missouristate.edu/kenvollmar/mars/license.htm). The JAR file given here is patched by [Mustafa Quraish](http://www.cs.toronto.edu/~mustafa/) to fix issues with freezing.
2. Open doodlejump.s in MARS.
3. Open Tools -> Keyboard and Display MMIO Simulator. In the new window, toggle *Connect to MIPS*.
4. Keep the previous windows open. Open Tools --> Bitmap Display. In the new window, toggle *Connect to Mips*. Change "Unit Width in Pixels" and "Unit Height in Pixels" to *8*. Change "Display Width in Pixels" and "Display Height in Pixels" to *256*. Change "Base address for display" to *0x10008000 ($gp)*.
5. By now, you should have three windows open. Put the code editor in focus. Then, press F3. This assembles the code (the MIPS equivalent of compilation).
6. After you press F3, your window will switch to the execute tab. The game is ready to play! Press F5 to play.
7. You should hear the game's soundtrack -- a rad blues progression on piano!
8. You should see the doodler bouncing up and down on the platform.

**Controls:**

1. Commands can be typed in the lower half of the Keyboard and Display MMIO Simulator.
2. The goal is to jump from one platform to the next and avoid falling to the bottom. You may encounter powerups such as a rocket ship. You may also encounter motivational messages!
2. Type *j* to move left. Type *k* to move right.
3. Have fun!
4. My high score is 653. Can you beat it?
