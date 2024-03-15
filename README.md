## Entropy Smart Contract

This is the first step in your journey towards learning how the Entropy smart contract works on the Flow network. All of the code that 
interacts with Flow is written with Cadence; a new high-level programming language intended for smart contract development.

## Table of content

- [Cadence](#cadence)
    - [Smart Contract](#smart-contract)
    - [Transactions](#transactions)
    - [Scripts](#scripts)

 ## Cadence

 On Flow, we have to write and develop not only the Contract, but also the scripts and transactions to interact with them and it's all written in Cadence. 

### 1. Smart Contract

- Collection Info
  - Contract-level variables
  - Events
  - Paths
- Access(contract) Dictionaries
  - nftStorage: dictionary of resources to store lost and found NFTs.
  - minters: dictionary to revoke NFTMinter capacities
- Structs
  - Ticket: is used to keep track of the NFT's state regarding its random number and svg
- Enums
  - TicketState: auxilary enum to support the Ticket struct
- Resources
  - NFT and Collection
  - Administrator: this contains all the functionality around setting up the maxSupply, the script, traits and other neccesary variables. It can also create other administrator resources, and create and        revoke the Minter capacities
    - Admin Functions
       - purchase: mint NFTs without payment.
  - Minter: resource object that can mint new tokens.
