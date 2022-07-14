pragma solidity >=0.5.0;

import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm{
    //All code goes here....
    string public name = "Dapp Token Farm";

    DappToken public dappToken;
    DaiToken public daiToken;
    address public owner;

    address [] public stakers;

    mapping (address => uint) public stakingBalance;

    mapping (address => bool) public hasStaked;

    mapping (address => bool) public isStaking;

    constructor(DappToken _dappToken , DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    //1. Staking Tokens. (Deposit)
    function stakeTokens(uint _amount) public {

        // Require amount greater than 0
        
        require(_amount > 0 , "amount cannot be 0");

        // Transfer Mock Dai Tokens to this contract for staking.

        daiToken.transferFrom(msg.sender, address(this), _amount); 

        // Update a staking balance.

        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // Add user to stakers array *only* if they haven't staked already.

        if (!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        //Update staking status.

        hasStaked[msg.sender] = true;

        isStaking[msg.sender] = true;
    }

    // 2. issuing Tokens. (Earning Interest)
    function issueTokens() public {

        // Only owner can call this function.

        require(msg.sender == owner , "caller must be the owner");

        // Issue tokens to all stakers.

        for (uint i = 0 ; i<stakers.length ; i++){
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if (balance > 0){
                dappToken.transfer(recipient, balance);
            }
        }
    }

    // 3. Unstaking Tokens. (Withdraw)
    function unstakeTokens () public {
        // Fetch staking balance.
        uint balance = stakingBalance[msg.sender];

        // Require amount must be greater than 0.
        require(balance > 0 , "staking balance cannot be 0. / Insufficient balancel.");

        // Transfer Mock Dai tokens to this contract for staking.
        daiToken.transfer(msg.sender, balance);

        // Reset staking balance.
        stakingBalance[msg.sender] = 0;

        // Updating staking status.
        isStaking[msg.sender] = false;
    }
    
}