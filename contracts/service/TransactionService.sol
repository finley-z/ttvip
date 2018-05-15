pragma solidity ^0.4.2;
import "./Configurable.sol";
import "../data/CustomerAccount.sol";
import "../data/CustomerTransaction.sol";

contract TransactionService is Configurable{
    CustomerTransaction data;
    CustomerAccount account;

    //构造函数
    function ContractService()public{
        address addr_tx=config.getCurrentVersion("CustomerTransaction");
        data=CustomerTransaction(addr_tx);
        address addr_acc=config.getCurrentVersion("AccountService");
        account =CustomerAccount(addr_acc);
    }

    //发起交易
    function transform(address from,address to, uint64 amount, uint160 txHash, string remark) public {

        if (amount < 0 || account.getBalance(from) < amount) {
            return;
        }
        data.addRecord(msg.sender, to, amount, txHash, timestamp, remark);
        var timestamp = uint64(now);
        account.updateBalance(from,-amount);
        account.updateBalance(to,amount);
    }

    //给账户加款
    function addFund(address to, uint160 txHash, uint64 amount, string remark) public onlyAdmin() returns (address touser, uint balance){
        var timestamp = uint64(now);
        data.addRecord(msg.sender, to, amount, txHash, timestamp, remark);
        account.updateBalance(to,amount);
    }

    //根据发送人或者接收人查看交易记录
    function getTransactions(address from,address to) public view returns (uint160[5][]){
        bool isAdmin=config.isAdmin(user_addr);
        uint160[5][] memory temp = new uint160[5][](rows);
        for (uint i = 0; i <rows; i++) {
            var (txHash,_from,_to,amount,timestamp,_start,total)=data.getTransactionsForPaging(from,to,start,isAdmin);
            temp[i] = [txHash,uint160(_from),uint160(_to),amount,timestamp];
            start=_start;
        }
        return temp;
    }

    //根据ID交易记录详情
    function getTransactionDetail(uint160 txHash) public view returns (uint160, address, address, uint64, uint64, string){
         return data.getTransactionByTxHash(txHash);
    }
}