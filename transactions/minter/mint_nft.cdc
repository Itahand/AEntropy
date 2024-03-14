// This transaction will fail if the authorizer does not have and AEntropy.MinterProxy
// resource. Use the setup_AEntropy_minter.cdc and deposit_AEntropy_minter.cdc transactions
// to configure the minter proxy.

import FungibleToken from "../../../contracts/Flow/standard/FungibleToken.cdc"
import AEntropy from "../../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../../contracts/Flow/AEntropy.cdc"

transaction(
    tokenId: UInt64,
    recipient: Address,
    randomID: UInt64,
    traits: String,
    svg: String
) {

    let tokenMinter: &AEntropy.MinterProxy
    let tokenMinterId: UInt64

    prepare(minterAccount: AuthAccount) {
        self.tokenMinter = minterAccount
            .borrow<&AEntropy.MinterProxy>(from: AEntropy.MinterProxyStoragePath)
            ?? panic("No minter available")

        self.tokenMinterId = self.tokenMinter.uuid
    }
    execute {
        let traits = {"key1" : traits}
       self.tokenMinter.mintTokens(
        _tokenId: tokenId,
       _recipient: recipient,
       _traits: traits,
       _randomNumber: randomID,
       _SVG: svg
       )

    }
}