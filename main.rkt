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
         "weapon-model.rkt"
         "zombie.rkt")

; contains camera position / location
(define myPlayer (player))
(define myEntities (entities))

(define (initEntity)
  ((myEntities 'add-entity)
   (make-zombie 0 -10 5 -10))
  ((myEntities 'add-entity)
   (make-weapon 0 -9 4 9)))

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
  (initEntity)
  
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
  (glEnd))

;; Set the draw function
(set-gl-draw-fn draw-opengl)
(define window (gl-run))

; initialize input handling
(init-input-listeners window myPlayer myWorld)
