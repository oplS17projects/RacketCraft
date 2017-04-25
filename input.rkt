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
    
    ;; Move forward
    (add-key-mapping #\w (lambda ()
                           (safe-move player
                                      (world 'collides?)
                                      (+ (player 'x) (* (player 'ms) (sin (deg2rad (player 'yrot)))))
                                      (- (player 'z) (* (player 'ms) (cos (deg2rad (player 'yrot))))))))
    ;; Move backward
    (add-key-mapping #\s (lambda ()
                           (safe-move player
                                      (world 'collides?)
                                      (- (player 'x) (* (player 'ms) (sin (deg2rad (player 'yrot)))))
                                      (+ (player 'z) (* (player 'ms) (cos (deg2rad (player 'yrot))))))))
    ;; Move left
    (add-key-mapping #\a (lambda ()
                           (safe-move player
                                      (world 'collides?)
                                      (+ (player 'x) (* (player 'ms) (sin (deg2rad (- (player 'yrot) 90)))))
                                      (- (player 'z) (* (player 'ms) (cos (deg2rad (- (player 'yrot) 90))))))))
    ;; Move right
    (add-key-mapping #\d (lambda ()
                           (safe-move player
                                      (world 'collides?)
                                      (- (player 'x) (* (player 'ms) (sin (deg2rad (- (player 'yrot) 90)))))
                                      (+ (player 'z) (* (player 'ms) (cos (deg2rad (- (player 'yrot) 90))))))))
    
    (add-key-mapping #\space (lambda () ((player 'jump) (world 'collides?))))))