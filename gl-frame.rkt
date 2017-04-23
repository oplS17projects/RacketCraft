;; By Brendan Burns, with modifications by Scott Owens
(module gl-frame racket/gui
  (require sgl/gl
           sgl/gl-vectors)
  (provide set-gl-draw-fn
           init-textures
           image->gl-vector
           bitmap->gl-vector
           gl-load-texture
           get-texture
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
  
  (define (recursive-handle-key list code)
    (cond
      ((empty? list) void)
      ((equal? (caar list) code) ((car (cdr (car list)))))
      (else (recursive-handle-key (rest list) code))))
  
  (define *key-mappings* '())
  
  (define (add-key-mapping key fn)
    (set! *key-mappings* (cons (list key fn) *key-mappings*)))
  
  (define (clear-key-mappings)
    (set! *key-mappings* '()))
  
  (define (gl-handlekey key)
    (recursive-handle-key *key-mappings* (send key get-key-code)))

  (define elisteners '())

  ; to be an event-listener you must take one parameter
  (define (add-event-listener elistener)
    (set! elisteners (cons elistener elisteners)))
  
  (define glcanvas%
    (class canvas%
      (inherit refresh with-gl-context swap-gl-buffers set-cursor)
      (define init? #f)
      (define refresh-queue 1)
      (define/override (on-paint)
        (set! refresh-queue (- refresh-queue 1))
        (print refresh-queue)
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
        (set! refresh-queue (+ refresh-queue 1))
        (gl-handlekey key)
        (refresh))

      (define redraw-mouse-count 0)
      (define/override (on-event event)
        (if (and (equal? (send event get-x) x-center) 
                 (equal? (send event get-y) y-center))
            0
            (if (< redraw-mouse-count -1)
                (set! redraw-mouse-count (+ redraw-mouse-count 1))
                (begin (set! refresh-queue (+ refresh-queue 1))
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
      (identity frame)))
  
  (define *textures* '())
  
  (define init-textures
    (lambda (count)
      (set! *textures* (glGenTextures count))))
  
  (define (bitmap->gl-vector bmp)
    (let* (
           (dc (instantiate bitmap-dc% (bmp)))
           (pixels (* (send bmp get-width) (send bmp get-height)))
           (vec (make-gl-ubyte-vector (* pixels 3)))
           (data (make-bytes (* pixels 4)))
           (i 0)
           )
      (send dc get-argb-pixels 0 0 (send bmp get-width) (send bmp get-height) data)
      (letrec
          ([loop
            (lambda ()
              (when (< i pixels)
                  (begin
                    (gl-vector-set! vec (* i  3) 
                                    (bytes-ref data (+ (* i 4) 1)))
                    (gl-vector-set! vec (+ (* i 3) 1) 
                                    (bytes-ref data (+ (* i 4) 2)))
                    (gl-vector-set! vec (+ (* i 3) 2) 
                                    (bytes-ref data (+ (* i 4) 3)))
                    (set! i (+ i 1))
                    (loop))))])
        (loop))
      (send dc set-bitmap #f)
      (list (send bmp get-width) (send bmp get-height) vec)))
  
  (define (image->gl-vector file) (bitmap->gl-vector (make-object bitmap% file 'unknown #f)))
  
  (define gl-load-texture
    (lambda (image-vector width height min-filter mag-filter ix)
      (glBindTexture GL_TEXTURE_2D (gl-vector-ref *textures* ix))
      (glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER min-filter)
      (glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER mag-filter)
      (let* ((new-width 128)
             (new-height 128)
             (new-img-vec (make-gl-ubyte-vector (* new-width new-height 3))))
        (gluScaleImage GL_RGB
                       width height GL_UNSIGNED_BYTE image-vector
                       new-width new-height GL_UNSIGNED_BYTE new-img-vec)
        (if (or (= min-filter GL_LINEAR_MIPMAP_NEAREST)
                (= mag-filter GL_LINEAR_MIPMAP_NEAREST))
            (gluBuild2DMipmaps GL_TEXTURE_2D 3 new-width new-height GL_RGB GL_UNSIGNED_BYTE new-img-vec)
            (glTexImage2D GL_TEXTURE_2D 0 3 new-width new-height 0 GL_RGB GL_UNSIGNED_BYTE new-img-vec))))
    )
  
  (define get-texture
    (lambda (ix)
      (gl-vector-ref *textures* ix)))
  )