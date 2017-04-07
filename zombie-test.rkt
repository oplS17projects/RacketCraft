#lang racket/gui
(require sgl/gl)
(require (lib "gl.ss" "sgl")
         (lib "gl-vectors.ss" "sgl")
         "gl-frame.rkt"
         "block.rkt"
         "input.rkt"
         "player.rkt"
         "zombie.rkt"
         "world.rkt")

(define-syntax-rule (gl-zombie-shape Vertex-Mode statement ...)
  (let () (glBegin Vertex-Mode) statement ... (glEnd)))
 
(define (resize width height)
  (glViewport 0 0 width height))

(define ZOM_SIZE 2)
 
(define (draw-zombie x y z)
  (glClearColor 0.0 0.0 0.0 0.0)
  (glEnable GL_DEPTH_TEST)
  (glClear GL_COLOR_BUFFER_BIT)
  (glClear GL_DEPTH_BUFFER_BIT)
 
  (define getmax (add1 (max x y z)))
 
  (glMatrixMode GL_PROJECTION)
  (glLoadIdentity)
  (glOrtho (/ (- getmax) 2) getmax (/ (- getmax) 2) getmax (/ (- getmax) 2) getmax)
  (glMatrixMode GL_MODELVIEW)
  (glLoadIdentity)
  (glRotatef -45 1.0 0.0 0.0)
  (glRotatef 45 0.0 1.0 0.0)

  ; random colors until textures are figured out
  (define c1 (/ (random 100) 100.0))
  (define c2 (/ (random 100) 100.0))
  (define c3 (/ (random 100) 100.0))
  (define c4 (/ (random 100) 100.0))
  (define c5 (/ (random 100) 100.0))
  (define c6 (/ (random 100) 100.0))
 
  (gl-zombie-shape GL_QUADS
                (glColor3f 0 c1 1)
                (glVertex3d x 0.0 z)
                (glVertex3d x y z)
                (glVertex3d x y 0.0)
                (glVertex3d x 0.0 0.0))
  (gl-zombie-shape GL_QUADS
                (glColor3f 1 c2 0)
                (glVertex3d x 0.0 0.0)
                (glVertex3d x y 0.0)
                (glVertex3d 0.0 y 0.0)
                (glVertex3d 0.0 0.0 0.0)) 
  (gl-zombie-shape GL_QUADS
                (glColor3f c2 c2 0)
                (glVertex3d x y 0.0)
                (glVertex3d x y z)
                (glVertex3d 0.0 y z)
                (glVertex3d 0.0 y 0.0))
  (gl-zombie-shape GL_QUADS
                (glColor3f 0 0 1)
                (glVertex3d (+ x 1) 0.0 (+ z 1))
                (glVertex3d (+ x 1) y z)
                (glVertex3d (+ x 1) y 0.0)
                (glVertex3d (+ x 1) 0.0 0.0))
  (gl-zombie-shape GL_QUADS
                (glColor3f c5 c1 c2)
                (glVertex3d (+ x 1) 0.0 0.0)
                (glVertex3d (+ x 1) y 0.0)
                (glVertex3d 0.0 y 0.0)
                (glVertex3d 0.0 0.0 0.0)) 
  (gl-zombie-shape GL_QUADS
                (glColor3f c2 c1 c1)
                (glVertex3d (+ x 1) y 0.0)
                (glVertex3d (+ x 1) y z)
                (glVertex3d 0.0 y z)
                (glVertex3d 0.0 y 0.0)))
 
(define zombie%
  (class* canvas% ()
    (inherit with-gl-context swap-gl-buffers)
    (init-field (x 15) (y 15) (z 15))
 
    (define/override (on-paint)
      (with-gl-context
        (lambda ()
          (draw-zombie x y z)
          (swap-gl-buffers))))
    
    (super-instantiate () (style '(gl)))))
 
(define window (new frame% (label "Zombie") (min-width 800) (min-height 600)))
(define gl (new zombie% (parent window) (x 1) (y 1) (z 1)))

;; un-comment this frame to show custom layout above and comment the rest from below
;; (send window show #t)

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
    ((make-zombie 'grass 5 0 0) 'draw)
  (glEnd)
)


;; Set the draw function
(set-gl-draw-fn draw-opengl)
(define win (gl-run))