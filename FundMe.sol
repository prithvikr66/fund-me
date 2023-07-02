// Get funds from the users
// Withdraw funds option for the owners
// Set minimum funding option
// SPDX-Licence-Identifier:MIT

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConvertor} from "PriceConvertor.sol";

contract FundMe{
uint256 public minUsd=5;
address[] public funders;
mapping (address funder => uint256 amountFunded) public amountToAdressFunded;
using PriceConvertor for uint256;
address public owner;
constructor(){
owner=msg.sender;
}

    function fund() public payable {
        
        require(msg.value.getConversionRate()>=1e18,"Didn't send enough ETH");
        funders.push(msg.sender);
        amountToAdressFunded[msg.sender]=amountToAdressFunded[msg.sender]+msg.value;
    }
    function withdraw() public onlyOwner {
        require(msg.sender==owner,"Must be Owner");
        for(uint i=0;i<=funders.length;i++){
            address funder=funders[i];
            amountToAdressFunded[funder]=0;

        }
        funders=new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool success=payable (msg.sender).send(address(this).balance);
        // require(success,"send failed");

        // call
        (bool sendSuccess,)=payable (msg.sender).call{value:address(this).balance}("");
        require(sendSuccess,"Call Failed");

    }
modifier onlyOwner(){
    require(msg.sender==owner,"Sender is not Owner!");
    _;
}
}