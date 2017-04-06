(module player racket/gui
  (provide player)
  (define (player)
    ; Player move speed
    (define MOVE_SPEED .1)

    ; Camera orientation
    (define xrot 0)
    (define yrot 50)
    (define zrot 0)

    ; Camera Location
    (define x 10)
    (define y -6)
    (define z -20)

    (define (dispatch sym)
      (cond
        ((equal? sym 'xrot) xrot)
        ((equal? sym 'yrot) yrot)
        ((equal? sym 'zrot) zrot)
        ((equal? sym 'set-xrot) (lambda (new-xrot) (set! xrot new-xrot)))
        ((equal? sym 'set-yrot) (lambda (new-yrot) (set! yrot new-yrot)))
        ((equal? sym 'set-zrot) (lambda (new-zrot) (set! zrot new-zrot)))
        ((equal? sym 'x) x)
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'set-x) (lambda (new-x) (set! x new-x)))
        ((equal? sym 'set-y) (lambda (new-y) (set! y new-y)))
        ((equal? sym 'set-z) (lambda (new-z) (set! z new-z)))
        ((equal? sym 'ms) MOVE_SPEED)
        (else (error "unknown symbol sent to player dispatch" sym))))
    dispatch))
