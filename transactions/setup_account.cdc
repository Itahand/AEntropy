import AEntropy from "../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../contracts/Flow/AEntropy.cdc"

import NonFungibleToken from "../../contracts/Flow/standard/NonFungibleToken.cdc"
import MetadataViews from "../../contracts/Flow/standard/MetadataViews.cdc"

// This transaction configures an account to hold a AEntropy NFT.

transaction {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&AEntropy.Collection>(from: AEntropy.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- AEntropy.createEmptyCollection()

            // save it to the account
            signer.save(<-collection, to: AEntropy.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&AEntropy.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection}>(AEntropy.CollectionPublicPath, target: AEntropy.CollectionStoragePath)
        }
    }
}