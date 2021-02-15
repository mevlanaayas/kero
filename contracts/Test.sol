pragma solidity ^0.5.16;

contract Test {

    bytes32 value;

    event ValueChanged(bytes32 _newValue);

    function setValue(string memory _key) public{
        value=keccak256(abi.encodePacked(_key));
        emit ValueChanged(value);
    }

    function setHash(bytes32 _hash) public{
        value=_hash;
    }

    function getKeccak256(string memory _key) public pure returns(bytes32){
        return keccak256(abi.encodePacked(_key));
    }

    function getK() public view returns(bytes32){
        return value;
    }

    function checkEqual(string memory _key) public view returns(bool){
        return value==keccak256(abi.encodePacked(_key));
    }
}
