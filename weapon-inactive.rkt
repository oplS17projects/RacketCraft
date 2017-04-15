(module inactive-weapon racket/gui
  (require "weapon-model.rkt")
  (provide inactive-weapon)

  (define (inactive-weapon)
    (define (draw)
      ((make-weapon 'grass 10 -6 -20) 'draw))
    
    (define (dispatch sym)
      (cond ((equal? sym 'draw) (draw))))
    dispatch))