pragma solidity ^0.4.21;

/**
    @author Artem Rapota artem.rapota@inveritasoft.com
    This class about Owner.
    It has Owner's address and modifier for check isOwner
 */
contract Owner {
    address internal owner;
    
    function Owner() internal {
        owner = msg.sender;
    }
    
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
}