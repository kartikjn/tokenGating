// SPDX-License-Identifier: None
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract A is ERC721 {

    uint256 public id = 0;
    constructor() ERC721("Token A", "A") {}

    function mint() public {
        id++;
        _mint(msg.sender, id);
    }
}