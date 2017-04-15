(module gl-frame racket/gui
  (require sgl/gl
           sgl/gl-vectors
           "textures.rkt")
  
  (provide make-weapon)
  
  (define BLOCK_SIZE 1)
  (define halfSize (/ BLOCK_SIZE 2))

  (define WEAPON_HEIGHT 3)
  (define WEAPON_WIDTH 1)
  
  (define (make-weapon id x y z)
    (define texture (getTexture id))
    (define x1 (+ x halfSize))
    (define xn1 (- x halfSize))
    (define y1 (+ y halfSize WEAPON_HEIGHT))       ;; make the sheep run above the ground like 1px
    (define yn1 (- y (/ halfSize 2)))  ;; make the sheep run above the ground like 1px
    (define z1 (+ z halfSize))
    (define zn1 (- z halfSize))
    
    (define (draw)
      ;; Drawing body
      ;; Top Face
      (glColor3f 1 0.5 1)     ; white
      (glVertex3f x1 y1 (+ zn1 WEAPON_WIDTH))
      (glVertex3f xn1 y1 (+ zn1 WEAPON_WIDTH))
      (glVertex3f (- xn1 WEAPON_WIDTH) y1  (+ z1 WEAPON_WIDTH))
      (glVertex3f (- x1 WEAPON_WIDTH) y1  (+ z1 WEAPON_WIDTH))
 
      ; Bottom face (y = -1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 yn1  z1)
      (glVertex3f xn1 yn1  z1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f  x1 yn1 zn1)
  
      ; Front face (z = 1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 yn1 z1)
      (glVertex3f xn1 yn1 z1)
      (glVertex3f (- xn1 1)  y1 (- z1 2))
      (glVertex3f (- x1 1) y1 (- z1 2))
 
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
      (glVertex3f x1 yn1 zn1))

    (define (dispatch sym)
      (cond
        ((equal? sym 'x) x)
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'size) BLOCK_SIZE)
        ((equal? sym 'set-x) (lambda (new-x) (set! x new-x)))
        ((equal? sym 'set-y) (lambda (new-y) (set! y new-y)))
        ((equal? sym 'set-z) (lambda (new-z) (set! z new-z)))
        ((equal? sym 'draw) (draw))))
    dispatch))
