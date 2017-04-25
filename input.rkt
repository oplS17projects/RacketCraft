(module input racket/gui
  (require "gl-frame.rkt"
           "entities.rkt"
           "myMath.rkt")
  (provide init-input-listeners)
  
  (define (init-input-listeners window player world)
  
    ; fixes the mouse to the center of the window
    (add-event-listener (lambda (event) (send window warp-pointer x-center y-center)))

    ; updates the player object's rotation vectors when the mouse is moved.
    (add-event-listener
     (lambda (event)
       (let ((new-xrot (- (player 'xrot) (quotient (- y-center (send event get-y)) 2)))
             (new-yrot (- (player 'yrot) (quotient (- x-center (send event get-x)) 2))))
         ((player 'set-xrot) (cond ((> new-xrot 90) 90)
                                   ((< new-xrot -90) -90)
                                   (else new-xrot)))
         ((player 'set-yrot) new-yrot))))

    (add-event-listener
     (lambda (event)
       (if (or (send event get-left-down) (equal? (send event get-event-type) 'left-up))
           (world 'break-block-by-player)
           0)))

    (define REPRESS-TIME 0.04)
    (define loopW? #f)
    (define (loop-press-w)
      (if loopW?
          (begin (safe-move player
                            (world 'collides?)
                            (+ (player 'x) (* (player 'ms) (sin (deg2rad (player 'yrot)))))
                            (- (player 'z) (* (player 'ms) (cos (deg2rad (player 'yrot))))))
                 (sleep REPRESS-TIME)
                 (loop-press-w))
          0))
    ;; Move forward
    (add-key-mapping #\w (lambda (pressed?)
                           (if pressed?
                               (if loopW?
                                   0
                                   (begin (set! loopW? #t)
                                          (thread loop-press-w)))
                               (if loopW?
                                   (set! loopW? #f)
                                   0)))) ; should never happen
    
    (define loopS? #f)
    (define (loop-press-s)
      (if loopS?
          (begin (safe-move player
                            (world 'collides?)
                            (- (player 'x) (* (player 'ms) (sin (deg2rad (player 'yrot)))))
                            (+ (player 'z) (* (player 'ms) (cos (deg2rad (player 'yrot))))))
                 (sleep REPRESS-TIME)
                 (loop-press-s))
          0))
    ;; Move backward
    (add-key-mapping #\s (lambda (pressed?)
                           (if pressed?
                               (if loopS?
                                   0
                                   (begin (set! loopS? #t)
                                          (thread loop-press-s)))
                               (if loopS?
                                   (set! loopS? #f)
                                   0)))) ; should never happen

    (define loopA? #f)
    (define (loop-press-a)
      (if loopA?
          (begin (safe-move player
                            (world 'collides?)
                            (+ (player 'x) (* (player 'ms) (sin (deg2rad (- (player 'yrot) 90)))))
                            (- (player 'z) (* (player 'ms) (cos (deg2rad (- (player 'yrot) 90))))))
                 (sleep REPRESS-TIME)
                 (loop-press-a))
          0))
    ;; Move left
    (add-key-mapping #\a (lambda (pressed?)
                           (if pressed?
                               (if loopA?
                                   0
                                   (begin (set! loopA? #t)
                                          (thread loop-press-a)))
                               (if loopA?
                                   (set! loopA? #f)
                                   0)))) ; should never happen

    (define loopD? #f)
    (define (loop-press-d)
      (if loopD?
          (begin (safe-move player
                            (world 'collides?)
                            (- (player 'x) (* (player 'ms) (sin (deg2rad (- (player 'yrot) 90)))))
                            (+ (player 'z) (* (player 'ms) (cos (deg2rad (- (player 'yrot) 90))))))
                 (sleep REPRESS-TIME)
                 (loop-press-d))
          0))
    ;; Strafe right
    (add-key-mapping #\d (lambda (pressed?)
                           (if pressed?
                               (if loopD?
                                   0
                                   (begin (set! loopD? #t)
                                          (thread loop-press-d)))
                               (if loopD?
                                   (set! loopD? #f)
                                   0)))) ; should never happen
    
    ;; Strafe right
 ;   (add-key-mapping #\d (lambda (isPressed)
 ;                          (define isPressed #f)
 ;                          (safe-move player
 ;                                     (world 'collides?)
 ;                                     (- (player 'x) (* (player 'ms) (sin (deg2rad (- (player 'yrot) 90)))))
 ;                                     (+ (player 'z) (* (player 'ms) (cos (deg2rad (- (player 'yrot) 90))))))))
    
    (add-key-mapping #\space (lambda (isPressed) ((player 'jump) (world 'collides?))))))