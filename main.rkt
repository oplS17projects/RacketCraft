#lang racket/gui

(require (lib "gl.ss" "sgl")
         (lib "gl-vectors.ss" "sgl")
         "block.rkt"
         "entities.rkt"
         "gl-frame.rkt"
         "input.rkt"
         "player.rkt"
         "world.rkt"
         "sheep.rkt"
         "weapon-inactive.rkt"
         "weapon-model.rkt"
         "zombie.rkt")

; contains camera position / location
(define myPlayer (player))


; contains blocks in world
(define myWorld (world myPlayer))

; contains weapon
(define iWeapon (inactive-weapon))
(define fps 0)
(define lastTime 0)

(define (draw-opengl)
  ;(print (/ 1000.0 (- (current-inexact-milliseconds) lastTime)))
  ;(set! lastTime (current-inexact-milliseconds))
  ;(print " ")
  
  (glClear (+ GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
  (glLoadIdentity)
  
  (glRotated (myPlayer 'xrot) 1 0 0)
  (glRotated (myPlayer 'yrot) 0 1 0)
  (glRotated (myPlayer 'zrot) 0 0 1)
  
  (glTranslated  (- (myPlayer 'x)) (- (myPlayer 'y)) (- (myPlayer 'z)))

  ;(print (list (myPlayer 'x) (myPlayer 'y) (myPlayer 'z)))
  (myWorld 'update)
  
  (glBegin GL_QUADS)
  (myWorld 'draw)
  (glEnd)
  (draw-crosshair))

(define (draw-crosshair)
  (define RADIUS 9)
  (define THICK 1)
  (glMatrixMode GL_PROJECTION)
  (glPushMatrix)
  (glLoadIdentity)
  (glOrtho 0.0 f-width f-height 0.0 -1.0 10.0)
  (glMatrixMode GL_MODELVIEW)
  (glLoadIdentity)
  (glDisable GL_CULL_FACE)

  (glClear GL_DEPTH_BUFFER_BIT)

  (glBegin GL_QUADS)
  (glColor3f .7 .7 .7)
  (glVertex2f (- x-center THICK) (+ y-center RADIUS))
  (glVertex2f (+ x-center THICK) (+ y-center RADIUS))
  (glVertex2f (+ x-center THICK) (- y-center RADIUS))
  (glVertex2f (- x-center THICK) (- y-center RADIUS))
  
  (glVertex2f (- x-center RADIUS) (+ y-center THICK))
  (glVertex2f (+ x-center RADIUS) (+ y-center THICK))
  (glVertex2f (+ x-center RADIUS) (- y-center THICK))
  (glVertex2f (- x-center RADIUS) (- y-center THICK))
  (glEnd)

  ; Making sure we can render 3d again
  (glMatrixMode GL_PROJECTION)
  (glPopMatrix)
  (glMatrixMode GL_MODELVIEW))

;; Set the draw function
(set-gl-draw-fn draw-opengl)
(define window (gl-run))

; initialize input handling
(init-input-listeners window myPlayer myWorld)
