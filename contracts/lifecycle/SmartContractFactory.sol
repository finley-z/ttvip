pragma solidity ^0.4.2;
import "../core/Config.sol";
import "../service/AccountService.sol";
import "../service/ContractService.sol";
import "../service/TransactionService.sol";

contract SmartContractFactory{
    Config config;
    address config_address;

    function SmartContractFactory(address _config_address)public payable{
        config=Config(_config_address);
        config_address=_config_address;
    }

    function getAccountService() public returns (AccountService service){
        address addr=config.getCurrentVersion("AccountService");
        //校验地址的正确性
        if(addr!=address(0)){
            service =AccountService(addr);
            service.init(config_address);
        }else{
            service =new AccountService();
            service.init(config_address);
            address publish_addr=address(service);
            config.publishNewVersion("AccountService", publish_addr);
        }

        return service;
    }

    function getContractService() public returns (ContractService service){
        address addr=config.getCurrentVersion("ContractService");
        if(addr!=address(0)){
            service =ContractService(addr);
            service.init(config_address);
        }else{
            service =new ContractService();
            service.init(config_address);
            address publish_addr=address(service);
            config.publishNewVersion("ContractService", publish_addr);
        }
        return service;
    }

    function getTransactionService() public returns (TransactionService service){
        address addr=config.getCurrentVersion("TransactionService");
        if(addr!=address(0)){
            service =TransactionService(addr);
            service.init(config_address);
        }else{
            service =new TransactionService();
            service.init(config_address);
            address publish_addr=address(service);
            config.publishNewVersion("TransactionService", publish_addr);
        }
        return service;
    }
}