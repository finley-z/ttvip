pragma solidity ^0.4.2;
import "../core/Config.sol";
contract Configurable{
    Config internal config;

    function setConfigInstance(Config _config)internal{
        config=_config;
    }
}