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
Each model is described in more detail in each section. Below is the overview of basic Agent interaction that leads to the model.
# Agent behavior
Comments in the Models will further explain each variables use, but the basic operation is as follows
* Set up genrates a grid of Nucleus-breed agents. these are arranges in a grid layout following Reynolds etc al (2019) patterning in the original model. 
* Each nucleus then will Breed a set of new agents called Lipid-breed. Lipid-breed are yellow agents (squares) that start as a formation of 6 around the nucleus to form lines to make a hexagon shaped cell. The lipid-breeds are bred to form a line of 12 (default) or 6 (reduced) lipids per side. The result of set up is a grid of hexagonal "Cells" where yellow squares constitute the membrane (Lipid-breed) and the white agents in the center are the Nucleus-breed
* Variables are defined and each agent is given a set of variables to Own using the {name}-breed-own command. The important variables are the **parent**, **parent-who**, **currentNuclearNotchCnt**, these are important for allowing agents to remember the original Nucleus-breed from which it originated.
* When go is pressed each Nucleus-breed will breed two new classes of agents: Notch-breed and Delta-breeds
 * Notch-breed is the Notch protein, and is given the color blue (orange in secondary signaling) and is told to pick a random direction and to move in a straight line outwards away from the parent Nucleus-breed and towards the Lipid-breed membrane.
 * Delta-breed agents behave identical to Notch agents however they are given a Red color when bred from the nucleus.
* Delta and Notch agents move towards the Lipid membrane, where when the agents are close enough together the first logic inherent to the agent is performed
 * When within a parameter distance of one another the Delta and Notch agents are Transitioned into Delta-mem and Notch-mem agents. These new agents are under a new set of logic for motion. The motion is now constrained in a 1 D motion along the membrane, and the agents are allowed to diffuse randomly across the membrane. The 1 D motion fixes the motion of the agents to only space occupied by membrane agents. 
* After a period of time Delta-mem agents will transform into Delta-prime-mem agents which color change into pink agents (formerly red for just delta)
* When a Delta-prime-mem agent is exactly opposite from a Notch-mem agent, But on two separate cells the signaling will occur. **parent** and **parent-who** parameters are required to prevent notch to activate with Delta-prime on the same cell (no intercellular signaling only intracellular)

