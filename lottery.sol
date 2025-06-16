//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.24;


contract Lottery{

    address payable[] public participants;
    address public manager;

    constructor(){
        manager = msg.sender; // Global Variable
    }

    receive () payable external{
        require(msg.value == 2 ether); // it is the require condition for the participants to enter in the lottery
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender == manager); // because this contract is only accessible by the manager
        return address(this).balance; // Global Variables
    }

    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length))); // generation of random address based on the current difficulty and the current time in seconds
    }

    function selectWinner() public 
    {
        require(msg.sender == manager);
        require(participants.length >= 3); // condition that minimum number of participants must be 3
        uint r = random();
        address payable winner;
        uint index = r % participants.length; // this is the equation to generate the random number by moduling it with the length
        winner = participants[index]; // this is the winner address that is stored in an array called 'particip
        winner.transfer(getBalance()); // this will transfer the balance of the participants to the winner based on the random
        participants = new address payable [] (0); // this is the function to delete all the entries from array or reset the lottery system
    }
}