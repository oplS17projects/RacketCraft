#lang racket/gui
(require sgl/gl)
(require (lib "gl.ss" "sgl")
         (lib "gl-vectors.ss" "sgl")
         "../gl-frame.rkt"
         "../block.rkt"
         "../input.rkt"
         "../player.rkt"
         "../weapon-model.rkt")

; contains camera position / location
(define myPlayer (player))

(define (draw-opengl)
  (glClear (+ GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
  (glLoadIdentity)
  
  (glRotated (myPlayer 'xrot) 1 0 0)
  (glRotated (myPlayer 'yrot) 0 1 0)
  (glRotated (myPlayer 'zrot) 0 0 1)
  
  (glTranslated (myPlayer 'x) (myPlayer 'y) (myPlayer 'z))
  
  (glBegin GL_QUADS)
    ((make-weapon 0 2 12 2) 'draw)
  (glEnd)
)


;; Set the draw function
(set-gl-draw-fn draw-opengl)
(define win (gl-run))