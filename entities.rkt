(module entities racket/gui
  (provide entities
           apply-grav
           safe-move
           GRAV-ACCEL)
  (define GRAV-ACCEL -.02)
  (define (entities)
    (define entityList (list))
    (define (update)
      (for-each (lambda (entity) (entity 'update)) entityList))
    (define (draw)
      (for-each (lambda (entity) (entity 'draw)) entityList))
    (define (add-entity entity)
      (set! entityList (cons entity entityList)))
    (define (dispatch sym)
      (cond
        ((equal? sym 'update) (update))
        ((equal? sym 'draw) (draw))
        ((equal? sym 'add-entity) add-entity)))
    dispatch)
  (define (apply-grav entity collides?)
    ((entity 'set-yvel) (+ (entity 'yvel) GRAV-ACCEL))
    (let ([new-y (+ (entity 'y) (entity 'yvel))])
      (if (collides? (entity 'x) (- new-y (entity 'HEIGHT)) (entity 'z))
          ((entity 'set-yvel) 0)
          ((entity 'set-y) new-y))))
    (define (safe-move entity collides? new-x new-z)
      (let* ([x (entity 'x)]
            [head-y (entity 'y)]
            [feet-y (- head-y (entity 'HEIGHT))]
            [z (entity 'z)])
        (if (or (collides? new-x head-y z) (collides? new-x feet-y z))
            0
            ((entity 'set-x) new-x))
        (if (or (collides? x head-y new-z) (collides? x feet-y new-z))
            0
            ((entity 'set-z) new-z)))))