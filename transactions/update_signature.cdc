import AEntropy from "../../contracts/Flow/AEntropy.cdc"

transaction(tokenId: UInt64, input: String) {


  let collectionRef: &AEntropy.Collection
  prepare (user: AuthAccount) {

    self.collectionRef = user.borrow<&AEntropy.Collection>(from: AEntropy.CollectionStoragePath)
                          ?? panic("This account is not the Administrator.")
  }

  execute {
    self.collectionRef.updateSignature(tokenId: tokenId, customInput: input)
  }
}
