pragma solidity ^0.4.2;
import "../core/Config.sol";
import "../service/AccountService.sol";
import "../service/ContractService.sol";
import "../service/TransactionService.sol";

contract SmartContractFactory{
    address config_addr;
    Config config;

    function getAccountService() public returns (AccountService service){
        address addr=config.getCurrentVersion("AccountService");
        service =AccountService(addr);
        return service;
    }

    function getContractService() public returns (ContractService service){
        address addr=config.getCurrentVersion("ContractService");
        service =ContractService(addr);
        return service;
    }

    function getTransactionService() public returns (TransactionService service){
        address addr=config.getCurrentVersion("AccountService");
        service =TransactionService(addr);
        return service;
    }


}