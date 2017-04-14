(module world racket/gui
  (require "block.rkt")
  (provide world)
  
  (define X-LEN 20)
  (define Y-LEN 20)
  (define Z-LEN 20)
  
  (define (world)
    ; This is just an array of spaces, not necessarily blocks.
    (define grid
      (init-grid X-LEN Y-LEN Z-LEN))
    (define (draw)
      (for-each (lambda (plane)
                  (for-each (lambda (row)
                              (for-each (lambda (block) (block 'draw)) row)) plane)) grid))
    (define (dispatch sym)
      (cond ((equal? sym 'draw) (draw))))
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
             (if (equal? rowNum 0) ((block 'setVisibility) 3 #t) 0)
             (if (equal? rowNum (- Z-LEN 1)) ((block 'setVisibility) 4 #t) 0)
             (if (equal? colNum 0) ((block 'setVisibility) 6 #t) 0)
             (if (equal? colNum (- X-LEN 1)) ((block 'setVisibility) 5 #t) 0)
             (set! colNum (+ colNum 1)))
           row)
          (set! rowNum (+ rowNum 1)))
        plane)
       (set! planeNum (+ planeNum 1)))
     grid))

  (define (set-block x y z newId)
    (define (getNth n theList)
      (if (equal? n 0)
          (car theList)
          (getNth (- n 1) (cdr theList))))
    0
    ;(define block-plane (getNth y grid))
    ;(define block-row   (getNth z
    ; get to it
  ;  (((getNth x (getNth z (getNth y grid))) 'setVisibility) 1 #t)
    ; get to its neighbors
    )
    
  
  ; functions to initialize the world's EMPTY grid, no blocks yet.
  (define (init-grid length height width)
    (init-box 0 10 0 length height width '()))
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
        (init-row (+ x BLOCK_SIZE) y z (- length 1) (cons (make-block 'grass x y z) row-builder)))))
