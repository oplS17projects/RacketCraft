#lang racket/gui

(require (lib "gl.ss" "sgl")
         (lib "gl-vectors.ss" "sgl")
         "block.rkt"
         "entities.rkt"
         "gl-frame.rkt"
         "input.rkt"
         "player.rkt"
         "world.rkt"
         "weapon-inactive.rkt"
         "zombie.rkt")

; contains camera position / location
(define myPlayer (player))
(define myEntities (entities))
((myEntities 'add-entity) (make-zombie 0 -10 5 -10))

; contains blocks in world
(define myWorld (world))

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
  
  (glTranslated (myPlayer 'x) (myPlayer 'y) (myPlayer 'z))
  
  (glBegin GL_QUADS)
  (myEntities 'update)
  (myEntities 'draw)
  (myWorld 'draw)
  (glEnd)
)

;; Set the draw function
(set-gl-draw-fn draw-opengl)
(define window (gl-run))

; initialize input handling
(init-input-listeners window myPlayer)
