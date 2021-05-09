contract BuilderMaster {
   function getContractId(uint tokenId) public view returns (uint);
   function getNiftyTypeId(uint tokenId) public view returns (uint);
   function getSpecificNiftyNum(uint tokenId) public view returns (uint);
   function encodeTokenId(uint contractId, uint niftyType, uint specificNiftyNum) public view returns (uint);
   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) public view returns (string memory);
   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) public view returns (string memory);
   function strConcat(string memory _a, string memory _b, string memory _c) public view returns (string memory);
   function strConcat(string memory _a, string memory _b) public view returns (string memory);
   function uint2str(uint _i) public view returns (string memory _uintAsString);
}