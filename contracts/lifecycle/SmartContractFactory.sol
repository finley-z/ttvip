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
        //校验地址的正确性
        require(addr!=address(0));

        service =AccountService(addr);
        service.setConfigInstance(config);
        return service;
    }

    function getContractService() public returns (ContractService service){
        address addr=config.getCurrentVersion("ContractService");
        require(addr!=address(0));

        service =ContractService(addr);
        service.setConfigInstance(config);
        return service;
    }

    function getTransactionService() public returns (TransactionService service){
        address addr=config.getCurrentVersion("AccountService");
        require(addr!=address(0));

        service =TransactionService(addr);
        service.setConfigInstance(config);
        return service;
    }
}