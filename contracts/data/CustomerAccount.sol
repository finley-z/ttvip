pragma solidity ^0.4.2;
pragma experimental ABIEncoderV2;

contract CustomerAccount {

    //用户资金账户
    struct Account {
    address userAddr;
    uint128 userId;         //用户ID
    string userName;        //用户名字
    uint32 status;          //账户状态  1正常，0禁用
    uint128 balance;         //余额  精确至分 换算成元  balance/100;
    }

    //资金账户数据
    mapping (address => Account) public  accounts;
    address[] account_keys;

    function getAccount(address addr) public  view  returns(address,uint128,string,uint32,uint128){
        Account memory acc= accounts[addr];
        return (acc.userAddr,acc.userId,acc.userName,acc.status,acc.balance);
    }

    function register(uint128 userId,string userName,uint64 balance){
        //注意各种校验
        address user_addr=tx.origin;
        Account memory acc=accounts[user_addr];
        require(acc.userId==0);
        Account memory newAcc=Account(user_addr,userId,userName,1,balance);
        accounts[user_addr]=newAcc;
        account_keys.push(user_addr);
    }

    function updateBalance(address addr,uint128 amount){
        //
        accounts[addr].balance+=amount;
    }

    function getBalance(address addr)public  view  returns(uint128){
        return accounts[addr].balance;
    }
    //将地址、用户名转换成bytes20
    function getAccountList()public  view  returns(bytes20[],string[]){
        bytes20[] memory addrs = new bytes20[](account_keys.length);
        string[] memory names = new string[](account_keys.length);
        for (uint i = 0; i <account_keys.length; i++) {
            addrs[i] =bytes20(accounts[account_keys[i]].userAddr);
            names[i]=accounts[account_keys[i]].userName;
        }
        return (addrs,names);
    }

}