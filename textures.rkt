(module textures racket/gui
  (require sgl/gl
           sgl/gl-vectors
           "gl-frame.rkt")
  (provide getTexture)

(define (getTexture id)
  ; Grass
  (define grass (makeTextureObj grass-top dirt grass-side))

  (cond ((equal? id 'grass) grass)))

(define (makeTextureObj top bot side)
  (define (dispatch sym)
    (cond ((equal? sym 'top) top)
          ((equal? sym 'bot) bot)
          ((equal? sym 'side) side)))
  dispatch)

(define grass-top (image->gl-vector "F:\\Users\\Jesus\\gitRepos\\racketcraft\\res\\grass_top.png"))
(define grass-side (image->gl-vector "F:\\Users\\Jesus\\gitRepos\\racketcraft\\res\\grass_side.png"))
(define dirt (image->gl-vector "F:\\Users\\Jesus\\gitRepos\\racketcraft\\res\\dirt.png")))
