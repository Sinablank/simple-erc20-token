// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./context.sol";

contract ownable is context {

    address private _owner;

    event ownershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit ownershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner(){
        require(_owner == _msgSender());
        _;
    }

    function renounceOwnership() public onlyOwner(){
        emit ownershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit ownershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

}