pragma solidity ^0.4.21;

/**
    @author Artem Rapota artem.rapota@inveritasoft.com
 */
interface ERC20Ethereum {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event TransferEtherForAllAddresses(address indexed _from, uint256 _value);
}