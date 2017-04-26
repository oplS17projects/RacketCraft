# RacketCraft

### Statement
A 3D Minecraft Simulator in Racket. Making a 3D simulator for one of the most favorite games of all time is very challenging and interesting at the same time. I think this project will help us to learn more about Racket individually and Scheme language in general. 

### Analysis
Explain what approaches from class you will bring to bear on the project.

Be explicit about the techiques from the class that you will use. For example:

- Will you use data abstraction? How?
	+ Yes, in Minecraft there are two types of things that we would represent in software: blocks, and entitys. We would have some kind of block class to house all the types of blocks that would populate the terrain of the game. Entitys would represent the moving things in the world, whether that is the player itself, or enemies, etc. We also plan to have an object for the opengl environment because the rendering code shouldn't mix with the game code.

- Will you use recursion? How?
	+ Yes, the on-draw of the opengl canvas calls itself (I think? It must just indirectly trigger itself somehow). I don't believe we will have too many essential recursive functions, though.

- Will you use map/filter/reduce? How?
	+ Yes, most likely for applying an update function on all the entities for every in-game motion update (i.e. applying gravity to all the entities in the active game world)

- Will you use object-orientation? 
	+ Yes, this project requires a huge amount of "oriented object".
	+ We will make a class for each element in the game such as Blocks, Tools, Entities (anything that walks around/is affected by gravity)
	+ For example, each block must have its own position, and material.
	+ For example, each Entity (like an angry zombie) must have a health bar, damage value, texture, behavior function to update its position

- Will you use functional approaches to processing your data? How?
	+ Yes, using our functions to measure how far the character is away from the object. From then, we can determine that if the character is allowed to do stuffs on that object.

- Will you use state-modification approaches? How? (If so, this should be encapsulated within objects. `set!` pretty much should only exist inside an object.)
	+ Yes, constantly. There is a lot of state-modification that is required, like the position of entitys and their health. These values would always be encapsulated.

- Will you build an expression evaluator, like we did in the symbolic differentatior and the metacircular evaluator?
	+ no way
- Will you use lazy evaluation approaches?
	+ Possibly, cant think of a perfect application right now.
	
### External Technologies
- Drawing 3D objects
- generate 3D automations
- generate or process sound

If your project will do anything in this category (not only the things listed above!), include this section and discuss.

### Data Sets or other Source Materials
If you will be working with existing data, where will you get those data from? (Dowload from a website? Access in a database? Create in a simulation you will build? ...)
- We will use some of the public 3D resources for Minecraft that are provided at (http://resourcepack.net/res/3d-resource-pack/)

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
- I think we have done this project as of 95% as planned at the beginnin since all of the goals are finished completely.
- The other 5% are not satisfied is that the models are not as pretty as we thought. It's hard to make the model pretty with pure OpenGL vectors.

## Architecture Diagram
![alt tag](https://github.com/oplS17projects/RacketCraft/blob/master/Artboard.png)
- OpenGL and pict3D environment will keep reading the signals from user (keyboard, mouse ...) and use that signal to determine what action the character will do by passing those signal arguments into our functions.
- After then, collect needed resources and data to draw resources on the screen.
- As an infinite loop, signal will never stop sending into the environemnt as long as the program is still opens.

## Schedule
### First Milestone (Sun Apr 9)
- Able to move around in a 3D world made of blocks. Limited map size. No collision physics.
- Able to break and place blocks from your character.
- blocks drop as item entities that you can walk over and pick up.
- The blocks will be textured.

### Second Milestone (Sun Apr 16)
- Collision physics so you dont fall through the world.
- health bar, takes falling damage

### Public Presentation (Mon Apr 24, Wed Apr 26, or Fri Apr 28)
- Complete a stretch goal, most likely implement other entities like animals or hostile creatures.

Until now, things we have done are:
- Able to draw a world made by blocks
- Able to create a first person's view in the game (player)
- Able to walk by using A,W,S,D keys and change view direction by moving the mouse.
- Able to place and break blocks (placing block is on testing period so it might not be fully working).
- Able to draw zombies and sheeps in the world.
- We now can check which block should be broken and which should not by comparing the distance and ray line from the  view direction of player.
- We also apply gravity into the RacketCraft world, so when we jump and walk onto a block, it feels real.

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
