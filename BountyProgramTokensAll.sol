pragma solidity ^0.4.21;
import "./Owner.sol";
import "./ERC20Token.sol";

/**
    This class working with BountyProgramTokens.
    This class is for distributing tokens for BountyHunters.
    @author Artem Rapota artem.rapota@inveritasoft.com
 */
contract BountyProgramTokens is Owner, ERC20Token {
    
    uint256 private _tokens;
    string private _name;
    uint256 private _totalSuply;
    mapping (address => uint256) private _balanceOf;
    
    function CreateBountyProgram(uint256 amountTokens, uint256 tokens, string name) isOwner public {
        require(_totalSuply == 0);
        _totalSuply = amountTokens;
        _balanceOf[owner] = amountTokens;
        _tokens = tokens;
        _name = name;
    }
    
    function getNameToken() public constant returns(string) {
        return _name;
    }
    
    function DestroyContract() isOwner public {
       selfdestruct(this);
    }
    
    function totalSupply() public constant returns (uint256) {
        return _balanceOf[owner];
    }
    
    function balanceOf(address _addr) constant public returns (uint256) {
        return _balanceOf[_addr];
    }
    
    function transfer(address _to, uint256 _value) isOwner public returns (bool success) {
        if (_value > 0 && _value <= _balanceOf[owner] && _value == _tokens) {
            _balanceOf[owner] -= _value;
            _balanceOf[_to] += _value;
            emit Transfer(owner, _to, _value);
            return true;
        }
        return false;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) isOwner returns (bool success) {
    }
    
    function approve(address _spender, uint256 _value) isOwner returns (bool success) {
    }
    
    function allowance(address _owner, address _spender) isOwner constant returns (uint remaining) {
    }
}