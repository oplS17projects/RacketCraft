(module world racket/gui
  (require "block.rkt"
           "entities.rkt"
           "myMath.rkt"
           "zombie.rkt")
  (provide world)
  
  (define myEntities (entities))
  ((myEntities 'add-entity) (make-zombie 0 -10 5 -10))
  
  (define X-LEN 30)
  (define Y-LEN 10)
  (define Z-LEN 30)
  
  (define (world myPlayer)
    ; This is just an array of spaces, not necessarily blocks.
    (define grid
      (init-grid X-LEN Y-LEN Z-LEN))
    
    (define (draw)
      (for-each (lambda (plane)
                  (for-each (lambda (row)
                              (for-each (lambda (block) (block 'draw)) row)) plane)) grid)
      (myEntities 'draw))
    
    (define (get-block x y z)
      (define (getNth n theList)
        (cond ((and (= n 0) (not (equal? theList '()))) (car theList))
              ((< n 0) -1)
              ((equal? theList '()) -1)
              (else (getNth (- n 1) (cdr theList)))))
      (let ([plane (getNth (round y) grid)])
        (if (equal? plane -1)
            -1
            (let ([col (getNth (round z) plane)])
              (if (equal? col -1)
                  -1
                  (let ([block (getNth (round x) col)])
                    (if (equal? block -1)
                        -1
                        block)))))))
    
    (define (set-block x y z newId)
      (define (setAdjacentVisibility x y z visibility)
        (if (< (+ y 1) Y-LEN)
            (((get-block x (+ y 1) z) 'setVisibility) 2 visibility)
            0)
        (if (>= (- y 1) 0)
            (((get-block x (- y 1) z) 'setVisibility) 1 visibility)
            0)
        (if (< (+ z 1) Z-LEN)
            (((get-block x y (+ z 1)) 'setVisibility) 4 visibility)
            0)
        (if (>= (- z 1) 0)
            (((get-block x y (- z 1)) 'setVisibility) 3 visibility)
            0)
        (if (< (+ x 1) X-LEN)
            (((get-block (+ x 1) y z) 'setVisibility) 5 visibility)
            0)
        (if (>= (- x 1) 0)
            (((get-block (- x 1) y z) 'setVisibility) 6 visibility)
            0))
      ; get to it
      (let* ([x (round x)]
             [y (round y)]
             [z (round z)]
             [block (get-block x y z)])
        (if (equal? block -1)
            ; block doesn't exist at that index
            -1
            (let ([oldId (block 'id)]
                  [height (myPlayer 'HEIGHT)])
              (if (or (equal? oldId newId)
                      (and (= x (round (myPlayer 'x)))
                           (= y (round (myPlayer 'y)))
                           (= z (round (myPlayer 'z))))
                      (and (= x (round (myPlayer 'x)))
                           (= y (round (- (myPlayer 'y) height)))
                           (= z (round (myPlayer 'z)))))
                  ; dont do anything same ID
                  0
                  (begin ((block 'set-id) newId)
                         (if (equal? newId 'empty)
                             ;turn on all adjacent quads
                             (setAdjacentVisibility x y z #t)
                             (if (equal? oldId 'empty)
                                 ;turn off all adjacent quads
                                 (setAdjacentVisibility x y z #f)
                                 ;dont do anything
                                 0))))))))
    
    (define (collides? x y z)
      (let ([block (get-block x y z)])
        (if (equal? block -1)
            #f
            (not (block 'empty?)))))

    (define (break-block-by-player)
      (define SCAN-DISTANCE 5)
      (define CHECK-DIVIDE 9)
      (define total-iters (* SCAN-DISTANCE CHECK-DIVIDE))
      
      (define ray (myPlayer 'getray))
      (define x-incr (/ (car ray) CHECK-DIVIDE))
      (define y-incr (/ (cadr ray) CHECK-DIVIDE))
      (define z-incr (/ (caddr ray) CHECK-DIVIDE))
      (define (find-block-on-ray xcomp ycomp zcomp attempts)
        (let ([block (get-block xcomp ycomp zcomp)])
          (if (or (equal? block -1) (block 'empty?))
              (if (< attempts total-iters)
                  (find-block-on-ray (+ xcomp x-incr) (+ ycomp y-incr) (+ zcomp z-incr) (+ attempts 1))
                  0)
              (set-block xcomp ycomp zcomp 'empty))))
              
      (find-block-on-ray (myPlayer 'x) (myPlayer 'y) (myPlayer 'z) 0))


    (define (place-block-by-player)
      (define SCAN-DISTANCE 5)
      (define CHECK-DIVIDE 9)
      (define total-iters (* SCAN-DISTANCE CHECK-DIVIDE))
      
      (define ray (myPlayer 'getray))
      (define x-incr (/ (car ray) CHECK-DIVIDE))
      (define y-incr (/ (cadr ray) CHECK-DIVIDE))
      (define z-incr (/ (caddr ray) CHECK-DIVIDE))
      (define (find-block-on-ray xcomp ycomp zcomp attempts)
        (let ([block (get-block xcomp ycomp zcomp)])
          (if (or (equal? block -1) (block 'empty?))
              (if (< attempts total-iters)
                  (find-block-on-ray (+ xcomp x-incr) (+ ycomp y-incr) (+ zcomp z-incr) (+ attempts 1))
                  0)
              (step-back xcomp ycomp zcomp (round xcomp) (round ycomp) (round zcomp) 0))))
      (define (step-back xcomp ycomp zcomp clickedx clickedy clickedz attempts)
        (if (> attempts 50) ; in-case the spaghetti code doesnt succeed, avoids infinite loop at least.
            0
            (if (and (= (round xcomp) clickedx)
                     (= (round ycomp) clickedy)
                     (= (round zcomp) clickedz))
                (step-back (- xcomp x-incr) (- ycomp y-incr) (- zcomp z-incr) clickedx clickedy clickedz (+ attempts 1))
                (set-block xcomp ycomp zcomp 'grass))))
              
      (find-block-on-ray (myPlayer 'x) (myPlayer 'y) (myPlayer 'z) 0))
;    (define (place-block-by-player)
;      (define SCAN-DISTANCE 4)
;      (define CHECK-DIVIDE 9)
;      (define total-iters (* SCAN-DISTANCE CHECK-DIVIDE))
;      
;      (define ray (myPlayer 'getray))
;      (define x-incr (/ (car ray) CHECK-DIVIDE))
;      (define y-incr (/ (cadr ray) CHECK-DIVIDE))
;      (define z-incr (/ (caddr ray) CHECK-DIVIDE))
;      (define (find-block-on-ray xcomp ycomp zcomp attempts)
;        (let ([block (get-block xcomp ycomp zcomp)])
;          (if (or (equal? block -1) (block 'empty?))
;              (if (< attempts total-iters)
;                  (find-block-on-ray (+ xcomp x-incr) (+ ycomp y-incr) (+ zcomp z-incr) (+ attempts 1))
;                  0)
;              (let ([side (find-clicked-side (round xcomp) (round ycomp) (round zcomp) block)])
;                (print side)
;                (cond ((equal? side 1) (set-block xcomp        (+ ycomp 1)  zcomp        'grass))
;                      ((equal? side 2) (set-block xcomp        (+ ycomp -1) zcomp        'grass))
;                      ((equal? side 3) (set-block xcomp        ycomp        (+ zcomp 1)  'grass))
;                      ((equal? side 4) (set-block xcomp        ycomp        (+ zcomp -1) 'grass))
;                      ((equal? side 5) (set-block (+ xcomp -1) ycomp        zcomp        'grass))
;                      ((equal? side 6) (set-block (+ xcomp 1)  ycomp        zcomp        'grass)))))))
;      (define (find-clicked-side x y z block)
;        (let ([halfSize (/ (block 'size) 2)])
;          (let ([p1 (list (+ x halfSize) (+ y halfSize) (+ z halfSize))]
;                [p2 (list (+ x halfSize) (+ y halfSize) (- z halfSize))]
;                [p3 (list (+ x halfSize) (- y halfSize) (+ z halfSize))]
;                [p4 (list (+ x halfSize) (- y halfSize) (- z halfSize))]
;                [p5 (list (- x halfSize) (+ y halfSize) (+ z halfSize))]
;                [p6 (list (- x halfSize) (+ y halfSize) (- z halfSize))]
;                [p7 (list (- x halfSize) (- y halfSize) (+ z halfSize))])
;            (let ([planes (list ((block 'getPlane) 1) ; (y = 1)
;                                ((block 'getPlane) 2) ; (y = -1)
;                                ((block 'getPlane) 3) ; (z = 1)
;                                ((block 'getPlane) 4) ; (z = -1)
;                                ((block 'getPlane) 5) ; (x = -1)
;                                ((block 'getPlane) 6))]); (x = 1)
;              (define planenum 0)
;              (printf "\n\nplayer: ~a ~a ~a\n" (myPlayer 'x) (myPlayer 'y) (myPlayer'z))
;              (printf "slope: ~a ~a ~a\n" (car ray) (cadr ray) (caddr ray))
;              (printf "block: ~a ~a ~a\n" x y z)
;              (let ([clicked-side (foldl (lambda (plane result)
;                       (set! planenum (+ planenum 1))
;                       (let* ([blockpt (list (block 'x) (block 'y) (block 'z))]
;                              [playerpt (list (myPlayer 'x) (myPlayer 'y) (myPlayer 'z))]
;                              [intersection (find-intersect plane blockpt (list (car ray) (cadr ray) (caddr ray)))])
;                         (printf "~a ... distance: ~a\n" intersection (distance blockpt intersection))
;                         (if (or (equal? intersection -1) (> (distance blockpt intersection) (sqrt (* 2 (expt halfSize 2))))) ;(sqrt (+ (expt (block 'size) 2) (expt (block 'size) 2)))
;                             result
;                             (if (equal? result -1)
;                                 (cons intersection planenum)
;                                 (if (< (distance playerpt intersection) (distance playerpt (car result)))
;                                     (cons intersection planenum)
;                                     result)))))
;                     -1 planes)])
;                (if (equal? clicked-side -1)
;                    -1
;                    (cdr clicked-side)))))))
;          
;      (find-block-on-ray (myPlayer 'x) (myPlayer 'y) (myPlayer 'z) 0))

    (define (update)
      (apply-grav myPlayer collides?)
      (myEntities 'update))
  
    (define (dispatch sym)
      (cond ((equal? sym 'draw) (draw))
            ((equal? sym 'update) (update))
            ((equal? sym 'collides?) collides?)
            ((equal? sym 'break-block-by-player) (break-block-by-player))
            ((equal? sym 'place-block-by-player) (place-block-by-player))))
    
    (init-world grid)
    dispatch)

  (define (init-world grid)
    (define planeNum 0)
    (for-each 
     (lambda (plane)
       (define rowNum 0)
       (for-each 
        (lambda (row)
          (define colNum 0)
          (for-each 
           (lambda (block) 
             (if (equal? planeNum 0) ((block 'setVisibility) 2 #t) 0)
             (if (equal? planeNum (- Y-LEN 1)) ((block 'setVisibility) 1 #t) 0)
             (if (equal? rowNum 0) ((block 'setVisibility) 4 #t) 0)
             (if (equal? rowNum (- Z-LEN 1)) ((block 'setVisibility) 3 #t) 0)
             (if (equal? colNum 0) ((block 'setVisibility) 5 #t) 0)
             (if (equal? colNum (- X-LEN 1)) ((block 'setVisibility) 6 #t) 0)
             (set! colNum (+ colNum 1)))
           row)
          (set! rowNum (+ rowNum 1)))
        plane)
       (set! planeNum (+ planeNum 1)))
     grid))
    
  
  ; functions to initialize the world's EMPTY grid, no blocks yet.
  (define (init-grid length height width)
    (init-box 0 0 0 length height width '()))
  (define (init-box x y z length height width box-builder)
    (if (<= height 0)
        box-builder
        (init-box x (- y BLOCK_SIZE) z length (- height 1) width (cons (init-plane x y z length width '()) box-builder))))
  (define (init-plane x y z length width plane-builder)
    (if (<= width 0)
        plane-builder
        (init-plane x y (+ z BLOCK_SIZE) length (- width 1) (cons (init-row x y z length '()) plane-builder))))
  (define (init-row x y z length row-builder)
    (if (<= length 0)
        row-builder
        (begin ;(print (list (- X-LEN x 1) " "  (+ Y-LEN (- y 1)) " " (- Z-LEN z 1)))
               (init-row (+ x BLOCK_SIZE) y z (- length 1) (cons (make-block 'grass (- X-LEN x 1) (+ Y-LEN (- y 1)) (- Z-LEN z 1)) row-builder))))))
