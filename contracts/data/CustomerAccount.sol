pragma solidity ^0.4.2;


contract CustomerAccount {

    //用户资金账户
    struct Account {
        uint128 userId;         //用户ID
        string userName;        //用户名字
        uint32 status;          //账户状态
        uint64 balance;         //余额  精确至分 换算成元  balance/100;
    }

    //资金账户数据
    mapping (address => Account) public  accounts;


}
