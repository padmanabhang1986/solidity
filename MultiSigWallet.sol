// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract MultiSigWallet{
    uint minApprovers;

    address beneficiary;
    address owner;

    mapping (address => bool) approvedBy;
    mapping (address => bool) isApprover;
    uint approvalsNum;

    constructor(
        address[] memory _approvers,
        uint _minApprovers,
        address _beneficiary
    ) payable {

        require(_minApprovers <= _approvers.length,
                                "Required number of approvers should be less than number of approvers");
        
        minApprovers = _minApprovers;
        beneficiary = _beneficiary;
        owner = msg.sender;

        for(uint i=0;i<_approvers.length;i++){
            address approver = _approvers[i];
            isApprover[approver] = true;
        }
    }

    function approve() public payable{
        require(isApprover[msg.sender],"Not a valid approver");
        if(!approvedBy[msg.sender]){
            approvedBy[msg.sender] = true;
            approvalsNum++;
        }
        
        if(approvalsNum == minApprovers){
            payable(beneficiary).transfer(address(this).balance);
            //selfdestruct(payable(owner));
        }
       
    }

    function reject() public{
        require(isApprover[msg.sender],"Not a valid approver");
        selfdestruct(payable(owner));
    }
}
