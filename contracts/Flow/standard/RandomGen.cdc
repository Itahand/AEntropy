import RandomBeaconHistory from "../standard/RandomBeaconHistory.cdc"
import Xorshift128plus from "../standard/Xorshift128plus.cdc"


pub contract RandomGen {

    // taken from
    // https://github.com/onflow/random-coin-toss/blob/4271cd571b7761af36b0f1037767171aeca18387/contracts/CoinToss.cdc#L95
    pub fun randUInt64(atBlockHeight: UInt64, salt: UInt64): UInt64 {
        //  query the Random Beacon history core-contract - if `blockHeight` <= current block height, panic & revert
         let sourceOfRandomness = RandomBeaconHistory.sourceOfRandomness(atBlockHeight: getCurrentBlock().height)
         assert(sourceOfRandomness.blockHeight == atBlockHeight, message: "RandomSource block height mismatch")

        //  instantiate a PRG object, seeding a source of randomness with `salt` and returns a pseudo-random
        //  generator object.
         let prg = Xorshift128plus.PRG(
             sourceOfRandomness: sourceOfRandomness.value,
             salt: salt.toBigEndianBytes()
         )

         return prg.nextUInt64()
        // TODO: use commented-out implementation once we can test using the randomness beacon in the cadence testing framework
        // return revertibleRandom()
    }

}