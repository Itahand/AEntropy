import FlowToken from "../../../contracts/Flow/standard/FlowToken.cdc"
import FungibleToken from "../../../contracts/Flow/standard/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/Flow/standard/NonFungibleToken.cdc"
import MetadataViews from "../../../contracts/Flow/standard/MetadataViews.cdc"
import NFTCatalog from "../../../contracts/Flow/standard/NFTCatalog.cdc"
import NFTStorefrontV2 from "../../../contracts/Flow/standard/NFTStorefrontV2.cdc"
import TokenForwarding from "../../../contracts/Flow/standard/TokenForwarding.cdc"
import HybridCustody from "../../../contracts/Flow/hybridCustody/HybridCustody.cdc"

/// Transaction used to facilitate the creation of the listing under the signer's owned storefront resource.
/// It accepts the certain details from the signer,i.e. -
///
/// `saleItemID` - ID of the NFT that is put on sale by the seller.
/// `saleItemPrice` - Amount of tokens (FT) buyer needs to pay for the purchase of listed NFT.
/// `customID` - Optional string to represent identifier of the dapp.
/// `buyer` - Optional address for the only address that is permitted to fill this listing
/// `expiry` - Unix timestamp at which created listing become expired.
/// `nftProviderAddress` - The address the nft being sold should come from
/// `providerPathIdentifier` - The path to the provider capability for the nft being sold
/// `publicPathIdentifier` - The path to the public capability for the nft being sold
/// `ftReceiverAddress` - The address that should receive purchase payment
/// If the given nft has a support of the RoyaltyView then royalties will added as the sale cut.

transaction(collectionIdentifier: String, saleItemID: UInt64, saleItemPrice: UFix64, customID: String, buyer: Address, expiry: UInt64, nftProviderPathIdentifier: String, nftProviderAddress: Address, ftReceiverAddress: Address) {
    let paymentReceiver: Capability<&FlowToken.Vault{FungibleToken.Receiver}>
    let nftProvider: Capability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let storefront: &NFTStorefrontV2.Storefront
    let nftType: Type

    prepare(seller: AuthAccount) {
        if seller.borrow<&NFTStorefrontV2.Storefront>(from: NFTStorefrontV2.StorefrontStoragePath) == nil {
            // Create a new empty Storefront
            let storefront <- NFTStorefrontV2.createStorefront() as! @NFTStorefrontV2.Storefront
            // save it to the account
            seller.save(<-storefront, to: NFTStorefrontV2.StorefrontStoragePath)
            // create a public capability for the Storefront, first unlinking to ensure we remove anything that's already present
            seller.unlink(NFTStorefrontV2.StorefrontPublicPath)
            seller.link<&NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}>(NFTStorefrontV2.StorefrontPublicPath, target: NFTStorefrontV2.StorefrontStoragePath)
        }

        let value = NFTCatalog.getCatalogEntry(collectionIdentifier: collectionIdentifier) ?? panic("Provided collection is not in the NFT Catalog.")

        if ftReceiverAddress == seller.address {
            self.paymentReceiver = seller.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
        } else {
            let manager = seller.borrow<&HybridCustody.Manager>(from: HybridCustody.ManagerStoragePath)
                ?? panic("Missing or mis-typed HybridCustody Manager")

            let child = manager.borrowAccount(addr: ftReceiverAddress) ?? panic("no child account with that address")
            self.paymentReceiver = getAccount(ftReceiverAddress).getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
        }

        assert(self.paymentReceiver.check(), message: "Missing or mis-typed FlowToken receiver")

        if nftProviderAddress == seller.address {
            let flowtyNftCollectionProviderPath = /private/FlowtyTestNFT0xd9c02cdacccb25abCollectionProviderForFlowty

            if !seller.getCapability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(flowtyNftCollectionProviderPath).check() {
                seller.unlink(flowtyNftCollectionProviderPath)
                seller.link<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(flowtyNftCollectionProviderPath, target: StoragePath(identifier: identifier)!)
            }

            if !seller.getCapability<&{NonFungibleToken.CollectionPublic}>(value.collectionData.publicPath).check() {
                seller.unlink(value.collectionData.publicPath)
                seller.link<&{NonFungibleToken.CollectionPublic}>(value.collectionData.publicPath, target: value.collectionData.storagePath)
            }

            self.nftProvider = seller.getCapability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(flowtyNftCollectionProviderPath)
        } else {
            let collectionProviderPrivatePath = PrivatePath(identifier: nftProviderPathIdentifier) ?? panic("invalid provider path identifier")

            let manager = seller.borrow<&HybridCustody.Manager>(from: HybridCustody.ManagerStoragePath)
                ?? panic("Missing or mis-typed HybridCustody Manager")

            let child = manager.borrowAccount(addr: nftProviderAddress) ?? panic("no child account with that address")
            let providerCap = child.getCapability(path: collectionProviderPrivatePath, type: Type<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>()) ?? panic("no nft provider found")
            self.nftProvider = providerCap as! Capability<&{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
        }

        assert(self.nftProvider.borrow() != nil, message: "Missing or mis-typed NFT provider")

        let collection = self.nftProvider.borrow()
            ?? panic("Could not borrow a reference to the collection")
        let nft = collection.borrowNFT(id: saleItemID)
        self.nftType = nft.getType()

        self.storefront = seller.borrow<&NFTStorefrontV2.Storefront>(from: NFTStorefrontV2.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {
        // check for existing listings of the NFT
        var existingListingIDs = self.storefront.getExistingListingIDs(
            nftType: self.nftType,
            nftID: saleItemID
        )
        // remove existing listings
        for listingID in existingListingIDs {
            self.storefront.removeListing(listingResourceID: listingID)
        }

        // Create listing
        self.storefront.createListing(
            nftProviderCapability: self.nftProvider,
            paymentReceiver: self.paymentReceiver,
            nftType: self.nftType,
            nftID: saleItemID,
            salePaymentVaultType: Type<@FlowToken.Vault>(),
            price: saleItemPrice,
            customID: customID,
            expiry: UInt64(getCurrentBlock().timestamp) + expiry,
            buyer: buyer
        )
    }
}