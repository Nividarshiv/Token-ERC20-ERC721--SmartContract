//SPDX-License-Identifier:MIT
pragma solidity >=0.8.2 <0.9.0;
import "./IERC20.sol";

contract TokenSwap{
    IERC20 public token1;
    address public owner1;
    IERC20 public token2;
    address public owner2;
    constructor(address _token1,address _owner1,address _token2,address _owner2){
        token1=IERC20(_token1);
        owner1=_owner1;
        token2=IERC20(_token2);
        owner2=_owner2;
    }
    function swap(uint amount1,uint amount2) public{
        require(msg.sender==owner1 || msg.sender==owner2,"Not authorized");
        require(token1.allowance(owner1,address(this)) >=amount1,"Token1 allowance too low");
        require(token2.allowance(owner2,address(this)) >=amount2,"Token2 allowance too low");
        SafeTransferFrom( token1, owner1, owner2, amount1);
        SafeTransferFrom(token2, owner2, owner1, amount2);
    }

    function SafeTransferFrom(IERC20 token,address sender,address recipient,uint amount) private{
        bool sent=token.transferFrom(sender, recipient, amount);
        require(sent,"Token transfer failed");
    }
}