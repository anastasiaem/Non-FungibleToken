;; Simplified Auction Contract

(define-map auctions
  uint
  {
    seller: principal,
    token-id: uint,
    end-block: uint,
    highest-bid: uint,
    highest-bidder: (optional principal)
  }
)

(define-data-var last-auction-id uint u0)

(define-read-only (get-auction (auction-id uint))
  (map-get? auctions auction-id)
)

(define-public (create-auction (token-id uint) (duration uint))
  (let
    (
      (auction-id (+ (var-get last-auction-id) u1))
      (end-block (+ block-height duration))
    )
    (map-set auctions auction-id {
      seller: tx-sender,
      token-id: token-id,
      end-block: end-block,
      highest-bid: u0,
      highest-bidder: none
    })
    (var-set last-auction-id auction-id)
    (ok auction-id)
  )
)

(define-public (place-bid (auction-id uint) (bid-amount uint))
  (let
    (
      (auction (unwrap! (map-get? auctions auction-id) (err u404)))
      (current-highest-bid (get highest-bid auction))
    )
    (asserts! (< block-height (get end-block auction)) (err u401))
    (asserts! (> bid-amount current-highest-bid) (err u402))
    (map-set auctions auction-id (merge auction {
      highest-bid: bid-amount,
      highest-bidder: (some tx-sender)
    }))
    (ok true)
  )
)

(define-public (end-auction (auction-id uint))
  (let
    (
      (auction (unwrap! (map-get? auctions auction-id) (err u404)))
      (seller (get seller auction))
      (highest-bidder (get highest-bidder auction))
      (highest-bid (get highest-bid auction))
    )
    (asserts! (>= block-height (get end-block auction)) (err u403))
    (match highest-bidder
      winner (ok true)
      (ok false)
    )
  )
)

