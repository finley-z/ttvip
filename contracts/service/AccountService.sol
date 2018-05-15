pragma solidity ^0.4.2;
import "./Configurable.sol";

contract AccountService is Configurable{
    CustomerAccount data;

    //构造函数
    function ContractService()public{
        address addr=config.getCurrentVersion("CustomerAccount");
        require(addr!=address(0));
        data=CustomerAccount(addr);
    }

    function register(uint128 userId,string userName,uint64 balance){
        data.register(userId,userName,balance);
    }

    function getAccount(address addr) public returns(address,uint128,string,uint32,uint128){
        return data.getAccount(addr);
    }


    function getBalance(address addr)returns(uint128){
        return data.getBalance(addr);
    }

    //将地址、用户名转换成bytes20
    function getAccountList() returns(byte20[2]){
        return data.getAccountList();
    }


}