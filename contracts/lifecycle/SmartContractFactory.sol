pragma solidity ^0.4.2;
import "../service/AccountService.sol";
import "../service/ContractService.sol";
import "../service/TransactionService.sol";

contract SmartContractFactory{

    function newPurchase(Listing listing, address _buyer) public returns (Purchase purchase){
        purchase = new Purchase(listing, _buyer);
    }
}