// This transaction will fail if the authorizer does not have and AEntropy.MinterProxy
// resource. Use the setup_AEntropy_minter.cdc and deposit_AEntropy_minter.cdc transactions
// to configure the minter proxy.

import AEntropy from "../../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../../contracts/Flow/AEntropy.cdc"

transaction(_tokenId: UInt64, _receiverAddress: Address, _svgInput: String) {

    let tokenMinter: &AEntropy.MinterProxy

    prepare(minterAccount: AuthAccount) {
        self.tokenMinter = minterAccount
            .borrow<&AEntropy.MinterProxy>(from: AEntropy.MinterProxyStoragePath)
            ?? panic("No minter available")

    }
    execute {
       self.tokenMinter.updateSVG(nftId: _tokenId, ownerWallet: _receiverAddress, svgInput: _svgInput)

    }
}