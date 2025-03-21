;; Volume Tracking Contract
;; Monitors water collected and used

(define-data-var admin principal tx-sender)

;; Data structure for volume records
(define-map volume-records
  { owner: principal, month: uint, year: uint }
  {
    collected: uint,
    used: uint,
    last-updated: uint
  }
)

;; Record water collection
(define-public (record-collection (amount uint) (month uint) (year uint))
  (let
    ((caller tx-sender)
     (record-key {owner: caller, month: month, year: year})
     (existing-record (map-get? volume-records record-key)))
    (begin
      (if (is-some existing-record)
        (map-set volume-records
          record-key
          (merge (unwrap-panic existing-record)
            {
              collected: (+ (get collected (unwrap-panic existing-record)) amount),
              last-updated: block-height
            }
          )
        )
        (map-set volume-records
          record-key
          {
            collected: amount,
            used: u0,
            last-updated: block-height
          }
        )
      )
      (ok true)
    )
  )
)

;; Record water usage
(define-public (record-usage (amount uint) (month uint) (year uint))
  (let
    ((caller tx-sender)
     (record-key {owner: caller, month: month, year: year})
     (existing-record (map-get? volume-records record-key)))
    (begin
      (asserts! (is-some existing-record) (err u1))
      (asserts! (<= amount (get collected (unwrap-panic existing-record))) (err u2))
      (ok (map-set volume-records
        record-key
        (merge (unwrap-panic existing-record)
          {
            used: (+ (get used (unwrap-panic existing-record)) amount),
            last-updated: block-height
          }
        )
      ))
    )
  )
)

;; Get volume record for a specific month
(define-read-only (get-volume-record (owner principal) (month uint) (year uint))
  (map-get? volume-records {owner: owner, month: month, year: year})
)

;; Calculate available water
(define-read-only (get-available-water (owner principal) (month uint) (year uint))
  (let
    ((record (map-get? volume-records {owner: owner, month: month, year: year})))
    (if (is-some record)
      (- (get collected (unwrap-panic record)) (get used (unwrap-panic record)))
      u0
    )
  )
)

