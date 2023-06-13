pragma solidity ^0.8.17;
//SPDX-License-Identifier: MIT
interface IERC20 {
    function transfer(address, uint) external ;
    function transferFrom(address from, address to, uint token) external;
}
contract crowdfund {
         
    IERC20 public token;
    
    struct Campaign {
        address creator;
        uint goal;
        uint pledged;
        uint startAt;
        uint endAt;
        bool claimed;
    }
    uint public count;

    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor( address _token) {
        token = IERC20(_token);
    }
    function Launch() external {}

    function cancel() external {}

    function pledge() external {}

    function unpledge() external {}

    function claim() external {}

    function refund() external {}
}