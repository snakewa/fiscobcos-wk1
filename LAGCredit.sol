pragma solidity ^0.4.16;

contract LAGCredit {

    string name = "LAGC";  // 积分名称  LIBRAIRIE AVANT-GARDE CREDIT
    string symbol = "LAG"; // 积分简称
    uint256 totalSupply; // 发行量

    // 地址对应余额
    mapping (address => uint256) public balances; 
    
    mapping (address=>int256[]) public creditRecords;
    mapping (address=>address[]) public transToRecords;

    // 用来通知客户端积分交易发生
    event transferEvent(address from, address to, uint256 value);

    // 查询账户余额
    function balanceOf(address _owner) public constant returns (uint256) {
        return balances[_owner];
    }

    // 查询积分发放总额
    function getTotalSupply() public constant returns (uint256) {
        return totalSupply;
    }

    // 构造函数，由积分创建者执行：书店
    constructor(uint256 initialSupply, string creditName, string creditSymbol) public {
        totalSupply = initialSupply; 
        balances[msg.sender] = totalSupply; 
        name = creditName;
        symbol = creditSymbol;
    }

    // 积分的发送函数，内部函数
    function _transfer(address _from, address _to, uint _value) internal {

        require(_to != 0x0); 
        require(balances[_from] >= _value); 
        require(_value >=0); //_value不能为负值

        uint previousBalances = balances[_from] + balances[_to]; 

        balances[_from] -= _value; 
        balances[_to] += _value;

        emit transferEvent(_from, _to, _value);   // 记录转账并通知客户端发生积分交易
        assert(balances[_from] + balances[_to] == previousBalances);  
        
        creditRecords[_from].push(int256(_value));
        transToRecords[_from].push(_to);
        creditRecords[_to].push(0-int256(_value));
        transToRecords[_to].push(_from);
    }

    // 客户端调用的积分发送函数
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value); 
    }
    
    //Credit transfer record
    function getTransferRecords(address _owner) constant public returns (address[],int256[]){
        return (transToRecords[_owner],creditRecords[_owner]);
    }
    
}