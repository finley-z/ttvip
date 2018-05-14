pragma solidity ^0.4.2;
import "./Config.sol";
contract TTVIPManage {
    address owner;
    //配置合约地址
    address config_addr;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //发布新版本
    function publish(string con_name,string ver_num,address pub_addr)public onlyOwner returns(bool){
        //更新发布地址，更新合约实例
    }

    //回滚
    function rollback(string con_name,string ver_num)public onlyOwner returns(bool){

    }

    //创建数据合约实例
    function  createDataContracts(){

    }
}
