pragma solidity ^0.4.2;


contract CustomerAccount {

    //用户资金账户
    struct Account {
        uint128 userId;         //用户ID
        string userName;        //用户名字
        uint32 status;          //账户状态
        uint128 balance;         //余额  精确至分 换算成元  balance/100;
    }

    //资金账户数据
    mapping (address => Account) public  accounts;

    function getAccount(){

    }

    function register(uint128 userId,string userName,uint64 balance){
        //注意各种校验

    }

    function updateBalance(address addr,uint128 amount){
        //
        accounts[addr].balance+=amount;
    }

    function getBalance(address addr)returns(uint128){
        return accounts[addr].balance;
    }
    //将地址、用户名转换成bytes20
    function getAccountList() returns(byte20[2]){
        bytes20(msg.sender);
    }

}
