import { describe, it, expect } from 'vitest'
import { readFileSync } from 'fs'

const contractSource = readFileSync('./contracts/marketplace.clar', 'utf8')

describe('Marketplace Contract', () => {
  it('should define contract-owner constant', () => {
    expect(contractSource).toContain('(define-constant contract-owner tx-sender)')
  })
  
  it('should define marketplace-fee constant', () => {
    expect(contractSource).toContain('(define-constant marketplace-fee u25)')
  })
  
  it('should define listings map', () => {
    expect(contractSource).toContain('(define-map listings')
  })
  
  it('should have a get-listing function', () => {
    expect(contractSource).toContain('(define-read-only (get-listing (token-id uint))')
  })
  
  it('should have a list-nft function', () => {
    expect(contractSource).toContain('(define-public (list-nft (token-id uint) (price uint))')
  })
  
  it('should have an unlist-nft function', () => {
    expect(contractSource).toContain('(define-public (unlist-nft (token-id uint))')
  })
  
  it('should have a buy-nft function', () => {
    expect(contractSource).toContain('(define-public (buy-nft (token-id uint))')
  })
  
  it('should check for seller in unlist-nft function', () => {
    expect(contractSource).toContain('(asserts! (is-eq tx-sender seller) (err u403))')
  })
  
  it('should calculate marketplace fee in buy-nft function', () => {
    expect(contractSource).toContain('(/ (* price marketplace-fee) u1000)')
  })
})
