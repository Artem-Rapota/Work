pragma solidity ^0.4.21;

/**
    @author Artem Rapota artem.rapota@inveritasoft.com
 */
interface ERC20Token {
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to) returns (bool success);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}