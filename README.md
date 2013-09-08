ArisDozer
=========

iPad based explorer for AristA switches

Supports:
========
-Detection of devices connected on an AristA switch
-Shows the devices on an iPad screen
-Draw lines between switches (unfinished to generate a vlan based on the line)

Compile:
========
-First download NMSSH @ https://github.com/Lejdborg/NMSSH (I used e3f2883957) and save the NMSSH project as sibling of the ArisDozer project.
-Open the ArisDozer project
-Select the iPad simulator as device and build/run.
--Note: most difficult part can be including the NMSSH project code, I have no solution if it doesn't compile ;-)

Assumptions:
============
-You need a proxy ssh linux server; permit password login for sshd and sshpass should be installed
-Password for the switch must be 'lab123', and set the host right for the switch in the loc: NSArray *switches =[[NSArray alloc] initWithObjects:@"admin@<IP/host>",@"lab123",nil]; of ADZMainViewController;


Work-arounds and Hacks:
=======================
-NMSHH doesn't work well, so it cannot directly connect to an AristA (strange error message), and open session sometimes end up in bogus. The current implementation uses the proxy-ssh to commit single commands to the switch via SSH.
-Some fixed parameters for the switch IP address and password
-SSH screenscraping for fetching data from the switch (ADZAristaFetcher)
--Very simple lexer used to parse result; may break very easily
--Prepared for recursive detecting switches and devices in the network
-Use of Core Data is "overengineering" at this stage
-Images are ADZDraggableView, which allows them to be draggable, i.e. for a drawing mode





