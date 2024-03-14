import AEntropy from "../../contracts/Flow/AEntropy.cdc"

pub fun main(): {AEntropy.State: [AEntropy.Ticket]}  {

    let tickets = AEntropy.getUnAssigned()

    return tickets
}
