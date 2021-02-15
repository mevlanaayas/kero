pragma solidity ^0.5.16;

contract Migrations {

  address public owner;
  uint public lastCompletedMigration;

  modifier restricted() {
    require(msg.sender == owner, "Caller is not owner");
    _;
  }

  constructor() public {
    owner = msg.sender;
  }

  function setCompleted(uint completed) public restricted {
    lastCompletedMigration = completed;
  }

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(lastCompletedMigration);
  }
}
