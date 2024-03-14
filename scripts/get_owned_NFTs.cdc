import AEntropy from "../../contracts/Flow/AEntropy.cdc"
import MetadataViews from "../../contracts/Flow/standard/MetadataViews.cdc"

  
  pub fun main(address: Address): [AnyStruct] {
    let collection = getAccount(address).getCapability(AEntropy.CollectionPublicPath)
                        .borrow<&AEntropy.Collection{MetadataViews.ResolverCollection}>()!
    let answer: [AnyStruct]  = []
    var nft: AnyStruct = nil
  
    let ids = collection.getIDs()
  
    for id in ids {
  
      let resolver = collection.borrowViewResolver(id: id)
      let serialView = resolver.resolveView(Type<MetadataViews.Serial>())! as! MetadataViews.Serial
      let traitsView = resolver.resolveView(Type<MetadataViews.Traits>())! as! MetadataViews.Traits
      let displayView = resolver.resolveView(Type<MetadataViews.Display>())! as! MetadataViews.Display
  
      nft = {
        "serial": serialView,
        "display": displayView,
       "traits": traitsView
        }
  
      answer.append(nft)
    } 
  
    return answer
  }