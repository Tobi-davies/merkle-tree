// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NFTClaim is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    bytes32 public root;

    constructor(bytes32 _root) ERC721("ADEBAYO", "TBN") {
      root = _root;
    }

    function mintNft(address to, bytes32[] memory proof, bytes32 leaf)
        public  
        returns (uint256)
    {
      require(keccak256(abi.encodePacked(msg.sender)) == leaf, "Not the correct address");
      require(verifyAddress(proof, leaf), "Not a whitelisted address");

        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId);

        _tokenIds.increment();
        return newItemId;
    }

    function verifyAddress(bytes32[] memory proof, bytes32 leaf) public view returns(bool) {
      return MerkleProof.verify(proof, root, leaf);
    }
}