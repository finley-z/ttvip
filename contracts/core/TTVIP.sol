pragma solidity ^0.4.2;

import "../lifecycle/SmartContractFactory.sol";
import "../service/AccountService.sol";
import "../service/ContractService.sol";
import "../service/TransactionService.sol";
import "../lifecycle/Upgradeable.sol";

contract TTVIP is Upgradeable{
    SmartContractFactory factory;
    AccountService accountService;
    ContractService contractService;
    TransactionService transactionService;

    function TTVIP(address config_addr){
        factory=new SmartContractFactory(config_addr);
        refresh();
    }

    //签署事件
    event Signed(address indexed firstParty, address indexed secondParty, uint indexed txHash);

    //交易事件
    event Transformed(address indexed from, address indexed to, uint indexed txHash);

    //签署合约
    function signContract(address secondParty,uint8 shareProfit,uint8 expireYear,uint160 txHash,string remark) public{
        contractService.signContract(msg.sender,secondParty,shareProfit,expireYear,txHash,timestamp,state,remark);
    }

    //确认合约
    function confirmContract()public{

    }

    //用户获取合约签署列表
    function getContracts()public view returns(uint160[6][]) {

    }

    //根据ID交易记录详情
    function getConrtactDetail(uint160 txHash) public view returns(address,address,uint8,uint8,uint160,uint64,string){

    }

    //发起交易
    function transform(address to,uint64 amount,uint160 txHash,string remark) public whenNotPaused{

    }

    //给账户加款
    function addFund(address to,uint160 txHash,uint64 amount,string remark) public whenNotPaused() onlyAdmin() returns(address touser,uint balance){

    }

    //根据发送人或者接收人查看交易记录
    function getTransactions(address to) public view returns(uint160[5][]){

    }

    //根据ID交易记录详情
    function getTransactionDetail(uint160 txHash) public view returns(uint160,address,address,uint64,uint64,string){

    }

    //获取账户信息
    function getAccountInfo() public view returns(uint16 status,uint64 balance,uint128 userid){

    }

    function refresh() public{
        accountService=factory.getAccountService();
        contractService=factory.getContractService();
        transactionService=factory.getTransactionService();
    }
}
