import HybridCustody from "../../../contracts/Flow/hybridCustody/HybridCustody.cdc"
import FlowToken from "../../../contracts/Flow/standard/FlowToken.cdc"
import FungibleToken from "../../../contracts/Flow/standard/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/Flow/standard/NonFungibleToken.cdc"
import NFTStorefrontV2 from "../../../contracts/Flow/standard/NFTStorefrontV2.cdc"
import MetadataViews from "../../../contracts/Flow/standard/MetadataViews.cdc"
import NFTCatalog from "../../../contracts/Flow/standard/NFTCatalog.cdc"


/// Storefront purchase txn that can route nfts to a child, and take tokens from a child to pay

transaction(storefrontAddress: Address, listingResourceID: UInt64, commissionRecipient: Address, collectionIdentifier: String, nftReceiverAddress: Address, ftProviderAddress: Address, privateFTPath: String ) {
  let paymentVault: @FungibleToken.Vault
  let collection: &AnyResource{NonFungibleToken.CollectionPublic}
  let storefront: &NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}
  let listing: &NFTStorefrontV2.Listing{NFTStorefrontV2.ListingPublic}
  var commissionRecipientCap: Capability<&{FungibleToken.Receiver}>?
  let collectionCap: Capability<&AnyResource{NonFungibleToken.CollectionPublic}>
  let listingAcceptor: &NFTStorefrontV2.Storefront{NFTStorefrontV2.PrivateListingAcceptor}

  prepare(buyer: AuthAccount) {
    if buyer.borrow<&NFTStorefrontV2.Storefront>(from: NFTStorefrontV2.StorefrontStoragePath) == nil {
      // Create a new empty Storefront
      let storefront <- NFTStorefrontV2.createStorefront() as! @NFTStorefrontV2.Storefront
      // save it to the account
      buyer.save(<-storefront, to: NFTStorefrontV2.StorefrontStoragePath)
      // create a public capability for the Storefront, first unlinking to ensure we remove anything that's already present
      buyer.unlink(NFTStorefrontV2.StorefrontPublicPath)
      buyer.link<&NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}>(NFTStorefrontV2.StorefrontPublicPath, target: NFTStorefrontV2.StorefrontStoragePath)
    }

    self.listingAcceptor = buyer.borrow<&NFTStorefrontV2.Storefront{NFTStorefrontV2.PrivateListingAcceptor}>(from: NFTStorefrontV2.StorefrontStoragePath) ?? panic("Buyer storefront is invalid")

    let value = NFTCatalog.getCatalogEntry(collectionIdentifier: collectionIdentifier) ?? panic("Provided collection is not in the NFT Catalog.")

    self.commissionRecipientCap = nil
    // Access the storefront public resource of the seller to purchase the listing.
    self.storefront = getAccount(storefrontAddress)
      .getCapability<&NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}>(
        NFTStorefrontV2.StorefrontPublicPath
      )!
      .borrow()
      ?? panic("Could not borrow Storefront from provided address")

    // Borrow the listing
    self.listing = self.storefront.borrowListing(listingResourceID: listingResourceID)
      ?? panic("Listing not found")
    let listingDetails = self.listing.getDetails()
    let nftRef = self.listing.borrowNFT() ?? panic("nft not found")

    if nftReceiverAddress == buyer.address {
        self.collectionCap = buyer.getCapability<&AnyResource{NonFungibleToken.CollectionPublic}>(value.collectionData.publicPath)
        // unlink and relink first, if it still isn't working, then we will try to save it!
        if !self.collectionCap.check() {
            if buyer.borrow<&AnyResource>(from: value.collectionData.storagePath) == nil {
                // pull the metdata resolver for this listing's nft and use it to configure this account's collection
                // if it is not already configured.
                let collectionData = nftRef.resolveView(Type<MetadataViews.NFTCollectionData>())! as! MetadataViews.NFTCollectionData
                buyer.save(<- collectionData.createEmptyCollection(), to: value.collectionData.storagePath)
            }

            buyer.unlink(value.collectionData.publicPath)
            buyer.link<&{NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection, NonFungibleToken.Receiver}>(value.collectionData.publicPath, target: value.collectionData.storagePath)
        }
    } else {
        // signer is the parent account and nftProvider is child Account
        // get the manager resource and borrow proxyAccount
        let manager = buyer.borrow<&HybridCustody.Manager>(from: HybridCustody.ManagerStoragePath)
            ?? panic("manager does not exist")
        let childAcct = manager.borrowAccount(addr: nftReceiverAddress) ?? panic("nft receiver address is not a child account")
        self.collectionCap = getAccount(nftReceiverAddress).getCapability<&AnyResource{NonFungibleToken.CollectionPublic}>(value.collectionData.publicPath)
        // We can't change child account links in any way
    }

    // Access the buyer or child's NFT collection to store the purchased NFT.
    self.collection = self.collectionCap.borrow() ?? panic("Cannot borrow NFT collection receiver")

    // Access the vault of the buyer/child to pay the sale price of the listing.
    if ftProviderAddress == buyer.address{
      let vault = buyer.borrow<&{FungibleToken.Provider}>(from: /storage/flowTokenVault)
        ?? panic("Cannot borrow FlowToken vault from acct storage")
      self.paymentVault <- vault.withdraw(amount: listingDetails.salePrice)
    } else {
      // signer is the parent account and ftProvider is child Account
      // get the manager resource and borrow proxyAccount
      let manager = buyer.borrow<&HybridCustody.Manager>(from: HybridCustody.ManagerStoragePath)
        ?? panic("manager does not exist")
      let childAcct = manager.borrowAccount(addr: ftProviderAddress) ?? panic("ftProvider account not found")

      let privatePath = PrivatePath(identifier: privateFTPath) ?? panic("private path identifier is not valid")
      let providerCap = childAcct.getCapability(path: privatePath, type: Type<&{FungibleToken.Provider}>()) ?? panic("token provider not found for supplied child account address")
      let ftProvider = providerCap as! Capability<&{FungibleToken.Provider}>
      let ftProviderVault = ftProvider.borrow() ?? panic("child account token vault could not be borrowed")
      self.paymentVault <- ftProviderVault.withdraw(amount: listingDetails.salePrice)
    }

    if commissionRecipient != nil && listingDetails.commissionAmount != 0.0 {
      // Access the capability to receive the commission.
      let _commissionRecipientCap = getAccount(commissionRecipient!).getCapability<&{FungibleToken.Receiver}>(/public/flowTokenReceiver)
      assert(_commissionRecipientCap.check(), message: "Commission Recipient doesn't have FlowToken receiving capability")
      self.commissionRecipientCap = _commissionRecipientCap
    } else if listingDetails.commissionAmount == 0.0 {
      self.commissionRecipientCap = nil
    } else {
      panic("Commission recipient can not be empty when commission amount is non zero")
    }
  }

  execute {
    // Purchase the NFT
    let item <- self.listing.purchase(
      payment: <-self.paymentVault,
      commissionRecipient: self.commissionRecipientCap,
      privateListingAcceptor: self.listingAcceptor
    )
    // Deposit the NFT in the buyer's collection.
    self.collection.deposit(token: <-item)
  }
}
