import AEntropy from "../../contracts/Flow/AEntropy.cdc"

pub fun main(tokenId: UInt64): UInt64?  {

    let ticket = AEntropy.getTicket(tokenId: tokenId)

    return ticket?.randomId
}
