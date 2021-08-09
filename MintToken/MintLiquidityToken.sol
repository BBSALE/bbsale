// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "./import/liquidityToken.sol";

contract MintToken is Ownable{
    struct tokenOwnerMaps {
        address _token;
        string _name;
        string _symbol;
        uint8 _decimals;
        uint256 _total;
        uint256 _setTaxFee;
        uint256 _setLiqFee;
    }
    
    mapping(address=>tokenOwnerMaps[]) public tokenOwners;
    mapping(address=>uint8) public tokenOwnersLength;
    mapping(address=>address) public tokenList;
    
    function doMint(string memory _name,string memory _symbol,uint8 _decimals,uint256 _initalSupply,uint8 _setTaxFee, uint8 _setLiqFee) external payable{
        
        require(msg.value>=4*10**17,'Amount must be greater than 0.4 BNB');
        
        LiquidityGeneratorToken _newToken = new LiquidityGeneratorToken(msg.sender,_name,_symbol,_decimals,_initalSupply,_setTaxFee,_setLiqFee,10,10,50);
        
        
        
         _newToken.excludeFromFee(owner());
         _newToken.excludeFromFee(msg.sender);
         uint256 totalBalance = _newToken.balanceOf(address(this));
         if(totalBalance > 0)
            _newToken.transfer(msg.sender,totalBalance);
         _newToken.transferOwnership(msg.sender);
        
        tokenOwnerMaps memory tokenOwnerMap; 
        tokenOwnerMap._token = address(_newToken);
        tokenOwnerMap._name= _name;
        tokenOwnerMap._symbol= _symbol;
        tokenOwnerMap._decimals= _decimals;
        tokenOwnerMap._total= _initalSupply;
        tokenOwnerMap._setTaxFee= _setTaxFee;
        tokenOwnerMap._setLiqFee= _setLiqFee;
        
        tokenOwners[msg.sender].push(tokenOwnerMap);
        tokenOwnersLength[msg.sender] +=1;
        tokenList[address(_newToken)] =  msg.sender;
        
        payable(owner()).transfer(msg.value);
        
    }
}