(module player racket/gui
  (require "weapon-inactive.rkt"
           "weapon-model.rkt")
  (provide player)
  (define (player)
    ; contains weapon
    (define iWeapon (inactive-weapon))

    ;; Player Attributes
    (define PLAYER-HEALTH 100)
    (define PLAYER-DAMAGE 10)

    ;; Player inventory
    ;; Todo -- Need to figure out how to make inventory list here
    
    ; Player move speed
    (define MOVE_SPEED .6)

    ; Camera orientation
    (define xrot 0)
    (define yrot 50)
    (define zrot 0)

    ; Camera Location
    (define x 10)
    (define y -6)
    (define z -20)

    (define (draw)
      ((make-weapon 'grass x y z) 'draw))

    (define (attack from-distance)
      (if (< 0.8 from-distance)
          (* (abs from-distance) PLAYER-DAMAGE)
          PLAYER-DAMAGE))

    (define (get-hurt damage)
      (if (> damage PLAYER-HEALTH)
          (set! PLAYER-HEALTH 0)
          (set! PLAYER-HEALTH (- PLAYER-HEALTH damage))))

    (define (isDead)
      (equal? PLAYER-HEALTH 0))

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
        ((equal? sym 'attack) (attack))
        ((equal? sym 'isDead) (isDead))
        ((equal? sym 'get-hurt) (get-hurt))
        ((equal? sym 'set-x) (lambda (new-x) (set! x new-x)))
        ((equal? sym 'set-y) (lambda (new-y) (set! y new-y)))
        ((equal? sym 'set-z) (lambda (new-z) (set! z new-z)))
        ((equal? sym 'draw) (draw))
        ((equal? sym 'ms) MOVE_SPEED)
        (else (error "unknown symbol sent to player dispatch" sym))))
    dispatch))
