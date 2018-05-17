pragma solidity ^0.4.2;
import "./Configurable.sol";
import "../data/CustomerAccount.sol";
import "../data/CustomerTransaction.sol";
import "../lifecycle/Upgradeable.sol";
contract TransactionService is Configurable,Upgradeable{
    CustomerTransaction data;
    CustomerAccount account;
    bool public inited=false;


    modifier whenInited() {
        require(inited);
        _;
    }
    modifier onlyAdmin() {
        require(config.isAdmin(msg.sender));
        _;
    }

    //构造函数
    function TransactionService()public{

    }

    //发起交易
    function transform(address from,address to, uint64 amount, uint160 txHash,uint64 timestamp, string remark) public {
        require(from!=address(0)&&from!=address(to)&&amount>0);
        assert (account.getBalance(from)>amount);
        data.addRecord(msg.sender, to, amount, txHash, timestamp, remark);
        account.updateBalance(from,-amount);
        account.updateBalance(to,amount);
    }

    //给账户加款
    function addFund(address to, uint160 txHash, uint64 amount, string remark) public onlyAdmin() returns (address touser, uint balance){
        var timestamp = uint64(now);
        data.addRecord(address(0), to, amount, txHash, timestamp, remark);
        account.updateBalance(to,amount);
    }

    //根据发送人或者接收人查看交易记录
    function getTransactions(address to,uint128 start,uint128 rows) public view returns (uint160[5][]){
        uint160[5][] memory temp = new uint160[5][](rows);
        for (uint i = 0; i <rows; i++) {
            var (txHash,_from,_to,amount,timestamp,_start,total)=data.getTransactionsForPaging(tx.origin,to,start,config.isAdmin(tx.origin));
            temp[i] = [txHash,uint160(_from),uint160(_to),amount,timestamp];
            start=_start;
        }
        return temp;
    }

    //根据ID交易记录详情
    function getTransactionDetail(uint160 txHash) public view returns (uint160, address, address, uint128, uint64, string){
        return data.getTransactionByTxHash(txHash);
    }

    function init(address _config){
        config=Config(_config);
        address addr_tx=config.getCurrentVersion("CustomerTransaction");
        require(addr_tx!=address(0));
        data=CustomerTransaction(addr_tx);
        address addr_acc=config.getCurrentVersion("AccountService");
        require(addr_acc!=address(0));
        account =CustomerAccount(addr_acc);
        inited=true;
    }
}