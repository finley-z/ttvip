pragma solidity ^0.4.2;

contract CustomerContract {
    //交易记录
    struct Transaction {
        uint160 txHash;           //交易ID
        address from;             //发起人地址
        address to;               //接收方地址
        uint64 amount;           //交易金额
        uint64 timestamp;        //交易时间
        string remark;           //备注
    }

    //交易记录
    Transaction[] public transactions;

    //交易序号
    mapping (address => uint64) public tnounces;

    //发起交易
    function transform(address to, uint64 amount, uint160 txHash, string remark) public {
        if (amount < 0 || accounts[msg.sender].balance < amount) {
            return;
        }
        var timestamp = uint64(now);
        accounts[msg.sender].balance -= amount;
        accounts[to].balance += amount;
        tnounces[msg.sender]++;
        tnounces[to]++;
        this.takerecord(msg.sender, to, amount, txHash, timestamp, remark);
        emit Transformed(msg.sender, to, timestamp);
    }
    //给账户加款
    function addFund(address to, uint160 txHash, uint64 amount, string remark) public onlyAdmin() returns (address touser, uint balance){
        var timestamp = uint64(now);
        accounts[to].balance += amount;
        this.takerecord(msg.sender, to, amount, txHash, timestamp, remark);
        tnounces[msg.sender]++;
        tnounces[to]++;
        Transformed(msg.sender, to, timestamp);
        return (to, accounts[to].balance);
    }

    //记录交易内容
    function takerecord(address from, address to, uint64 amount, uint160 txHash, uint64 timestamp, string remark){
        transactions.push(Transaction(txHash, from, to, amount, timestamp, remark));
    }

    //获取合同内容列表
    function getTransactionsInternal(address from, address to) constant internal returns (uint160[5][]) {
        var length = (from == admin ? transactions.length : tnounces[from]);
        uint160[5][] memory temp = new uint160[5][](length);
        uint64 index = 0;
        for (uint64 i = 0; i < transactions.length; i++) {
            Transaction t = transactions[i];
            if (from == admin) {
                if (to != 0 && t.to != to) {
                    continue;
                }
                temp[index] = [t.txHash, uint160(t.from), uint160(t.to), t.amount, t.timestamp];
                index++;
            }
            else {
                if (t.from == from || t.to == from) {
                    temp[index] = [t.txHash, uint160(t.from), uint160(t.to), t.amount, t.timestamp];
                    index++;
                }
            }

        }
        return temp;
    }

    //根据发送人或者接收人查看交易记录
    function getTransactions(address to) public view returns (uint160[5][]){
        return getTransactionsInternal(msg.sender, to);
    }

    //根据ID交易记录详情
    function getTransactionDetail(uint160 txHash) public view returns (uint160, address, address, uint64, uint64, string){
        for (uint64 i = 0; i < transactions.length; i++) {
            Transaction t = transactions[i];
            if (t.txHash == txHash) {
                return (t.txHash, t.from, t.to, t.amount, t.timestamp, t.remark);
            }

        }
        return (0, 0, 0, 0, 0, "");
    }


}
