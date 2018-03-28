pragma solidity ^0.4.21;


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