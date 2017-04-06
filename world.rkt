(module world racket/gui
  (require "block.rkt")
  (provide world)
  
  (define (world)
    (define blocks (init-world 8 8 8))
    (define (draw)
      (for-each (lambda (plane)
                  (for-each (lambda (row)
                              (for-each (lambda (block) (block 'draw)) row)) plane)) blocks))
    (define (dispatch sym)
      (cond ((equal? sym 'draw) (draw))))
    dispatch)

  ; functions to initialize the world with a box of blocks.
  (define (init-world length height width)
    (init-box 0 0 0 length height width '()))
  (define (init-box x y z length height width box-builder)
    (if (<= height 0)
        box-builder
        (init-box x (+ y BLOCK_SIZE) z length (- height 1) width (cons (init-plane x y z length width '()) box-builder))))
  (define (init-plane x y z length width plane-builder)
    (if (<= width 0)
        plane-builder
        (init-plane x y (+ z BLOCK_SIZE) length (- width 1) (cons (init-row x y z length '()) plane-builder))))
  (define (init-row x y z length row-builder)
    (if (<= length 0)
        row-builder
        (init-row (+ x BLOCK_SIZE) y z (- length 1) (cons (make-block 'grass x y z) row-builder)))))
