## VitaGraphs
Simple Graphing Calculator for PS Vita
### Building
Download nightly build of lpp-vita http://rinnegatamante.it/lpp-nightly.php<br>
Then open Readme.txt file in the lpp-builder folder (read there "How to use")
Use eboot_unsafe.bin
### How to change a function
001 - 007 Change second line of <code>Y_make(x)</code> function in index.lua 
Example:<code>return 2*x+4</code>
### Plan
1 Make inApp function input<br>
2 More functionality
