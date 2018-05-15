pragma solidity ^0.4.2;
pragma experimental ABIEncoderV2;

import "../lifecycle/SmartContractFactory.sol";
import "../lifecycle/AccountService.sol";
import "../lifecycle/ContractService.sol";
import "../lifecycle/TransactionService.sol";
import "../lifecycle/TTVIPUpgradeable.sol";

contract TTVIP is Upgradeable{
    SmartContractFactory factory;
    AccountService accountService;
    ContractService contractService;
    TransactionService transactionService;

    //签署事件
    event Signed(address indexed firstParty, address indexed secondParty, uint indexed txHash);

    //交易事件
    event Transformed(address indexed from, address indexed to, uint indexed txHash);

    //签署合约
    function signContract(address secondParty,uint8 shareProfit,uint8 expireYear,uint160 txHash,string remark) public{

    }

    //确认合约
    function confirmContract(){

    }

    //用户获取合约签署列表
    function getContracts()public  view returns(uint160[6][]) {

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


    }
}
