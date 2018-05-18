pragma solidity ^0.4.2;
pragma experimental ABIEncoderV2;

contract TTVIP {
    enum ContractState{
    ALL,
    CREATED,
    CONFIRMED,
    EFFECTED,
    CLOSED
    }
    //合同内容
    struct Content{
    address firstParty;      //甲方地址
    address secondParty;     //乙方地址
    uint32 shareProfit;       //分润点 0-100 %
    uint32 expireYear;        //有效时间  N 年
    uint160 txHash;          //交易哈希值
    uint64 timestamp;        //交易时间戳
    ContractState state;     //签署状态
    string remark;           //备注
    }

    //用户资金账户
    struct Account{
    address userAddr;
    uint128 userId;         //用户ID
    string userName;        //用户名字
    uint32 status;          //账户状态  1正常，0禁用
    uint128 balance;         //余额  精确至分 换算成元  balance/100;
    }

    //交易记录
    struct Transaction{
    uint160 txHash;           //交易ID
    address from;             //发起人地址
    address to;               //接收方地址
    uint128 amount;           //交易金额
    uint64 timestamp;        //交易时间
    string remark;           //备注
    }

    //合约创建人，管理员
    address admin;

    //资金账户数据
    mapping (address => Account) public  accounts;
    address[] account_keys;


    //合约的序号
    mapping (address=>uint)  cnounces;
    //合约数据索引
    mapping (uint160 => uint)  c_indexs;

    //交易序号
    mapping (address => uint)  tnounces;
    //数据索引
    mapping (uint160 => uint)  t_indexs;

    //合约内容数据
    Content[] public contracts;
    //交易记录
    Transaction[] public transactions;

    uint160 txHash=1010101;


    //签署事件
    event Signed(address indexed firstParty,address indexed secondParty,uint indexed txHash);
    //交易事件
    event Transformed(address indexed from,address indexed to,uint indexed txHash);

    function TTVIP() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        if (msg.sender != admin) throw;
        _;
    }

    //签署合约
    function signContract(address secondParty,uint32 shareProfit,uint32 expireYear,string remark) public{
        uint160 txHash=getTxHash();
        var timestamp=uint64(now);
        Content memory con=Content(msg.sender,secondParty,shareProfit,expireYear,txHash,timestamp,ContractState.CREATED,remark);
        uint index=contracts.length;
        c_indexs[txHash]=index;
        contracts.push(con);

        cnounces[msg.sender]++;
        cnounces[secondParty]++;
        Signed(msg.sender,secondParty,timestamp);
    }

    //更新合约状态
    function confirmContract(uint160 txHash,ContractState state)public{
        uint index=c_indexs[txHash];
        Content memory t=contracts[index];
        require(msg.sender==t.secondParty&&t.state==ContractState.CREATED);
        contracts[index].state=state;
    }


    //获取合同内容列表
    function getContractsInternal(address useraddress,ContractState state) constant internal returns(uint160[7][]) {
        var length=(useraddress==admin?contracts.length:cnounces[useraddress]);
        uint160[7][] memory temp=new uint160[7][](length);
        uint index=0;
        for (uint64 i = 0; i < contracts.length; i++) {
            if(useraddress==admin){
                if(contracts[i].state==state){
                    temp[i] = [uint160(contracts[i].firstParty),uint160(contracts[i].secondParty),contracts[i].shareProfit,contracts[i].expireYear,contracts[i].txHash,contracts[i].timestamp,uint8(contracts[i].state)];
                }else{
                    continue;
                }
            }else{
                if(contracts[i].state==state){
                    if(contracts[i].firstParty==useraddress||contracts[i].secondParty==useraddress){
                        temp[index] = [uint160(contracts[i].firstParty),uint160(contracts[i].secondParty),contracts[i].shareProfit,contracts[i].expireYear,contracts[i].txHash,contracts[i].timestamp,uint8(contracts[i].state)];
                        index++;
                    }
                }else{
                    continue;
                }
            }
        }
        return temp;
    }

    //用户获取合约签署列表
    function getContracts(ContractState state)public  view returns(uint160[7][]) {
        return getContractsInternal(msg.sender,state);
    }


    //根据ID交易记录详情
    function getConrtactDetail(uint160 txHash) public view returns(address,address,uint32,uint32,uint160,uint64,string,uint8){
        uint index=c_indexs[txHash];
        Content memory t=contracts[index];
        return(t.firstParty,t.secondParty,t.shareProfit,t.expireYear,t.txHash,t.timestamp,t.remark,uint8(t.state));
    }

    //发起交易
    function transform(address to,uint128 amount ,string remark) public{
        require(amount>0&&accounts[msg.sender].balance>=amount);

        uint160 txHash=getTxHash();
        var timestamp=uint64(now);
        accounts[msg.sender].balance-=amount;
        accounts[to].balance+=amount;
        tnounces[msg.sender]++;
        tnounces[to]++;
        this.takerecord(msg.sender,to,amount,txHash,timestamp,remark);
        shareProfit(to,amount);
        emit Transformed(msg.sender,to,timestamp);
    }

    function shareProfit(address secondParty,uint128 amount){
        var length=cnounces[secondParty];
        uint32 shareProfit=0;
        address firstParty;
        for (uint i = 0; i < contracts.length; i++) {
            if(contracts[i].state==ContractState.EFFECTED){
                if(contracts[i].secondParty==secondParty){
                    shareProfit=contracts[i].shareProfit;
                    firstParty=contracts[i].firstParty;
                    break;
                }
            }
        }
        if(shareProfit>0){
            uint160 txHash=getTxHash();
            uint128 profit=amount*(shareProfit/100);
            takerecord(firstParty,secondParty,profit,txHash,uint64(now),"share profit!");
        }
    }

    //给账户加款
    function addFund(address to,uint128 amount,string remark) public onlyAdmin() returns(address touser,uint balance){
        var timestamp=uint64(now);
        uint160 txHash=getTxHash();
        accounts[to].balance+=amount;
        this.takerecord(msg.sender,to,amount,txHash,timestamp,remark);
        tnounces[msg.sender]++;
        tnounces[to]++;
        Transformed(msg.sender,to,timestamp);
        return (to,accounts[to].balance);
    }

    //记录交易内容
    function takerecord(address from,address to,uint128 amount,uint160 txHash,uint64 timestamp,string remark){
        uint index = transactions.length;
        t_indexs[txHash] = index;
        transactions.push(Transaction(txHash,from,to,amount,timestamp,remark));
    }

    //获取合同内容列表
    function getTransactionsInternal(address from,address to) constant internal returns(uint160[5][]) {
        var length=(from==admin?transactions.length:tnounces[from]);
        uint160[5][] memory temp=new uint160[5][](length);
        uint64 index=0;
        for (uint64 i = 0; i < transactions.length; i++) {
            Transaction t=transactions[i];
            if(from==admin){
                if(to!=0&&t.to!=to){
                    continue;
                }
                temp[index]=[t.txHash,uint160(t.from),uint160(t.to),t.amount,t.timestamp];
                index++;
            }else{
                if(t.from==from||t.to==from){
                    temp[index]=[t.txHash,uint160(t.from),uint160(t.to),t.amount,t.timestamp];
                    index++;
                }
            }

        }
        return temp;
    }

    //根据发送人或者接收人查看交易记录
    function getTransactions(address to) public view returns(uint160[5][]){
        return getTransactionsInternal(msg.sender,to);
    }

    //根据ID交易记录详情
    function getTransactionDetail(uint160 txHash) public view returns(uint160,address,address,uint128,uint64,string){
        uint index = t_indexs[txHash];
        Transaction memory t = transactions[index];
        return(t.txHash,t.from, t.to, t.amount, t.timestamp, t.remark);
    }

    //账户注册
    function register(uint128 userId,string userName,uint64 balance)public{
        //注意各种校验
        address user_addr=tx.origin;
        Account memory acc=accounts[user_addr];
        require(acc.userId==0);
        Account memory newAcc=Account(user_addr,userId,userName,1,balance);
        accounts[user_addr]=newAcc;
        account_keys.push(user_addr);
    }

    //更新账户余额 
    function updateBalance(address addr,uint128 amount){
        accounts[addr].balance+=amount;
    }

    //将地址用户名转换成bytes20
    function getAccountList() public  view  returns(bytes20[],string[]){
        bytes20[] memory addrs = new bytes20[](account_keys.length);
        string[] memory names = new string[](account_keys.length);
        for (uint i = 0; i <account_keys.length; i++) {
            addrs[i] =bytes20(accounts[account_keys[i]].userAddr);
            names[i]=accounts[account_keys[i]].userName;
        }
        return (addrs,names);
    }

    //获取账户信息  
    function getAccount() public  view  returns(address,uint128,string,uint32,uint128){
        Account memory acc= accounts[msg.sender];
        return (acc.userAddr,acc.userId,acc.userName,acc.status,acc.balance);
    }

    //查询余额 
    function getBalance()public  view  returns(uint128){
        return accounts[msg.sender].balance;
    }

    function getTxHash()internal returns(uint160){
        txHash++;
        return txHash;
    }



    //测试
    function test() public view returns(address val,uint64 t){
        uint64 a=uint64(msg.sender);
        //   uint64 va=uint64(now);
        return (admin,a);
    }
}
