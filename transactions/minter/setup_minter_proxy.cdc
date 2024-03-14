// This transaction creates a new minter proxy resource and
// stores it in the signer's account.
//
// After running this transaction, the AEntropy administrator
// must run deposit_AEntropy_minter.cdc to deposit a minter resource
// inside the minter proxy.

import AEntropy from "../../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../../contracts/Flow/AEntropy.cdc"

transaction {

    prepare(minter: AuthAccount) {

        let minterProxy <- AEntropy.createMinterProxy()

        minter.save(
            <- minterProxy, 
            to: AEntropy.MinterProxyStoragePath,
        )
            
        minter.link<&AEntropy.MinterProxy{AEntropy.MinterProxyPublic}>(
            AEntropy.MinterProxyPublicPath,
            target: AEntropy.MinterProxyStoragePath
        )
    }
}