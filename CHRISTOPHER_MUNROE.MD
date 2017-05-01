# RacketCraft

## Christopher Munroe
### April 30, 2017

# Overview
I worked on RacketCraft, a game that mimics the popular game Minecraft.

We chose to represent many of the game concepts with objects. For example, we represented our collective 'world' as an object, 
and the blocks that filled up this world had their own object. The player was also an object.

Much of the code works upon a 3D list of block objects, where each index maps directly to the block's positions in 3D space. 
This list is recursively constructed. 

With a 3D list that directly maps to real-world coordinates, we can fairly easily perform collision detection,
block breaking, and block placing.

**Authorship note:** All of the code described here was written by myself.

# Libraries Used
The code I am describing in this readme used the library:

```
(require sgl/gl)
```

* The ```sgl/gl``` library is racket's opengl library which ultimately provides access to native opengl functions.

# Key Code Excerpts

Here is a discussion of the most essential procedures, including a description of how they embody ideas from 
UMass Lowell's COMP.3010 Organization of Programming languages course.

Five examples are shown and they are individually numbered. 

## 1. World construction

The following code recursively creates our 3D list of blocks.

```
  (define (init-grid length height width)
    (init-box 0 0 0 length height width '()))
  (define (init-box x y z length height width box-builder)
    (if (<= height 0)
        box-builder
        (init-box x (- y BLOCK_SIZE) z length (- height 1) width (cons (init-plane x y z length width '()) box-builder))))
  (define (init-plane x y z length width plane-builder)
    (if (<= width 0)
        plane-builder
        (init-plane x y (+ z BLOCK_SIZE) length (- width 1) (cons (init-row x y z length '()) plane-builder))))
  (define (init-row x y z length row-builder)
    (if (<= length 0)
        row-builder
        (init-row (+ x BLOCK_SIZE) y z (- length 1) (cons (make-block 'grass (- X-LEN x 1) (+ Y-LEN (- y 1)) (- Z-LEN z 1)) row-builder))))
 ```
 
When we first start the program, the world is constructed by calling ```init-grid```, which then constructs a box. The 
high-level idea of ```init-box``` is to generate a box of blocks, starting from position x y z, where the box's dimensions 
is ```length```, ```width```, and ```height```. If we think about it geometrically, a box is composed of a stack of planes.
So, the box function recursively constructs a list of planes by
calling itself with a lower origin point ```(- y BLOCK_SIZE)``` and a smaller height ```(- height 1)```.
Notice that it works in an *iterative* style using ```box-builder``` as a storage variable for the previous calls,
 rather than using extra memory for ```(cons (init-plane ...)```. The other functions, ```init-plane``` and ```init-row``` work
 identitcally to ```init-box```.
 
## 2. Selectors and Predicates using Procedural Abstraction

A set of procedures was created to operate on the ```player``` object. The player basically controls where the camera
is located, and where it is pointed in RacketCraft. In Racket, I chose to represent the player as a pure object with a dispatch function. 
 
```
(define (dispatch sym)
      (cond
        ((equal? sym 'xrot) xrot) ; used to represent the direction of the camera
        ((equal? sym 'yrot) yrot)
        ((equal? sym 'zrot) zrot)
        ((equal? sym 'set-xrot) set-xrot)
        ((equal? sym 'set-yrot) set-yrot)
        ((equal? sym 'set-zrot) set-zrot)
        ((equal? sym 'x) x) ; for camera positioning
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'set-x) set-x)
        ((equal? sym 'set-y) set-y)
        ((equal? sym 'set-z) set-z)
        ((equal? sym 'xvel) xvel) ; for jumping / gravity
        ((equal? sym 'yvel) yvel)
        ((equal? sym 'zvel) zvel)
        ((equal? sym 'set-xvel) set-xvel)
        ((equal? sym 'set-yvel) set-yvel)
        ((equal? sym 'set-zvel) set-zvel)
```
        
One of the simple setters:
```
    (define (set-x new-x) (set! x new-x))
```

