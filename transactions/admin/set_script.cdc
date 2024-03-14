import AEntropy from "../../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../../contracts/Flow/AEntropy.cdc"

transaction(_script: String) {

  let Administrator: &AEntropy.Administrator
  prepare (deployer: AuthAccount) {

    self.Administrator = deployer.borrow<&AEntropy.Administrator>(from: AEntropy.AdministratorStoragePath)
                          ?? panic("This account is not the Administrator.")
  }

  execute {

    self.Administrator.setScript(script: _script)
  }
}