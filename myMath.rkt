(module input racket/gui
  (provide deg2rad
           rotate-by-xrot
           rotate-by-yrot)
; simple function to convert degrees to radians
(define (deg2rad x) (/ (* x pi) 180))

; http://stackoverflow.com/questions/14607640/rotating-a-vector-in-3d-space
(define (rotate-by-xrot theta vector)
  (let ([xcomp (car vector)]
        [ycomp (cadr vector)]
        [zcomp (caddr vector)]
        [rads (deg2rad (- theta))])
  (list xcomp
        (+ (* (cos rads) ycomp) (* (- (sin rads)) zcomp))
        (+ (* (sin rads) ycomp) (* (cos rads) zcomp)))))

; http://stackoverflow.com/questions/14607640/rotating-a-vector-in-3d-space
(define (rotate-by-yrot theta vector)
  (let ([xcomp (car vector)]
        [ycomp (cadr vector)]
        [zcomp (caddr vector)]
        [rads (deg2rad (- theta))])
  (list (+ (* (cos rads) xcomp) (* (sin rads) zcomp))
        ycomp
        (+ (* (- (sin rads)) xcomp) (* (cos rads) zcomp))))))
