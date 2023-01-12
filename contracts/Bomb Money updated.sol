pragma solidity >0.5.16;

contract InvestmentDashboard {

struct website {
    string websitename;
    address websiteaddress;
    uint256 KycCount;
    bool CanAddCustomer;
    bool KycPrivilege;
}
struct Customer {
    string Customername;
    string CustomerData;
    address Customerwebsite;
    bool KycStatus;
}

mapping (address => website) websites;
mapping (string => Customer) CustomerInfo;

function AddNewwebsite(string memory _websiteName, address _Address) public{
    websites[_Address] = website(_websiteName,_Address,0,true,true);
}

function BlockwebsiteFromKyc (address _websiteAddress) public {
    websites[_websiteAddress].KycPrivilege=false;
}

function AllowwebsiteFromKyc (address _websiteAddress) public{
    websites[_websiteAddress].KycPrivilege=true;
}

function BlockwebsiteFromAddingNewCustomers (address _websiteAddress) public{
    websites[_websiteAddress].CanAddCustomer=false;
}

function AllowBlockwebsiteFromAddingNewCustomers (address _websiteAddress) public {
    
    websites[_websiteAddress].CanAddCustomer=true;
}

function AddNewCustomerTowebsite(string memory _CustomerName, string memory _CustomerData, address _Customerwebsite) public{
   require(!websites[_Customerwebsite].CanAddCustomer,"The website doesnt have permission to add customers");
   CustomerInfo[_CustomerName] =Customer(_CustomerName,_CustomerData,_Customerwebsite,false); 
}

function AddNewCustomerRequestforKyc(string memory _CustomerName, address _Customerwebsite) public{
    require(!websites[_Customerwebsite].KycPrivilege, "The website doesnt have permission to perform KYC for the customers");
    CustomerInfo[_CustomerName].KycStatus =true;
}    

function ViewCustomerData (string memory _CustomerName) public view returns (string memory, address,bool) {
    return(CustomerInfo[_CustomerName].CustomerData, CustomerInfo[_CustomerName].Customerwebsite,CustomerInfo[_CustomerName].KycStatus);
}
}