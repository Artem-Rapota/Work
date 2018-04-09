pragma solidity ^0.4.21;
import "./Owner.sol";
import "./ERC20Token.sol";
import "./ERC20TokensAll.sol";

/**
    This class working with BountyProgramTokens.
    This class is for distributing tokens for BountyHunters.
    Send Tokens all at once Bounty Hunters.
    @author Artem Rapota artem.rapota@inveritasoft.com
 */
contract BountyProgramTokensAll is Owner, ERC20Token, ERC20TokensAll {
    
    uint256 private _tokens;
    string private _tokenName;
    uint256 private _totalSuply;
    uint256 private _endDate;
    mapping (address => uint256) private _balanceOf;
    address[] private allAddress;
    
    function BountyProgramTokensAll(uint256 amountTokens, uint256 tokens, string name, uint256 endDate) public {
        require(amountTokens > 0);
        require(tokens > 0);
        require(endDate > 0);
        
        _totalSuply = amountTokens;
        _balanceOf[owner] = amountTokens;
        _tokens = tokens;
        _tokenName = name;
        _endDate = endDate;
    }
    
    function destroyContract() isOwner public {
       selfdestruct(this);
    }
    
    function totalSupply() public constant returns (uint256) {
        return _totalSuply;
    }
    
    function balanceOf(address _addr) constant public returns (uint256) {
        return _balanceOf[_addr];
    }
    
    function transfer(address _to) isOwner public returns (bool success) {
        
        if (
            _tokens > 0 
            && _tokens <= _balanceOf[owner] 
        ) {
            _balanceOf[owner] -= _tokens;
            _balanceOf[_to] += _tokens;
            emit Transfer(owner, _to, _tokens);
            
            return true;
        }
        
        return false;
    }
    
    function sendTokensForAllAddresses(uint256 endDate) isOwner public returns (bool success) {
        require(endDate >= _endDate);
        require(_balanceOf[owner] == 0);

        emit TransferForAllAdd(endDate, _totalSuply);
        _totalSuply = 0;
        
        return true;
    }
}