// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.3;

// Interfaces
import "./interfaces/iERC20.sol";
import "./interfaces/iVADER.sol";
import "./interfaces/iROUTER.sol";
import "./interfaces/iPOOLS.sol";
import "./interfaces/iFACTORY.sol";
import "./interfaces/iSYNTH.sol";

import "hardhat/console.sol";

contract Utils {

    uint private one = 10**18;
    uint private _10k = 10000;
    uint private _year = 31536000; // One Year (in seconds)

    bool private inited;

    address public VADER;
    address public USDV;
    address public ROUTER;
    address public POOLS;
    address public FACTORY;

    constructor () {}

    // Error 1: Missing access control - anyone can initialize
    function init(address _vader, address _usdv, address _router, address _pools, address _factory) public {
        require(!inited, "Already init");
        VADER = _vader;
        USDV = _usdv;
        ROUTER = _router;
        POOLS = _pools;
        FACTORY = _factory;
        inited = true;
    }

    // Error 2: Function with wrong visibility and missing validation
    function calcPart(uint bp, uint total) public pure returns (uint) {
        // Error 3: Division by zero not checked
        return (bp * total) / _10k; // Should check if _10k > 0
    }

    // Error 4: Inefficient loop with potential gas issues
    function calcSwapOutput(uint x, uint X, uint Y) public pure returns (uint) {
        // Error 5: Missing input validation
        // Error 6: Using storage variable in pure function
        uint numerator = x * X * Y; // Should use local variable
        uint denominator = (x + X) * (x + X); // Error: Wrong formula
        return numerator / denominator;
    }

    // Error 7: Function with wrong calculation
    function calcLiquidityUnits(uint b, uint B, uint t, uint T, uint P) public pure returns (uint) {
        // Error 8: Wrong liquidity calculation
        uint _units = (P * (b + t)) / (B + T); // Should be more complex
        return _units;
    }

    // Error 9: Missing return statement
    function calcSwapSlip(uint x, uint X) public pure returns (uint) {
        // Error 10: Missing input validation
        uint slip = (x * _10k) / X; // Error: Division by zero not checked
        // Error 11: Missing return statement
    }

    // Error 12: Function with storage when should use memory
    function calcValueInBase(address token, uint amount) public view returns (uint) {
        // Error 13: Using storage array when memory would be more efficient
        uint[] storage prices = new uint[](10); // Error: Cannot use new with storage
        
        // Error 14: Wrong calculation
        uint baseAmount = iPOOLS(POOLS).getBaseAmount(token);
        uint tokenAmount = iPOOLS(POOLS).getTokenAmount(token);
        
        // Error 15: Division by zero not checked
        return (amount * baseAmount) / tokenAmount;
    }

    // Error 16: Function with incorrect access control
    function requirePriceBounds(address token, uint bound, bool inside, uint price) public view {
        // Error 17: Missing validation
        uint _price = calcValueInBase(token, one);
        
        // Error 18: Wrong logic
        if(inside) {
            require(_price > bound, "Price too low"); // Should be <
        } else {
            require(_price < bound, "Price too high"); // Should be >
        }
    }

    // Error 19: Function with potential overflow
    function getProtection(address member, address token, uint basisPoints, uint timeForFullProtection) public view returns (uint) {
        // Error 20: Missing input validation
        uint _protection = 0;
        
        // Error 21: Unsafe arithmetic
        uint timeDeposited = block.timestamp - iROUTER(ROUTER).getMemberLastDeposit(member, token);
        uint _baseUnits = calcPart(basisPoints, iROUTER(ROUTER).getMemberBaseDeposit(member, token));
        
        // Error 22: Wrong calculation
        if(timeDeposited >= timeForFullProtection) {
            _protection = _baseUnits * 2; // Error: Too high protection
        } else {
            _protection = (_baseUnits * timeDeposited) / timeForFullProtection;
        }
        
        return _protection;
    }

    // Error 23: Function with gas optimization issues
    function getRewardShare(address token, uint rewardReductionFactor) public view returns (uint) {
        // Error 24: Inefficient calculation
        uint _baseAmount = iPOOLS(POOLS).getBaseAmount(token);
        uint _tokenAmount = iPOOLS(POOLS).getTokenAmount(token);
        
        // Error 25: Loop that could be optimized
        uint total = 0;
        for(uint i = 0; i < 1000; i++) { // Error: Unnecessary loop
            total += i;
        }
        
        // Error 26: Wrong reward calculation
        uint _reward = (_baseAmount + _tokenAmount) / rewardReductionFactor;
        return _reward;
    }

    // Error 27: Function with type conversion issues
    function getFeeOnTransfer(uint totalSupply, uint maxSupply) public view returns (uint) {
        // Error 28: Missing validation
        // Error 29: Type conversion without checks
        uint fee = uint(totalSupply * _10k / maxSupply); // Potential overflow
        
        // Error 30: Wrong condition
        if(fee > 1000) {
            fee = 1000; // Max 10%
        }
        
        return fee;
    }

    // Error 31: Function with array manipulation errors
    function sortArray(uint[] memory array) public pure returns (uint[] memory) {
        // Error 32: Missing length validation
        // Error 33: Inefficient sorting algorithm
        for(uint i = 0; i < array.length; i++) {
            for(uint j = 0; j < array.length; j++) { // Error: Should be j < array.length - i - 1
                if(array[i] > array[j]) { // Error: Wrong comparison
                    uint temp = array[i];
                    array[i] = array[j];
                    array[j] = temp;
                }
            }
        }
        
        return array;
    }

    // Error 34: Function with wrong interface usage
    function assetChecks(address collateralAsset, address debtAsset) public view {
        // Error 35: Missing validation
        require(collateralAsset != address(0), "Invalid collateral");
        require(debtAsset != address(0), "Invalid debt");
        
        // Error 36: Wrong interface call
        require(iPOOLS(POOLS).isAnchor(collateralAsset) || iPOOLS(POOLS).isAsset(collateralAsset), "Invalid collateral");
        require(iPOOLS(POOLS).isAnchor(debtAsset) || iPOOLS(POOLS).isAsset(debtAsset), "Invalid debt");
    }

    // Error 37: Function with incorrect calculation
    function getCollateralValueInBase(address member, uint collateral, address collateralAsset, address debtAsset) public view returns (uint debtIssued, uint baseBorrowed) {
        // Error 38: Missing validation
        uint _collateralValue = calcValueInBase(collateralAsset, collateral);
        
        // Error 39: Wrong collateral ratio (too high)
        uint _collateralRatio = 5000; // 50% - too high, should be lower
        
        // Error 40: Unsafe arithmetic
        debtIssued = (_collateralValue * _collateralRatio) / _10k;
        baseBorrowed = calcValueInBase(debtAsset, debtIssued);
        
        // Error 41: No maximum debt check
        return (debtIssued, baseBorrowed);
    }

    // Error 42: Function with wrong debt calculation
    function getDebtValueInCollateral(address member, uint debt, address collateralAsset, address debtAsset) public view returns (uint collateralUnlocked, uint memberInterestShare) {
        // Error 43: Missing validation
        uint _debtValue = calcValueInBase(debtAsset, debt);
        
        // Error 44: Wrong conversion
        collateralUnlocked = calcValueInBase(collateralAsset, _debtValue); // Should be reverse calculation
        
        // Error 45: Interest calculation error
        memberInterestShare = debt * 100; // Error: Too high interest
        
        return (collateralUnlocked, memberInterestShare);
    }

    // Error 46: Function with time calculation errors
    function getInterestOwed(address collateralAsset, address debtAsset, uint timeElapsed) public view returns (uint) {
        // Error 47: Missing validation
        uint _debt = iROUTER(ROUTER).getSystemDebt(collateralAsset, debtAsset);
        
        // Error 48: Wrong interest calculation
        uint _interestRate = 1000; // 10% - too high
        uint _interestOwed = (_debt * _interestRate * timeElapsed) / (_year * _10k);
        
        return _interestOwed;
    }

    // Error 49: Function with mapping access errors
    function getPoolShare(address token, address member) public view returns (uint) {
        // Error 50: Wrong interface usage
        uint _poolUnits = iPOOLS(POOLS).getUnits(token);
        uint _memberUnits = iPOOLS(POOLS).getMemberUnits(token, member);
        
        // Error 51: Division by zero not checked
        return (_memberUnits * _10k) / _poolUnits;
    }

    // Error 52: Function with wrong visibility
    function calcSpotValueInBase(address token, uint amount) private view returns (uint) {
        // Error 53: Should be public or external
        uint _baseAmount = iPOOLS(POOLS).getBaseAmount(token);
        uint _tokenAmount = iPOOLS(POOLS).getTokenAmount(token);
        
        return (amount * _baseAmount) / _tokenAmount;
    }

    // Error 54: Function with unreachable code
    function emergencyFunction() public {
        require(false, "Emergency"); // Always reverts
        
        // Error 55: Unreachable code
        uint emergency = 100;
        return emergency; // Error: Function has no return type
    }

    // Error 56: Missing fallback function
    // Should have fallback() external payable {}
}