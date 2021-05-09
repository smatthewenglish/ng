contract NiftyRegistry {
   function isValidNiftySender(address sending_key) public view returns (bool);
   function isOwner(address owner_key) public view returns (bool);
}