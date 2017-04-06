#lang racket/gui

(require (lib "gl.ss" "sgl")
         (lib "gl-vectors.ss" "sgl")
         "gl-frame.rkt"
         "block.rkt"
         "input.rkt"
         "player.rkt"
         "world.rkt")

; contains camera position / location
(define myPlayer (player))

; contains blocks in world
(define myWorld (world))

(define (draw-opengl)
  (glClear (+ GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
  (glLoadIdentity)
  
  (glRotated (myPlayer 'xrot) 1 0 0)
  (glRotated (myPlayer 'yrot) 0 1 0)
  (glRotated (myPlayer 'zrot) 0 0 1)
  
  (glTranslated (myPlayer 'x) (myPlayer 'y) (myPlayer 'z))
  
  (glBegin GL_QUADS)
    (myWorld 'draw)
  (glEnd)
)


;; Set the draw function
(set-gl-draw-fn draw-opengl)
(define window (gl-run))

; initialize input handling
(init-input-listeners window myPlayer)
