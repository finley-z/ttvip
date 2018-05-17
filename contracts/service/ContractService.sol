pragma solidity ^0.4.2;

import "../data/CustomerContract.sol";
import "./Configurable.sol";
import "../lifecycle/Upgradeable.sol";
contract ContractService is Configurable,Upgradeable{
    CustomerContract data;
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
    function ContractService( )public{

    }

    //签署合约
    function signContract(address firstParty,address secondParty, uint32 shareProfit, uint32 expireYear, uint160 txHash, uint64 timestamp,CustomerContract.ContractState state,string remark) public {
        data.addContract(firstParty, secondParty, shareProfit, expireYear, txHash, timestamp, state,remark);
    }

    //确认合约
    function confirmContract( uint160 txHash, CustomerContract.ContractState state) public {
        var (firstParty,secondParty,shareProfit,expireYear,_txHash,timestamp,_state,remark)=data.getContractByTxHash(txHash);
        require(tx.origin==secondParty&&_state==CustomerContract.ContractState.CREATED);
        data.updateContract(txHash,state);
    }

    //获取合同内容列表
    function getContractList(uint128 start,uint128 rows,CustomerContract.ContractState state)public  view  returns (uint160[6][]) {
        uint128 total=data.countContractForPaging(msg.sender,config.isAdmin(msg.sender),state);
        uint160[6][] memory temp = new uint160[6][](rows);
        for (uint i = 0; i <rows; i++) {
            var (firstParty,secondParty,txHash,timestamp,_state,_start)=data.getContractForPaging(msg.sender,start,config.isAdmin(msg.sender),state);
            temp[i] = [uint160(firstParty),uint160(secondParty),txHash,timestamp,uint160(_state),total];
            start=_start;
        }
        return temp;
    }

    //根据ID交易记录详情
    function getContractDetail(uint160 txHash) public view returns(address,address,uint32,uint32,uint160,uint64,CustomerContract.ContractState,string){
        return data.getContractByTxHash(txHash);
    }

    function init(address _config){
        config=Config(_config);
        address addr=config.getCurrentVersion("CustomerContract");
        require(addr!=address(0));
        data=CustomerContract(addr);
        inited=true;
    }

}