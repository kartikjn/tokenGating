// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./TokenGating.sol";

contract MyToken is ERC721, TokenGating {
    address public admin;
    uint256 public id = 0;

    string public baseURI;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        admin = msg.sender;
    }

    function mint(address _contract) external validateBalance(_contract) {
        id++;
        _mint(msg.sender, id);
    }

    function setBaseURI(string memory _uri) external {
        require(msg.sender == admin, "Not owner");
        require(bytes(_uri).length > 0, "invalid base uri");
        baseURI = _uri;
    }

    function _baseURI() internal view override returns(string memory) {
        if (bytes(baseURI).length > 0) {
            return baseURI;
        }
        return "";
    }

    function updateWhitelist(address[] memory _contracts, bool _val) external {
        require(msg.sender == admin, "Not owner");
        _updateWhitelist(_contracts, _val);
    }
}
