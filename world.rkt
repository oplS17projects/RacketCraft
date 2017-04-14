(module world racket/gui
  (require "block.rkt")
  (provide world)
  
  (define (world)
    ; This is just an empty array, NO BLOCKS.
    (define grid (init-world))
    (define (draw)
      (for-each (lambda (plane)
                  (for-each (lambda (row)
                              (for-each (lambda (block) (block 'draw)) row)) plane)) grid))
    (define (dispatch sym)
      (cond ((equal? sym 'draw) (draw))))
    dispatch)

  (define (init-world)
    (init-grid 10 10 10))

  (define (set-block x y z newId) 0)
    
  
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
        (init-row (+ x BLOCK_SIZE) y z (- length 1) (cons (make-block 'grass x y z) row-builder)))))
