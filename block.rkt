(module block racket/gui
  (require sgl/gl
           sgl/gl-vectors)
  (provide make-block
           BLOCK_SIZE)
  
  (define BLOCK_SIZE 1)
  (define halfSize (/ BLOCK_SIZE 2))
  (define (make-block id x y z)
    (define empty? (equal? id 'empty))
    (define renderSide1 #f) ; (y = 1)
    (define renderSide2 #f) ; (y = -1)
    (define renderSide3 #f) ; (z = 1)
    (define renderSide4 #f) ; (z = -1)
    (define renderSide5 #f) ; (x = -1)
    (define renderSide6 #f) ; (x = 1)
    (define isVisible #t)   ; used to check if this block is visible

    (define (set-id newId)
      (set! texture (getTexture id))
      (set! id newId)
      (set! empty? (equal? id 'empty)))
  
    (define (draw)
      (if empty?
          0
          (colored-draw)))
    
    (define (colored-draw)
      (if renderSide1 (drawSide1) 0)
      (if renderSide2 (drawSide2) 0)
      (if renderSide3 (drawSide3) 0)
      (if renderSide4 (drawSide4) 0)
      (if renderSide5 (drawSide5) 0)
      (if renderSide6 (drawSide6) 0))

    (define (setVisibility side visible)
      (cond
        ((equal? side 1) (set! renderSide1 visible))
        ((equal? side 2) (set! renderSide2 visible))
        ((equal? side 3) (set! renderSide3 visible))
        ((equal? side 4) (set! renderSide4 visible))
        ((equal? side 5) (set! renderSide5 visible))
        ((equal? side 6) (set! renderSide6 visible))))

    (define (setBlockVisibility visible)
      (begin (set! renderSide1 visible)
             (set! renderSide2 visible)
             (set! renderSide3 visible)
             (set! renderSide4 visible)
             (set! renderSide5 visible)
             (set! renderSide6 visible)
             ;; Hung -- Currently I do not know which type value of visible is
             ;; so I am just assuming to use this function to make block VISIBLE
             ;; will update later to check visible values by "cond"
             ;; and set isVisible #t or #f afterward
             (set! isVisible #t)))
    
    (define (get-distance player-x player-y player-z)
      (let ((dx (- (sqr (abs x)) (sqr (abs player-x))))
            (dy (- (sqr (abs y)) (sqr (abs player-y))))
            (dz (- (sqr (abs z)) (sqr (abs player-z)))))
       (sqrt (+ dx dy dz))))

    (define (break)
      (if (equal? isVisible #t)
          (begin (setBlockVisibility #f)
                 (set! isVisible #f))
          #f))

    (define (make)
      (if (equal? isVisible #f)
          (begin (setBlockVisibility #t)
                 (set! isVisible #t))
          #f))
    
    (define (dispatch sym)
      (cond
        ((equal? sym 'draw) (draw))
        ((equal? sym 'x) x)
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'id) id)
        ((equal? sym 'set-id) set-id)
        ((equal? sym 'break) (break))
        ((equal? sym 'make) (make))
        ((equal? sym 'get-distance) (get-distance))
        ((equal? sym 'size) BLOCK_SIZE)
        ((equal? sym 'empty?) empty?)
        ((equal? sym 'setVisibility) setVisibility)))

    ; offsets for colored-draw func
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
    
    (define (drawSide1)
      ; Top face
      (glColor3f 0 c1 0)     ; Green
      (glVertex3f  x1 y1 zn1)
      (glVertex3f xn1 y1 zn1)
      (glVertex3f xn1 y1  z1)
      (glVertex3f  x1 y1  z1))

    (define (drawSide2)
      ; Bottom face (y = -1)
      (glColor3f c2 c2 0)      ; Orange
      (glVertex3f  x1 yn1  z1)
      (glVertex3f xn1 yn1  z1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f  x1 yn1 zn1))

    (define (drawSide3)
      ; Back face (z = 1)
      (glColor3f c3 0 0)     ; red
      (glVertex3f  x1 yn1 z1)
      (glVertex3f xn1 yn1 z1)
      (glVertex3f xn1  y1 z1)
      (glVertex3f  x1  y1 z1))

    (define (drawSide4)
      ; Back face (z = -1)
      (glColor3f c4 c4 0)     ; Yellow
      (glVertex3f  x1 yn1 zn1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f xn1  y1 zn1)
      (glVertex3f  x1  y1 zn1))

    (define (drawSide5)
      ; Left face (x = -1)
      (glColor3f 0 0 c5)     ; Blue
      (glVertex3f xn1  y1  z1)
      (glVertex3f xn1  y1 zn1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f xn1 yn1  z1))

    (define (drawSide6)
      ; Right face (x = 1)
      (glColor3f c6 0 c6)     ;  Magenta
      (glVertex3f x1  y1 zn1)
      (glVertex3f x1  y1  z1)
      (glVertex3f x1 yn1  z1)
      (glVertex3f x1 yn1 zn1))
    
    dispatch))
