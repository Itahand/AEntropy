import AEntropy from "../../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../../contracts/Flow/AEntropy.cdc"

transaction(_tokenId: UInt64, _receiverAddress: Address) {

    let tokenMinter: &AEntropy.MinterProxy

    prepare(minterAccount: AuthAccount) {
        self.tokenMinter = minterAccount
            .borrow<&AEntropy.MinterProxy>(from: AEntropy.MinterProxyStoragePath)
            ?? panic("No minter available")

    }
    execute {
       self.tokenMinter.generateRandomNumber(_tokenId: _tokenId, _receiverAddress: _receiverAddress)

    }
}