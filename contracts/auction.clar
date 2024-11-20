;; auction.clar
;; Auction Contract for handling NFT auctions and bids

(use-trait nft-trait .nft-token)

(define-map auctions
  uint
  {
    seller: principal,
    token-id: uint,
    start-price: uint,
    end-block: uint,
    highest-bid: uint,
    highest-bidder: (optional principal)
  }
)

(define-map bids
  {auction-id: uint, bidder: principal}
  uint
)

(define-read-only (get-auction (auction-id uint))
  (map-get? auctions auction-id)
)

(define-read-only (get-bid (auction-id uint) (bidder principal))
  (map-get? bids {auction-id: auction-id, bidder: bidder})
)

(define-public (create-auction (nft <nft-trait>) (token-id uint) (start-price uint) (duration uint))
  (let
    (
      (auction-id (+ (var-get last-auction-id) u1))
      (seller tx-sender)
      (end-block (+ block-height duration))
    )
    (try! (contract-call? nft transfer token-id seller (as-contract tx-sender)))
    (map-set auctions auction-id {
      seller: seller,
      token-id: token-id,
      start-price: start-price,
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
      (auction (unwrap! (map-get? auctions auction-id) (err u200)))
      (current-highest-bid (get highest-bid auction))
    )
    (asserts! (< block-height (get end-block auction)) (err u201))
    (asserts! (> bid-amount current-highest-bid) (err u202))
    (map-set auctions auction-id (merge auction {
      highest-bid: bid-amount,
      highest-bidder: (some tx-sender)
    }))
    (map-set bids {auction-id: auction-id, bidder: tx-sender} bid-amount)
    (ok true)
  )
)

(define-public (end-auction (auction-id uint))
  (let
    (
      (auction (unwrap! (map-get? auctions auction-id) (err u200)))
      (seller (get seller auction))
      (token-id (get token-id auction))
      (highest-bidder (get highest-bidder auction))
      (highest-bid (get highest-bid auction))
    )
    (asserts! (>= block-height (get end-block auction)) (err u203))
    (match highest-bidder
      winner
        (begin
          (try! (as-contract (stx-transfer? highest-bid tx-sender seller)))
          (try! (as-contract (contract-call? .nft transfer token-id tx-sender winner)))
          (ok true)
        )
      (begin
        (try! (as-contract (contract-call? .nft transfer token-id tx-sender seller)))
        (ok false)
      )
    )
  )
)

(define-data-var last-auction-id uint u0)

(define-read-only (get-last-auction-id)
  (var-get last-auction-id)
)