## 3. Using Recursion to emulate key-strokes

Racket's canvas class doesn't handle simultaneous key-strokes too intuitively. Imagine the scenario: you want to walk diagonally,
you hold both the FORWARD key (W) and the RIGHT key (D). You would expect to move forward and right simulataneously to move diagonally.
Initially, I bound each key to a function. The W key would act as forward, everytime we got an event for W it would add to
the position of the player. If you hold W down, the callback is repeatedly fired, GOOD. Now, if you hold down W and then hold another key, like D, the event callbacks look like this: 

```<event for W> <event for W> <event for W> .. <event for W> <event for D> <event for D> .. <event for D>``` 

Immediately, we stop getting events for W and only get events for D even though we are holding them both, meaning that I would
stop receiving callbacks for W and you would only move to the RIGHT. Instead, I
relied on a down and release event for the keys. When I receive an event for the W key, if its a key-down event, I start
a thread that repeatedly updates the player's position (calling itself recursively) if there isnt a thread already running.
If it is a key-release event, then we set a boolean that stops the looping thread.

```
    (define loopW? #f)
    (define (loop-press-w)
      (if loopW?
          (begin (safe-move player
                            (world 'collides?)
                            (+ (player 'x) (* (player 'ms) (sin (deg2rad (player 'yrot)))))
                            (- (player 'z) (* (player 'ms) (cos (deg2rad (player 'yrot))))))
                 (sleep REPRESS-TIME)
                 (loop-press-w))
          0))
    ;; Move forward
    (add-key-mapping #\w (lambda (pressed?)
                           (if pressed?
                               (if loopW?
                                   0
                                   (begin (set! loopW? #t)
                                          (thread loop-press-w)))
                               (if loopW?
                                   (set! loopW? #f)
                                   0))))
```

## 4. Drawing the world using our objects and for-each 

Within our opengl function, first we translate/rotate the world based on position/viewing direction of the player, then we draw the world by calling our 'draw function through world's dispatch function (much like the player's dispatch function in #2.): 

```
(glBegin GL_QUADS)
  (myWorld 'draw)
  (glEnd)
```

Here is the myWorld draw function which traverses our 3-dimensional list of blocks and calls each block's draw function through it's dispatch function:

```
(define (draw)
      (for-each (lambda (plane)
                  (for-each (lambda (row)
                              (for-each (lambda (block) (block 'draw)) row)) plane)) grid)
      (myEntities 'draw))
```

Block's draw function:
```
    (define (draw)
      (if empty?
          0
          (colored-draw)))
```
The empty? variable stored within block is enabled if the block is broken, meaning that we should not draw anything if the block is broken.

colored draw just draws the block's six faces. You'll notice that each side has a boolean which can disable/enable the drawing of each face. This is used to save computer resources. We don't always want to draw all 6 faces of each block. Imagine there are two blocks directly adjacent to eachother, side-by-side. In this case, both blocks only need to render 5 sides each, because they both have a side that is obstructed by the other block. So whenever we alter the map these variables are updated accordingly for the affected blocks to avoid drawing unviewable block surfaces.

```
    (define (colored-draw)
      (if renderSide1 (drawSide1) 0)
      (if renderSide2 (drawSide2) 0)
      (if renderSide3 (drawSide3) 0)
      (if renderSide4 (drawSide4) 0)
      (if renderSide5 (drawSide5) 0)
      (if renderSide6 (drawSide6) 0))
```

Example of one of the drawSide functions:
```
    (define (drawSide1)
      ; Top face
      (glColor3f 0 c1 0)     ; Green
      (glVertex3f  x1 y1 zn1)
      (glVertex3f xn1 y1 zn1)
      (glVertex3f xn1 y1  z1)
      (glVertex3f  x1 y1  z1))
```
The variables x1, y1, zn1, etc. are just variable offsets from the blocks true coordinates x y z. We compute these offsets and store them when a block is constructed so we don't compute them for every single draw call in an attempt to save computer resources.
