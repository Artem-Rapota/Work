pragma solidity ^0.4.21;
import "./Owner.sol";
import "./ERC20Token.sol";

/**
    This class working with BountyProgramTokens.
    This class is for distributing tokens for BountyHunters.
    Send Token one by one Bounty Hunters.
    @author Artem Rapota artem.rapota@inveritasoft.com
 */
contract BountyProgramTokensOne is Owner, ERC20Token {
    
    uint256 private _tokens;
    string private _TokenName;
    mapping (address => uint256) private _balanceOf;
    
    function BountyProgramTokensOne(uint256 amountTokens, uint256 tokens, string tokenName) public {
        require(amountTokens > 0);
        require(tokens > 0);
        
        _balanceOf[owner] = amountTokens;
        _tokens = tokens;
        _TokenName = tokenName;
    }
    
    function getNameToken() public constant returns(string) {
        return _TokenName;
    }
    
    function destroyContract() isOwner public {
       selfdestruct(this);
    }
    
    function balanceOf(address _addr) constant public returns (uint256) {
        return _balanceOf[_addr];
    }
    
    function transfer(address _to) isOwner public returns (bool success) {
        require(_to != owner);
        
        if (
            _tokens > 0 
            && _balanceOf[owner] >= _tokens 
        ) {
            _balanceOf[owner] -= _tokens;
            _balanceOf[_to] += _tokens;
            emit Transfer(owner, _to, _tokens);
            
            return true;
        }
        return false;
    }
}