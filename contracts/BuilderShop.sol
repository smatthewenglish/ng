/**
 *Submitted for verification at Etherscan.io on 2020-08-26
*/

pragma solidity ^0.5.0;

contract BuilderShop {
   address[] builderInstances;
   uint contractId = 0;

   //nifty registry is hard coded
   address niftyRegistryContract = 0x6e53130dDfF21E3BC963Ee902005223b9A202106;

   modifier onlyValidSender() {
       NiftyRegistry nftg_registry = NiftyRegistry(niftyRegistryContract);
       bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
       require(is_valid==true);
       _;
   }

   mapping (address => bool) public BuilderShops;

   function isValidBuilderShop(address builder_shop) public view returns (bool isValid) {
       //public function, allowing anyone to check if a contract address is a valid nifty gateway contract
       return(BuilderShops[builder_shop]);
   }

   event BuilderInstanceCreated(address new_contract_address, uint contractId);

   function createNewBuilderInstance(
       string memory _name,
       string memory _symbol,
       uint num_nifties,
       string memory token_base_uri,
       string memory creator_name)
       public returns (NiftyBuilderInstance tokenAddress) { // <- must replace this !!!
   //public onlyValidSender returns (NiftyBuilderInstance tokenAddress) {

       contractId = contractId + 1;

       NiftyBuilderInstance new_contract = new NiftyBuilderInstance(
           _name,
           _symbol,
           contractId,
           num_nifties,
           token_base_uri,
           creator_name
       );

       address externalId = address(new_contract);

       BuilderShops[externalId] = true;

       emit BuilderInstanceCreated(externalId, contractId);

       return (new_contract);
    }
}


































