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
* When a Delta-prime-mem agent is exactly opposite from a Notch-mem agent, But on two separate cells the signaling will occur. **parent** and **parent-who** parameters are required to prevent notch to activate with Delta-prime on the same cell (no intracellular signaling only intercellular)
 * The Notch-mem agents now breed two lines of agents. First the Notch-mem agents become cleaved-Notch agents and these are green or yellow squares that appear just inside the lipid agents at the location that the "signaling" occured. the new cleaved notch agents are then given a direction towards the **parent** nucleus of the cleaved notch, and when the migrating cleaved-Notch reaches a distance termed "centersome" the Cleaved notch forms the second breed called Cleaved-Nuclear-Notch
  * Cleaved-Nucelar-Notch does not move and forms green triangles around the white **parent** Nucleus-breed.
 * Inhibition occurs when Delta-Mem agants set "Protected" status to neigboring Notch membrane agent, which is a binary setting that prevents the signaling (and thus clevage of Notch). More delta therefore will prevent more Notch from being activated by having the "Protected" status.
 * **currentNuclearNotchCnt** is a variable that counts the number of Cleaved Nuclear Notch there is for each Nucleus. By asking how many Nuclear notch have **parent-who** of the nucleus, it can determine which nucleus-breeds have more notch being cleaved and which are not having their notch cleaved. 
  * Low values mean the cell is expressing mainly Delta, thus Delta agents (red) are mainly produced.
  -------------------------------------------------------------------------
  * **Modifications**
  Earlier is the operation for the basic model Developed by Reynolds etc al (2019). Several changes were made to futher create the circuits that a different in each model
  -----------------------------------------------------------
  **all Circuits**
  * all circuits have the addition of the florescence indicator to differentiate the different cell types. 
  * this is achived by leveraging the **currentNuclearNotchCnt** variable from before
   * if this value is zero for the Nucleus-breed, A line of code tells the agent to ask all surrounding patches (Netlogo topography agents) to turn their color from black to Blue. (called pcolor)
   * if the value is greater than zero, of its related variable **currentNuclearNotchCnt2** is greater than zero, then the cell will ask the surrounding patches to turn either green or pink depending on the circuit design (see supplemental figures or the paper for circuit layouts)
  * the **check-cell-line** is a continuous button to allow for the color of the cell (patch color) to be updated each time step as more Cleaved Nuclear Notch is formed and Die out. This gives a very obvious color change that can be viewed real time in each model.
 -----------------------------------------------------------------------------
 **Two layer Two Genotype**
 Two layer Two genotype is modified where instead of a sheet of identical cells, it starts as a mixture of two different cell genotypes.
 * starting cells called cell A will produce only Delta, 
  * to achieve this Netlogo first gets the number of cells, and then will pick a random 1/3 of those cells to produce Delta intially.
  * next each nucleus agent is asked if it is producing delta agents by determining the numeber of delta agents with **parent** equals the nucleus in question
   * if this is zero, the agent will begin breeding Notch agents alone
   * if it is non zero, it is one of the inital 1/3 selected agents and it will be told to continue making Delta alone.
   * each time step then asks the numerb of Notch agents **and** delta agents with **parent** equals the nucleus in question
    * if this is non zero, all delta agents are asked to [die], effectively preventing the Notch producing nucleus agents from making Delta.
* Cleavage of Notch acts identical to the general procedure.
* when currentNuclearNotchCnt builds up above zero, the cell is told to perform the **check-cell-line** function again and patches around the nucleus will turn green.
-----------------------------------------------------------------------------
**Three layer Two Genotype**
Three layer Two genotype behaves identical to the Two Layer Two Genotype model initially
* However instead of only producing Delta, The "starter cells" will also produce new agents called Notch2. these do not interact with Delta 1 agents, instead they will interact with new Delta 2 agents.
* Delta 2 agents are told to be bred from the Nucleus **only** after the currentNuclearNotchCnt value has exceeded a threshold value (3 to avoid color fluttering).
* The signaling then occurs between Notch 2 and Delta 2 agents as it does in the general model.
The results is a directional diffusion of the signal that feeds back. i.e cell A activated cell B only, which turns B to C. cell C now express Delta 2 and activate the original cell A to turn into cell D.
------------------------------------------------------------------------------

