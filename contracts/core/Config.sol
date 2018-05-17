pragma solidity ^0.4.2;

contract Config{
    address owner;

    struct Version{
    //合约实例名称
    string  name;
    //版本
    uint32  ver;
    //部署地址
    address publish_addr;
    }

    //合约历史版本
    mapping(string=>Version[])  preVersions;

    //合约最新版本号
    mapping(string=>uint32) lastVersionNum;

    //合约当前发布地址
    mapping(string=>address)  curVersion;

    //管理员账户列表
    mapping(address=>bool) admins;

    function Config(){
        owner=msg.sender;
        setAdmin(msg.sender,true);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender]);
        _;
    }

    function publishNewVersion(string name,address publish_addr)public   returns(bool){
        uint32 ver_num=lastVersionNum[name];
        ver_num++;
        lastVersionNum[name]=ver_num;
        preVersions[name].push(Version(name,ver_num,publish_addr));
        setCurrentVersion(name,publish_addr);
    }

    function addVersion(string name,address publish_addr)public  returns(bool){
        uint32 ver_num=lastVersionNum[name];
        ver_num++;
        lastVersionNum[name]=ver_num;
        preVersions[name].push(Version(name,ver_num,publish_addr));
        return true;
    }

    function getVersionInfo(string name,uint32 ver_num)public view  returns(string,uint32,address){
        Version[] memory vers=preVersions[name];
        for(uint i=0;i<vers.length;i++){
            Version memory v=vers[i];
            if(v.ver==ver_num){
                return (v.name,v.ver,v.publish_addr);
            }
        }
    }

    function setCurrentVersion(string name,address pub_addr)public  returns(bool){
        curVersion[name]=pub_addr;
        return true;
    }

    function getCurrentVersion(string name)public view returns(address){
        return curVersion[name];
    }

    function setAdmin(address addr,bool isAdmin)public  onlyOwner{
        admins[addr]=isAdmin;
    }

    function isAdmin(address addr)public view returns(bool){
        return admins[addr];
    }

}