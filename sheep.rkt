(module gl-frame racket/gui
  (require sgl/gl
           sgl/gl-vectors)
  
  (provide make-sheep)
  
  (define BLOCK_SIZE 4)
  (define halfSize (/ BLOCK_SIZE 2))
  
  (define (make-sheep id x y z)
    (define x1 (+ x halfSize))
    (define xn1 (- x halfSize))
    (define y1 (+ y halfSize 1))       ;; make the sheep run above the ground like 1px
    (define yn1 (- y (/ halfSize 2)))  ;; make the sheep run above the ground like 1px
    (define z1 (+ z halfSize))
    (define zn1 (- z halfSize))
    (define xh1 (- xn1 1))
    (define yh1 (- y1 1))
    (define yhn1 (+ yn1 1))
    (define zh1 (- z1 1))
    (define zhn1 (+ zn1 1))

    ;; Sheep Attributes
    (define SHEEP-HEALTH 10)
    (define SHEEP-MEAT 1)

    ;; initial velocity
    (define vec-x (/ (random 10) 100))
    (define vec-y (/ (random 10) 100))
    (define vec-z (/ (random 10) 100))
    (define speed (/ (random 10) 100))
    (define distance 0)
  
    (define (draw)
      ;; Drawing body
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 y1 zn1)
      (glVertex3f xn1 y1 zn1)
      (glVertex3f xn1 y1  z1)
      (glVertex3f  x1 y1  z1)
 
      ; Bottom face (y = -1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 yn1  z1)
      (glVertex3f xn1 yn1  z1)
      (glVertex3f xn1 yn1 zn1)
      (glVertex3f  x1 yn1 zn1)
  
      ; Back face (z = 1)
      (glColor3f 1 1 1)     ; white
      (glVertex3f  x1 yn1 z1)
      (glVertex3f xn1 yn1 z1)
      (glVertex3f xn1  y1 z1)
      (glVertex3f  x1  y1 z1)
 
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
      (glVertex3f x1 yn1 zn1)

      ;; **** Drawing Head
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f xn1 yh1 zhn1)
      (glVertex3f xh1 yh1 zhn1)
      (glVertex3f xh1 yh1  zh1)
      (glVertex3f xn1 yh1  zh1)
 
      ; Bottom face (y = -1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f  x1 yhn1  zh1)
      (glVertex3f xn1 yhn1  zh1)
      (glVertex3f xn1 yhn1 zhn1)
      (glVertex3f  x1 yhn1 zhn1)
  
      ; Back face (z = 1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f xn1 yhn1 zh1)
      (glVertex3f xh1 yhn1 zh1)
      (glVertex3f xh1  yh1 zh1)
      (glVertex3f xn1  yh1 zh1)
 
      ; Back face (z = -1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f  xn1 yhn1 zhn1)
      (glVertex3f  xh1 yhn1 zhn1)
      (glVertex3f  xh1  yh1 zhn1)
      (glVertex3f  xn1  yh1 zhn1)
 
      ; Left face (x = -1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f xh1  yh1  zh1)
      (glVertex3f xh1  yh1 zhn1)
      (glVertex3f xh1 yhn1 zhn1)
      (glVertex3f xh1 yhn1  zh1)
 
      ; Right face (x = 1)
      (glColor3f 0.5 0.35 0.05) ; brown
      (glVertex3f xn1  yh1 zhn1)
      (glVertex3f xn1  yh1  zh1)
      (glVertex3f xn1 yhn1  zh1)
      (glVertex3f xn1 yhn1 zhn1))

    (define (update)
      (if (> distance 1.5)
          (begin (set! distance 0)
                  (* vec-x -1)
                  (* vec-y -1)
                  (* vec-z -1))
          (begin (set! x (- x vec-x))
                 (set! y (- y vec-y))
                 (set! z (- z vec-z))
                 (set! distance (+ distance (max vec-x vec-y vec-z))))))

    (define (get-distance player-x player-y player-z)
      (let ((dx (- (sqr (abs x)) (sqr (abs player-x))))
            (dy (- (sqr (abs y)) (sqr (abs player-y))))
            (dz (- (sqr (abs z)) (sqr (abs player-z)))))
       (sqrt (+ dx dy dz))))

    (define (hurt damage)
      (if (< SHEEP-HEALTH damage)
          (set! SHEEP-HEALTH 0)
          (set! SHEEP-HEALTH (- SHEEP-HEALTH damage))))

    (define (isDead)
      (equal? SHEEP-HEALTH 0))

    (define (dispatch sym)
      (cond
        ((equal? sym 'x) x)
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'update) (update))
        ((equal? sym 'hurt) (hurt))
        ((equal? sym 'isDead) (isDead))
        ((equal? sym 'get-distance) (get-distance))
        ((equal? sym 'size) BLOCK_SIZE)
        ((equal? sym 'draw) (draw))))
    dispatch))
