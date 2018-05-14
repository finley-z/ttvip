pragma solidity ^0.4.2;

contract Config{

    struct Version{
        //合约实例名称
        string  name;
        //版本
        string  ver;
        //部署地址
        address publish_addr;
    }

    //合约历史版本
    mapping(string=>Version[])  preVersions;

    //合约当前发布地址
    mapping(string=>address)  curVersion;


    function addVersion(string name,string ves_num,address publish_addr)public{

    }

    function getVersionInfo(string name,string ver_num){

    }

    function setCurrentVersion(string name,address pub_addr){

    }

    function getCurrentVersion(string name){

    }



}