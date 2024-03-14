import RandomBeaconHistory from "../../contracts/Flow/standard/RandomBeaconHistory.cdc"
import Xorshift128plus from "../../contracts/Flow/standard/Xorshift128plus.cdc"

pub fun main(salt: UInt64): AnyStruct  {

        //  query the Random Beacon history core-contract - if `blockHeight` <= current block height, panic & revert
         let sourceOfRandomness = RandomBeaconHistory.sourceOfRandomness(atBlockHeight: 10)
         assert(sourceOfRandomness.blockHeight == 10, message: "RandomSource block height mismatch")

        //  instantiate a PRG object, seeding a source of randomness with `salt` and returns a pseudo-random
        //  generator object.
         let prg = Xorshift128plus.PRG(
             sourceOfRandomness: sourceOfRandomness.value,
             salt: salt.toBigEndianBytes()
         )

         return sourceOfRandomness.value
}