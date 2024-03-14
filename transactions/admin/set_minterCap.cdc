import AEntropy from "../../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../../contracts/Flow/AEntropy.cdc"

transaction(_minterId: UInt64, _boolean: Bool) {

  let Administrator: &AEntropy.Administrator
  prepare (deployer: AuthAccount) {

    self.Administrator = deployer.borrow<&AEntropy.Administrator>(from: AEntropy.AdministratorStoragePath)
                          ?? panic("This account is not the Administrator.")
  }

  execute {

    self.Administrator.revokeMinter(minterId: _minterId, status: _boolean)
  }
}