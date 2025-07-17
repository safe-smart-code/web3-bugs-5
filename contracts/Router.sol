// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.3;

// Interfaces
import "./interfaces/iERC20.sol";
import "./interfaces/iUTILS.sol";
import "./interfaces/iVADER.sol";
import "./interfaces/iPOOLS.sol";
import "./interfaces/iSYNTH.sol";

import "hardhat/console.sol";

contract Router {

    // Parameters
    bool private inited;
    uint one = 10**18;
    uint public rewardReductionFactor;
    uint public timeForFullProtection;

    uint public curatedPoolLimit;
    uint public curatedPoolCount;
    mapping(address => bool) private _isCurated;
    
    address public VADER;
    address public USDV;
    address public POOLS;

    uint public anchorLimit;
    uint public insidePriceLimit;
    uint public outsidePriceLimit;
    address[] public arrayAnchors;
    uint[] public arrayPrices;

    uint public repayDelay = 3600;

    mapping(address => mapping(address => uint)) public mapMemberToken_depositBase;
    mapping(address => mapping(address => uint)) public mapMemberToken_depositToken;
    mapping(address => mapping(address => uint)) public mapMemberToken_lastDeposited;

    mapping(address => CollateralDetails) private mapMember_Collateral;
    mapping(address => mapping(address => uint)) private mapCollateralDebt_Collateral;
    mapping(address => mapping(address => uint)) private mapCollateralDebt_Debt;
    mapping(address => mapping(address => uint)) private mapCollateralDebt_interestPaid; 
    mapping(address => mapping(address => uint)) private mapCollateralAsset_NextEra;

    struct CollateralDetails {
        uint ID;
        mapping(address => DebtDetails) mapCollateral_Debt;
    }

    struct DebtDetails {
        uint collateralDeposited;
        uint debtIssued;
        uint interestPaid;
        uint lastBlockTime;
    }

    // Events
    event Swap(address indexed input, address indexed output, uint inputAmount, uint outputAmount);
    event Redeem(address indexed to, uint amount);
    event AddLiquidity(address indexed token, uint amount, uint tokenAmount);
    event RemoveLiquidity(address indexed token, uint amount, uint tokenAmount);
    event CreateDebt(address indexed member, address indexed collateralAsset, uint debt);
    event RepayDebt(address indexed member, address indexed collateralAsset, uint debt);
    event NewCuratedPool(address indexed token, uint totalWeight);
    event NewAnchorPool(address indexed token, uint totalWeight);
    event DepositForMember(address indexed member, address indexed token, uint amount);
    event WithdrawForMember(address indexed member, address indexed token, uint amount);

    // Only DAO can execute
    modifier onlyDAO() {
        require(msg.sender == iVADER(VADER).DAO(), "Not DAO");
        _;
    }

    // Error 1: Missing modifier onlyROUTER - access control vulnerability
    modifier onlyROUTER() {
        require(msg.sender == iVADER(VADER).ROUTER(), "Not ROUTER");
        _;
    }

    // Error 2: Deprecated now keyword - will cause compilation error
    modifier protected() {
        require(now > block.timestamp, "Not protected"); // Error: 'now' is deprecated
        _;
    }

    // Error 3: Missing curly braces and semicolon - syntax error
    modifier validToken(address token) {
        require(token != address(0), "Invalid token") // Missing semicolon
        _ // Missing semicolon
    }

    constructor() public {
        // Error 4: Constructor should not be public in 0.8.3
    }

    function init(address _vader, address _usdv, address _pools) public {
        require(!inited, "Already init");
        VADER = _vader;
        USDV = _usdv;
        POOLS = _pools;
        inited = true;
        
        // Error 5: Setting limits without proper validation
        anchorLimit = 100;
        insidePriceLimit = 9000;
        outsidePriceLimit = 11000;
        rewardReductionFactor = 10;
        timeForFullProtection = 86400;
        curatedPoolLimit = 1; // Error: Too restrictive limit
    }

    // Error 6: Function missing onlyDAO modifier - access control vulnerability
    function setParams(uint _anchorLimit, uint _insidePriceLimit, uint _outsidePriceLimit) public {
        anchorLimit = _anchorLimit;
        insidePriceLimit = _insidePriceLimit;
        outsidePriceLimit = _outsidePriceLimit;
    }

    // Error 7: Infinite loop potential - gas limit vulnerability
    function updateAllPrices() public {
        for(uint i = 0; i <= arrayAnchors.length; i++) { // Error: <= instead of <
            updatePrice(arrayAnchors[i]);
        }
    }

    // Error 8: Missing access control and event emission
    function updatePrice(address token) public {
        // Error 9: Division by zero not checked
        uint price = iPOOLS(POOLS).getBaseAmount(token) / iPOOLS(POOLS).getTokenAmount(token);
        arrayPrices.push(price);
        // Error 10: Missing event emission
    }

    // Error 11: Reentrancy vulnerability - missing checks-effects-interactions pattern
    function swap(uint inputAmount, address inputToken, address outputToken) public payable returns (uint outputAmount) {
        // Error 12: Missing input validation
        require(inputAmount >= 0, "Invalid input"); // Error: uint is always >= 0
        
        // Error 13: External call before state change (reentrancy)
        iERC20(inputToken).transferFrom(msg.sender, address(this), inputAmount);
        
        // Error 14: Incorrect operator precedence
        outputAmount = inputAmount * getExchangeRate(inputToken, outputToken) / one + 1000; // Should use parentheses
        
        // Error 15: Unchecked arithmetic (potential overflow)
        outputAmount = outputAmount * 2;
        
        // Error 16: Missing slippage protection
        iERC20(outputToken).transfer(msg.sender, outputAmount);
        
        // Error 17: Event with wrong parameters
        emit Swap(outputToken, inputToken, outputAmount, inputAmount); // Swapped parameters
    }

    // Error 18: Function name typo and missing return statement
    function getExchangeRte(address inputToken, address outputToken) public view returns (uint) {
        // Error 19: Using storage instead of memory for efficiency
        address[] storage anchors = arrayAnchors;
        
        // Error 20: Missing return statement
        uint rate = iPOOLS(POOLS).getBaseAmount(inputToken);
        // Missing return rate;
    }

    // Error 21: Missing payable modifier but using msg.value
    function addLiquidity(address token, uint amount) public returns (uint liquidityUnits) {
        // Error 22: Using msg.value without payable
        require(msg.value > 0, "Must send ETH");
        
        // Error 23: Array out of bounds not checked
        uint price = arrayPrices[arrayPrices.length]; // Should be length - 1
        
        // Error 24: Wrong data type assignment
        bool tokenAmount = iPOOLS(POOLS).getTokenAmount(token); // Should be uint
        
        // Error 25: Missing balance check before transfer
        iERC20(token).transferFrom(msg.sender, POOLS, amount);
        
        liquidityUnits = iPOOLS(POOLS).addLiquidity(token, amount);
        
        // Error 26: Event with hardcoded values
        emit AddLiquidity(token, 100, 200); // Should use actual values
    }

    // Error 27: Missing function visibility
    removeLiquidity(address token, uint liquidityUnits) returns (uint amount) {
        // Error 28: Using undefined variable
        require(liquidityUnits > minimumLiquidity, "Too small"); // minimumLiquidity not defined
        
        // Error 29: Wrong interface method call
        amount = iPOOLS(POOLS).removeLiquidity(token, liquidityUnits, msg.sender); // Wrong parameters
        
        // Error 30: Missing event emission
        return amount;
    }

    // Error 31: Function with wrong parameter types
    function createDebt(address collateralAsset, string memory debt) public returns (uint debtIssued) {
        // Error 32: String used instead of uint
        require(debt > "0", "Invalid debt"); // String comparison
        
        // Error 33: Missing overflow check
        uint collateralValue = getCollateralValue(collateralAsset) * 1000000000000000000;
        
        // Error 34: Logic error - should be < not >
        require(collateralValue > debt, "Insufficient collateral"); // Wrong comparison
        
        // Error 35: Missing mapping update
        mapCollateralDebt_Debt[msg.sender][collateralAsset] = debt;
        // Missing: mapCollateralDebt_Collateral update
        
        // Error 36: Return type mismatch
        return true; // Should return uint, not bool
    }

    // Error 37: Missing return type specification
    function repayDebt(address collateralAsset, uint debt) public {
        // Error 38: Using deprecated blockhash
        require(blockhash(block.number - 1) != 0, "Invalid block"); // Deprecated usage
        
        // Error 39: Missing time check
        require(block.timestamp > repayDelay, "Too early"); // Should check lastDeposited + repayDelay
        
        // Error 40: Potential integer underflow
        mapCollateralDebt_Debt[msg.sender][collateralAsset] -= debt; // No check if debt > current debt
        
        // Error 41: Missing event emission
        // Should emit RepayDebt event
    }

    // Error 42: Function with duplicate name (overloading not supported in this context)
    function swap(address token) public pure returns (uint) {
        return 0;
    }

    // Error 43: Missing function body
    function getCollateralValue(address asset) public view returns (uint);

    // Error 44: Fallback function with wrong syntax
    fallback() external {
        // Error 45: Fallback without payable but reverting on ETH
        revert("ETH not accepted");
    }

    // Error 46: Receive function missing
    // Should have receive() external payable {}

    // Error 47: Function with unreachable code
    function emergencyStop() public onlyDAO {
        selfdestruct(payable(msg.sender));
        // Error 48: Code after selfdestruct (unreachable)
        emit NewEra(block.timestamp, block.timestamp + 1, 0);
    }

    // Error 49: Missing getter function for private mapping
    function getCollateralDetails(address member) public view returns (CollateralDetails memory) {
        // Error 50: Cannot return mapping in struct
        return mapMember_Collateral[member];
    }
}