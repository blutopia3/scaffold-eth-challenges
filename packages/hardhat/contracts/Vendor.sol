pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable{

  YourToken yourToken;

  uint256 public constant tokensPerEth = 10000;


  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  constructor(address tokenAddress) public {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable{
    uint256 tokensPurchased = msg.value * tokensPerEth;

    yourToken.transfer(msg.sender, tokensPurchased);
    emit BuyTokens(msg.sender, msg.value, tokensPurchased);
  }
  
  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  
  function withdraw(uint256 withdrawInput) public onlyOwner {
    uint256 withdrawAmount = withdrawInput;
    address withdrawWallet = msg.sender;
    payable(withdrawWallet).transfer(withdrawAmount);
  }

  // ToDo: create a sellTokens() function:

  function sellTokens(uint256 theAmount) public {
    require(theAmount > 0, "No value entered.");
    //yourToken.approve(address(this),theAmount); <- this is already happening in the js file
    uint256 allowance = yourToken.allowance(msg.sender,address(this));
    uint256 sellValueETH = theAmount / tokensPerEth;
    require(theAmount <= allowance,"Check allowance.");
    
    yourToken.transferFrom(msg.sender,address(this), theAmount);

  
    uint256 payOwner = sellValueETH / 100;
    uint256 paySeller = sellValueETH - payOwner;
    payable(msg.sender).transfer(paySeller);
    payable(owner()).transfer(payOwner);

  }

}
