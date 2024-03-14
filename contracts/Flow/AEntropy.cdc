import MetadataViews from "./standard/MetadataViews.cdc"
import NonFungibleToken from "./standard/NonFungibleToken.cdc"
import FungibleToken from "./standard/FungibleToken.cdc"
import FlowToken from "./standard/FlowToken.cdc"
import ViewResolver from "./standard/ViewResolver.cdc"


pub contract AEntropy: NonFungibleToken, ViewResolver {

    // Collection Information
    access(self) let collectionInfo: {String: AnyStruct}

    // Contract-level variables
    pub var totalSupply: UInt64
    pub var ticketSupply: UInt64
    pub var purchased: UInt64
    pub var maxTokensPerPurchase: UInt64
    pub var deployer: Address
    pub var maxSupply: UInt64
    pub var script: String
    pub var traitScript: String
    pub var saleActive: Bool
    pub var pricePerToken: UFix64
    // Events
    pub event ContractInitialized()
    pub event Purchase(tokenId: UInt64, receiverAddress: Address)
    pub event MinterCreated(minterId: UInt64)
    pub event MinterState(canMint: Bool)
    pub event Minted(id: UInt64, recipient: Address, randomID: UInt64)
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Signature(tokenId: UInt64, receiverAddress: Address, randomNumber: UInt64, customInput: String)
    pub event GenerateImage(tokenId: UInt64, receiverAddress: Address, randomNumber: UInt64)
    pub event TicketCreated(ticketId: UInt64, receiver:Address)
    // Paths
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let CollectionPrivatePath: PrivatePath
    pub let AdministratorStoragePath: StoragePath
    pub let MetadataStoragePath: StoragePath
    pub let MetadataPublicPath: PublicPath
    // MinterProxy related paths.
    pub let MinterProxyStoragePath: StoragePath
    pub let MinterProxyPublicPath: PublicPath
    // Ticket related paths
    pub let AEntropyStoragePath: StoragePath
    pub let AEntropyStoragePublicPath: PublicPath

    access(account) let nftStorage: @{Address: {UInt64: NFT}}
    access(account) let minters: {UInt64: Bool}

    pub resource AEntropyStorage: AEntropyStoragePublic {
        // List of tickets
        pub var tickets: {UInt64: Ticket}

        init () {
            self.tickets = {}
        }

        access(all) fun getTickets(): {UInt64: AEntropy.Ticket}? {
            return self.tickets
        }
        access(all) fun getTicket(tokenId: UInt64):  Ticket? {
            return self.tickets[tokenId]
        }
        access(all) fun addTicket(tokenId: UInt64, collectorAddress: Address) {
            let purchased = &self.tickets as &{UInt64: Ticket}
            let ticket = Ticket(tokenId: tokenId, _owner: collectorAddress)
            self.tickets[tokenId] = ticket
        }
        access(all) fun isPurchased(tokenId: UInt64): Bool {
            if self.tickets[tokenId]?.state == TicketState.purchased {
                return true
            } else {
                return false
            }
        }
        access(all) fun isRandom(tokenId: UInt64): Bool {
            if self.tickets[tokenId]?.state == TicketState.random {
                return true
            } else {
                return false
            }
        }
        access(all) fun isGenerateImg(tokenId: UInt64): Bool {
            if self.tickets[tokenId]?.state == TicketState.generateimage {
                return true
            } else {
                return false
            }
        }
        access(all) fun changeToRandom(tokenId: UInt64, randomNumber: UInt64) {
            let ticket = &self.tickets[tokenId]! as &Ticket
            ticket.state = TicketState.random
            ticket.randomId = randomNumber
        }
        access(all) fun changeToGenerateImg(tokenId: UInt64) {
            let ticket = &self.tickets[tokenId]! as &Ticket
            ticket.state = TicketState.generateimage
        }
        access(all) fun changeToAutographed(tokenId: UInt64) {
            let ticket = &self.tickets[tokenId]! as &Ticket
            ticket.state = TicketState.autographed
        }

        // Fetch all tickets
/*         pub fun getTickets(): {State: [Ticket]} {
            return self.tickets
        } */
/*         // Fetch tickets that have not generated a randomId
        pub fun getUnAssigned(): [AEntropy.Ticket]? {
            return self.tickets[State.purchase]
        }
        // Fetch tickets that have not minted their NFTs
        pub fun getUnMinted(): [AEntropy.Ticket]? {
            return self.tickets[State.random]
        }
        // Fetch tickets that have minted their NFTs but not signed
        pub fun getUnAssignedTickets(): [AEntropy.Ticket]? {
            return self.tickets[State.generateimage]
        }
        // Fetch tickets that have autographed their NFTs
        pub fun getAutographed(): [AEntropy.Ticket]? {
            return self.tickets[State.autographed]
        } */
    }
    /// Defines the public methods for the Ticket Storgage
    ///
    pub resource interface AEntropyStoragePublic {
        pub fun getTicket(tokenId: UInt64): Ticket?
		pub fun getTickets(): {UInt64: AEntropy.Ticket}?
/*		pub fun getUnAssigned(): [AEntropy.Ticket]?
		pub fun getUnMinted(): [AEntropy.Ticket]?
		pub fun getUnAssignedTickets(): [AEntropy.Ticket]?
		pub fun getAutographed(): [AEntropy.Ticket]? */
    }

        pub enum TicketState: UInt64 {
        pub case purchased
        pub case random
        pub case generateimage
        pub case autographed
    }

        pub struct Ticket {
        pub let id: UInt64
        pub let owner: Address
        pub(set) var state: TicketState
        pub(set) var randomId: UInt64?
        pub var customInput: String?

        init(tokenId: UInt64, _owner: Address) {
            self.id = tokenId
            self.state = TicketState.purchased
            self.owner = _owner
            self.randomId = nil
            self.customInput = nil

            AEntropy.ticketSupply = AEntropy.ticketSupply + 1
            emit TicketCreated(ticketId: self.id, receiver: self.owner)
        }
    }

    pub resource NFT: NonFungibleToken.INFT, MetadataViews.Resolver {
        pub let id: UInt64
        // The 'metadataId' is what maps this NFT to its 'SVG'
        pub let randomID: UInt64
        pub let originalMinter: Address
        pub var signature: String
        pub var SVG: String
        pub let extra: {String: AnyStruct}
        pub let script: String
        pub var Autographed: Bool
        pub var svgUpdated: Bool

        init(
            _randomID: UInt64,
            _recipient: Address,
            _extra: {String: AnyStruct},
            _SVG: String,
            _tokenId: UInt64
            ) {

            // Assign serial number to the NFT based on the number of minted NFTs
            self.id = _tokenId
            self.randomID = _randomID
            self.originalMinter = _recipient
            self.extra = _extra
            self.signature = ""
            self.SVG = _SVG
            self.script = AEntropy.script
            self.Autographed = false
            self.svgUpdated = false

            // Update AEntropy collection NFTs count
            AEntropy.totalSupply = AEntropy.totalSupply + 1

            emit Minted(id: self.id, recipient: _recipient, randomID: _randomID)
        }

        pub fun updateSignature(input: String) {
            pre {
                self.Autographed == false: "This NFT's signature has already been updated"
            }
            // Replace current signature string with the new one
            self.signature = input
            // Update number of updated
            self.Autographed = true
        }

        pub fun updateSVG(input: String) {
            pre {
                self.Autographed == true: "This NFT's signature has not been updated"
                self.svgUpdated == false: "This NFT's SVG has already been updated"
            }
            // Replace current svg string with the new one
            self.SVG = input
            // Mark svg as updated
            self.svgUpdated = true
        }

        pub fun getViews(): [Type] {
            return [
                Type<MetadataViews.Display>(),
                Type<MetadataViews.ExternalURL>(),
                Type<MetadataViews.NFTCollectionData>(),
                Type<MetadataViews.NFTCollectionDisplay>(),
                Type<MetadataViews.Royalties>(),
                Type<MetadataViews.Serial>(),
                Type<MetadataViews.NFTView>()
            ]
        }

        pub fun resolveView(_ view: Type): AnyStruct? {
            switch view {
                case Type<MetadataViews.Display>():

                    return MetadataViews.Display(
                        randomID: self.randomID.toString(),
                        description: "First on-chain generative art collection on the Flow blockchain.",
                        thumbnail: MetadataViews.HTTPFile(
                                url: self.SVG,
                            )
                    )
                case Type<MetadataViews.Traits>():
                    let metaCopy = self.extra
                    metaCopy["Signature"] = self.signature
                    return MetadataViews.dictToTraits(dict: metaCopy, excludedNames: nil)

                case Type<MetadataViews.NFTView>():
                    return MetadataViews.NFTView(
                        id: self.id,
                        uuid: self.uuid,
                        display: self.resolveView(Type<MetadataViews.Display>()) as! MetadataViews.Display?,
                        externalURL: self.resolveView(Type<MetadataViews.ExternalURL>()) as! MetadataViews.ExternalURL?,
                        collectionData: self.resolveView(Type<MetadataViews.NFTCollectionData>()) as! MetadataViews.NFTCollectionData?,
                        collectionDisplay: self.resolveView(Type<MetadataViews.NFTCollectionDisplay>()) as! MetadataViews.NFTCollectionDisplay?,
                        royalties: self.resolveView(Type<MetadataViews.Royalties>()) as! MetadataViews.Royalties?,
                        traits: self.resolveView(Type<MetadataViews.Traits>()) as! MetadataViews.Traits?
                    )
                case Type<MetadataViews.NFTCollectionData>():
                    return AEntropy.resolveView(view)
                case Type<MetadataViews.ExternalURL>():
                    return AEntropy.getCollectionAttribute(key: "website") as! MetadataViews.ExternalURL
                case Type<MetadataViews.NFTCollectionDisplay>():
                    return AEntropy.resolveView(view)
                case Type<MetadataViews.Royalties>():
                      return MetadataViews.Royalties([
                        MetadataViews.Royalty(
                              recepient: getAccount(self.originalMinter).getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver),
                              cut: 0.10, // 10% royalty on secondary sales
                              description: "The creator of the original content gets 10% of every secondary sale."
                        )
                      ])
                case Type<MetadataViews.Serial>():
                    return MetadataViews.Serial(
                        self.id
                    )
            }
            return nil
        }


    }

    /// Defines the methods that are particular to this NFT contract collection
    ///
    pub resource interface AEntropyCollectionPublic {
        pub fun deposit(token: @NonFungibleToken.NFT)
        pub fun getIDs(): [UInt64]
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
        pub fun borrowAEntropy(id: UInt64): &AEntropy.NFT? {
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow AEntropy NFT reference: the ID of the returned reference is incorrect"
            }
        }
    }

    pub resource Collection: AEntropyCollectionPublic, NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, MetadataViews.ResolverCollection {

        pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}
        // Update an NFT's signature with a custom input
        pub fun updateSignature(tokenId: UInt64, customInput: String) {
            // Fetch reference to the NFT in order to use its functions
            let nftRef = self.borrowAEntropy(id: tokenId)!
            // update the signature
            nftRef.updateSignature(input: customInput)
            // withdraw the nft from the collection
            let nft <- self.withdraw(withdrawID: tokenId)
            // get AEntropy's contract collection resource and deposit it there
            			// Fetch StoragePath for this randomID and recipient
			let identifier = "AEntropySVGStorage_".concat(nft.id.toString()).concat("_").concat(self.owner!.address.toString())
			let path = StoragePath(identifier: identifier)!

            emit Signature(tokenId: tokenId, receiverAddress: self.owner?.address!, randomNumber: nftRef.randomID, customInput: customInput)

			AEntropy.account.save(<- nft, to: path)
        }
        // Update an NFT's signature with a custom input
        pub fun updateSVG(tokenId: UInt64, customInput: String) {
            // Fetch reference to the NFT in order to use its functions
            let nftRef = self.borrowAEntropy(id: tokenId)!
            // update the signature
            nftRef.updateSVG(input: customInput)
        }
        // Withdraw removes an NFT from the collection and moves it to the caller(for Trading)
        pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
            let token <- self.ownedNFTs.remove(key: withdrawID) ?? panic("missing NFT")

            emit Withdraw(id: token.id, from: self.owner?.address)

            return <-token
        }
        // Deposit takes a NFT and adds it to the collections dictionary
        // and adds the ID to the id array
        pub fun deposit(token: @NonFungibleToken.NFT) {
            let token <- token as! @NFT

            let id: UInt64 = token.id

            // Add the new token to the dictionary
            self.ownedNFTs[id] <-! token

            emit Deposit(id: id, to: self.owner?.address)
        }

        // GetIDs returns an array of the IDs that are in the collection
        pub fun getIDs(): [UInt64] {
            return self.ownedNFTs.keys
        }

        // BorrowNFT gets a reference to an NFT in the collection
        pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
            return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
        }

        /// Gets a reference to an NFT in the collection so that
        /// the caller can read its metadata and call its methods
        ///
        /// @param id: The ID of the wanted NFT
        /// @return A reference to the wanted NFT resource
        ///
        pub fun borrowAEntropy(id: UInt64): &AEntropy.NFT? {
            if self.ownedNFTs[id] != nil {
                // Create an authorized reference to allow downcasting
                let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
                return ref as! &AEntropy.NFT
            }

            return nil
        }

        pub fun borrowViewResolver(id: UInt64): &AnyResource{MetadataViews.Resolver} {
            let token = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
            let nft = token as! &NFT
            return nft
        }

        pub fun claim() {
            if let storage = &AEntropy.nftStorage[self.owner!.address] as &{UInt64: NFT}? {
                for id in storage.keys {
                    self.deposit(token: <- storage.remove(key: id)!)
                }
            }
        }

        init () {
            self.ownedNFTs <- {}
        }

        destroy() {
            destroy self.ownedNFTs
        }
    }

    pub resource Administrator {
        // This sets the script for the contract
        // this is necessary so that we don't always call mintNFT with the script parameter
        pub fun setScript(script: String) {
            AEntropy.script = script
        }
        // This sets the traits for the contract
        pub fun setTraitScript(script: String) {
            AEntropy.traitScript = script
        }
        // This sets the saleActive var for the contract
        pub fun setSaleActive(boolean: Bool) {
            AEntropy.saleActive = boolean
        }
        // This sets the price per token for the contract
        pub fun setPricePerToken(newPrice: UFix64) {
            AEntropy.pricePerToken = newPrice
        }
        // This sets the maxSupply
        pub fun setMaxSupply(newMax: UInt64) {
            pre {
                AEntropy.saleActive != true: "Sale is active, can't change Max Supply."
                newMax >= AEntropy.totalSupply: "New max supply can't be less than total supply"
            }
            AEntropy.maxSupply = newMax
        }

        // Create a new Administrator resource
        pub fun createAdmin(): @Administrator {
            return <- create Administrator()
        }

        // Mint NFTs without payment
        pub fun purchase(numberOfTokens: UInt64, receiver: Address) {
            pre {
                AEntropy.script != "": "Script has not been set yet"
                AEntropy.traitScript != "": "Traits has not been set yet"
                AEntropy.purchased + numberOfTokens < AEntropy.maxSupply: "Not enough supply available"
            }

            var index: UInt64 = 0
            // Update purchased
            while index < numberOfTokens {
                emit Purchase(tokenId: AEntropy.purchased, receiverAddress: receiver)

                AEntropy.purchased = AEntropy.purchased + 1
                index = index + 1
            }
        }

        // Function that creates a Minter resource.
        // This should be stored at a unique path in storage then a capability to it wrapped
        // in a MinterProxy to be stored in a minter account's storage.
        // This is done by the minter account running:
        // transactions/Posterity/minter/setup_minter_account.cdc
        // then the administrator account running:
        // transactions/Posterity/administrator/deposit_minter_capability.cdc
        //
        pub fun createNewMinter(): @Minter {
            let Minter <- create Minter()
            AEntropy.minters[Minter.uuid] = true
            emit MinterCreated(minterId: Minter.uuid)
            return <- Minter
        }

        pub fun revokeMinter(minterId: UInt64, status: Bool) {
            let minters = &AEntropy.minters as &{UInt64: Bool}
            minters[minterId] = status
            emit MinterState(canMint: minters[minterId]!)
            //AEntropy.minters[minterId] = status
        }

        // change AEntropy of collection info
        pub fun changeField(key: String, value: AnyStruct) {
            AEntropy.collectionInfo[key] = value
        }
    }

    // Minter
    //
    // Resource object that can mint new tokens.
    // The administrator stores this and passes it to the minter account as a capability wrapper resource.
    //
    pub resource Minter {
        // Generate the random number for the user
        pub fun generateRandomNumber(tokenId: UInt64, receiverAddress: Address) {
            // Load the tickets from the AEntropy account
            let storage = AEntropy.account.borrow<&AEntropy.AEntropyStorage>(from: AEntropy.AEntropyStoragePath)!
            // Check this ticket's state is Purchased
            let isPurchased = storage.isPurchased(tokenId: tokenId)
            if isPurchased {
                // Generate random number
                let randomId = revertibleRandom()
                emit GenerateImage(tokenId: tokenId, receiverAddress: receiverAddress, randomNumber: randomId)
                // Change ticket to GenerateImg
                storage.changeToRandom(tokenId: tokenId, randomNumber: randomId)
            } else {
                panic("This ticket is not in the Purchased state")
            }
        }
        // mintNFT mints a new NFT and deposits
        // it in the recipients collection
        pub fun mintTokens(
            tokenId: UInt64,
            recipient: Address,
            traits: {String: AnyStruct},
            randomNumber: UInt64,
            SVG: String
            ) {
            pre {
                AEntropy.minters[self.uuid] == true: "This minter cap has been revoked"
            }
                // Load the tickets from the AEntropy account
                let storage = AEntropy.account.borrow<&AEntropy.AEntropyStorage>(from: AEntropy.AEntropyStoragePath)!
                // Make sure the ticket's state is random
                let ticket = storage.isRandom(tokenId: tokenId)
                if ticket {
                    let nft <- create NFT(
                        _randomID: randomNumber,
                        _recipient: recipient,
                        _extra: traits,
                        _SVG: SVG,
                        _tokenId: tokenId
                        )

                    if let recipientCollection = getAccount(recipient).getCapability(AEntropy.CollectionPublicPath).borrow<&AEntropy.Collection{NonFungibleToken.CollectionPublic}>() {
                        recipientCollection.deposit(token: <- nft)
                    } else {
                        if let storage = &AEntropy.nftStorage[recipient] as &{UInt64: NFT}? {
                            storage[nft.id] <-! nft
                        } else {
                            AEntropy.nftStorage[recipient] <-! {nft.id: <- nft}
                        }
                    }
                    // Change ticket to generateImg
                    storage.changeToGenerateImg(tokenId: tokenId)
                } else {
                    panic("This ticket is not in the Random state")
                }
            }
        // Update an NFT SVG
        pub fun updateSVG(tokenId: UInt64, ownerWallet: Address, svgInput: String) {
            // Load the tickets from the AEntropy account
            let storage = AEntropy.account.borrow<&AEntropy.AEntropyStorage>(from: AEntropy.AEntropyStoragePath)!
            // Make sure the ticket's state is random
            let ticket = storage.isGenerateImg(tokenId: tokenId)

            if ticket {
                let identifier = "AEntropySVGStorage_".concat(tokenId.toString()).concat("_").concat(ownerWallet.toString())
                let path = StoragePath(identifier: identifier)!
                // Fetch the NFT from the stored path
                let nft <- AEntropy.account.load<@AEntropy.NFT>(from: path)!
                // Update SVG
                nft.updateSVG(input: svgInput)
                // Deposit back the NFT into the owner's collection
                let recipientCollection = getAccount(ownerWallet).getCapability(AEntropy.CollectionPublicPath)
                    .borrow<&AEntropy.Collection{NonFungibleToken.CollectionPublic}>()!

                recipientCollection.deposit(token: <- nft)
                // Change ticket to Autographed
                storage.changeToAutographed(tokenId: tokenId)
            } else {
                panic("This ticket is not in the GenerateImg state")
            }
        }
    }

    pub resource interface MinterProxyPublic {
        pub fun setMinterCapability(cap: Capability<&Minter>)
        pub fun generateRandomNumber(_tokenId: UInt64, _receiverAddress: Address)
        pub fun updateSVG(nftId: UInt64, ownerWallet: Address, svgInput: String)
    }

    // MinterProxy
    //
    // Resource object holding a capability that can be used to mint new tokens.
    // The resource that this capability represents can be deleted by the account
    // holding the administrator resource.
    // in order to unilaterally revoke minting capability if needed.
    pub resource MinterProxy: MinterProxyPublic {

        // access(self) so nobody else can copy the capability and use it.
        access(self) var minterCapability: Capability<&Minter>?

        // Anyone can call this, but only the admin can create Minter capabilities,
        // so the type system constrains this to being called by the admin.
        pub fun setMinterCapability(cap: Capability<&Minter>) {
            self.minterCapability = cap
        }

        pub fun generateRandomNumber(_tokenId: UInt64, _receiverAddress: Address) {
            pre {
                self.minterCapability != nil: "Minter capability has not been set"
            }

            return self.minterCapability!
            .borrow()!
            .generateRandomNumber(tokenId: _tokenId, receiverAddress: _receiverAddress)
        }

        pub fun mintTokens(
            _tokenId: UInt64,
            _recipient: Address,
            _traits: {String: AnyStruct},
            _randomNumber: UInt64,
            _SVG: String
            ) {
                pre {
                    self.minterCapability != nil: "Minter capability has not been set"
                }
                return self.minterCapability!
                .borrow()!
                .mintTokens(
                    tokenId: _tokenId,
                    recipient: _recipient,
                    traits: _traits,
                    randomNumber: _randomNumber,
                    SVG: _SVG
                )

        }
        pub fun updateSVG(nftId: UInt64, ownerWallet: Address, svgInput: String) {
            return self.minterCapability!
            .borrow()!
            .updateSVG(tokenId: nftId, ownerWallet: ownerWallet, svgInput: svgInput)
        }

        init() {
            self.minterCapability = nil
        }
    }


    // public function that anyone can call to create a new empty collection
    pub fun createEmptyCollection(): @NonFungibleToken.Collection {
        return <- create Collection()
    }

    // Function that creates a MinterProxy.
    // Anyone can call this, but the MinterProxy cannot mint without a Minter capability,
    // and only the administrator can provide that.
    //
    pub fun createMinterProxy(): @MinterProxy {
        return <- create MinterProxy()
    }

    // public function that anyone can call to purchase a randomId
    pub fun purchase(payment: @FungibleToken.Vault, numberOfTokens: UInt64, receiver: Address) {
        pre {
            self.saleActive == true: "Sale is not active"
            self.script != "": "Script has not been set yet"
            self.traitScript != "": "Traits has not been set yet"
            self.pricePerToken * UFix64(numberOfTokens) == payment.balance: "Payment is incorrect"
            self.purchased + numberOfTokens <= self.maxSupply: "Not enough supply available"
            self.maxTokensPerPurchase >= numberOfTokens: "Max number of tokens per purchase is ".concat(self.maxTokensPerPurchase.toString())
        }
        // Give paymennt to Entropy account
        let paymentRecipient = self.account.getCapability(/public/flowTokenReceiver)
                                .borrow<&{FungibleToken.Receiver}>() ?? panic("Could not borrow receiver reference to the recipient's Vault")

        paymentRecipient.deposit(from: <- payment)

        var index: UInt64 = 0
		let storage = AEntropy.account.borrow<&AEntropy.AEntropyStorage>(from: AEntropy.AEntropyStoragePath)!
        while index < numberOfTokens {
            if !storage.isPurchased(tokenId: self.purchased) {
                storage.addTicket(tokenId: self.purchased, collectorAddress: receiver)
                emit Purchase(tokenId: self.purchased, receiverAddress: receiver)
                // Update purchased
                self.purchased = self.purchased + 1
                index = index + 1
            }
        }
    }

    access(contract) fun isPurchased(tokenId: UInt64): Bool {
		let storage = AEntropy.account.borrow<&AEntropy.AEntropyStorage>(from: AEntropy.AEntropyStoragePath)!
        return storage.isPurchased(tokenId: tokenId)
    }

    /// Function that resolves a metadata view for this contract.
    ///
    /// @param view: The Type of the desired view.
    /// @return A structure representing the requested view.
    ///
    pub fun resolveView(_ view: Type): AnyStruct? {
        switch view {
            case Type<MetadataViews.NFTCollectionData>():
                return MetadataViews.NFTCollectionData(
                    storagePath: AEntropy.CollectionStoragePath,
                    publicPath: AEntropy.CollectionPublicPath,
                    providerPath: AEntropy.CollectionPrivatePath,
                    publicCollection: Type<&AEntropy.Collection{AEntropy.AEntropyCollectionPublic}>(),
                    publicLinkedType: Type<&AEntropy.Collection{AEntropy.AEntropyCollectionPublic,NonFungibleToken.CollectionPublic,NonFungibleToken.Receiver,MetadataViews.ResolverCollection}>(),
                    providerLinkedType: Type<&AEntropy.Collection{AEntropy.AEntropyCollectionPublic,NonFungibleToken.CollectionPublic,NonFungibleToken.Provider,MetadataViews.ResolverCollection}>(),
                    createEmptyCollectionFunction: (fun (): @NonFungibleToken.Collection {
                        return <-AEntropy.createEmptyCollection()
                    })
                )
            case Type<MetadataViews.NFTCollectionDisplay>():
                let media = AEntropy.getCollectionAttribute(key: "image") as! MetadataViews.Media
                return MetadataViews.NFTCollectionDisplay(
                        name: "AEntropy",
                        description: "Sell AEntropys of any Tweet in seconds.",
                        externalURL: MetadataViews.ExternalURL("https://AEntropy.gg/"),
                        squareImage: media,
                        bannerImage: media,
                        socials: {
                            "twitter": MetadataViews.ExternalURL("https://twitter.com/CreateAAEntropy")
                        }
                    )
        }
        return nil
    }

    pub fun getCollectionInfo(): {String: AnyStruct} {
        let collectionInfo = self.collectionInfo
        collectionInfo["totalSupply"] = self.totalSupply
        collectionInfo["version"] = 1
        return collectionInfo
    }

    pub fun getCollectionAttribute(key: String): AnyStruct {
        return self.collectionInfo[key] ?? panic(key.concat(" is not an attribute in this collection."))
    }

    pub fun getTickets(): {UInt64: AEntropy.Ticket}? {
        // Load the tickets from the AEntropy account
        let AEntropyStorageRef = getAccount(self.account.address).getCapability(AEntropy.AEntropyStoragePublicPath)
                      .borrow<&AEntropy.AEntropyStorage{AEntropy.AEntropyStoragePublic}>()
                      ?? panic("Could not borrow a reference to the capability")

        return AEntropyStorageRef.getTickets()
    }

    pub fun getTicket(tokenId: UInt64): Ticket? {
        // Load the tickets from the AEntropy account
        let AEntropyStorageRef = getAccount(self.account.address).getCapability(AEntropy.AEntropyStoragePublicPath)
                      .borrow<&AEntropy.AEntropyStorage{AEntropy.AEntropyStoragePublic}>()
                      ?? panic("Could not borrow a reference to the capability")

        return AEntropyStorageRef.getTicket(tokenId: tokenId)
    }

    init() {
        // Collection Info
        self.collectionInfo = {}
        self.deployer = self.account.address
        self.totalSupply = 0
        self.maxSupply = 1000
        self.ticketSupply = 0
        self.script = ""
        self.traitScript = ""
        self.saleActive = false
        self.purchased = 0
        self.maxTokensPerPurchase = 5
        self.nftStorage <- {}
        self.minters = {}
        self.pricePerToken = 1.0
        self.collectionInfo["pricePerToken"] = self.pricePerToken
        self.collectionInfo["maxSuppy"] = self.maxSupply
        self.collectionInfo["name"] = "AEntropy"
        self.collectionInfo["description"] = "Sell AEntropys of any Tweet in seconds."
        self.collectionInfo["image"] = MetadataViews.Media(
                        file: MetadataViews.HTTPFile(
                            url: "https://media.discordapp.net/attachments/1075564743152107530/1149417271597473913/AEntropy_collection_image.png?width=1422&height=1422"
                        ),
                        mediaType: "image/jpeg"
                      )
        self.collectionInfo["dateCreated"] = getCurrentBlock().timestamp
        self.collectionInfo["website"] = MetadataViews.ExternalURL("https://www.AEntropy.gg/")
        self.collectionInfo["socials"] = {"Twitter": MetadataViews.ExternalURL("https://frontend-react-git-testing-AEntropy.vercel.app/")}

        // Set the named paths
        let identifier = "AEntropy_Collection".concat(self.account.address.toString())
        self.CollectionStoragePath = StoragePath(identifier: identifier)!
        self.CollectionPublicPath = PublicPath(identifier: identifier)!
        self.CollectionPrivatePath = PrivatePath(identifier: identifier)!
        self.AdministratorStoragePath = StoragePath(identifier: identifier.concat("_Administrator"))!
        self.MetadataStoragePath = StoragePath(identifier: identifier.concat("_Metadata"))!
        self.MetadataPublicPath = PublicPath(identifier: identifier.concat("_Metadata"))!
        self.MinterProxyPublicPath = PublicPath(identifier: identifier.concat("_MinterProxy"))!
        self.MinterProxyStoragePath = StoragePath(identifier: identifier.concat("_MinterProxy"))!
        self.AEntropyStoragePath = StoragePath(identifier: identifier.concat("_Tickets"))!
        self.AEntropyStoragePublicPath = PublicPath(identifier: identifier.concat("_Tickets"))!

        // Create a Collection resource and save it to storage
        let collection <- create Collection()
        self.account.save(<- collection, to: self.CollectionStoragePath)

        // Create a public capability for the collection
        self.account.link<&Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection}>(
            self.CollectionPublicPath,
            target: self.CollectionStoragePath
        )
        // Create a TicketsStorage resource and save it to AEntropy account storage
        let ticketsStorage <- create AEntropyStorage()
        self.account.save(<- ticketsStorage, to: self.AEntropyStoragePath)
		// Create a public capability for the Tickets Storage
		self.account.link<&AEntropyStorage{AEntropyStoragePublic}>(
			self.AEntropyStoragePublicPath,
			target: self.AEntropyStoragePath
		)

        // Create a Administrator resource and save it to AEntropy account storage
        let administrator <- create Administrator()
        self.account.save(<- administrator, to: self.AdministratorStoragePath)

        let minter <- create Minter()
        self.account.save(<- minter, to: StoragePath(identifier: identifier.concat("_Administrator_Minter"))!)


        emit ContractInitialized()
    }
}
