// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import '@forge-std/Script.sol';
import {DeployBase} from './DeployBase.sol';
import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

contract DeployAllScript is DeployBase, Script {
    function run() external {
        uint deployerPrivateKey = vm.envUint('PRIVATE_KEY');
        vm.startBroadcast(deployerPrivateKey);
        // deploy contracts
        _deploy();
        console2.log('ProxyAdmin:', address(proxyAdmin));
        console2.log('AccessControlManager:', address(accessControlManager));
        console2.log('Config:', address(config));
        console2.log('IncentiveCalculator:', address(incentiveCalculator));
        console2.log('InitCore:', address(initCore));
        console2.log('PositionManager:', address(positionManager));
        console2.log('InitOracle:', address(initOracle));
        console2.log('Api3OracleReader:', address(api3OracleReader));
        console2.log('PythOracleReader:', address(pythOracleReader));
        console2.log('WrapCenter:', address(wrapCenter));
        console2.log('MockWlpUniV2:', address(mockWLpUniV2));
        console2.log('RiskManager:', address(riskManager));

        // set up
        _setConfigs();
        console2.log('DoubleSlopeIRM:', address(doubleSlopeIRM));
        for (uint i = 0; i < poolConfigs.length; ++i) {
            address lendingPool = address(lendingPools[poolConfigs[i].underlyingToken]);
            string memory symbol = IERC20Metadata(lendingPool).name();
            console2.log(string.concat('LendingPool', symbol, ': '), lendingPool);
            // console2.log('isMode1AllowBorrow', config.isAllowedForBorrow(1, lendingPool));
            // console2.log('isMode2AllowBorrow', config.isAllowedForBorrow(2, lendingPool));
            // console2.log('isMode1AllowCollateral', config.isAllowedForCollateral(1, lendingPool));
            // console2.log('isMode1AllowCollateral', config.isAllowedForCollateral(2, lendingPool));
        }
        console2.log('CORE', riskManager.CORE());

        vm.stopBroadcast();
    }
}
