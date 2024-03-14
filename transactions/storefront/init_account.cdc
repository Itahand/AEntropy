import FungibleToken from "../../../contracts/Flow/standard/FungibleToken.cdc"
import NonFungibleToken from "../../../contracts/Flow/standard/NonFungibleToken.cdc"
import NFTStorefrontV2 from "../../../contracts/Flow/standard/NFTStorefrontV2.cdc"
import AEntropy from "../../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../../contracts/Flow/AEntropy.cdc"



pub fun hasItems(_ address: Address): Bool {
  return getAccount(address)
    .getCapability<&AEntropy.Collection>(AEntropy.CollectionPublicPath)
    .check()
}

pub fun hasStorefront(_ address: Address): Bool {
  return getAccount(address)
    .getCapability<&NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}>(NFTStorefrontV2.StorefrontPublicPath)
    .check()
}

transaction {
  prepare(acct: AuthAccount) {
    if !hasItems(acct.address) {
      if acct.borrow<&AEntropy.Collection>(from: AEntropy.CollectionStoragePath) == nil {
        acct.save(<-AEntropy.createEmptyCollection(), to: AEntropy.CollectionStoragePath)
      }

      acct.unlink(AEntropy.CollectionPublicPath)

      acct.link<&AEntropy.Collection>(AEntropy.CollectionPublicPath, target: AEntropy.CollectionStoragePath)
    }

    if !hasStorefront(acct.address) {
      if acct.borrow<&NFTStorefrontV2.Storefront>(from: NFTStorefrontV2.StorefrontStoragePath) == nil {
        acct.save(<-NFTStorefrontV2.createStorefront(), to: NFTStorefrontV2.StorefrontStoragePath)
      }

      acct.unlink(NFTStorefrontV2.StorefrontPublicPath)

      acct.link<&NFTStorefrontV2.Storefront{NFTStorefrontV2.StorefrontPublic}>(NFTStorefrontV2.StorefrontPublicPath, target: NFTStorefrontV2.StorefrontStoragePath)
    }
  }
}