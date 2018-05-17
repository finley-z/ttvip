pragma solidity ^0.4.2;
pragma experimental ABIEncoderV2;

import "../lifecycle/SmartContractFactory.sol";
import "../service/AccountService.sol";
import "../service/ContractService.sol";
import "../service/TransactionService.sol";
import "../lifecycle/Upgradeable.sol";
import "../data/CustomerContract.sol";
contract TTVIP is Upgradeable{
    SmartContractFactory factory;
    AccountService accountService;
    ContractService contractService;
    TransactionService transactionService;

    function TTVIP(address config_addr)public payable {
        factory=new SmartContractFactory(config_addr);
        refresh();
    }

    //签署事件
    event Signed(address indexed firstParty, address indexed secondParty, uint indexed txHash);

    //交易事件
    event Transformed(address indexed from, address indexed to, uint indexed txHash);

    //签署合约
    function signContract(address secondParty,uint8 shareProfit,uint8 expireYear,uint160 txHash,CustomerContract.ContractState state,string remark) public{
        contractService.signContract(msg.sender,secondParty,shareProfit,expireYear,txHash,uint64(now),state,remark);
    }

    //确认合约
    function confirmContract(uint160 txHash,CustomerContract.ContractState state)public{
        contractService.confirmContract(txHash,state);
    }

    //用户获取合约签署列表
    function getContracts(uint128 start,uint128 rows,CustomerContract.ContractState state)public view returns(uint160[6][]) {
        contractService.getContractList(start,rows,state);
    }

    //根据ID交易记录详情
    function getContractDetail(uint160 txHash) public view returns(address,address,uint32,uint32,uint160,uint64,CustomerContract.ContractState,string){
        return contractService.getContractDetail(txHash);
    }

    //发起交易
    function transform(address to,uint64 amount,uint160 txHash,string remark) public whenNotPaused{
        transactionService.transform(msg.sender,to,amount,txHash,uint64(now),remark);
    }

    //给账户加款
    function addFund(address to,uint160 txHash,uint64 amount,string remark) public whenNotPaused returns(address touser,uint balance){
        transactionService.addFund(to, txHash, amount, remark);
    }

    //根据发送人或者接收人查看交易记录
    function getTransactions(address to,uint128 start,uint128 rows) public view returns(uint160[5][]){
        return transactionService.getTransactions(to,start,rows);
    }

    //根据ID交易记录详情
    function getTransactionDetail(uint160 txHash) public view returns(uint160, address, address, uint128, uint64, string){
        return transactionService.getTransactionDetail(txHash);
    }

    //用户注册
    function register(uint128 userId,string userName,uint64 balance){
        accountService.register(userId,userName,balance);
    }

    //获取账户信息
    function getAccount() public  view  returns(address,uint128,string,uint32,uint128){
        return accountService.getAccount(msg.sender);
    }

    //获取账户余额
    function getBalance( )public  view returns(uint128){
        return accountService.getBalance(msg.sender);
    }

    //将地址、用户名转换成bytes20
    function getAccountList()public  view  returns(bytes20[],string[]){
        return accountService.getAccountList();
    }

    function refresh() public{
        accountService=factory.getAccountService();
        contractService=factory.getContractService();
        transactionService=factory.getTransactionService();
    }


}
