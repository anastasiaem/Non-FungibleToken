(define-non-fungible-token nft-token uint)

(define-data-var last-token-id uint u0)

(define-constant contract-owner tx-sender)

(define-map token-metadata
  uint
  {creator: principal}
)

(define-read-only (get-last-token-id)
  (var-get last-token-id)
)

(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata token-id)
)

(define-public (mint)
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (is-eq tx-sender contract-owner) (err u403))
    (try! (nft-mint? nft-token token-id tx-sender))
    (map-set token-metadata token-id {creator: tx-sender})
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u403))
    (nft-transfer? nft-token token-id sender recipient)
  )
)

