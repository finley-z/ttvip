pragma solidity ^0.4.2;
import "./Configurable.sol";

contract AccountService is Configurable{

    //初始化，创建数据合约实例
    function init(){

    }

    function  register(){

    }

    function getAccount(){

    }

    //将地址、用户名转换成bytes20
    function getAccountList() returns(byte20[2]){
        bytes20(msg.sender);
    }

    function updateBalance(){

    }
}