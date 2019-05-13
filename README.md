# Agent-Based-Modeling-Of-Syn-Notch
Five models for egent based modeling of Syn-Notch and Delta-Notch signaling in cells are provided.


------------------------------------------------------------------------------------------------------------------------------------
# Files Included
* Included are five modeling files and a folder containing Figures both supplemental and figures that were used in the paper.
* the included files are 
  * Final Single Genotype A signals B.nlogo
  * Final version Single Genotype Two Layer (contact inhibition).nlogo
  * Final version one genotype one notch.nolog
  * Final version Single Genotype Three layer.nlogo
  * final version Two Genotype Three Layer.nlogo
  * Supplemental images for paper (folder)
------------------------------------------------------------------------------------------------------------------------------------
# Prior to use requirements

NetLogo must be installed from https://ccl.northwestern.edu/netlogo/. The version used in these files is **Version 6.0.4**. 
* Note versions later than Version 6.0.4, specifically any version 5 or earlier, will **NOT** work with the current models, change in some commands render old versions of Netlogo incompatible with this version. 
* The converter which moves old files from version 5 to 6 would sometimes not work correctly, specifically in trying to use Reynolds etc al (2019) code which was written in version 5.
------------------------------------------------------------------------------------------------------------------------------------
# Operation

Each model has several buttons and several input windows to specifify parameters for the system.
* **Setup** initialized the system and sets up the cell sheet layout
* **go** will run the simulation and will continue to run untill the button is pressed a second time. Any additional button press will resume the simulation and a second press is required to stop it each time
* **go-1** is a single time step (called a tick) that will run the simulation for 1 tick and then stop
* **current-seed** is an input box, however the code will generate a random seed each time setup is clicked. The input box is to read the current seed chosen. Netlogo is Pseudo random in that two different seeds will be different however if the seed is kept the same the simulation will run identically each time
* **notch-cleaved-diffusion-time** sets the time for cleaved notch to diffuse through the cytosol
* **delta-transform-time** is the time before delta will activate into delta prime
* **notch-transcription-inital-rate** is the initial rate that will modulate how frequently Notch is transcribed (bred) by the nucleus of the simulation
* **delta-transcription-initial-rate** is idencial to the behavior of notch-transcription-initial-rate however it is for delta.
* **cell-line-overlay?** a switch that must be on to see the flourescence of the cells.
* **check-cell-line** is a continuous button that will set the florescence of the cells to be updated each time tick. One press of this button will have the color change based on the nuclear notch. turning this off while cell-line-overlay? is on will fix the color at the time step it was turned off.
* **Display** is the large black box that is the agentspace. this will be populated when setup is pressed.
------------------------------------------------------------------------------------------------------------------------------------
The order to run the simulation is to first press the **setup** button. next decide if florescence is required (by default assume yes) and turn on **cell-line-overlay**. Next press the **check-cell-line** to make sure it is active. lastly Press **go** (or **go-1**).
The simulation will then run and agents will move about the **display** unitl **go** is pressed again.

------------------------------------------------------------------------------------------------------------------------------------
# Modeling sepcifics and intended code behavior

Each model behaves simmilarly in structure with additional changes made to model the four different circuits and the additinal circuit with motion. 

