# RacketCraft

### Statement
A 3D Minecraft Simulator in Racket. Making a 3D simulator for one of the most favorite games of all time is very challenging and interesting at the same time. I think this project will help us to learn more about Racket individually and Scheme language in general. 

### Analysis
Explain what approaches from class you will bring to bear on the project.

Be explicit about the techiques from the class that you will use. For example:

- Will you use data abstraction? How?
	

- Will you use recursion? How?
	+ Yes, element will be generated recursively during time playing.

- Will you use map/filter/reduce? How?
	

- Will you use object-orientation? 
	+ Yes, this project requires a huge amount of "oriented object".
	+ We will make a class for each element in the game such as Rock, Weapons, Animals...
	+ For example, each block must have its own position, and visibility in the map so it will be interacting easier to the main character.

- Will you use functional approaches to processing your data? How?
	+ Yes, using our functions to measure how far the character is away from the object. From then, we can determine that if the character is allowed to do stuffs on that object.

- Will you use state-modification approaches? How? (If so, this should be encapsulated within objects. `set!` pretty much should only exist inside an object.)

- Will you build an expression evaluator, like we did in the symbolic differentatior and the metacircular evaluator?
- Will you use lazy evaluation approaches?

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
		+ Moving around the 3D racketcraft world.
		+ Able to build rock and break rocks. 
		+ Having an inventory of weapons, tools... 
	+ We are expecting to add "farming - skills" if there is still time.

### Evaluation of Results
How will you know if you are successful? 
If you include some kind of _quantitative analysis,_ that would be good.

## Architecture Diagram
Upload the architecture diagram you made for your slide presentation to your repository, and include it in-line here.
Create several paragraphs of narrative to explain the pieces and how they interoperate.

## Schedule
### First Milestone (Sun Apr 9)
- Able to draw 3D rocks, create a 3D building
- Attach 3D resources into the project

### Second Milestone (Sun Apr 16)
- Able to move character through only the “allowed spaces” in the 3D building
- Able to generate and process audio

### Public Presentation (Mon Apr 24, Wed Apr 26, or Fri Apr 28 [your date to be determined later])
- Able to play a simple Minecraft game with our project. Should finish all of the basic game-functionalities by this time

## Presentation Slides
Slides available at: https://docs.google.com/presentation/d/1srbz82QFLJGQBim3tOUbULgHD4rR_sbK0Ar46lQP2iM/edit?usp=sharing

## Team Declaration and Group Responsibilities
### Hung Nguyen @hnguyenworkstation
Hung will do documentation and work on the game play, objects....

### Christopher Munroe @idkm23 
Christopher is team lead. Additionally, Chris will work on game development...   