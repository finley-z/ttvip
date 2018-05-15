pragma solidity ^0.4.2;

import "../data/CustomerContract.sol";
import "./Configurable.sol";

contract ContractService is Configurable{
    CustomerContract data;

    //构造函数
    function ContractService()public{
        address addr=config.getCurrentVersion("CustomerContract");
        data=CustomerContract(addr);
    }

    //签署合约
    function signContract(address firstParty,address secondParty, uint32 shareProfit, uint32 expireYear, uint160 txHash, uint64 timestamp,uint32 state,string remark) public {
         data.addContract(firstParty, secondParty, shareProfit, expireYear, txHash, timestamp, state,remark);
    }

    //确认合约
    function confirmContract( uint160 txHash, uint32 state) public {
        var (firstParty,secondParty,shareProfit,expireYear,_txHash,timestamp,_state,remark)=data.getContractByTxHash(txHash);
        if(msg.sender!=secondParty){
            throw;
        }else{
            data.updateContract(txHash,state);
        }
    }

    //获取合同内容列表
    function getContractList(address user_addr,uint128 start,uint128 rows) constant  returns (uint160[6][]) {
        bool isAdmin=config.isAdmin(user_addr);
        uint160[6][] memory temp = new uint160[6][](rows);
        for (uint i = 0; i <rows; i++) {
            var (firstParty,secondParty,txHash,timestamp,state,_start,total)=data.getContractForPaging(user_addr,start,isAdmin);
            temp[i] = [uint160(firstParty),uint160(secondParty),txHash,timestamp,uint160(state),total];
            start=_start;
        }
        return temp;
    }

    //根据ID交易记录详情
    function getContractDetail(uint160 txHash) public view returns(address,address,uint32,uint32,uint160,uint64,uint32,string){
        return data.getContractByTxHash(txHash);
    }

}