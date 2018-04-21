
pragma solidity ^0.4.8;

contract SpitiCoin{
	// Creating a mapping of an account address to the current account balance to store the accounts' current balance.
	mapping(address => uint256) public currentBalance;

	//Creating a mapping of an account address to another account address to set the transfer allowance and limit
	mapping(address => (address => uint256)) public allowedLimit;
	
	// State variables defining the state of the contract 
	// Public variables can be accessed by contract members
	uint256 public totalCoinSupply;
	string public coinSymbol;
	string public version = "SpitiCoin v0.0.1";
	uint8 public decimalPoints;
	string public nameOfToken;

	//Creating an event to log the transfers
	event Transfer(address indexed fromAddress, address indexed toAddress, uint256 amountTransferred);


	// The SpitiCoin constructor that takes inital coin supply as an argument and transfers it in the contract deployers' account address.
	function SpitiCoin(uint256 initialCoinSupply, string tokenName, string tokenSymbol, uint8 nDecimal){
		//Initializing variables as per constructor argumennts
		currentBalance[msg.sender] = initialCoinSupply;
		totalCoinSupply = initialCoinSupply;
		decimalPoints = nDecimal;
		nameOfToken = tokenName;
		coinSymbol = tokenSymbol;
	}


	// Method to transfer SpitiCoin from one account to another, taken receiver address and amount to be sent as an argument.
	function transferCoin(address toAccount, uint256 transferAmount) public {
		//Check if the current balance of the message sender is less than the transferAmount, if true then throw an error
		require(currentBalance[msg.sender] > transferAmount);

		//Check for overflow, if true then throw an error
		require(currentBalance[toAccount] + transferAmount > currentBalance[toAccount]);

		//Reducing the transfer amount from the senders' account address
		currentBalance[msg.sender] -= transferAmount;

		//Adding the transfer amount to the receivers' account address
		currentBalance[toAccount] += transferAmount;

		//logging the transfer event to the contract members
		Transfer(msg.sender, toAccount, transferAmount);
	}

	function approveForTransfer(address targetAddress, uint256 amountValue) returns (bool success){
		// Allowing a target address to allow for transfer and setting the transfer limit
		allowedLimit[msg.sender][targetAddress] = amountValue;
		return true;
	}

	function transferFunds(address fromAccount, address toAccount, uint256 transferAmount) returns (bool success){
		require(currentBalance[fromAccount] > transferAmount);
		require(currentBalance[toAccount] + transferAmount > currentBalance[toAccount]);

		// If the allowed limit for transfer is less than the transfer amount then don't proceed.
		require(allowedLimit[fromAccount][msg.sender] < transferAmount);

		currentBalance[fromAccount] -= transferAmount;
		currentBalance[toAccount] += transferAmount;

		// Reduce the allowed transfer limit from the executors' account 
		allowedLimit[fromAccount][msg.sender] -= transferAmount;

		Transfer(fromAccount, toAccount, transferAmount);
		return true;
	}


}

// Author : Anup Tiwari


