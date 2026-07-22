// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract ParkingSystem{
    address public owner;
    address[] public drivers;
    mapping (address =>uint) public lastEntryTime;

    uint public constant PARKING_FEE= 0.0002 ether;

    event DriverEntered(address indexed driver, uint amount);
    event paymentWithdrawn(address indexed  owner, uint amount);

    constructor(){
        owner=msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender==owner, "only owner can perform this action");
        _;
    }

    function  enterParking() public  payable {
        require(msg.value== PARKING_FEE, "Incorrect parking fee");

        require(block.timestamp >= lastEntryTime[msg.sender] + 2 hours, "you can only enter once every 2 Hours");

        drivers.push(msg.sender);

        lastEntryTime[msg.sender]=block.timestamp;

        emit DriverEntered(msg.sender, msg.value);

    }

    function getDrivers()public  view  returns(address[] memory){
        return drivers;
    } 

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function withdrawFees() public onlyOwner{
        uint amount= address(this). balance;

        (bool success,)= payable (owner).call{value:amount}(""); 
        require(success, "Transfer failed");
        emit paymentWithdrawn(owner, amount);
        }
}

