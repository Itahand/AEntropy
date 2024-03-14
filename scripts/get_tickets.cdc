import AEntropy from "../../contracts/Flow/AEntropy.cdc"

pub fun main(): {UInt64: AEntropy.Ticket}?  {

    //let AEntropyAccount = getAccount(AEntropy.deployer)
/*     let AEntropyStorageRef = getAccount(AEntropy.deployer).getCapability(AEntropy.AEntropyStoragePublicPath)
                      .borrow<&AEntropy.AEntropyStorage{AEntropy.AEntropyStoragePublic}>()
                      ?? panic("Could not borrow a reference to the capability") */


    return AEntropy.getTickets()
}
