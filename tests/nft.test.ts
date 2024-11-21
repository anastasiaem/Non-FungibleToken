import { describe, it, expect } from 'vitest'
import { readFileSync } from 'fs'

const contractSource = readFileSync('./contracts/nft.clar', 'utf8')

describe('NFT Contract', () => {
  it('should define a non-fungible token', () => {
    expect(contractSource).toContain('(define-non-fungible-token nft-token uint)')
  })
  
  it('should have a last-token-id variable', () => {
    expect(contractSource).toContain('(define-data-var last-token-id uint u0)')
  })
  
  it('should define a token-metadata map', () => {
    expect(contractSource).toContain('(define-map token-metadata')
  })
  
  it('should have a get-last-token-id function', () => {
    expect(contractSource).toContain('(define-read-only (get-last-token-id)')
  })
  
  it('should have a get-token-metadata function', () => {
    expect(contractSource).toContain('(define-read-only (get-token-metadata (token-id uint))')
  })
  
  it('should have a mint function', () => {
    expect(contractSource).toContain('(define-public (mint)')
  })
  
  it('should have a transfer function', () => {
    expect(contractSource).toContain('(define-public (transfer (token-id uint) (sender principal) (recipient principal))')
  })
  
  it('should check for contract owner in mint function', () => {
    expect(contractSource).toContain('(asserts! (is-eq tx-sender contract-owner) (err u403))')
  })
  
  it('should check for token owner in transfer function', () => {
    expect(contractSource).toContain('(asserts! (is-eq tx-sender sender) (err u403))')
  })
})

