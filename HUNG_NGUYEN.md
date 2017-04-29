# Final Project: RacketCraft

## Hung Nguyen
### April 28, 2017

# Overview
A 3D Minecraft Simulator in Racket. Making a 3D simulator for one of the most favorite games of all time is very challenging and interesting at the same time. This project has helped us learn how to use Racket in practice.

We have finished 7/9 goals we expected to implement for this game, except adding sound and be able to fight in the game. My job in this project is creating the model objects such as zombies, sheeps, weapons... and calculating the ray from the player's camera direction to the center of the screen (since the mouse click only affects at the center of the screen).

# Libraries Used
The code uses three main libraries, two are in OpenGL:

```
(require sgl/gl
        sgl/gl-vectors
        racket/gui)
```
These libraries help me able to connect vectors into surfaces and from surfaces, we made cells.

# Key Code Excerpts
## 1. Discuss about making game models:
Game model is an object that you can interact with by using "dispatch" function. A model has many of their own attributes and we can get any of them by also using "dispatch". There are a few common attributes that I should mention here:

* `draw`: Draw is a procedure that draws the object on the openGl screen. For example, if I call "((make-sheep 0 1 2 3) 'draw)", it means that I want to create a sheep object of type 0 at position (1, 2, 3) and then draw it immediately on the screen.
* A simple dispatch procedure for sheep object. You can tell which does which by just reading the name of the parameters.
```
(make-sheep id x y z)
  .
  .
  .
  (define (dispatch sym)
      (cond
        ((equal? sym 'x) x)
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'update) (update))
        ((equal? sym 'hurt) (hurt))
        ((equal? sym 'isDead) (isDead))
        ((equal? sym 'get-distance) (get-distance))
        ((equal? sym 'size) BLOCK_SIZE)
        ((equal? sym 'draw) (draw))))
    dispatch))
)
```
* Also, I want to mention about "how a model actually draws on the screen". A model is draw by connecting all the vectors together to form a planar space of any shape (I used rectangle the most), and then connect all the planar into a 3D cells. Finally, I draw all those cell together at an ordered position so it will form an actually game model (still doesn't look that nice).
* Here is a sample block of code that draw the sheep model
```
(define (draw)
      ;; Drawing body
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 y1 zn1)
      (glVertex3f xn1 y1 zn1)
      (glVertex3f xn1 y1  z1)
      (glVertex3f  x1 y1  z1)
 
      ; Bottom face (y = -1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 yn1  z1)
      (glVertex3f xn1 yn1  z1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f  x1 yn1 zn1)
  
      ; Back face (z = 1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 yn1 z1)
      (glVertex3f xn1 yn1 z1)
      (glVertex3f xn1  y1 z1)
      (glVertex3f  x1  y1 z1)
 
      ; Back face (z = -1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 yn1 zn1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f xn1  y1 zn1)
      (glVertex3f  x1  y1 zn1)
 
      ; Left face (x = -1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f xn1  y1  z1)
      (glVertex3f xn1  y1 zn1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f xn1 yn1  z1)
 
      ; Right face (x = 1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f x1  y1 zn1)
      (glVertex3f x1  y1  z1)
      (glVertex3f x1 yn1  z1)
      (glVertex3f x1 yn1 zn1)

      ;; **** Drawing Head
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f xn1 yh1 zhn1)
      (glVertex3f xh1 yh1 zhn1)
      (glVertex3f xh1 yh1  zh1)
      (glVertex3f xn1 yh1  zh1)
 
      ; Bottom face (y = -1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f  x1 yhn1  zh1)
      (glVertex3f xn1 yhn1  zh1)
      (glVertex3f xn1 yhn1 zhn1)
      (glVertex3f  x1 yhn1 zhn1)
  
      ; Back face (z = 1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f xn1 yhn1 zh1)
      (glVertex3f xh1 yhn1 zh1)
      (glVertex3f xh1  yh1 zh1)
      (glVertex3f xn1  yh1 zh1)
 
      ; Back face (z = -1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f  xn1 yhn1 zhn1)
      (glVertex3f  xh1 yhn1 zhn1)
      (glVertex3f  xh1  yh1 zhn1)
      (glVertex3f  xn1  yh1 zhn1)
 
      ; Left face (x = -1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f xh1  yh1  zh1)
      (glVertex3f xh1  yh1 zhn1)
      (glVertex3f xh1 yhn1 zhn1)
      (glVertex3f xh1 yhn1  zh1)
 
      ; Right face (x = 1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f xn1  yh1 zhn1)
      (glVertex3f xn1  yh1  zh1)
      (glVertex3f xn1 yhn1  zh1)
      (glVertex3f xn1 yhn1 zhn1))
```

## 2. Checking which block should be break on Mouse click.
* To be able to detect which block should be break on mouse click, we first need to determine the ray line (linear line) from the player's camera view direction (3x1 matrix) to the center coordiniate of the screen. You can get more details at: http://stackoverflow.com/questions/14607640/rotating-a-vector-in-3d-space (this algorithms I also apply in my code -- gave credit in the code as well).

```
  (define (getray)
       (rotate-by-yrot yrot (rotate-by-xrot xrot BINDPOSE)))

  ; http://stackoverflow.com/questions/14607640/rotating-a-vector-in-3d-space
  (define (rotate-by-xrot theta vector)
    (let ([xcomp (car vector)]
          [ycomp (cadr vector)]
          [zcomp (caddr vector)]
          [rads (deg2rad (- theta))])
      (list xcomp
            (+ (* (cos rads) ycomp) (* (- (sin rads)) zcomp))
            (+ (* (sin rads) ycomp) (* (cos rads) zcomp)))))

  ; http://stackoverflow.com/questions/14607640/rotating-a-vector-in-3d-space
  (define (rotate-by-yrot theta vector)
    (let ([xcomp (car vector)]
          [ycomp (cadr vector)]
          [zcomp (caddr vector)]
          [rads (deg2rad (- theta))])
      (list (+ (* (cos rads) xcomp) (* (sin rads) zcomp))
            ycomp
            (+ (* (- (sin rads)) xcomp) (* (cos rads) zcomp)))))
```
* After all, I use the linear line to check if there is any presentation of a block or not (from near to far, distance will increase a constant value by times from player position into the 3D world), if the distance get further than 3, we stop.
## 3. Core values of this project:
- Be able to learn more about using third party library in Racket.
- Be able to use more of Racket technique with:
  + data abstraction
  + recursion
  + map/filter/reduce
  + object-orientation
  + state-modification approaches
  + functional approaches to processing data
  + ...