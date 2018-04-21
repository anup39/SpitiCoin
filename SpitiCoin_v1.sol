
pragma solidity ^0.4.8;

contract SpitiCoin{
	// Creating a mapping of an account address to the current account balance
	mapping(address => uint) public currentBalance;
	
	// The SpitiCoin constructor that takes inital coin supply as an argument and transfers it in the creators' account address.
	function SpitiCoin(uint initialCoinSupply){
		currentBalance[msg.sender] = initialCoinSupply;
	}


	// Method to transfer SpitiCoin from one account to another, taken receiver address and amount to be sent as an argument.
	function transferCoin(address toAccount, uint transferAmount){
		currentBalance[msg.sender] -= transferAmount;
		currentBalance[toAccount] += transferAmount;
	}

}

// Author : Anup Tiwari


