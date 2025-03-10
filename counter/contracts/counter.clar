;;A variable to store the current global count.
(define-data-var global-count int 0)

;; Define a map data structure.
(define-map counters principal uint)

;; Function to retrieve the count for a given individual.
(define-read-only (get-user-count (who principal))
    (default-to u0 (map-get? counters who))
)

;; Function to retrieve the current global count.
(define-read-only (get-global-count) 
    (var-get global-count)
)

;; Function to record a user's total count.
(define-private (record-user-count)
    (map-set counters tx-sender (+ (get-user-count tx-sender) u1))
)

;; Function that allows a user to mint 1 count token, record their individual count total and increment the global count.
(define-public (increment)
    (begin
        (record-user-count)
        (var-set global-count (+ (var-get global-count) 1))
        (contract-call? .count-token mint)
    )
)

;; Function that allows a user to mint 1 count token, record their individual count total and decrement the global count.
(define-public (decrement)
    (begin
        (record-user-count)
        (var-set global-count (- (var-get global-count) 1))
        (contract-call? .count-token burn)
    )
)