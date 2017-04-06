;; By Brendan Burns, with modifications by Scott Owens
(module gl-frame racket/gui
  (require sgl/gl
           sgl/gl-vectors
           "textures.rkt")
  (provide make-block
           BLOCK_SIZE)
  
  (define BLOCK_SIZE 2)
  (define halfSize (/ BLOCK_SIZE 2))
  (define (make-block id x y z)
    (define texture (getTexture id))
    (define x1 (+ x halfSize))
    (define xn1 (- x halfSize))
    (define y1 (+ y halfSize))
    (define yn1 (- y halfSize))
    (define z1 (+ z halfSize))
    (define zn1 (- z halfSize))

    ; random colors until textures are figured out
    (define c1 (/ (random 100) 100.0))
    (define c2 (/ (random 100) 100.0))
    (define c3 (/ (random 100) 100.0))
    (define c4 (/ (random 100) 100.0))
    (define c5 (/ (random 100) 100.0))
    (define c6 (/ (random 100) 100.0))
  
    (define (draw)
      (glColor3f 0 c1 0)     ; Green
      (glVertex3f  x1 y1 zn1)
      (glVertex3f xn1 y1 zn1)
      (glVertex3f xn1 y1  z1)
      (glVertex3f  x1 y1  z1)
 
      ; Bottom face (y = -1)
      (glColor3f c2 c2 0)      ; Orange
      (glVertex3f  x1 yn1  z1)
      (glVertex3f xn1 yn1  z1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f  x1 yn1 zn1)
  
      ; Back face (z = 1)
      (glColor3f c3 0 0)     ; red
      (glVertex3f  x1 yn1 z1)
      (glVertex3f xn1 yn1 z1)
      (glVertex3f xn1  y1 z1)
      (glVertex3f  x1  y1 z1)
 
      ; Back face (z = -1)
      (glColor3f c4 c4 0)     ; Yellow
      (glVertex3f  x1 yn1 zn1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f xn1  y1 zn1)
      (glVertex3f  x1  y1 zn1)
 
      ; Left face (x = -1)
      (glColor3f 0 0 c5)     ; Blue
      (glVertex3f xn1  y1  z1)
      (glVertex3f xn1  y1 zn1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f xn1 yn1  z1)
 
      ; Right face (x = 1)
      (glColor3f c6 0 c6)     ;  Magenta
      (glVertex3f x1  y1 zn1)
      (glVertex3f x1  y1  z1)
      (glVertex3f x1 yn1  z1)
      (glVertex3f x1 yn1 zn1))

    (define (dispatch sym)
      (cond
        ((equal? sym 'x) x)
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'size) BLOCK_SIZE)
        ((equal? sym 'draw) (draw))))

    dispatch))