pragma solidity ^0.4.2;
import "./Config.sol";
import "./TTVIP.sol";

contract TTVIPManage {

    TTVIP ttvip;
    Config config;

    function TTVIPManage(address config_addr,address tt_addr) public{
        ttvip=TTVIP(config_addr);
        config=Config(tt_addr);
    }


    modifier onlyAdmin() {
        require(config.isAdmin(msg.sender));
        _;
    }

    //发布新版本
    function publish(string con_name,string ver_num,address pub_addr)public  returns(bool){
        config.publishNewVersion(con_name,pub_addr);
        pause();
        //更新发布地址，调用TTIVP的refresh更新合约实例
        ttvip.refresh();
        unpause();
    }

    //回滚
    function rollback(string con_name,uint32 ver_num)public  returns(bool){
        var(name,ver,addr)= config.getVersionInfo(con_name,ver_num);
        config.setCurrentVersion(con_name,addr);
        pause();
        //更新发布地址，调用TTIVP的refresh更新合约实例
        ttvip.refresh();
        unpause();
    }


    function pause() internal {

        AccountService(config.getCurrentVersion("AccountService")).pause();
        ContractService(config.getCurrentVersion("ContractService")).pause();
        TransactionService(config.getCurrentVersion("TransactionService")).pause();
    }

    function unpause()internal {
        AccountService(config.getCurrentVersion("AccountService")).unpause();
        ContractService(config.getCurrentVersion("ContractService")).unpause();
        TransactionService(config.getCurrentVersion("TransactionService")).unpause();
    }
}
