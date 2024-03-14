import RandomBeaconHistory from "../../contracts/Flow/standard/RandomBeaconHistory.cdc"
import Xorshift128plus from "../../contracts/Flow/standard/Xorshift128plus.cdc"

transaction(salt: UInt64) {

    // taken from
    // https://github.com/onflow/random-coin-toss/blob/4271cd571b7761af36b0f1037767171aeca18387/contracts/CoinToss.cdc#L95

    prepare (deployer: AuthAccount) {

        //  query the Random Beacon history core-contract - if `blockHeight` <= current block height, panic & revert
        let sourceOfRandomness = RandomBeaconHistory.sourceOfRandomness(atBlockHeight: 1)
        assert(sourceOfRandomness.blockHeight == 1, message: "RandomSource block height mismatch")

    }

    execute {


    }
}


/* pub contract RandomGen {

    // taken from
    // https://github.com/onflow/random-coin-toss/blob/4271cd571b7761af36b0f1037767171aeca18387/contracts/CoinToss.cdc#L95
    pub fun randUInt64(atBlockHeight: UInt64, salt: UInt64): UInt64 {
        //  query the Random Beacon history core-contract - if `blockHeight` <= current block height, panic & revert
         let sourceOfRandomness = RandomBeaconHistory.sourceOfRandomness(atBlockHeight: atBlockHeight)
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
    
} */