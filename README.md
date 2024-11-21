# NFT Marketplace on Stacks

This project implements a simple NFT Marketplace using Clarity smart contracts on the Stacks blockchain. The marketplace allows users to mint NFTs, create auctions, place bids, list NFTs for sale, and buy NFTs with royalty distribution to creators.

## Features

- Mint NFTs with customizable metadata and royalty percentages
- Create and participate in NFT auctions
- List NFTs for direct sale
- Buy NFTs with automatic royalty distribution
- Marketplace fee on sales

## Contracts

1. `nft.clar`: Handles NFT minting and transfers
2. `auction.clar`: Manages NFT auctions and bidding
3. `marketplace.clar`: Coordinates NFT listings, sales, and royalty distribution

## Usage

### Minting an NFT

```clarity
(contract-call? .nft mint "My NFT Metadata" u500)

This mints a new NFT with the given metadata and a 5% royalty.

### Creating an Auction

```plaintext
(contract-call? .auction create-auction .nft u1 u1000000 u144)
```

This creates an auction for NFT with token ID 1, starting price of 1 STX, and duration of 144 blocks (approximately 1 day).

### Placing a Bid

```plaintext
(contract-call? .auction place-bid u1 u1100000)
```

This places a bid of 1.1 STX on auction with ID 1.

### Ending an Auction

```plaintext
(contract-call? .auction end-auction u1)
```

This ends the auction with ID 1, transferring the NFT to the highest bidder or back to the seller if there were no bids.

### Listing an NFT for Sale

```plaintext
(contract-call? .marketplace list-nft .nft u1 u5000000)
```

This lists NFT with token ID 1 for sale at a price of 5 STX.

### Buying an NFT

```plaintext
(contract-call? .marketplace buy-nft .nft u1)
```

This purchases the NFT with token ID 1 at the listed price, distributing royalties and fees automatically.

## Testing

To test these contracts, you can use Clarinet's console or write unit tests using Clarinet's testing framework. Make sure to deploy all three contracts and mint some NFTs before testing the auction and marketplace functionality.

## Disclaimer

This NFT Marketplace implementation is for educational purposes only and has not been audited. Use at your own risk in any production environment.

```plaintext

This NFT Marketplace implementation provides a solid foundation for minting NFTs, creating auctions, and selling NFTs with royalty distribution. The contracts work together to create a complete marketplace ecosystem:

1. The `nft.clar` contract handles the core NFT functionality, including minting and transfers.
2. The `auction.clar` contract manages NFT auctions, allowing users to create auctions and place bids.
3. The `marketplace.clar` contract ties everything together, handling direct sales and royalty distribution.

To further improve this marketplace, you could consider adding features like:

1. Batch minting and transfers
2. Timed listings for direct sales
3. Offer system for listed NFTs
4. More advanced auction types (e.g., Dutch auctions)
5. Upgradeability for contracts
6. Integration with off-chain metadata storage solutions

Remember to thoroughly test and audit these contracts before deploying them on the mainnet, as they handle valuable assets and financial transactions.
```
