# Agent-Based-Modeling-Of-Syn-Notch
Five models for agent based modeling of Syn-Notch and Delta-Notch signaling in cells are provided.


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
  * 7770 Final Thomas Roberts Final Version.pdf
  * Appendix folder
   * Appendix A : Readme in PDF on detailed modeling  MODELING_README.pdf
   * Appendix B : Supplemental figures provided again   (collection of png, jpeg,)
   * Appendix C : POWERPOINT.pdf file of powerpoint presentation
------------------------------------------------------------------------------------------------------------------------------------
# Prior to use requirements

NetLogo must be installed from https://ccl.northwestern.edu/netlogo/. The version used in these files is **Version 6.0.4**. 
* Note versions later than Version 6.0.4, specifically any version 5 or earlier, will **NOT** work with the current models, change in some commands render old versions of Netlogo incompatible with this version. 
* The converter which moves old files from version 5 to 6 would sometimes not work correctly, specifically in trying to use Reynolds etc al (2019) code which was written in version 5.
------------------------------------------------------------------------------------------------------------------------------------
# Operation

Each model has several buttons and several input windows to specifify parameters for the system.
* **Setup** initialized the system and sets up the cell sheet layout
* **go** will run the simulation and will continue to run until the button is pressed a second time. Any additional button press will resume the simulation and a second press is required to stop it each time
* **go-1** is a single time step (called a tick) that will run the simulation for 1 tick and then stop
* **current-seed** is an input box, however the code will generate a random seed each time setup is clicked. The input box is to read the current seed chosen. NetLogo is Pseudo random in that two different seeds will be different however if the seed is kept the same the simulation will run identically each time
* **notch-cleaved-diffusion-time** sets the time for cleaved notch to diffuse through the cytosol
* **delta-transform-time** is the time before delta will activate into delta prime
* **notch-transcription-initial-rate** is the initial rate that will modulate how frequently Notch is transcribed (bred) by the nucleus of the simulation
* **delta-transcription-initial-rate** is identical to the behavior of notch-transcription-initial-rate however it is for delta.
* **cell-line-overlay?** a switch that must be on to see the fluorescence of the cells.
* **check-cell-line** is a continuous button that will set the florescence of the cells to be updated each time tick. One press of this button will have the color change based on the nuclear notch. turning this off while cell-line-overlay? is on will fix the color at the time step it was turned off.
* **Display** is the large black box that is the agent space. this will be populated when setup is pressed.
------------------------------------------------------------------------------------------------------------------------------------
The order to run the simulation is to first press the **setup** button. next decide if florescence is required (by default assume yes) and turn on **cell-line-overlay**. Next press the **check-cell-line** to make sure it is active. lastly Press **go** (or **go-1**).
The simulation will then run and agents will move about the **display** until **go** is pressed again.

------------------------------------------------------------------------------------------------------------------------------------
# Modeling specifics and intended code behavior

