pragma solidity ^0.4.2;
import "./Config.sol";
import "./TTVIP.sol";

contract TTVIPManage {
    //配置合约地址
    address config_addr;

    TTVIP ttvip;
    Config config;

    function TTVIPManage(address config_addr,tt_addr){
        ttvip=TTVIP(config_addr);
        config=Config(tt_addr);
    }


    modifier onlyAdmin() {
        require(config.isAdmin(msg.sender));
        _;
    }

    //发布新版本
    function publish(string con_name,string ver_num,address pub_addr)public onlyAdmin returns(bool){
        config.publishNewVersion(con_name,pub_addr);
        pause();
        //更新发布地址，调用TTIVP的refresh更新合约实例
        ttvip.refresh();
        unpause();
    }

    //回滚
    function rollback(string con_name,string ver_num)public onlyAdmin returns(bool){
        config.setCurrentVersion(con_name,pub_addr);
        pause();
        //更新发布地址，调用TTIVP的refresh更新合约实例
        ttvip.refresh();
        unpause();
    }


    function pause() internal onlyAdmin{
        AccountService(config.getCurrentVersion("AccountService")).pause();
        ContractService(config.getCurrentVersion("ContractService")).pause();
        TransactionService(config.getCurrentVersion("TransactionService")).pause();
    }

    function unpause()internal onlyAdmin{
        AccountService(config.getCurrentVersion("AccountService")).unpause();
        ContractService(config.getCurrentVersion("ContractService")).unpause();
        TransactionService(config.getCurrentVersion("TransactionService")).unpause();
    }
}
