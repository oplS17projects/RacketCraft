#lang racket/gui

(require (lib "gl.ss" "sgl")
         (lib "gl-vectors.ss" "sgl")
         "gl-frame.rkt"
         graphics/graphics)



(define grassTopTx (image->gl-vector "F:\\Users\\Jesus\\gitRepos\\racketcraft\\res\\grass_top.png"))
(define grassSideTx (image->gl-vector "F:\\Users\\Jesus\\gitRepos\\racketcraft\\res\\grass_side.png"))
(define dirtTx (image->gl-vector "F:\\Users\\Jesus\\gitRepos\\racketcraft\\res\\dirt.png"))

(define MOVE_SPEED .1)
(define *xrot* 0)
(define *yrot* 0)
(define *zrot* 0)
(define *tex* 0)
(define *x* 0)
(define *y* 0)
(define *z* -5)

(define (draw-opengl)
  (glClear (+ GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
  (glLoadIdentity)
  
  (glRotated *xrot* 1 0 0)
  (glRotated *yrot* 0 1 0)
  (glRotated *zrot* 0 0 1)
  
  (glTranslated *x* *y* *z*)
  
  (glBegin GL_QUADS)
      (glColor3f 0 1 0)     ; Green
      (glVertex3f  1 1 -1)
      (glVertex3f -1 1 -1)
      (glVertex3f -1 1  1)
      (glVertex3f  1 1  1)
 
      ; Bottom face (y = -1)
      (glColor3f 1 0.5 0)      ; Orange
      (glVertex3f  1 -1  1)
      (glVertex3f -1 -1  1)
      (glVertex3f -1 -1 -1)
      (glVertex3f  1 -1 -1)
  
      ; Back face (z = 1)
      (glColor3f 1 0 0)     ; red
      (glVertex3f  1 -1 1)
      (glVertex3f -1 -1 1)
      (glVertex3f -1  1 1)
      (glVertex3f  1  1 1)
 
      ; Back face (z = -1)
      (glColor3f 1 1 0)     ; Yellow
      (glVertex3f  1 -1 -1)
      (glVertex3f -1 -1 -1)
      (glVertex3f -1  1 -1)
      (glVertex3f  1  1 -1)
 
      ; Left face (x = -1)
      (glColor3f 0 0 1)     ; Blue
      (glVertex3f -1  1  1)
      (glVertex3f -1  1 -1)
      (glVertex3f -1 -1 -1)
      (glVertex3f -1 -1  1)
 
      ; Right face (x = 1)
      (glColor3f 1 0 1)     ;  Magenta
      (glVertex3f 1  1 -1)
      (glVertex3f 1  1  1)
      (glVertex3f 1 -1  1)
      (glVertex3f 1 -1 -1)
  (glEnd)
)

;; Set the draw function
(set-gl-draw-fn draw-opengl)
(define window (gl-run))
;(send window fullscreen (lambda () #t))
; fixes the mouse to the center of the window
(add-event-listener (lambda (event) (send window warp-pointer x-center y-center)))
; changes rotation of world with mouse
(add-event-listener
 (lambda (event)
   (print *yrot*)
   (print " ")
   (if (< (- y-center (send event get-y)) 200)
       (begin (set! *xrot* (- *xrot* (quotient (- y-center (send event get-y)) 2)))
              (set! *yrot* (- *yrot* (quotient (- x-center (send event get-x)) 2))))
       0)))

(define (deg2rad x) (/ (* x pi) 180))

;; Move forward
(add-key-mapping #\w (lambda ()
                       (set! *x* (- *x* (* MOVE_SPEED (sin (deg2rad *yrot*)))))
                       (set! *z* (+ *z* (* MOVE_SPEED (cos (deg2rad *yrot*)))))))

;; Move backward
(add-key-mapping #\s (lambda ()
                       (set! *x* (+ *x* (* MOVE_SPEED (sin (deg2rad *yrot*)))))
                       (set! *z* (- *z* (* MOVE_SPEED (cos (deg2rad *yrot*)))))))
;; Move left
(add-key-mapping #\a (lambda () 
                       (set! *x* (- *x* (* MOVE_SPEED (sin (deg2rad (- *yrot* 90))))))
                       (set! *z* (+ *z* (* MOVE_SPEED (cos (deg2rad (- *yrot* 90))))))))
;; Move right
(add-key-mapping #\d (lambda () 
                       (set! *x* (+ *x* (* MOVE_SPEED (sin (deg2rad (- *yrot* 90))))))
                       (set! *z* (- *z* (* MOVE_SPEED (cos (deg2rad (- *yrot* 90))))))))
