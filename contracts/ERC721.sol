// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721 {
    address public admin;
    uint256 public id = 0;

    string public baseURI;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        admin = msg.sender;
    }

    function mint() external {
        id++;
        _mint(msg.sender, id);
    }

    function setBaseURI(string memory _uri) external {
        require(bytes(_uri).length > 0, "invalid base uri");
        baseURI = _uri;
    }

    function _baseURI() internal view override returns(string memory) {
        if (bytes(baseURI).length > 0) {
            return baseURI;
        }
        return "";
    }
}
