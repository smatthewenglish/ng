contract NiftyBuilderInstance is ERC721Full {

   //MODIFIERS

   modifier onlyValidSender() {
       NiftyRegistry nftg_registry = NiftyRegistry(niftyRegistryContract);
       bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
       require(is_valid==true);
       _;
   }

   //CONSTANTS

   // how many nifties this contract is selling
   // used for metadat retrieval
   uint public numNiftiesCurrentlyInContract;

   //id of this contract for metadata server
   uint public contractId;
   
   //is permanently closed
   bool public isClosed = false;

   //baseURI for metadata server
   string public baseURI;

//   //name of creator
//   string public creatorName;

   string public nameOfCreator;

   //nifty registry contract
   address public niftyRegistryContract = 0x6e53130dDfF21E3BC963Ee902005223b9A202106;

   //master builder - ONLY DOES STATIC CALLS
   address public masterBuilderContract = 0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;

   using Counters for Counters.Counter;

   //MAPPINGS

   //mappings for token Ids
   mapping (uint => Counters.Counter) public _numNiftyMinted;
   mapping (uint => uint) public _niftyPrice;
   mapping (uint => string) public _niftyIPFSHashes;
   mapping (uint => bool) public _IPFSHashHasBeenSet;

   //EVENTS

   //purchase + creation events
   event NiftyPurchased(address _buyer, uint256 _amount, uint _tokenId);
   event NiftyCreated(address new_owner, uint _niftyType, uint _tokenId);

   //CONSTRUCTOR FUNCTION

   constructor(
       string memory _name,
       string memory _symbol,
       uint contract_id,
       uint num_nifties,
       string memory base_uri,
       string memory name_of_creator) ERC721Full(_name, _symbol) public {

       //set local variables based on inputs
       contractId = contract_id;
       numNiftiesCurrentlyInContract = num_nifties;
       baseURI = base_uri;
       nameOfCreator = name_of_creator;

       //offset starts at 1 - there is no niftyType of 0
    //   for (uint i=0; i<(num_nifties); i++) {
    //       _numNiftyPermitted[i+1] = nifty_quantities[i];
    //   }
   }
   
   function setNiftyIPFSHash(uint niftyType, 
                            string memory ipfs_hash) onlyValidSender public {
        //can only be set once
        if (_IPFSHashHasBeenSet[niftyType] == true) {
            revert("Can only be set once");
        } else {
            _niftyIPFSHashes[niftyType] = ipfs_hash;
            _IPFSHashHasBeenSet[niftyType]  = true;
        }
    }
    
    function closeContract() onlyValidSender public {
        //permanently close this open edition
        isClosed = true;
        
    }

   function giftNifty(address collector_address, 
                      uint niftyType) onlyValidSender public {
       //master for static calls
       BuilderMaster bm = BuilderMaster(masterBuilderContract);
       _numNiftyMinted[niftyType].increment();
       //check if this collection is closed
       if (isClosed==true) {
           revert("This contract is closed!");
       }
       //mint a nifty
       uint specificTokenId = _numNiftyMinted[niftyType].current();
       uint tokenId = bm.encodeTokenId(contractId, niftyType, specificTokenId);
       string memory tokenIdStr = bm.uint2str(tokenId);
       string memory tokenURI = bm.strConcat(baseURI, tokenIdStr);
       string memory ipfsHash = _niftyIPFSHashes[niftyType];
       //mint token
       _mint(collector_address, tokenId);
       _setTokenURI(tokenId, tokenURI);
       _setTokenIPFSHash(tokenId, ipfsHash);
       //do events
       emit NiftyCreated(collector_address, niftyType, tokenId);
   }

}