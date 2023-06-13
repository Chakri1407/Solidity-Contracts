pragma solidity ^0.8.17;
//SPDX-License-Identifier: MIT
contract Etherwallet {

    address payable public  owner;

    constructor() {
        owner = payable(msg.sender);
    }

    receive() payable virtual external {} 

    function getbalance() public view returns(uint) {
        return address(this).balance;
    }
    function withdraw(uint _value) public {
        require(msg.sender == owner,"caller not owner");
        payable(msg.sender).transfer(_value);
    }
}

contract sendeth {
    fallback() external payable {}

    function sendether(address payable _addr,uint _value) public {
        payable(_addr).transfer(_value);

    }
}
