(module gl-frame racket/gui
  (require sgl/gl
           sgl/gl-vectors
           "textures.rkt")
  
  (provide make-weapon)
  (define weapon_height 0.8)
  
  (define (make-weapon id x y z)
    (define ltx (+ x 0.3))
    (define rtx (+ x 0.7))
    (define rx (+ x 0.4))
    (define yu (+ y weapon_height))
    (define ze (+ z 0.4))
    
    (define (draw)
      (glColor3f 0.35 0.35 0.35)
      (glVertex3f rtx yu ze)
      (glVertex3f ltx yu ze)
      (glVertex3f ltx yu z)
      (glVertex3f rtx yu z)

      (glColor3f 0.35 0.35 0.35)
      (glVertex3f rx y ze)
      (glVertex3f x y ze)
      (glVertex3f x y z)
      (glVertex3f rx y z)

      (glColor3f 0.35 0.35 0.35)
      (glVertex3f rtx yu ze)
      (glVertex3f ltx yu ze)
      (glVertex3f rx y ze)
      (glVertex3f x y ze)

      (glColor3f 0.35 0.35 0.35)
      (glVertex3f ltx yu z)
      (glVertex3f rtx yu z)
      (glVertex3f x y z)
      (glVertex3f rx y z)
      )

    (define (dispatch sym)
      (cond
        ((equal? sym 'x) x)
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'set-x) (lambda (new-x) (set! x new-x)))
        ((equal? sym 'set-y) (lambda (new-y) (set! y new-y)))
        ((equal? sym 'set-z) (lambda (new-z) (set! z new-z)))
        ((equal? sym 'draw) (draw))))
    dispatch))
