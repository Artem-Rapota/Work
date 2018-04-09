pragma solidity ^0.4.21;
import "./Owner.sol";
import "./ERC20Ethereum.sol";

/**
    This class working with BountyProgramEther.
    This class is for distributing Ethereum for BountyHunters.
    Send Ethereum all at once Bounty Hunters.
    @author Artem Rapota artem.rapota@inveritasoft.com
 */
contract BountyProgramEthereumAll is Owner, ERC20Ethereum {
    
    uint256 private _pieceOfEther;
    uint256 private _endDate;
    mapping (address => uint256) private _balanceOf;
    address[] private allAddress;
    
    function BountyProgramEthereumAll(uint256 pieceOfEther, uint256 endDate) public payable {
        require(pieceOfEther > 0);
        require(endDate > 0);
        
        address(this).call.value(msg.value);
        _balanceOf[owner] = msg.value;
        _pieceOfEther = pieceOfEther;
        _endDate = endDate;
    }
    
    function destroyContract() isOwner public {
        owner.transfer(address(this).balance);
        selfdestruct(this);
    }
    
    function balanceContractEther() public view returns(uint) {
        return address(this).balance;
    }

    function balanceOf(address _addr) constant public returns (uint) {
        return _balanceOf[_addr];
    }
    
    function transfer(address _to) isOwner public returns (bool success) {
        require(_to != owner);
        
        if (
            _balanceOf[owner] > 0 
            && _balanceOf[owner] >= _pieceOfEther 
        ) {
            _balanceOf[owner] -= _pieceOfEther;
            _balanceOf[_to] += _pieceOfEther;
            
            bool forAddAdress = true;
            for(uint256 i = 0; i < allAddress.length; i++) {
                if (allAddress[i] == _to) {
                    forAddAdress = false;
                    break;
                }
            }
            
            if (forAddAdress) {
                allAddress.push(_to);
            }
            
            emit Transfer(owner, _to, _pieceOfEther);

            return true;
        }
        
        return false;
    }
    
    function sendEtherForAllAddresses(uint256 endDate) isOwner payable public {
        require(endDate >= _endDate);
        require(_balanceOf[owner] == 0);
        
        uint256 allSum = 0;
        
        for(uint256 i = 0; i < allAddress.length; i++) {
            allSum += _balanceOf[allAddress[i]];
        }   
        
        if(allSum != address(this).balance) {
            revert();
        }
        
        for(i = 0; i < allAddress.length; i++) {
            allAddress[i].transfer(_balanceOf[allAddress[i]]);
            delete _balanceOf[allAddress[i]];
        }

        emit TransferEtherForAllAddresses(owner, endDate);
    }
}