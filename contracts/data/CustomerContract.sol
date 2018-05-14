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

    Content[] public contracts;
    //合约的序号
    mapping (address => uint64) public cnounces;
    //签署事件
    event Signed(address indexed firstParty, address indexed secondParty, uint indexed txHash);

    //签署合约
    function signContract(address secondParty, uint8 shareProfit, uint8 expireYear, uint160 txHash, string remark) public {
        var timestamp = uint64(now);
        Content memory con = Content(msg.sender, secondParty, shareProfit, expireYear, txHash, timestamp, remark);
        contracts.push(con);
        // contents[msg.sender].push(con);
        // contentLength++;
        cnounces[msg.sender]++;
        cnounces[secondParty]++;
        Signed(msg.sender, secondParty, timestamp);
    }

    //获取合同内容列表
    function getContractsInternal(address useraddress) constant internal returns (uint160[6][]) {
        var length = (useraddress == admin ? contracts.length : cnounces[useraddress]);
        uint160[6][] memory temp = new uint160[6][](length);
        uint index = 0;
        for (uint64 i = 0; i < contracts.length; i++) {
            if (useraddress == admin) {
                temp[i] = [uint160(contracts[i].firstParty), uint160(contracts[i].secondParty), contracts[i].shareProfit, contracts[i].expireYear, contracts[i].txHash, contracts[i].timestamp];
            }
            else {
                if (contracts[i].firstParty == useraddress || contracts[i].secondParty == useraddress) {
                    temp[index] = [uint160(contracts[i].firstParty), uint160(contracts[i].secondParty), contracts[i].shareProfit, contracts[i].expireYear, contracts[i].txHash, contracts[i].timestamp];
                    index++;
                }
            }
        }
        return temp;
    }

    //用户获取合约签署列表
    function getContracts() public view returns (uint160[6][]) {
        return getContractsInternal(msg.sender);
    }

    //根据ID交易记录详情
    function getConrtactDetail(uint160 txHash) public view returns(address,address,uint8,uint8,uint160,uint64,string){
        for (uint64 i = 0; i < contracts.length; i++) {
            Content t=contracts[i];
            if(t.txHash==txHash){
                return(t.firstParty,t.secondParty,t.shareProfit,t.expireYear,t.txHash,t.timestamp,t.remark);
            }

        }
        return (0,0,0,0,0,0,"");
    }
}
