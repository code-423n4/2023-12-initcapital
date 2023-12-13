// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import 'forge-std/Test.sol';

import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {DeployBase} from '../../script/DeployBase.sol';

contract DeployAll is DeployBase, Test {
    // RPCs
    string private constant MANTLE_RPC_URL = 'https://rpc.mantle.xyz';
    string private constant ANVIL_RPC_URL = 'http://localhost:8545';
    uint private mantleFork;
    uint private anvilFork;

    function setUp() public virtual {
        mantleFork = vm.createFork(MANTLE_RPC_URL);
        anvilFork = vm.createFork(ANVIL_RPC_URL);
        vm.selectFork(anvilFork);
        // vm.selectFork(mantleFork);
        startHoax(ADMIN);
        _deploy();
        _setConfigs();
        vm.stopPrank();
    }

    function _setUpLiquidity() internal {
        // provide liquidity to lending pools
        for (uint i = 0; i < poolConfigs.length; ++i) {
            // NOTE: ignore USDY pool for now
            if (poolConfigs[i].underlyingToken == USDY) continue;
            address lendingPool = address(lendingPools[poolConfigs[i].underlyingToken]);
            IERC20Metadata underlyingToken = IERC20Metadata(poolConfigs[i].underlyingToken);
            // init liquidity 1m$ to each pool
            uint amount = _priceToTokenAmt(poolConfigs[i].underlyingToken, 1_000_000);
            deal(poolConfigs[i].underlyingToken, address(this), amount);
            underlyingToken.transfer(lendingPool, amount);
            initCore.mintTo(lendingPool, address(1));
        }
    }

    function _priceToTokenAmt(address token, uint usd) internal view returns (uint tokenAmt) {
        // get price from init oracle
        // convert usd to token amount
        tokenAmt = (usd * 1e36) / initOracle.getPrice_e36(token);
    }

    // -------------------- Tests ------------------------
    // function testLogAddress() public view {
    //     console2.log('ProxyAdmin:', address(proxyAdmin));
    //     console2.log('AccessControlManager:', address(accessControlManager));
    //     console2.log('Config:', address(config));
    //     console2.log('IncentiveCalculator:', address(incentiveCalculator));
    //     console2.log('InitCore:', address(initCore));
    //     console2.log('PositionManager:', address(positionManager));
    //     console2.log('InitOracle:', address(initOracle));
    //     console2.log('Api3OracleReader:', address(api3OracleReader));
    //     console2.log('PythOracleReader:', address(pythOracleReader));
    //     console2.log('WrapCenter:', address(wrapCenter));
    //     console2.log('MockWlpUniV2:', address(mockWLpUniV2));
    //     console2.log('MockSwapStrat:', address(mockSwapStrat));
    //     console2.log('FixedRateIRM:', address(fixedRateIRM));
    //     for (uint i = 0; i < poolConfigs.length; ++i) {
    //         address lendingPool = address(lendingPools[poolConfigs[i].underlyingToken]);
    //         string memory symbol = IERC20Metadata(lendingPool).name();
    //         console2.log(string.concat('LendingPool', symbol, ': '), lendingPool);
    //     }
    // }
}
