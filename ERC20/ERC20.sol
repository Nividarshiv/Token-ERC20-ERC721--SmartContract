//SPDX-License-Identifier:MIT
pragma solidity >=0.8.2 <0.9.0;
import "./IERC20.sol";

contract ERC20 is IERC20{
    uint  totalsupply;
    mapping(address=>uint)  balanceof;
    mapping(address=>mapping(address=>uint))  allowances;
    string public name;
    string public symbol;
    uint public decimals=18;

    constructor(string memory _name,string memory _symbol){
        name=_name;
        symbol=_symbol;
    }

    function totalSupply() external view returns (uint){
          return totalsupply;
    }

    function balanceOf(address account) external view returns (uint){
          return balanceof[account];
    }

    function transfer(address recipient,uint amount) external returns (bool){
        require(balanceof[msg.sender]>amount,"Insufficient balance to transfer");
         balanceof[msg.sender] -=amount;
         balanceof[recipient] +=amount;
         emit Transfer(msg.sender, recipient, amount);
         return true;
    }

    function allowance(address owner,address spender) external view returns (uint){
        return allowances[owner][spender];
    }
   
    function approve(address spender,uint amount) external  returns (bool){
        require(balanceof[msg.sender]>amount,"Insufficient balance to approve");
        allowances[msg.sender][spender] +=amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender,address recipient,uint amount) external returns(bool){
        require(balanceof[sender]>=amount,"Insufficient balance to transfer");
        require(allowances[sender][msg.sender]>=amount,"Insufficient allowance of money");
        allowances[sender][msg.sender] -=amount;
        balanceof[sender] -=amount;
        balanceof[recipient] +=amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external{
        balanceof[msg.sender]+=amount;
        totalsupply+=amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external{
        require(balanceof[msg.sender]>amount,"You cant burn due to low balance");
        balanceof[msg.sender] -=amount;
        totalsupply -=amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}