pragma solidity ^0.4.21;
import "./Owner.sol";

/**
    This class working with BountyProgramEther.
    This class is for distributing Ethereum for BountyHunters.
    Send Ethereum one by one Bounty Hunters.
    @author Artem Rapota artem.rapota@inveritasoft.com
 */
contract BountyProgramEthereumOne is Owner {
    uint256 private _pieceOfEther;
    
    function BountyProgramEthereumOne(uint256 pieceOfEther) public payable {
        require(msg.value > 0);
        require(pieceOfEther > 0);
        
        _pieceOfEther = pieceOfEther;
        address(this).call.value(msg.value);
    }
    
    function sendEtherToAddress(address addr) isOwner public {
        require(addr != owner);
        
        require(
            address(this).balance > 0 
            && address(this).balance >= _pieceOfEther
        );
        
        addr.transfer(_pieceOfEther);
    }
    
    function balanceContractEther() public view returns(uint) {
        return address(this).balance;
    }
    
    function destroyContract() isOwner public {
        owner.transfer(address(this).balance);
        selfdestruct(this);
    }
}