//SPDX-License-Identifier: None

pragma solidity ^0.8.1;

interface ITOKEN {
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

abstract contract TokenGating {

    mapping(address => bool) internal _whitelisting;

    modifier validateOwner(address _contract, uint _id) {
        _verifyOwner(_contract, _id);
        _;
    }

    modifier validateBalance(address _contract) {
        _verifyBalance(_contract);
        _;
    }

    function _updateWhitelist(address[] memory _addresses, bool _val) internal {
        for(uint i=0; i< _addresses.length; i++) {
            if (_whitelisting[_addresses[i]] != _val) {
                _whitelisting[_addresses[i]] = _val;
            }
        }
    }

    function _verifyOwner(address _contract, uint _id) private view {
        require(_whitelisting[_contract] == true, "Not WL");
        require(ITOKEN(_contract).ownerOf(_id) == msg.sender, "Not Owner");
    }

    function _verifyBalance(address _contract) private view {
        require(_whitelisting[_contract] == true, "Not WL");
        require(ITOKEN(_contract).balanceOf(msg.sender) > 0, "No Balance");
    }
}