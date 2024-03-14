// This transaction creates a new AEntropy minter and deposits
// it into an existing minter proxy resource on the specified account.
//
// Parameters:
// - minterAddress: The minter account address.
//
// This transaction will fail if the authorizer does not have the AEntropy.Administrator
// resource.
//
// This transaction will fail if the minter account does not have
// an AEntropy.MinterProxy resource. Use the setup_AEntropy_minter.cdc transaction to 
// create a minter proxy in the minter account.

import AEntropy from "../../../contracts/Flow/AEntropy.cdc"
//import AEntropy from "../../../contracts/Flow/AEntropy.cdc"

transaction(minterAddress: Address) {

    let resourceStoragePath: StoragePath
    let capabilityPrivatePath: CapabilityPath
    let minterCapability: Capability<&AEntropy.Minter>

    prepare(adminAccount: AuthAccount) {

        // These paths must be unique within the AEntropy contract account's storage
        self.resourceStoragePath =  AEntropy.MinterProxyStoragePath
        self.capabilityPrivatePath = AEntropy.MinterProxyPublicPath

        // Create a reference to the admin resource in storage.
        let tokenAdmin = adminAccount.borrow<&AEntropy.Administrator>(from: AEntropy.AdministratorStoragePath)
            ?? panic("Could not borrow a reference to the admin resource")

        // Create a new minter resource and a private link to a capability for it in the admin's storage.
        let minter <- tokenAdmin.createNewMinter()
        adminAccount.save(<- minter, to: self.resourceStoragePath)
        self.minterCapability = adminAccount.link<&AEntropy.Minter>(
            self.capabilityPrivatePath,
            target: self.resourceStoragePath
        ) ?? panic("Could not link minter")

    }

    execute {
        // This is the account that the capability will be given to
        let minterAccount = getAccount(minterAddress)

        let capabilityReceiver = minterAccount.getCapability
            <&AEntropy.MinterProxy{AEntropy.MinterProxyPublic}>
            (AEntropy.MinterProxyPublicPath)
            .borrow() ?? panic("Could not borrow capability receiver reference")

        capabilityReceiver.setMinterCapability(cap: self.minterCapability)
    }

}