// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import {ERC20} from '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Hie is ERC20 {
  address owner;
  
  // Implement new ERC20 token with name "Hiep Token" and symbol "HIE"
  constructor() ERC20("Hiep Token", "HIE"){
    owner = msg.sender;
    _mint(msg.sender, 100000000);
  }

   // Add blacklist to the contract
  mapping(address => bool) public blacklist;

  function addToBlacklist(address account) external onlyOwner {
    blacklist[account] = true;
  }

  function removeFromBlacklist(address account) external onlyOwner {
    blacklist[account] = false;
  }

  // Add ownership to the deployer, mint & burn functions are only allowed by the owner
  function mint(address to, uint256 amount) external onlyOwner {
    _mint(to, amount);
  }

  function burn(address from, uint256 amount) external onlyOwner {
    _burn(from, amount);
  }

  // Add tax fee to the contract, default is 5% of the transaction amount
  uint256 public taxFee = 5;
  address public treasuryAddress;

  // Set treasury address
  function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
    treasuryAddress = _treasuryAddress;
  }

  // Take tax fee for each transaction
  // Cannot override transfer function from ERC20, since it is internal, not virtual
  function transfer(address to, uint256 amount) public override returns (bool) {
    require(!blacklist[msg.sender], "You are in the blacklist");
    require(!blacklist[to], "Recipient is in the blacklist");

    uint256 taxAmount = amount * taxFee / 100;
    uint256 taxedAmount = amount - taxAmount;

    _transfer(msg.sender, treasuryAddress, taxAmount);
    _transfer(msg.sender, to, taxedAmount);

    return true;
  }

  // --- Modifiers ---
  // Only owner modifier
  modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }
}