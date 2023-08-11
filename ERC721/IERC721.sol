//SPDX-License-Identifier:MIT
pragma solidity >=0.8.2 <0.9.0;
import "./IERC165.sol";

interface IERC721 is IERC165 {
    function balanceof(address owner) external view returns(uint balance);
    function ownerof(uint tokenID) external view returns(address owner);
    function safeTransferFrom(address from,address to,uint tokenID) external;
    function safeTransferFrom(address from,address to,uint tokenID,bytes calldata data) external;
    function transferFrom(address from,address to,uint tokenID) external;
    function approve(address to,uint tokenID) external;
    function getApproved(uint tokenID) external view returns (address operator);
    function setApprovalForAll(address operator,bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);   
}