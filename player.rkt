(module player racket/gui
  (require "weapon-inactive.rkt"
           "weapon-model.rkt"
           "entities.rkt"
           "myMath.rkt"
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
    (define JUMP-VEL .4)

    ;; Player inventory
    ;; Todo -- Need to figure out how to make inventory list here
    
    ; Player move speed
    (define MOVE_SPEED .18)

    ; height of entity in blocks
    (define HEIGHT 1.9)
    (define BINDPOSE (list 0 0 -1))

    ; Camera orientation
    (define xrot 0)
    (define yrot 0)
    (define zrot 0)
    (define (set-xrot new-xrot) (set! xrot new-xrot))
    (define (set-yrot new-yrot) (set! yrot new-yrot))
    (define (set-zrot new-zrot) (set! zrot new-zrot))

    ; Camera Location
    (define x 1.0)
    (define y 12.0)
    (define z 1.0)
    (define (set-x new-x) (set! x new-x))
    (define (set-y new-y) (set! y new-y))
    (define (set-z new-z) (set! z new-z))
    
    (define xvel 0)
    (define yvel 0)
    (define zvel 0)
    (define (set-xvel new-xvel) (set! xvel new-xvel))
    (define (set-yvel new-yvel) (set! yvel new-yvel))
    (define (set-zvel new-zvel) (set! zvel new-zvel))

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

    (define (getray)
      (rotate-by-yrot yrot (rotate-by-xrot xrot BINDPOSE)))
    
    ;; Currently doing the algorithms based on http://antongerdelan.net/opengl/raycasting.html
    ;; Will find a way with camera rotation direction
    ;; Mouse x Mouse y is the position of the mouse click on the screen -- not on the racketworld
    (define (myray mousex mousey)
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

    (define (jump collides?)
      (if (collides? x (+ (- y HEIGHT) GRAV-ACCEL) z)
          (set-yvel (+ yvel JUMP-VEL))
          0))

    (define (dispatch sym)
      (cond
        ((equal? sym 'xrot) xrot)
        ((equal? sym 'yrot) yrot)
        ((equal? sym 'zrot) zrot)
        ((equal? sym 'set-xrot) set-xrot)
        ((equal? sym 'set-yrot) set-yrot)
        ((equal? sym 'set-zrot) set-zrot)
        ((equal? sym 'x) x)
        ((equal? sym 'y) y)
        ((equal? sym 'z) z)
        ((equal? sym 'set-x) set-x)
        ((equal? sym 'set-y) set-y)
        ((equal? sym 'set-z) set-z)
        ((equal? sym 'xvel) xvel)
        ((equal? sym 'yvel) yvel)
        ((equal? sym 'zvel) zvel)
        ((equal? sym 'set-xvel) set-xvel)
        ((equal? sym 'set-yvel) set-yvel)
        ((equal? sym 'set-zvel) set-zvel)
        ((equal? sym 'HEIGHT) HEIGHT)
        ((equal? sym 'jump) jump)
        ((equal? sym 'getray) (getray))
        ((equal? sym 'myray) (myray))
        ((equal? sym 'attack) (attack))
        ((equal? sym 'isDead) (isDead))
        ((equal? sym 'get-hurt) (get-hurt))
        ((equal? sym 'draw) (draw))
        ((equal? sym 'ms) MOVE_SPEED)
        (else (error "unknown symbol sent to player dispatch" sym))))
    dispatch))
