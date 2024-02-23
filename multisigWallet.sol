//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

contract MultiSigWallet {

    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(address indexed owner, uint indexed txIndex, address indexed To, uint amount, bytes data);
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner,uint indexed txIndex);
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public Approvals_required;

    receive() external  payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    struct Transaction {
        address To;
        uint value;
        bytes data;
        bool executed;
        uint numofconfirmations;

               
    }

    Transaction[] public transactions;

    mapping(uint => mapping(address => bool)) public isConfirmed;

    modifier onlyOwner() {
        require(isOwner[msg.sender]," Not a owner");
        _;
    }

    modifier txExists(uint _txindex) {
        require(_txindex < transactions.length, "tx do not exists");
        _;
    }

    modifier notexecuted(uint _txindex) {
        require(!transactions[_txindex].executed," Tx already executed");
        _;
    }

    modifier notconfirmed(uint _txindex) {
        require(!isConfirmed[_txindex][msg.sender]," tx already exists");
        _;
    }


    constructor(address [] memory _owner,uint _numofapprovalsRequired) {
        require(owners.length > 0,"No owners found");
        require(_numofapprovalsRequired > 0 && _numofapprovalsRequired <= owners.length,"invalid number of confirmations");

        for(uint i = 0 ; i < _owner.length ; i++){
        address owner = _owner[i];

        require(owner != address(0), " invalid owner");
        require(!isOwner[owner], " owner exists");

        isOwner[owner] = true;
        owners.push(owner);
        }
        Approvals_required = _numofapprovalsRequired;

    }

    function Addowner(address _addowner) public onlyOwner{
        owners.push(_addowner);
        isOwner[_addowner] = true;
    }

    function submittransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint txIndex = transactions.length;

        transactions.push(Transaction({
            To: _to,
            value : _value,
            data : _data,
            executed : false,
            numofconfirmations : 0
    }));

    emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);

        }

    function confirmTransaction(uint _txindex) public onlyOwner txExists(_txindex) notexecuted(_txindex)
    notconfirmed(_txindex) {
        Transaction storage trasaction = transactions[_txindex];
        trasaction.numofconfirmations += 1;
        isConfirmed[_txindex][msg.sender] =  true;

        emit ConfirmTransaction(msg.sender, _txindex);
    } 

    function executeTransaction(uint _txindex) public onlyOwner txExists(_txindex) notexecuted(_txindex) {
        Transaction storage transaction = transactions[_txindex];

        require(transaction.numofconfirmations >= Approvals_required," No enough confirmations");

        transaction.executed = true;
        (bool success, ) = transaction.To.call{value : transaction.value}(transaction.data); 

        require(success,"tx failed");

        emit ExecuteTransaction(msg.sender,_txindex);
    }

    function revokeConfirmation(uint _txindex) public onlyOwner txExists(_txindex) notexecuted(_txindex) {
        Transaction storage transaction = transactions[_txindex];
        require(isConfirmed[_txindex][msg.sender], "tx not confirmed");

        transaction.numofconfirmations -= 1;
        isConfirmed[_txindex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender,_txindex);

    }

    function getOwners() public view returns(address[] memory ) {
        return owners;
    }

    function getTransactionCount() public view returns(uint) {
        return transactions.length;
    }

    function getTransaction(uint _txindex) public view returns(address to, uint value,bytes memory data,bool executed, uint numofconfirmations) {
        Transaction storage transaction = transactions[_txindex];

        return (
            transaction.To,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numofconfirmations
        );
    }

}