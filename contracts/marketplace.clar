(define-constant contract-owner tx-sender)
(define-constant marketplace-fee u25) ;; 2.5% marketplace fee

(define-map listings
  uint
  {seller: principal, price: uint}
)

(define-read-only (get-listing (token-id uint))
  (map-get? listings token-id)
)

(define-public (list-nft (token-id uint) (price uint))
  (let
    (
      (seller tx-sender)
    )
    (map-set listings token-id {seller: seller, price: price})
    (ok true)
  )
)

(define-public (unlist-nft (token-id uint))
  (let
    (
      (listing (unwrap! (map-get? listings token-id) (err u404)))
      (seller (get seller listing))
    )
    (asserts! (is-eq tx-sender seller) (err u403))
    (map-delete listings token-id)
    (ok true)
  )
)

(define-public (buy-nft (token-id uint))
  (let
    (
      (listing (unwrap! (map-get? listings token-id) (err u404)))
      (price (get price listing))
      (seller (get seller listing))
      (marketplace-amount (/ (* price marketplace-fee) u1000))
      (seller-amount (- price marketplace-amount))
    )
    (try! (stx-transfer? price tx-sender (as-contract tx-sender)))
    (try! (as-contract (stx-transfer? marketplace-amount tx-sender contract-owner)))
    (try! (as-contract (stx-transfer? seller-amount tx-sender seller)))
    (map-delete listings token-id)
    (ok true)
  )
)

