//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "./TokenGating.sol";

contract B is TokenGating {

    address public admin;
    uint256 public check;

    constructor() {
        admin = msg.sender;
    }

    function pass(address con) public validateBalance(con) {
        check++;
    }

    function passAgain(address con, uint id) public validateOwner(con, id) {
        check++;
    }

    function update(address[] memory con, bool val) public {
        _updateWhitelist(con, val);
    }
}