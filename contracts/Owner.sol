pragma solidity ^0.5.16;

contract Owner {

    address private owner;
    bool  isActive;
    bool  isPayActive;

    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier isOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    modifier onlyActive() {
        require(isActive);
        _;
    }

    modifier onlyPayActive() {
        require(isPayActive);
        _;
    }

    constructor() public {
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
        emit OwnershipTransferred(address(0), owner);
    }

    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function kill() public onlyOwner {
        selfdestruct(address(uint160(owner)));
    }
}