Each model behaves similarly in structure with additional changes made to model the four different circuits and the additional circuit with motion. 
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
 * The Notch-mem agents now breed two lines of agents. First the Notch-mem agents become cleaved-Notch agents and these are green or yellow squares that appear just inside the lipid agents at the location that the "signaling" occurred. the new cleaved notch agents are then given a direction towards the **parent** nucleus of the cleaved notch, and when the migrating cleaved-Notch reaches a distance termed "centrosome" the Cleaved notch forms the second breed called Cleaved-Nuclear-Notch
  * Cleaved-Nuclear-Notch does not move and forms green triangles around the white **parent** Nucleus-breed.
 * Inhibition occurs when Delta-Mem agents set "Protected" status to neighboring Notch membrane agent, which is a binary setting that prevents the signaling (and thus cleavage of Notch). More delta therefore will prevent more Notch from being activated by having the "Protected" status.
 * **currentNuclearNotchCnt** is a variable that counts the number of Cleaved Nuclear Notch there is for each Nucleus. By asking how many Nuclear notch have **parent-who** of the nucleus, it can determine which nucleus-breeds have more notch being cleaved and which are not having their notch cleaved. 
  * Low values mean the cell is expressing mainly Delta, thus Delta agents (red) are mainly produced.
  -------------------------------------------------------------------------
  * **Modifications**
  Earlier is the operation for the basic model Developed by Reynolds etc al (2019). Several changes were made to further create the circuits that a different in each model
  -----------------------------------------------------------
  **all Circuits**
  * all circuits have the addition of the florescence indicator to differentiate the different cell types. 
  * this is achieved by leveraging the **currentNuclearNotchCnt** variable from before
   * if this value is zero for the Nucleus-breed, A line of code tells the agent to ask all surrounding patches (Netlogo topography agents) to turn their color from black to Blue. (called pcolor)
   * if the value is greater than zero, of its related variable **currentNuclearNotchCnt2** is greater than zero, then the cell will ask the surrounding patches to turn either green or pink depending on the circuit design (see supplemental figures or the paper for circuit layouts)
  * the **check-cell-line** is a continuous button to allow for the color of the cell (patch color) to be updated each time step as more Cleaved Nuclear Notch is formed and Die out. This gives a very obvious color change that can be viewed real time in each model.
 -----------------------------------------------------------------------------
 **Two layer Two Genotype**
 Two layer Two genotype is modified where instead of a sheet of identical cells, it starts as a mixture of two different cell genotypes.
 * starting cells called cell A will produce only Delta, 
  * to achieve this NetLogo first gets the number of cells, and then will pick a random 1/3 of those cells to produce Delta initially.
  * next each nucleus agent is asked if it is producing delta agents by determining the numeber of delta agents with **parent** equals the nucleus in question
   * if this is zero, the agent will begin breeding Notch agents alone
   * if it is non zero, it is one of the initial 1/3 selected agents and it will be told to continue making Delta alone.
   * each time step then asks the number of Notch agents **and** delta agents with **parent** equals the nucleus in question
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
**Two layer One Genotype (contact inhibition) **
Two layer one genotype is the basic contact inhibition model that was originally developed by Reynolds etc al (2019). Minor changes were made in this version of the model such as the addition of the color for florescence and changing the input parameters to input windows instead of sliders. 
* the basic performance of contact inhibition is that each cell is allowed to produce the delta and notch as in the Basic model. the inhibition combined with random direction and variable production rates of Delta and Notch lead to the imbalances that keep the agents from getting stuck in an alternating loop
 * However, as Reynolds pointed out in their paper, and verified in this model, incerasing the Notch production quickly relative to Delta leads to a system that will oscilate between cell fate A and cell fate B. it is reccomended therefore to keep the Notch production low relative to Delta production (set by the initial rate input boxes) or keep the Delta High to avoid long simulation times.
 ---------------------------------------------------------------------------------
 **Three layer One Genotype**
 The extension of the One genotype model was to add identical coding structure for a second Notch-Delta signaling model
 * The second Notch2 and Delta 2 agents are only produced by the cells when the **currentNuclearNotchCnt** exceeds a threshold value (an input box allows for the value to be set from 0 to any value greater than zero). Zero threshold would mean both Signaling pathways are open at the same time and thus cells produce Notch1 and 2 and Delta 1 and 2 at the same time. The threshold was set to 5 to instead see how it could mimic the Three layer formation Todo etc al (2018) tested in the context of One genotype.
 * The **check-cell-line** color coding was modified to accomidate the new signaling.
  * If a cell is only breeding Delta agents (both delta 1 and 2), it therefore has zero **currentNuclearNotchCnt**. these cells are Blue and are the "neuron" cells represented by the agents.
  * when a agent is producing Delta 1 but not Delta 2, it is given a green floroescence, indicating **currentNuclearNotchCnt** is non zero however **currentNuclearNotchCnt2** is non zero. 
  * lastly the cells that have a non zero amount of **currentNuclearNotchCnt** and **currentNuclearNotchCnt2** are given a pink color and are the new cell fate. 
  * The behavior is different from the Two Genotype Three layer because the cells are allowed to have to tug of war where Notch and Delta have inhibition effects on each other.
  -----------------------------------------------------------------------------------
  **Two Layer Mobility A signals B**
  To model mobility the following additions were made to the Two layer circuit described above.
  * All agents are now assigned a new parameter called **move-who**. this parameter is tied to the original Who value of the Nucleus-breed that bred the agents. 
   * The result is a Set of agents with identical **move-who** to their **parent** nucleus, which fixes the agents into a group based on cell.
  * Netlogo then asks **all** agents with **move-who** = n, where n is a random value from 0 to # of cells, to change direction to a random value from 0 to 360 and move a distance 8.6 units. 
   * the result is the nucleus breed and all agents with **parent** of the nucleus breed will move in the same direction at the same speed at the same time.
   * since this is random each time step, a random cell will move each time.
  * **check-cell-line** was modified to ask all patches to turn black before each time step (the result is only patches that have been told to turn a color that time step will change and remain the determined color).
   * this removes any trails of color on the patches that may form.
  * Cadherin was modled as a binary feature of the Nucleus-breeds.
   * if **currentNuclearNotchCnt** was non-zero the Nucleus-breeds would have a setting changed from Cadherin = false to Cadherin = true
   * all agents with **move-who** equals the move who of the nucleus would change their setting to Cadherin = true
   * If two Nucleus-Breeds got within Radius + 1 of each other (their membrane agents would be near to overlapping) a new setting called Binding would be set to True.
   * the Movement speed of the agents was then dictated by whether Binding was true or not
    * If binding was true, Movment would be slowed so the agents only move 0.6 units of distance
    * IF binding was false, movemnt was allowed to remain at 8.6 units each time step.
   * Thus Green C cells that were Binding True would eventually run into each other, and slow to a stop. The result is "clusters" of green cells would form slow moving masses, with fast blue A delta producting cells would occasionally move close enough to the clusters to maintain the levels of Cleaved nuclear notch in the Green cells.
  * movement was then biased towards the right, as a random choice in 360 let to many agents that would not move far from their starting positions, so to drive the interactions a bias is present. (this can be removed by changin the Random 180 in the **Diffuse-cells?** code to a random 360.
  
  

