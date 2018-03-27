pragma solidity ^0.4.21;
import "./Owner.sol";

contract BountyProgramTokens is Owner {
    uint256 private _amountTokens;
    uint256 private _tokens;
    mapping (address => uint256) private _walletList;
    
    function setAmountTokensAndNumberTokens(uint256 amountTokens, uint256 tokens) isOwner public {
        require(_tokens == 0);
        _amountTokens = amountTokens;
        _tokens = tokens;
    }
    
    function sendTokensForHunter(address hunterAddress) isOwner public {
        require(_amountTokens >= _tokens);
        _walletList[hunterAddress] += _tokens;
        _amountTokens -= _tokens;
    }
    
    function DestroyContract() isOwner public {
       selfdestruct(this);
    }
    
    function getTokensByAddressHunter(address hunterAddress) isOwner view public returns(uint256) {
        return _walletList[hunterAddress];
    }
}