pragma solidity ^0.4.2;
pragma experimental ABIEncoderV2;

import "./Configurable.sol";
import "../data/CustomerAccount.sol";
import "../lifecycle/Upgradeable.sol";
contract AccountService is Upgradeable{
    CustomerAccount data;
    Config public config;
    bool public inited=false;


    modifier whenInited() {
        require(inited);
        _;
    }

    //构造函数
    function AccountService() public{

    }

    function register(uint128 userId,string userName,uint64 balance){
        data.register(userId,userName,balance);
    }

    function getAccount(address addr) public view returns(address,uint128,string,uint32,uint128){
        return data.getAccount(addr);
    }


    function getBalance(address addr)public view returns(uint128){
        return data.getBalance(addr);
    }

    //将地址、用户名转换成bytes20
    function getAccountList()public view  returns(bytes20[],string[]){
        return data.getAccountList();
    }

    function init(address _config){
        config=Config(_config);
        address addr=config.getCurrentVersion("CustomerAccount");
        require(addr!=address(0));
        data=CustomerAccount(addr);
        inited=true;
    }
}