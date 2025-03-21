;; Quality Testing Contract
;; Records water testing results and treatments

(define-data-var admin principal tx-sender)

;; Data structure for quality tests
(define-map quality-tests
  { owner: principal, test-id: uint }
  {
    ph-level: uint,
    contaminant-level: uint,
    test-date: uint,
    passed: bool,
    treatment-applied: (optional (string-utf8 100))
  }
)

;; Counter for test IDs
(define-data-var test-id-counter uint u0)

;; Record a quality test
(define-public (record-test (ph-level uint) (contaminant-level uint) (passed bool) (treatment-applied (optional (string-utf8 100))))
  (let
    ((caller tx-sender)
     (new-test-id (+ (var-get test-id-counter) u1)))
    (begin
      (var-set test-id-counter new-test-id)
      (ok (map-set quality-tests
        {owner: caller, test-id: new-test-id}
        {
          ph-level: ph-level,
          contaminant-level: contaminant-level,
          test-date: block-height,
          passed: passed,
          treatment-applied: treatment-applied
        }
      ))
    )
  )
)

;; Update treatment information
(define-public (update-treatment (test-id uint) (treatment-applied (string-utf8 100)))
  (let
    ((caller tx-sender)
     (test-key {owner: caller, test-id: test-id})
     (existing-test (map-get? quality-tests test-key)))
    (begin
      (asserts! (is-some existing-test) (err u1))
      (ok (map-set quality-tests
        test-key
        (merge (unwrap-panic existing-test)
          {
            treatment-applied: (some treatment-applied)
          }
        )
      ))
    )
  )
)

;; Get test details
(define-read-only (get-test (owner principal) (test-id uint))
  (map-get? quality-tests {owner: owner, test-id: test-id})
)

;; Get latest test ID for an owner
(define-read-only (get-latest-test-id)
  (var-get test-id-counter)
)
