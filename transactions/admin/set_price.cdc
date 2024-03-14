import AEntropy from "../../../contracts/Flow/AEntropy.cdc"

transaction(newPrice: UFix64) {
  let Administrator: &AEntropy.Administrator
  prepare (deployer: AuthAccount) {
    self.Administrator = deployer.borrow<&AEntropy.Administrator>(from: AEntropy.AdministratorStoragePath)
                          ?? panic("This account is not the Administrator.")
  }

  execute {
    self.Administrator.setPricePerToken(newPrice: newPrice)
  }
}
