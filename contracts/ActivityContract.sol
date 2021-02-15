pragma solidity ^0.5.16;

import "./Owner.sol";

contract ActivityContract is Owner
{

    mapping(address => Activity) activities;        //owner of activity to Activity struct
    mapping(uint => address) activityOwners;        //index of activity to address of activity owner
    uint numberOfActivity;

    struct Activity {
        string name;
        address owner;
        bool isActive;
        bool isPayActive;
        uint price;
        uint limit;
        uint registeredCount;
        uint date;
        string content;
        string participationUrl;        //we should change this ,string is visible :)
        bytes32 validateNumber;         //this is a hash to participant verify themselves for payback money

        mapping(address => Participant) participants;       //address of user to Participant struct
        mapping(uint => address) participantIndex;          //index of user to address of user
    }

    struct Participant {
        string email;
        bool validated;
        bool payBack;
        address addr;
        bool deleted;
        uint256 value;      //amount of deposit ,maybe this is unnecessary :)
    }

    event ParticipantRegisteredAt(string name, address _Owner, address usr, string email, uint value);
    event ParticipantDeletedAt(string name, address _Owner, address usr, string email, uint value);
    event ParticipantPayBackAt(string name, address _Owner, address usr, string email, uint value);
    event ActivityCreated(string _name, address _owner, uint _limit, uint _date);
    event OwnershipTransferred(string _name, address indexed previousOwner, address indexed newOwner);

    constructor(bool _isActive, bool _isPayActive) public {
        isActive = _isActive;
        isPayActive = _isPayActive;
    }

    modifier onlyActiveActivity(address _act) {
        require(activities[_act].isActive);
        _;
    }
    modifier onlyOwnerActivity(address _act) {
        require(activities[_act].owner == msg.sender);
        _;
    }

    function createActivity(string memory _name, uint _limit, uint _price, uint _date, string memory _content)
    onlyActive
    payable
    public
    {
        if (msg.value != 1 * 10 ** 17) {        //assume 0.1 ether to prevent DDOS, 0.01 ether :)
            revert();
        }
        require(activities[msg.sender].owner == address(0));
        //if has not  create an activity before
        activities[msg.sender] = Activity(
        {
        name : _name,
        owner : msg.sender,
        isActive : true,
        isPayActive : false,
        price : _price,     //only  owner of activity  can change
        limit : _limit,
        date : _date,
        content : _content,
        registeredCount : 0,
        participationUrl : "",
        validateNumber : 0
        });
        numberOfActivity++;
        //start with index 1
        activityOwners[numberOfActivity] = msg.sender;
        emit ActivityCreated(_name, msg.sender, _limit, _date);
    }

    function registerToActivity(address _activity, string memory _email)
    onlyActive
    onlyActiveActivity(_activity)
    payable
    public {
        require(!isRegistered(_activity, msg.sender), "Already registered to activity");

        Activity storage activity = activities[_activity];
        require(activity.registeredCount < activity.limit, "Activity capacity reached to max allowed");

        require(msg.value >= activity.price * 1 * 10 ** 16, "Insufficient funds");        //price control 1*ether value,now 0.1 ether

        activity.registeredCount++;
        activity.participants[msg.sender] = Participant(_email, false, false, msg.sender, false, msg.value);
        activity.participantIndex[activity.registeredCount] = msg.sender;

        emit ParticipantRegisteredAt(activity.name, activity.owner, msg.sender, _email, msg.value);
    }

    function isRegistered(address _activity, address _participantAddr) public view returns (bool) {
        Activity storage activity = activities[_activity];      //may be this is unnecessary
        return activity.owner != address(0) && activity.participants[_participantAddr].addr != address(0) && !activity.participants[_participantAddr].deleted;
    }

    function getParticipationUrl(address _activity) public
    onlyActive
    onlyActiveActivity(_activity)
    view returns (string memory) {
        require(isRegistered(_activity, msg.sender), "Cannot get participation url without registering an activity");
        require(activities[_activity].participants[msg.sender].validated);
        return activities[_activity].participationUrl;
    }

    function getTotalActivity() public view returns (uint) {
        return numberOfActivity;
    }

    function getTotalParticipant(address _activity) public view returns (uint) {
        return activities[_activity].registeredCount;
    }

    function getLimit(address _activity) public view returns (uint) {
        return activities[_activity].limit;
    }

    function leaveActivity(address _activity)
    onlyActive
    onlyActiveActivity(_activity)
    public view {
        require(isRegistered(_activity, msg.sender), "Cannot leave activity without registering");
    }

    function getInfoActivity(address _activity)
    public view returns (string memory, address, bool, uint, uint, uint, uint, string memory){
        Activity storage temp = activities[_activity];
        return (temp.name, temp.owner, temp.isActive, temp.price, temp.registeredCount, temp.limit, temp.date, temp.content);
    }

    //Admin methods
    function getParticipant(address _activity, uint idx) public
    onlyActive
    onlyOwnerActivity(_activity)
    view
    returns (uint index, string memory email, address addr, uint256 value)
    {
        Activity storage activity = activities[_activity];
        address userAddr = activity.participantIndex[idx];
        Participant storage participant = activity.participants[userAddr];
        return (idx, participant.email, participant.addr, participant.value);
    }

    function deleteParticipant(address _activity, uint idx) public
    onlyActive
    onlyOwnerActivity(_activity)
    {
        Activity storage activity = activities[_activity];
        address userAddr = activity.participantIndex[idx];
        Participant storage participant = activity.participants[userAddr];

        require(!participant.deleted, "Participant already deleted");
        require(!participant.payBack, "Participant is not payBack");

        participant.deleted = true;
        participant.payBack = true;
        activity.registeredCount--;

        address payable payableAddressOfParticipant = address(uint160(participant.addr));
        payableAddressOfParticipant.transfer(participant.value);
        emit ParticipantDeletedAt(activity.name, address(_activity), msg.sender, participant.email, participant.value);
    }

    function validateStudentStatus(address _activity, uint idx, bool isValidated)
    onlyActive
    onlyOwnerActivity(_activity)
    public
    {
        Activity storage activity = activities[_activity];
        address userAddr = activity.participantIndex[idx];
        Participant storage participant = activity.participants[userAddr];
        participant.validated = isValidated;
    }


    // if we will share invitation link like this,we must change this method because string is visible on block explorer :)
    function setParticipationLink(address _activity, string memory url) public
    onlyActive
    onlyOwnerActivity(_activity) {
        activities[_activity].participationUrl = url;
    }

    function setPrice(address _activity, uint _price) public
    onlyActive
    onlyOwnerActivity(_activity) {
        activities[_activity].price = _price;
    }

    function getPrice(address _activity) public view returns (uint) {
        return activities[_activity].price;
    }

    function closeParticipation(address _activity) public
    onlyActive
    onlyOwnerActivity(_activity) {
        activities[_activity].isActive = false;
    }

    function openParticipation(address _activity) public
    onlyActive
    onlyOwnerActivity(_activity) {
        activities[_activity].isActive = true;
    }

    function closePayActive(address _activity) public onlyActive
    onlyOwnerActivity(_activity) {
        activities[_activity].isPayActive = false;
    }

    function openPayActive(address _activity) public onlyActive
    onlyOwnerActivity(_activity) {
        activities[_activity].isPayActive = true;
    }

    //only Owner set validateNumber=keccak256(key), during lesson we will share only key to participants
    function validateMeReturnMoney(address _activity, string memory _key) public
    onlyActive
    onlyActiveActivity(_activity)
    {
        require(isRegistered(_activity, msg.sender));
        Activity storage activity = activities[_activity];
        require(activity.validateNumber == keccak256(abi.encodePacked(_key)), "Key is not valid");

        Participant storage participant = activity.participants[msg.sender];

        require(!participant.deleted, "Participant already deleted");
        require(!participant.payBack, "Participant is not payBack");

        participant.payBack = true;

        address payable payableAddressOfParticipant = address(uint160(participant.addr));
        payableAddressOfParticipant.transfer(participant.value * 6);

        emit ParticipantPayBackAt(activity.name, activity.owner, msg.sender, participant.email, participant.value);
    }

    function setValidateHash(address _activity, bytes32 _hash) public
    onlyActive
    onlyOwnerActivity(_activity) {
        Activity storage activity = activities[_activity];
        activity.validateNumber = _hash;
    }

    function getValidateHash(address _activity)
    onlyOwnerActivity(_activity)
    public view returns (bytes32)
    {
        return activities[_activity].validateNumber;
    }

    function transferOwnershipActivity(address _activity, address newOwner)
    onlyActive
    onlyOwnerActivity(_activity)
    public {
        Activity storage activity = activities[_activity];
        require(newOwner != address(0));
        emit OwnershipTransferred(activity.name, activity.owner, newOwner);
        activity.owner = newOwner;
    }

    function getName(address _activity) public view returns (string memory){
        return activities[_activity].name;
    }

    function getActive() public view returns (bool){
        return isActive;
    }

    function setActive() onlyOwner public {
        isActive = true;
    }
}