pragma solidity ^0.4.2;
import "../core/Config.sol";
import "../service/AccountService.sol";
import "../service/ContractService.sol";
import "../service/TransactionService.sol";

contract SmartContractFactory{
    Config config;

    function SmartContractFactory(address config_addr){
        config=Config(config_addr);
    }

    function getAccountService() public returns (AccountService service){
        address addr=config.getCurrentVersion("AccountService");
        service =AccountService(addr);
        service.setConfigInstance(config);
        return service;
    }

    function getContractService() public returns (ContractService service){
        address addr=config.getCurrentVersion("ContractService");
        service =ContractService(addr);
        service.setConfigInstance(config);
    return service;
    }

    function getTransactionService() public returns (TransactionService service){
        address addr=config.getCurrentVersion("AccountService");
        service =TransactionService(addr);
        service.setConfigInstance(config);
        return service;
    }


}