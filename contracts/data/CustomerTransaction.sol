pragma solidity ^0.4.2;


contract CustomerTransaction {
    //交易记录
    struct Transaction {
    uint160 txHash;           //交易ID
    address from;             //发起人地址
    address to;               //接收方地址
    uint128 amount;           //交易金额
    uint64 timestamp;        //交易时间
    string remark;           //备注
    }

    //交易记录
    Transaction[] public transactions;

    //交易序号
    mapping (address => uint64) public tnounces;

    //数据索引
    mapping (uint160 => uint) public indexs;

    //记录交易内容
    function addRecord(address from, address to, uint64 amount, uint160 txHash, uint64 timestamp, string remark){
        uint index = transactions.length;
        indexs[txHash] = index;
        transactions.push(Transaction(txHash, from, to, amount, timestamp, remark));
        tnounces[from]++;
        tnounces[to]++;
    }

    //按分页获取合同内容
    function getTransactionsForPaging(address from, address to,uint128 start,bool isAdmin)public view  returns (uint160,address,address,uint128,uint64,uint128,uint128) {
        uint128 total = uint128((isAdmin? transactions.length : tnounces[from]));
        for (; start < total; start++) {
            Transaction memory t = transactions[start];
            if (isAdmin) {
                if (to != address(0) && t.to != to) {
                    continue;
                }
                return (t.txHash,t.from,t.to,t.amount,t.timestamp,start,total);
            }
            else {
                if (t.from == from || t.to == from) {
                    if (to != address(0) && t.to != to) {
                        continue;
                    }
                    return (t.txHash,t.from,t.to,t.amount,t.timestamp,start,total);
                }
            }
        }
    }

    //根据ID查询交易记录详情
    function getTransactionByTxHash(uint160 txHash) public view returns (uint160, address, address, uint128, uint64, string){
        //校验数据是否存在
        uint index = indexs[txHash];
        return getTransactionDetail(index);
    }

    function getTransactionDetail(uint index) public view returns (uint160, address, address, uint128, uint64, string){
        Transaction memory t = transactions[index];
        return(t.txHash,t.from, t.to, t.amount, t.timestamp, t.remark);
    }

}
