;; System Registration Contract
;; Records details of collection installations

(define-data-var admin principal tx-sender)

;; Data structure for a rainwater harvesting system
(define-map systems
  { owner: principal }
  {
    location: (string-utf8 100),
    capacity: uint,
    installation-date: uint,
    active: bool
  }
)

;; Register a new system
(define-public (register-system (location (string-utf8 100)) (capacity uint) (installation-date uint))
  (let
    ((caller tx-sender))
    (begin
      (asserts! (not (is-some (map-get? systems {owner: caller}))) (err u1))
      (ok (map-set systems
        {owner: caller}
        {
          location: location,
          capacity: capacity,
          installation-date: installation-date,
          active: true
        }
      ))
    )
  )
)

;; Update system details
(define-public (update-system (location (string-utf8 100)) (capacity uint))
  (let
    ((caller tx-sender))
    (begin
      (asserts! (is-some (map-get? systems {owner: caller})) (err u2))
      (ok (map-set systems
        {owner: caller}
        (merge (unwrap-panic (map-get? systems {owner: caller}))
          {
            location: location,
            capacity: capacity
          }
        )
      ))
    )
  )
)

;; Deactivate a system
(define-public (deactivate-system)
  (let
    ((caller tx-sender))
    (begin
      (asserts! (is-some (map-get? systems {owner: caller})) (err u3))
      (ok (map-set systems
        {owner: caller}
        (merge (unwrap-panic (map-get? systems {owner: caller}))
          {active: false}
        )
      ))
    )
  )
)

;; Get system details
(define-read-only (get-system (owner principal))
  (map-get? systems {owner: owner})
)

