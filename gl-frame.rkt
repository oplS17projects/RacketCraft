(module gl-frame racket/gui
  (require sgl/gl
           sgl/gl-vectors)
  (provide set-gl-draw-fn
           add-key-mapping
           add-event-listener
           f-width
           f-height
           x-center
           y-center
           clear-key-mappings
           gl-run)
  
  (define gl-draw void)
  (define gl-init
    (lambda ()
      ;; Standard Init
      (glClearColor 0.0 0.0 0.0 0.5)
      (glClearDepth 1)
      (glEnable GL_TEXTURE_2D)
      (glEnable GL_DEPTH_TEST)
      (glDepthFunc GL_LEQUAL)
      (glHint GL_PERSPECTIVE_CORRECTION_HINT GL_NICEST)
        
      ;; default light
      (glEnable GL_LIGHT0)))
  
  (define (set-gl-draw-fn fn)
    (set! gl-draw fn))

  ; frame width and height
  (define f-width 800)
  (define f-height 600)
  (define x-center 400)
  (define y-center 300)
  
  ;; A function that recorrects for a new aspect ratio when the window is resized
  (define (gl-resize width height)
    (glViewport 0 0 width height)
    
    (glMatrixMode GL_PROJECTION)
    (glLoadIdentity)
    (gluPerspective 45 (/ width height) 0.1 100)
    
    (glMatrixMode GL_MODELVIEW)
    (glLoadIdentity)
    
    (set! f-width width)
    (set! f-height height)
    (set! x-center (quotient width 2))
    (set! y-center (quotient height 2)))
  
  (define (recursive-handle-key list key code)
    (cond
      ((empty? list) void)
      ((or (equal? (caar list) code)
           (equal? (caar list) (send key get-key-release-code)))
       ((car (cdr (car list))) (not (equal? code 'release))))
      (else (recursive-handle-key (rest list) key code))))
  
  (define *key-mappings* '())
  
  (define (add-key-mapping key fn)
    (set! *key-mappings* (cons (list key fn) *key-mappings*)))
  
  (define (clear-key-mappings)
    (set! *key-mappings* '()))
  
  (define (gl-handlekey key)
    ;(print (send key get-key-code))
    (recursive-handle-key *key-mappings* key (send key get-key-code)))

  (define elisteners '())

  ; to be an event-listener you must take one parameter
  (define (add-event-listener elistener)
    (set! elisteners (cons elistener elisteners)))
  
  (define glcanvas%
    (class canvas%
      (inherit refresh with-gl-context swap-gl-buffers set-cursor)
      (define init? #f)
      ;(define refresh-queue 1)
      (define/override (on-paint)
        ;(set! refresh-queue (- refresh-queue 1))
        ;(print refresh-queue)
        (with-gl-context
         (lambda ()
           (unless init?
             (gl-init)
             (set! init? #t))
           (gl-draw)
           (swap-gl-buffers)))
        (queue-callback (lambda () (refresh)) #f))
      
      (define/override (on-size w h)
        (with-gl-context 
         (lambda ()
           (gl-resize w h))))
      
      (define/override (on-char key)
        (gl-handlekey key)
        (refresh))

      (define redraw-mouse-count 0)
      (define/override (on-event event)
        (if (and (equal? (send event get-x) x-center) 
                 (equal? (send event get-y) y-center)
                 (equal? (send event get-event-type) 'motion))
            0
            (if (< redraw-mouse-count 1)
                (set! redraw-mouse-count (+ redraw-mouse-count 1))
                (begin ;(set! refresh-queue (+ refresh-queue 1))
                       (if focused (for-each (lambda (x) (x event)) elisteners) 1)
                       (set! redraw-mouse-count 0)
                       (refresh)))))

      (define focused #f)

      ; when the game goes out of focus, stop handling mouse events and unhide the mouse.
      (define/override (on-focus _focused)
        (set! focused _focused)
        (if focused
            (hide-mouse)
            (unhide-mouse)))

      (super-new (style '(gl no-autoclear)))
      (define (hide-mouse) (set-cursor (make-object cursor% 'blank)))
      (define (unhide-mouse) (set-cursor (make-object cursor% 'arrow)))))

  
  (define (gl-run)
    (let* ((frame (new frame% (label "RacketCraft") 
                              (width f-width) 
                              (height f-height)))
           (glcanvas (new glcanvas% (parent frame))))
      (unless
          (send (send (send glcanvas get-dc) get-gl-context) ok?)
        (display "Error: OpenGL context failed to initialize")
        (newline)
        (exit))
      (send frame show #t)
      (identity frame))))