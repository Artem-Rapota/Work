pragma solidity ^0.4.21;
import "./Owner.sol";

contract BountyProgramEther is Owner {
    
    uint256 private _pieceOfEther;
    mapping (address => uint256) private _balanceOf;
    address[] private allAddress;
    string private _typeOfPay;
    
    string constant private _one = "one";
    string constant private _all = "all";
    
    function createBountyProgram(uint256 pieceOfEther, string typeOfPay) isOwner payable public returns(bool) {
        
        if (_balanceOf[owner] > 0 || pieceOfEther == 0 || msg.value == 0)
        {
            revert();
            
            return false;
        }
        
        if (
            keccak256(typeOfPay) == keccak256(_one) 
            || keccak256(typeOfPay) == keccak256(_all)
        ) {
            _typeOfPay = typeOfPay;
        } else {
            revert();
            
            return false;
        }
        
        address(this).call.value(msg.value);
        _balanceOf[owner] = msg.value;
        _pieceOfEther = pieceOfEther;
            
        return true;
    }

    
    function sendEtherToAddress(address addr) isOwner public {
        require(
            _balanceOf[owner] > 0 
            && _balanceOf[owner] >= _pieceOfEther
            && address(this).balance > 0 
            && address(this).balance >= _pieceOfEther
            && keccak256(_typeOfPay) == keccak256(_one)
        );
        
        _balanceOf[addr] += _pieceOfEther;
        _balanceOf[owner] -= _pieceOfEther;
        addr.transfer(_pieceOfEther);
    }
    
    function balanceContractEther() public view returns(uint) {
        
        if (keccak256(_typeOfPay) == keccak256(_one)) {
            return address(this).balance;
        } else {
            return _balanceOf[owner];
        }
        
    }
    
    function destroyContract() isOwner public {
        owner.transfer(address(this).balance);
        selfdestruct(this);
    }
    
    function balanceOf(address _addr) constant public returns (uint) {
        return _balanceOf[_addr];
    }
    
    function transfer(address _to) isOwner public returns (bool success) {
        
        if (_balanceOf[owner] >= _pieceOfEther) {
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
            
            return true;
        }
        
        return false;
    }
    
    function sendEtherForAllAddresses() isOwner payable public {
        
        require(keccak256(_typeOfPay) == keccak256(_all));
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
    }
}