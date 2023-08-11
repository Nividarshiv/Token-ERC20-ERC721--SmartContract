//SPDX-License-Identifier:MIT
pragma solidity >=0.8.2 <0.9.0;
import "./IERC721.sol";
import "./IERC721Receiver.sol";

contract ERC721 is IERC721{
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed spender, uint indexed id);
    event ApprovalForAll(address indexed owner,address indexed operator, bool approved);

    mapping(uint=>address) internal _ownerOf;
    mapping(address=>uint) internal _balanceOf;
    mapping(uint=>address) internal _approvals;
    mapping(address=>mapping(address=>bool)) public isApprovedForAll;

    function supportsInterface(bytes4 interfaceID) external pure returns(bool){
        return interfaceID==  type(IERC721).interfaceId || interfaceID== type(IERC165).interfaceId;
    }

    function balanceof(address owner) external view returns(uint){
        require(owner !=address(0),"Address is zero");
        return _balanceOf[owner];
    }

    function ownerof(uint tokenID) external view returns(address owner){
        owner=_ownerOf[tokenID];
        require(owner!= address(0),"No token exists");
    }

    function safeTransferFrom(address from,address to,uint tokenID) external{
        transferFrom(from, to, tokenID);
        require(to.code.length==0 || IERC721Receiver(to).onERC721Received(msg.sender,from,tokenID," ")==IERC721Receiver.onERC721Received.selector,
        "Unsafe receipient");
    }

    function safeTransferFrom(address from,address to,uint tokenID,bytes calldata data) external{
         transferFrom(from, to, tokenID);
        require(to.code.length==0 || IERC721Receiver(to).onERC721Received(msg.sender,from,tokenID,data)==IERC721Receiver.onERC721Received.selector,
        "Unsafe receipient");
  
    }

    function transferFrom(address from,address to,uint tokenID) public{
        require(from == _ownerOf[tokenID],"Your are not owner");
        require(to!=address(0),"Address invalid");
        require(isApprovedOrOwner(from, msg.sender, tokenID),"Not Authorized");
        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[tokenID]=to;
        delete _approvals[tokenID];
        emit Transfer(from, to, tokenID); 
    }

    function isApprovedOrOwner(address owner,address spender,uint tokenID) internal view returns(bool){
        return (spender==owner || IsApprovedForAll(owner,spender) || spender==_approvals[tokenID]);
    }

    function approve(address to,uint tokenID) external{
        address owner=_ownerOf[tokenID];
        require(owner==msg.sender || isApprovedForAll[owner][msg.sender],"Not authorized");
        _approvals[tokenID]=to;
        emit Approval(owner, to, tokenID);
    }

    function getApproved(uint tokenID) external view returns (address){
        require(_ownerOf[tokenID]!=address(0),"Token doesn't exist");
        return _approvals[tokenID];
    }

    function setApprovalForAll(address operator,bool _approved) external{
        isApprovedForAll[msg.sender][operator]=_approved;
        emit ApprovalForAll(msg.sender, operator,_approved);
    }

    function IsApprovedForAll(address owner, address operator) public view returns (bool){
        return isApprovedForAll[owner][operator];
    } 

    function mint(address to,uint tokenID) public {
        require(to !=address(0),"No address");
        require(_ownerOf[tokenID]==address(0),"Token exists");
        _balanceOf[to]++;
        _ownerOf[tokenID]=to;
        emit Transfer(address(0), to, tokenID);
    }

    function burn(uint tokenID) public{
        address owner=_ownerOf[tokenID];
        require(owner!=address(0),"Token doesn't exists");
        _balanceOf[owner]--;
        delete _ownerOf[tokenID];
        delete _approvals[tokenID];
        emit Transfer(owner, address(0), tokenID);
    }
}