//SPDX-License-Identifier: None

pragma solidity ^0.8.1;

interface ITOKEN {
    function balanceOf(address owner) external view returns (uint256 balance);
    function ownerOf(uint256 tokenId) external view returns (address owner);
}

abstract contract TokenGating {

    mapping(address => uint256) internal _whitelisting;
    address[] public whitelistedAddresses;

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
            if ((_whitelisting[_addresses[i]] == 0 && _val) || 
                (_whitelisting[_addresses[i]] != 0 && !_val)) {
                _updateWhitelist(_addresses[i], _val);
            }
        }
    }

    function _updateWhitelist(address _contract, bool _add) private {
        if(_add) {
            whitelistedAddresses.push(_contract);
            _whitelisting[_contract] = whitelistedAddresses.length;
        } else {
            _whitelisting[whitelistedAddresses[whitelistedAddresses.length-1]] = _whitelisting[_contract];
            whitelistedAddresses[_whitelisting[_contract]-1] = whitelistedAddresses[whitelistedAddresses.length-1];
            _whitelisting[_contract] = 0;
            whitelistedAddresses.pop();
        }
    }

    function _verifyOwner(address _contract, uint _id) private view {
        require(_whitelisting[_contract] != 0, "Not WL");
        require(ITOKEN(_contract).ownerOf(_id) == msg.sender, "Not Owner");
    }

    function _verifyBalance(address _contract) private view {
        require(_whitelisting[_contract] != 0, "Not WL");
        require(ITOKEN(_contract).balanceOf(msg.sender) > 0, "No Balance");
    }
}