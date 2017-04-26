(module input racket/gui
  (provide deg2rad
           distance
           rotate-by-xrot
           rotate-by-yrot
           make-plane
           find-intersect)
  ; simple function to convert degrees to radians
  (define (deg2rad x) (/ (* x pi) 180))

  (define (distance u v)
    (sqrt (+ (expt (- (car u) (car v)) 2)
             (expt (- (cadr u) (cadr v)) 2)
             (expt (- (caddr u) (caddr v)) 2))))
  
  (define (dotprod v u)
    (+ (* (car v) (car u))
       (* (cadr v) (cadr u))
       (* (caddr v) (caddr u))))

  (define (2point-apply fn v u)
    (list (fn (car v) (car u))
          (fn (cadr v) (cadr u))
          (fn (caddr v) (caddr u))))

  (define (point-apply fn v scalar)
    (list (fn (car v) scalar)
          (fn (cadr v) scalar)
          (fn (caddr v) scalar)))
  
  (define (crossprod v u)
    (list (- (* (cadr v) (caddr u)) (* (caddr v) (cadr u)))
          (- (* (caddr v) (car u)) (* (car v) (caddr u)))
          (- (* (car v) (cadr u)) (* (cadr v) (car u)))))
  
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
            (+ (* (- (sin rads)) xcomp) (* (cos rads) zcomp)))))

  (define (find-intersect plane p0 p1) ;p1 use to be u
    ; for each plane, find the point.
    ; if it is <= block-width^2 away from block origin, then it is valid.
    ; for each valid point, find the closest intersection.
    ; this plane is the corresponding plane to place the block on.
;    (let ([nDotA (dotprod (plane 'n) offset)]
;          [nDotSlope (dotprod (plane 'n) slope)])
;      (if (= nDotSlope 0)
;          -1
;          (2point-apply + offset (point-apply * slope (/ (- (plane 'd) nDotA) nDotSlope))))))
    (let* ([p_co (plane 'p_co)]
           [p_no (plane 'p_no)]
           [n (plane 'n)]
           [u (2point-apply - p1 p0)]
           [dot (dotprod p_no u)])
      (if (= dot 0)
          -1
          (let* ([w (2point-apply - p0 p_co)]
                 [fac (/ (- (dotprod p_no w)) dot)]
                 [u2 (point-apply * u fac)])
                 (2point-apply + p0 u2)))))
          ;(2point-apply + p0 (point-apply * u (/ (- (+ (* a x0) (* b y0) (* c z0) d)) (dotprod n u)))))))

    
  (define (make-plane a b c)
    (define n (make-normal a b c))
    (define (dispatch sym)
      (cond
        ((equal? sym 'n) n)
        ((equal? sym 'v0) a)
        ((equal? sym 'd) (dotprod a n))))
    dispatch)
  
  (define (make-normal a b c)
    (crossprod (2point-apply - b a) (2point-apply - c a))))
