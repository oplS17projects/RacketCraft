(module input racket/gui
  (require "gl-frame.rkt")
  (provide init-input-listeners)
  
  ; simple function to convert degrees to radians
  (define (deg2rad x) (/ (* x pi) 180))
  
  (define (init-input-listeners window player)
  
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

    ;; Move forward
    (add-key-mapping #\w (lambda ()
                           ((player 'set-x) (- (player 'x) (* (player 'ms) (sin (deg2rad (player 'yrot))))))
                           ((player 'set-z) (+ (player 'z) (* (player 'ms) (cos (deg2rad (player 'yrot))))))))

    ;; Move backward
    (add-key-mapping #\s (lambda ()
                           ((player 'set-x) (+ (player 'x) (* (player 'ms) (sin (deg2rad (player 'yrot))))))
                           ((player 'set-z) (- (player 'z) (* (player 'ms) (cos (deg2rad (player 'yrot))))))))
    ;; Move left
    (add-key-mapping #\a (lambda () 
                           ((player 'set-x) (- (player 'x) (* (player 'ms) (sin (deg2rad (- (player 'yrot) 90))))))
                           ((player 'set-z) (+ (player 'z) (* (player 'ms) (cos (deg2rad (- (player 'yrot) 90))))))))
    ;; Move right
    (add-key-mapping #\d (lambda () 
                           ((player 'set-x) (+ (player 'x) (* (player 'ms) (sin (deg2rad (- (player 'yrot) 90))))))
                           ((player 'set-z) (- (player 'z) (* (player 'ms) (cos (deg2rad (- (player 'yrot) 90))))))))))