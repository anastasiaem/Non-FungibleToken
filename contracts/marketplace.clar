;; marketplace.clar
;; Marketplace Contract for managing NFT sales and royalties

(use-trait nft-trait .nft-token)

(define-constant contract-owner tx-sender)
(define-constant marketplace-fee u25) ;; 2.5% marketplace fee

(define-map listings
  uint
  {seller: principal, price: uint}
)

(define-read-only (get-listing (token-id uint))
  (map-get? listings token-id)
)

(define-public (list-nft (nft <nft-trait>) (token-id uint) (price uint))
  (let
    (
      (seller tx-sender)
    )
    (try! (contract-call? nft transfer token-id seller (as-contract tx-sender)))
    (map-set listings token-id {seller: seller, price: price})
    (ok true)
  )
)

(define-public (unlist-nft (nft <nft-trait>) (token-id uint))
  (let
    (
      (listing (unwrap! (map-get? listings token-id) (err u300)))
      (seller (get seller listing))
    )
    (asserts! (is-eq tx-sender seller) (err u301))
    (try! (as-contract (contract-call? nft transfer token-id tx-sender seller)))
    (map-delete listings token-id)
    (ok true)
  )
)

(define-public (buy-nft (nft <nft-trait>) (token-id uint))
  (let
    (
      (listing (unwrap! (map-get? listings token-id) (err u300)))
      (price (get price listing))
      (seller (get seller listing))
      (metadata (unwrap! (contract-call? nft get-token-metadata token-id) (err u302)))
      (creator (get creator metadata))
      (royalty (get royalty metadata))
      (royalty-amount (/ (* price royalty) u10000))
      (marketplace-amount (/ (* price marketplace-fee) u1000))
      (seller-amount (- price (+ royalty-amount marketplace-amount)))
    )
    (try! (stx-transfer? price tx-sender (as-contract tx-sender)))
    (try! (as-contract (stx-transfer? royalty-amount tx-sender creator)))
    (try! (as-contract (stx-transfer? marketplace-amount tx-sender contract-owner)))
    (try! (as-contract (stx-transfer? seller-amount tx-sender seller)))
    (try! (as-contract (contract-call? nft transfer token-id tx-sender tx-sender)))
    (map-delete listings token-id)
    (ok true)
  )
)
