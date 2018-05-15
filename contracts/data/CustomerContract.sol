pragma solidity ^0.4.2;

contract CustomerContract {
    enum ContractState{
        CREATED,
        CONFIRMED,
        EFFECTED,
        CLOSED
    }

    //合同内容
    struct CustomerContract{
        address firstParty;      //甲方地址
        address secondParty;     //乙方地址
        uint32 shareProfit;       //分润点 0-100 %
        uint32 expireYear;        //有效时间  N 年
        uint160 txHash;          //交易哈希值
        uint64 timestamp;        //交易时间戳
        ContractState state;     //签署状态
        string remark;           //备注
    }

    //合约内容列表
    CustomerContract[] public contracts;

    //合约的序号
    mapping (address => uint64) public cnounces;

    //数据索引
    mapping (uint160 => uint) public indexs;

    //签署合约
    function addContract(address firstParty,address secondParty, uint32 shareProfit, uint32 expireYear, uint160 txHash, uint64 timestamp,ContractState state,string remark) public {
        CustomerContract memory con = CustomerContract(firstParty, secondParty, shareProfit, expireYear, txHash, timestamp, state,remark);
        uint index=contracts.length;
        indexs[txHash]=index;
        contracts.push(con);
        cnounces[msg.sender]++;
        cnounces[secondParty]++;
    }

    //更新合约状态
    function updateContract(uint160 txHash,ContractState state)public{
        uint index=indexs[txHash];
        contracts[index].state=state;
    }

    //按分页获取合同内容
    function getContractForPaging(address useraddress,uint128 start,bool isAdmin)public view  returns (address,address,uint160,uint64,uint32,uint128,uint128) {
        // bool isAdmin=config.isAdmin(useraddress);
        uint128 total = uint128((isAdmin? contracts.length : cnounces[useraddress]));
        for (; start < total; start++) {
            CustomerContract memory t = contracts[start];
            if (isAdmin) {
                return (t.firstParty,t.secondParty,t.txHash,t.timestamp,uint32(t.state),start,total);
            }
            else {
                if (contracts[start].firstParty == useraddress || contracts[start].secondParty == useraddress) {
                    return (t.firstParty,t.secondParty,t.txHash,t.timestamp,uint32(t.state),start,total);
                }
            }
        }
    }

    //根据ID查询交易记录详情
    function getContractByTxHash(uint160 txHash) public view returns(address,address,uint32,uint32,uint160,uint64,string){
        //校验数据是否存在
        uint index=indexs[txHash];
        return getContractDetail(index);
    }

    function getContractDetail(uint index) public view returns(address,address,uint32,uint32,uint160,uint64,string){
        CustomerContract memory t=contracts[index];
        return(t.firstParty,t.secondParty,t.shareProfit,t.expireYear,t.txHash,t.timestamp,t.remark);
    }
}
