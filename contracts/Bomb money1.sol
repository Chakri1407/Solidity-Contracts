pragma solidity ^0.5.11;
contract InvestmentDashboard {
    address public contractOwner;
    constructor() public {
        contractOwner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == contractOwner);
        _;
    }
    struct token {
        uint256 id;
        string name;
        string owner;
        uint256 value;
    }
    mapping(uint256 => token) public properties;
    function addtoken(
        uint256 _tokenid,
        string memory _name,
        string memory _owner,
        uint256 _value

    ) public onlyOwner {
        properties[_tokenid].name = _name;
        properties[_tokenid].owner = _owner;
        properties[_tokenid].value = _value;
    }
    function querytokenById(uint256 _tokenid)
        public view returns (
            string memory name,
            string memory owner,
            uint256 value
        )
    {
        return (
            properties[_tokenid].name,
            properties[_tokenid].owner,
            properties[_tokenid].value
        );
    }
    function transfertokenOwnership(
        uint256 _tokenid,
        string memory _newOwner) public {
        properties[_tokenid].owner = _newOwner;
    }
}