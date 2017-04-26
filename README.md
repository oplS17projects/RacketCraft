# RacketCraft

### Statement
A 3D Minecraft Simulator in Racket. Making a 3D simulator for one of the most favorite games of all time is very challenging and interesting at the same time. This project has helped us learn how to use Racket in practice. 

### Analysis
Explain what approaches from class you will bring to bear on the project.

Be explicit about the techiques from the class that you will use. For example:

- Will you use data abstraction? How?
	+ Yes, world.rkt is a good example. world.rkt creates a world object which contains a 3d list of blocks and a list of entities along with many functions to act on them, but someone using the world object usually only cares about the *update* function and the *draw* function. These functions are the only useful entry point to world.rkt and so that is the some of the only functions we expose.

- Will you use recursion? How?
	+ Yes, we use recursion for scanning an area when breaking/placing a block.
	+ We also use recursion when initializing/constructing our 3D list of blocks in world.rkt
	+ We also use it when looping through a list of key-bindings in gl-frame.rkt
	+ We use recursion and multithreading in input.rkt to keep holding a key down until we see a release event. This allows us to press multiple keys at once, like walking diagonally while jumping.

- Will you use map/filter/reduce? How?
	+ does for-each count? (we used it to call a draw function on each block) No we did not use map/filter/reduce in particular.

- Will you use object-orientation? 
	+ Yes, in Minecraft there are two main types of things that we represented in software: blocks, and entitys. Blocks are the building blocks in the game that you can break and place. Entitys represent the moving things in the world, whether that is the player itself, or enemies, etc.
	+ For example, each Entity (like an angry zombie) must have a health bar, damage value, texture, behavior function to update its position
	+ We also have weapons partially implemented which is an object with attributes, like damage value.
	+ We also have a world object which contains a 3D array of blocks, and a list of entities.

- Will you use functional approaches to processing your data? How?
	+ Yes, using our functions to measure how far the character is away from the object. From then, we can determine that if the character is allowed to do stuffs on that object.

- Will you use state-modification approaches? How? (If so, this should be encapsulated within objects. `set!` pretty much should only exist inside an object.)
	+ Yes, constantly. There is a lot of state-modification that we use in our objects, like the position of entitys and their health. These values are always encapsulated.
	+ Players store x y z position information, a camera direction, a x-component velocity vector, y-comp..., and z-comp...
	+ Blocks contain an x y z and an ID value which determines if they are visible or not. Each side of every block has a boolean associated with it to enable or disable a side that cannot be seen (motivation: imagine two adjacent blocks, the side between the two blocks is drawn twice for no reason, so we disable unnecessary sides with a boolean)
	+ We use state modification when handling keystrokes, when a key is pressed we are notified "<key> pressed down". When a key of interest is pressed down, we set a corresponding boolean to true and start a thread that loops a corresponding callback while that boolean remains true. When we receive the event "<key> released" we set the boolean to false and the thread stops.

- Will you build an expression evaluator, like we did in the symbolic differentatior and the metacircular evaluator?
	+ We did not.
- Will you use lazy evaluation approaches?
	+ We have not.
	
### External Technologies
- Drawing 3D objects
- generate 3D automations
- generate or process sound

If your project will do anything in this category (not only the things listed above!), include this section and discuss.

### Data Sets or other Source Materials
If you will be working with existing data, where will you get those data from? (Dowload from a website? Access in a database? Create in a simulation you will build? ...)
- We did not.

### Deliverable and Demonstration
Explain exactly what you'll have at the end. What will it be able to do at the live demo?
- We will be able to play a simple Minecraft game in Racket with basic functionalities, such as:
	+ At the demo, we will be able to:
		+ Moving around in a 3D world (of limited size) made of blocks. (Terrain generation is probably not on our list of todos)
		+ Able to modify the 3D world by breaking, collecting, and placing these blocks.
		+ (Stretch goal) Fight other enemies, like zombies, that spawn at night.
		+ (Stretch goal) Crafting system to make tools/stuff
		+ (Stretch goal) Simple, but infinite terrain generation and dynamic map loading (so you dont load all blocks at once)

### Evaluation of Results
How will you know if you are successful? 
If you include some kind of _quantitative analysis,_ that would be good.
- I think we have done this project as of 95% as planned at the beginning since many of the goals are finished completely.
- The other 5% are not satisfied is that the models are not as pretty as we thought. It's hard to make the model pretty with pure OpenGL vectors.

## Architecture Diagram
![alt tag](https://github.com/oplS17projects/RacketCraft/blob/master/Artboard.png)
- OpenGL canvas reads the signals from the user (keyboard, mouse ...) fires callbacks which affect world/player
- left click/ right click modifies the blocks in world (break/place block)
- wasd changes the player's location
- mouse changes the player's viewing vector

## Schedule
### First Milestone (Sun Apr 9)
- Able to move around in a 3D world made of blocks. Limited map size. No collision physics. :heavy_check_mark:
- Able to break and place blocks from your character. :heavy_check_mark:
- blocks drop as item entities that you can walk over and pick up. :x:
- The blocks will be textured. :x:

### Second Milestone (Sun Apr 16)
- Collision physics so you dont fall through the world. :heavy_check_mark:
- health bar, takes falling damage :x:

### Public Presentation (Wed Apr 26)
- Complete a stretch goal, most likely implement other entities like animals or hostile creatures. :question:

Until now, things we have done are:
- Able to draw a world made by blocks
- Able to walk by using A,W,S,D keys and change view direction by moving the mouse (first person style).
- Able to place and break blocks.
- Able to draw zombies and sheeps in the world.
- We now can check which block should be broken/placed and which should not by comparing the distance and ray line from the  view direction of player.
- Able to collide and experience gravity in the RacketCraft world, so you can jump and walk on blocks.

## Presentation Slides
Slides available at: https://docs.google.com/presentation/d/1srbz82QFLJGQBim3tOUbULgHD4rR_sbK0Ar46lQP2iM/edit?usp=sharing

## Team Declaration and Group Responsibilities
### Hung Nguyen @hnguyenworkstation
Hung will do documentation and work on the game play, objects....
- So far, Hung has made the models for zombies, sheeps and weapon.
- Hung applied coordinate of mouse to calculate the ray vector of mouse clicking to the object.
- For example, when we move the mouse and click on a block, we able to get the ray vector from our camera to that block at the center at the screen so we will be able to correctly interact with it.

### Christopher Munroe @idkm23 
Christopher is team lead. Additionally, Chris will work on game development...
- made the lower level ideas, like constructing the 3D array of blocks, collision detection, looking around/walking around with mouse and WASD
- implemented, using the Player's ray code, the placement of blocks.
- implemented performance improvements by disabling the unnecessary surfaces on adjacent blocks.
