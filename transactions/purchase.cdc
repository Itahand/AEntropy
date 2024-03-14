import AEntropy from "../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../contracts/Flow/AEntropy.cdc"

import FlowToken from "../../contracts/Flow/standard/FlowToken.cdc"
import FungibleToken from "../../contracts/Flow/standard/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/Flow/standard/NonFungibleToken.cdc"
import MetadataViews from "../../contracts/Flow/standard/MetadataViews.cdc"

transaction(_numberOfTokens: UInt64) {
    let PaymentVault: &FungibleToken.Vault
    let userAddress: Address

    prepare (signer: AuthAccount) {
        // Setup
        if signer.borrow<&AEntropy.Collection>(from: AEntropy.CollectionStoragePath) == nil {
            signer.save(<- AEntropy.createEmptyCollection(), to: AEntropy.CollectionStoragePath)
            signer.link<&AEntropy.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection}>(AEntropy.CollectionPublicPath, target: AEntropy.CollectionStoragePath)
        }

        // Rest of the code
        var paymentPath: StoragePath = /storage/flowTokenVault
        self.userAddress = signer.address

        self.PaymentVault = signer.borrow<&FungibleToken.Vault>(from: paymentPath)!
    }

    execute {
        let price = AEntropy.pricePerToken
        let payment: @FungibleToken.Vault <- self.PaymentVault.withdraw(amount: price * UFix64(_numberOfTokens))
        AEntropy.purchase(payment: <- payment, numberOfTokens: _numberOfTokens, receiver: self.userAddress)
    }
}
