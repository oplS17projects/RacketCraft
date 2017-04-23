(module player racket/gui
  (require "weapon-inactive.rkt"
           "weapon-model.rkt"
           math/array
           racket/vector
           sgl/gl
           sgl/gl-vectors)
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

    ;; Variables needed to get ray
    (define projects (make-gl-float-vector 10))
    (define views (make-gl-float-vector 10))
    (define ports (make-gl-float-vector 10))
    (define ray-start (make-gl-float-vector 3))
    (define ray-end (make-gl-float-vector 3))
    (define rayx-start 0)
    (define rayy-start 0)
    (define rayz-start 0)
    (define rayx-end 0)
    (define rayy-end 0)
    (define rayz-end 0)

    (define (draw)
      ((make-weapon 'grass x y z) 'draw))

    (define (attack from-distance)
      (if (< 0.8 from-distance)
          (* (abs from-distance) PLAYER-DAMAGE)
          PLAYER-DAMAGE))

    ;; Currently doing the algorithms based on http://antongerdelan.net/opengl/raycasting.html
    ;; Will find a way with camera rotation direction
    ;; Mouse x Mouse y is the position of the mouse click on the screen -- not on the racketworld
    (define (getray mousex mousey)
      ;; Getting the values to all views and projections
      (begin (glGetFloatv GL_PROJECTION_MATRIX projects)
             ;; binding the camera direction into a matrix
             ;; if this doesn't work as expected, we could bind x-y-zrot into a new vector3f
             (glGetFloatv GL_MODELVIEW_MATRIX views) 
             (glGetIntegerv GL_VIEWPORT ports))
      
      (if (not (and (equal? (vector-length projects) 0)
                    (equal? (vector-length views) 0)
                    (equal? (vector-length ports) 0)))
          (begin (gluUnProject mousex mousey 0 views projects ports ray-start)
                 (gluUnProject mousex mousey 1 views projects ports ray-end)
                 (if (not (and (equal? (vector-length ray-start) 0)
                               (equal? (vector-length ray-end) 0)))
                     (begin (vector->values ray-start rayx-start rayy-start rayz-start)
                            (vector->values ray-end rayx-end rayy-end rayz-end))
                     "Failed to get Ray vector"))
          "Failed getting port views")
      )

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
        ((equal? sym 'getray) (getray))
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
