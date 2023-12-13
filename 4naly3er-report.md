# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Using bools for storage incurs overhead | 3 |
| [GAS-2](#GAS-2) | Cache array length outside of loop | 39 |
| [GAS-3](#GAS-3) | For Operations that will not overflow, you could use unchecked | 536 |
| [GAS-4](#GAS-4) | Functions guaranteed to revert when called by normal users can be marked `payable` | 31 |
| [GAS-5](#GAS-5) | `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too) | 1 |
| [GAS-6](#GAS-6) | Splitting require() statements that use && saves gas | 2 |
| [GAS-7](#GAS-7) | Use != 0 instead of > 0 for unsigned integer comparison | 10 |
### <a name="GAS-1"></a>[GAS-1] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (3)*:
```solidity
File: contracts/core/Config.sol

24:     mapping(address => bool) public whitelistedWLps; // @inheritdoc IConfig

```

```solidity
File: contracts/core/InitCore.sol

48:     bool internal isMulticallTx;

```

```solidity
File: contracts/core/PosManager.sol

39:     mapping(address => mapping(uint => bool)) public isCollateralized; // @inheritdoc IPosManager

```

### <a name="GAS-2"></a>[GAS-2] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (39)*:
```solidity
File: contracts/core/Config.sol

103:         for (uint i; i < _pools.length; i = i.uinc()) {

119:         for (uint i; i < _pools.length; i = i.uinc()) {

144:         for (uint i; i < _wLps.length; i = i.uinc()) {

```

```solidity
File: contracts/core/InitCore.sol

188:         for (uint i; i < pools.length; i = i.uinc()) {

191:         for (uint i; i < wLps.length; i = i.uinc()) {

192:             for (uint j; j < ids[i].length; j = j.uinc()) {

201:         for (uint i; i < pools.length; i = i.uinc()) {

365:         uint[] memory balanceBefores = new uint[](_pools.length);

368:         for (uint i; i < _pools.length; i = i.uinc()) {

382:         for (uint i; i < _pools.length; i = i.uinc()) {

396:         for (uint i; i < posIds.length; i = i.uinc()) {

459:         for (uint i; i < pools.length; i = i.uinc()) {

466:         for (uint i; i < wLps.length; i = i.uinc()) {

467:             for (uint j; j < ids[i].length; j = j.uinc()) {

485:         for (uint i; i < pools.length; i = i.uinc()) {

567:         for (uint i; i < _pools.length; i = i.uinc()) {

568:             for (uint j = i.uinc(); j < _pools.length; j = j.uinc()) {

```

```solidity
File: contracts/core/LiqIncentiveCalculator.sol

73:         for (uint i; i < _modes.length; i = i.uinc()) {

86:         for (uint i; i < _tokens.length; i = i.uinc()) {

104:         for (uint i; i < _modes.length; i = i.uinc()) {

```

```solidity
File: contracts/core/PosManager.sol

84:         for (uint i; i < pools.length; i = i.uinc()) {

115:         for (uint i; i < pools.length; i = i.uinc()) {

121:         for (uint i; i < wLps.length; i = i.uinc()) {

124:             for (uint j; j < ids[i].length; j = j.uinc()) {

260:             if (posCollInfo.ids[_wLp].length() == 0) {

298:         for (uint i; i < _tokens.length; i = i.uinc()) {

310:         for (uint i; i < tokens.length; i = i.uinc()) {

```

```solidity
File: contracts/hook/MoneyMarketHook.sol

71:         for (uint i; i < _params.withdrawParams.length; i = i.uinc()) {

149:         for (uint i; i < _params.length; i = i.uinc()) {

173:         for (uint i; i < _params.length; i = i.uinc()) {

210:         for (uint i; i < _params.length; i = i.uinc()) {

230:         for (uint i; i < _params.length; i = i.uinc()) {

```

```solidity
File: contracts/oracle/Api3OracleReader.sol

51:         for (uint i; i < _dataFeedIds.length; i = i.uinc()) {

67:         for (uint i; i < _maxStaleTimes.length; i = i.uinc()) {

```

```solidity
File: contracts/oracle/InitOracle.sol

83:         for (uint i; i < _tokens.length; i = i.uinc()) {

91:         for (uint i; i < _tokens.length; i = i.uinc()) {

100:         for (uint i; i < _tokens.length; i = i.uinc()) {

112:         for (uint i; i < _tokens.length; i = i.uinc()) {

```

```solidity
File: contracts/risk_manager/RiskManager.sol

86:         for (uint i; i < _pools.length; i = i.uinc()) {

```

### <a name="GAS-3"></a>[GAS-3] For Operations that will not overflow, you could use unchecked

*Instances (536)*:
```solidity
File: contracts/common/AccessControlManager.sol

4: import '@openzeppelin-contracts/access/AccessControlDefaultAdminRules.sol';

4: import '@openzeppelin-contracts/access/AccessControlDefaultAdminRules.sol';

4: import '@openzeppelin-contracts/access/AccessControlDefaultAdminRules.sol';

5: import {IAccessControlManager} from '../interfaces/common/IAccessControlManager.sol';

5: import {IAccessControlManager} from '../interfaces/common/IAccessControlManager.sol';

5: import {IAccessControlManager} from '../interfaces/common/IAccessControlManager.sol';

```

```solidity
File: contracts/common/UnderACM.sol

4: import {IAccessControlManager} from '../interfaces/common/IAccessControlManager.sol';

4: import {IAccessControlManager} from '../interfaces/common/IAccessControlManager.sol';

4: import {IAccessControlManager} from '../interfaces/common/IAccessControlManager.sol';

8:     IAccessControlManager public immutable ACM; // access control manager

8:     IAccessControlManager public immutable ACM; // access control manager

```

```solidity
File: contracts/common/library/UncheckedIncrement.sol

7:             return self + 1;

```

```solidity
File: contracts/core/Config.sol

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

5: import '../common/library/UncheckedIncrement.sol';

5: import '../common/library/UncheckedIncrement.sol';

5: import '../common/library/UncheckedIncrement.sol';

9: } from '../interfaces/core/IConfig.sol';

9: } from '../interfaces/core/IConfig.sol';

9: } from '../interfaces/core/IConfig.sol';

10: import {UnderACM} from '../common/UnderACM.sol';

10: import {UnderACM} from '../common/UnderACM.sol';

12: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

12: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

12: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

12: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

12: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

24:     mapping(address => bool) public whitelistedWLps; // @inheritdoc IConfig

24:     mapping(address => bool) public whitelistedWLps; // @inheritdoc IConfig

```

```solidity
File: contracts/core/InitCore.sol

4: import {Multicall} from '../common/Multicall.sol';

4: import {Multicall} from '../common/Multicall.sol';

5: import '../common/library/InitErrors.sol';

5: import '../common/library/InitErrors.sol';

5: import '../common/library/InitErrors.sol';

6: import '../common/library/UncheckedIncrement.sol';

6: import '../common/library/UncheckedIncrement.sol';

6: import '../common/library/UncheckedIncrement.sol';

7: import {UnderACM} from '../common/UnderACM.sol';

7: import {UnderACM} from '../common/UnderACM.sol';

9: import {IInitCore} from '../interfaces/core/IInitCore.sol';

9: import {IInitCore} from '../interfaces/core/IInitCore.sol';

9: import {IInitCore} from '../interfaces/core/IInitCore.sol';

10: import {IPosManager} from '../interfaces/core/IPosManager.sol';

10: import {IPosManager} from '../interfaces/core/IPosManager.sol';

10: import {IPosManager} from '../interfaces/core/IPosManager.sol';

11: import {ModeConfig, PoolConfig, TokenFactors, ModeStatus, IConfig} from '../interfaces/core/IConfig.sol';

11: import {ModeConfig, PoolConfig, TokenFactors, ModeStatus, IConfig} from '../interfaces/core/IConfig.sol';

11: import {ModeConfig, PoolConfig, TokenFactors, ModeStatus, IConfig} from '../interfaces/core/IConfig.sol';

12: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

12: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

12: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

13: import {IBaseWrapLp} from '../interfaces/wrapper/IBaseWrapLp.sol';

13: import {IBaseWrapLp} from '../interfaces/wrapper/IBaseWrapLp.sol';

13: import {IBaseWrapLp} from '../interfaces/wrapper/IBaseWrapLp.sol';

14: import {IInitOracle} from '../interfaces/oracle/IInitOracle.sol';

14: import {IInitOracle} from '../interfaces/oracle/IInitOracle.sol';

14: import {IInitOracle} from '../interfaces/oracle/IInitOracle.sol';

15: import {ILiqIncentiveCalculator} from '../interfaces/core/ILiqIncentiveCalculator.sol';

15: import {ILiqIncentiveCalculator} from '../interfaces/core/ILiqIncentiveCalculator.sol';

15: import {ILiqIncentiveCalculator} from '../interfaces/core/ILiqIncentiveCalculator.sol';

16: import {ICallbackReceiver} from '../interfaces/receiver/ICallbackReceiver.sol';

16: import {ICallbackReceiver} from '../interfaces/receiver/ICallbackReceiver.sol';

16: import {ICallbackReceiver} from '../interfaces/receiver/ICallbackReceiver.sol';

17: import {IFlashReceiver} from '../interfaces/receiver/IFlashReceiver.sol';

17: import {IFlashReceiver} from '../interfaces/receiver/IFlashReceiver.sol';

17: import {IFlashReceiver} from '../interfaces/receiver/IFlashReceiver.sol';

18: import {IRiskManager} from '../interfaces/risk_manager/IRiskManager.sol';

18: import {IRiskManager} from '../interfaces/risk_manager/IRiskManager.sol';

18: import {IRiskManager} from '../interfaces/risk_manager/IRiskManager.sol';

20: import {ReentrancyGuardUpgradeable} from '@openzeppelin-contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol';

20: import {ReentrancyGuardUpgradeable} from '@openzeppelin-contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol';

20: import {ReentrancyGuardUpgradeable} from '@openzeppelin-contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol';

20: import {ReentrancyGuardUpgradeable} from '@openzeppelin-contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol';

21: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

21: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

21: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

21: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

22: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

22: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

22: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

22: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

22: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

23: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

23: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

23: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

23: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

23: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

24: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

24: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

24: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

24: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

25: import {IERC721} from '@openzeppelin-contracts/token/ERC721/IERC721.sol';

25: import {IERC721} from '@openzeppelin-contracts/token/ERC721/IERC721.sol';

25: import {IERC721} from '@openzeppelin-contracts/token/ERC721/IERC721.sol';

25: import {IERC721} from '@openzeppelin-contracts/token/ERC721/IERC721.sol';

26: import {EnumerableSet} from '@openzeppelin-contracts/utils/structs/EnumerableSet.sol';

26: import {EnumerableSet} from '@openzeppelin-contracts/utils/structs/EnumerableSet.sol';

26: import {EnumerableSet} from '@openzeppelin-contracts/utils/structs/EnumerableSet.sol';

26: import {EnumerableSet} from '@openzeppelin-contracts/utils/structs/EnumerableSet.sol';

44:     address public config; // @inheritdoc IInitCore

44:     address public config; // @inheritdoc IInitCore

45:     address public oracle; // @inheritdoc IInitCore

45:     address public oracle; // @inheritdoc IInitCore

46:     address public liqIncentiveCalculator; // @inheritdoc IInitCore

46:     address public liqIncentiveCalculator; // @inheritdoc IInitCore

47:     address public riskManager; // @inheritdoc IInitCore

47:     address public riskManager; // @inheritdoc IInitCore

49:     EnumerableSet.UintSet internal uncheckedPosIds; // posIds that need to be checked after multicall

49:     EnumerableSet.UintSet internal uncheckedPosIds; // posIds that need to be checked after multicall

140:         _require(ILendingPool(_pool).totalDebt() + _amt <= poolConfig.borrowCap, Errors.BORROW_CAP_REACHED);

206:             _riskManager.updateModeDebtShares(currentMode, pools[i], -shares[i].toInt256());

290:         _require(vars.config.isAllowedForCollateral(vars.mode, _poolOut), Errors.TOKEN_NOT_WHITELISTED); // config and mode are already stored

290:         _require(vars.config.isAllowedForCollateral(vars.mode, _poolOut), Errors.TOKEN_NOT_WHITELISTED); // config and mode are already stored

296:         vars.repayAmtWithLiqIncentive = (vars.repayAmt * vars.liqIncentive_e18) / ONE_E18;

296:         vars.repayAmtWithLiqIncentive = (vars.repayAmt * vars.liqIncentive_e18) / ONE_E18;

298:             uint[] memory prices_e36; // prices = [repayTokenPrice, collToken]

298:             uint[] memory prices_e36; // prices = [repayTokenPrice, collToken]

303:             shares = ILendingPool(_poolOut).toShares((vars.repayAmtWithLiqIncentive * prices_e36[0]) / prices_e36[1]);

303:             shares = ILendingPool(_poolOut).toShares((vars.repayAmtWithLiqIncentive * prices_e36[0]) / prices_e36[1]);

305:             shares = shares.min(IPosManager(POS_MANAGER).getCollAmt(_posId, _poolOut)); // take min of what's available

305:             shares = shares.min(IPosManager(POS_MANAGER).getCollAmt(_posId, _poolOut)); // take min of what's available

327:         _require(vars.config.whitelistedWLps(_wLp), Errors.TOKEN_NOT_WHITELISTED); // config is already stored

327:         _require(vars.config.whitelistedWLps(_wLp), Errors.TOKEN_NOT_WHITELISTED); // config is already stored

334:         vars.repayAmtWithLiqIncentive = (vars.repayAmt * vars.liqIncentive_e18) / ONE_E18;

334:         vars.repayAmtWithLiqIncentive = (vars.repayAmt * vars.liqIncentive_e18) / ONE_E18;

375:             fees[i] = (_amts[i] * poolConfig.flashFee_e18).ceilDiv(ONE_E18); // round up

375:             fees[i] = (_amts[i] * poolConfig.flashFee_e18).ceilDiv(ONE_E18); // round up

375:             fees[i] = (_amts[i] * poolConfig.flashFee_e18).ceilDiv(ONE_E18); // round up

384:             _require(poolCash >= balanceBefores[i] + fees[i], Errors.INVALID_AMOUNT_TO_REPAY);

462:             uint tokenValue_e36 = ILendingPool(pools[i]).toAmtCurrent(shares[i]) * tokenPrice_e36;

464:             collCredit_e54 += tokenValue_e36 * factors.collFactor_e18;

464:             collCredit_e54 += tokenValue_e36 * factors.collFactor_e18;

469:                 uint wLpValue_e36 = amts[i][j] * wLpPrice_e36;

471:                 collCredit_e54 += wLpValue_e36 * factors.collFactor_e18;

471:                 collCredit_e54 += wLpValue_e36 * factors.collFactor_e18;

474:         collCredit_e36 = collCredit_e54 / ONE_E18;

489:             uint tokenValue_e36 = tokenPrice_e36 * ILendingPool(pools[i]).debtShareToAmtCurrent(debtShares[i]);

491:             borrowCredit_e54 += (tokenValue_e36 * factors.borrFactor_e18);

491:             borrowCredit_e54 += (tokenValue_e36 * factors.borrFactor_e18);

500:             ? (getCollateralCreditCurrent_e36(_posId) * ONE_E18) / borrowCredit_e36

500:             ? (getCollateralCreditCurrent_e36(_posId) * ONE_E18) / borrowCredit_e36

545:         IPosManager(POS_MANAGER).updatePosDebtShares(_posId, _pool, -sharesToRepay.toInt256());

549:         IRiskManager(riskManager).updateModeDebtShares(_mode, _pool, -sharesToRepay.toInt256());

```

```solidity
File: contracts/core/LiqIncentiveCalculator.sol

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

5: import {Errors} from '../common/library/InitErrors.sol';

5: import {Errors} from '../common/library/InitErrors.sol';

5: import {Errors} from '../common/library/InitErrors.sol';

6: import {LogExpMath} from '../common/library/LogExpMath.sol';

6: import {LogExpMath} from '../common/library/LogExpMath.sol';

6: import {LogExpMath} from '../common/library/LogExpMath.sol';

7: import {UncheckedIncrement} from '../common/library/UncheckedIncrement.sol';

7: import {UncheckedIncrement} from '../common/library/UncheckedIncrement.sol';

7: import {UncheckedIncrement} from '../common/library/UncheckedIncrement.sol';

8: import {UnderACM} from '../common/UnderACM.sol';

8: import {UnderACM} from '../common/UnderACM.sol';

9: import {ILiqIncentiveCalculator} from '../interfaces/core/ILiqIncentiveCalculator.sol';

9: import {ILiqIncentiveCalculator} from '../interfaces/core/ILiqIncentiveCalculator.sol';

9: import {ILiqIncentiveCalculator} from '../interfaces/core/ILiqIncentiveCalculator.sol';

11: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

11: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

11: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

11: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

11: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

12: import {Math} from '@openzeppelin-contracts/utils/math/Math.sol';

12: import {Math} from '@openzeppelin-contracts/utils/math/Math.sol';

12: import {Math} from '@openzeppelin-contracts/utils/math/Math.sol';

12: import {Math} from '@openzeppelin-contracts/utils/math/Math.sol';

22:     uint public maxLiqIncentiveMultiplier_e18; // @inheritdoc ILiqIncentiveCalculator

22:     uint public maxLiqIncentiveMultiplier_e18; // @inheritdoc ILiqIncentiveCalculator

23:     mapping(uint16 => uint) public modeLiqIncentiveMultiplier_e18; // @inheritdoc ILiqIncentiveCalculator

23:     mapping(uint16 => uint) public modeLiqIncentiveMultiplier_e18; // @inheritdoc ILiqIncentiveCalculator

24:     mapping(address => uint) public tokenLiqIncentiveMultiplier_e18; // @inheritdoc ILiqIncentiveCalculator

24:     mapping(address => uint) public tokenLiqIncentiveMultiplier_e18; // @inheritdoc ILiqIncentiveCalculator

25:     mapping(uint16 => uint) public minLiqIncentiveMultiplier_e18; // @inheritdoc ILiqIncentiveCalculator

25:     mapping(uint16 => uint) public minLiqIncentiveMultiplier_e18; // @inheritdoc ILiqIncentiveCalculator

60:         uint incentive_e18 = (ONE_E18 * ONE_E18) / _healthFactor_e18 - ONE_E18;

60:         uint incentive_e18 = (ONE_E18 * ONE_E18) / _healthFactor_e18 - ONE_E18;

60:         uint incentive_e18 = (ONE_E18 * ONE_E18) / _healthFactor_e18 - ONE_E18;

61:         incentive_e18 = (incentive_e18 * (modeLiqIncentiveMultiplier_e18[_mode] * maxTokenLiqIncentiveMultiplier_e18))

61:         incentive_e18 = (incentive_e18 * (modeLiqIncentiveMultiplier_e18[_mode] * maxTokenLiqIncentiveMultiplier_e18))

62:             / (ONE_E18 * ONE_E18);

62:             / (ONE_E18 * ONE_E18);

63:         multiplier_e18 = Math.min(ONE_E18 + incentive_e18, maxLiqIncentiveMultiplier_e18); // cap multiplier at max multiplier

63:         multiplier_e18 = Math.min(ONE_E18 + incentive_e18, maxLiqIncentiveMultiplier_e18); // cap multiplier at max multiplier

63:         multiplier_e18 = Math.min(ONE_E18 + incentive_e18, maxLiqIncentiveMultiplier_e18); // cap multiplier at max multiplier

64:         multiplier_e18 = Math.max(multiplier_e18, minLiqIncentiveMultiplier_e18[_mode]); // cap multiplier at min multiplier

64:         multiplier_e18 = Math.max(multiplier_e18, minLiqIncentiveMultiplier_e18[_mode]); // cap multiplier at min multiplier

```

```solidity
File: contracts/core/PosManager.sol

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

5: import '../common/library/UncheckedIncrement.sol';

5: import '../common/library/UncheckedIncrement.sol';

5: import '../common/library/UncheckedIncrement.sol';

6: import {IPosManager} from '../interfaces/core/IPosManager.sol';

6: import {IPosManager} from '../interfaces/core/IPosManager.sol';

6: import {IPosManager} from '../interfaces/core/IPosManager.sol';

7: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

7: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

7: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

8: import {IBaseWrapLp} from '../interfaces/wrapper/IBaseWrapLp.sol';

8: import {IBaseWrapLp} from '../interfaces/wrapper/IBaseWrapLp.sol';

8: import {IBaseWrapLp} from '../interfaces/wrapper/IBaseWrapLp.sol';

9: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

9: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

9: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

9: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

10: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

10: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

10: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

10: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

13:     '@openzeppelin-contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';

13:     '@openzeppelin-contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';

13:     '@openzeppelin-contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';

13:     '@openzeppelin-contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';

13:     '@openzeppelin-contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';

13:     '@openzeppelin-contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol';

15:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

15:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

15:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

15:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

15:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

15:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

16: import {EnumerableSet} from '@openzeppelin-contracts/utils/structs/EnumerableSet.sol';

16: import {EnumerableSet} from '@openzeppelin-contracts/utils/structs/EnumerableSet.sol';

16: import {EnumerableSet} from '@openzeppelin-contracts/utils/structs/EnumerableSet.sol';

16: import {EnumerableSet} from '@openzeppelin-contracts/utils/structs/EnumerableSet.sol';

17: import {UnderACM} from '../common/UnderACM.sol';

17: import {UnderACM} from '../common/UnderACM.sol';

31:     mapping(address => uint) public nextNonces; // @inheritdoc IPosManager

31:     mapping(address => uint) public nextNonces; // @inheritdoc IPosManager

37:     uint8 public maxCollCount; // limit number of collateral to avoid out of gas

37:     uint8 public maxCollCount; // limit number of collateral to avoid out of gas

38:     mapping(uint => mapping(address => uint)) public pendingRewards; // @inheritdoc IPosManager

38:     mapping(uint => mapping(address => uint)) public pendingRewards; // @inheritdoc IPosManager

39:     mapping(address => mapping(uint => bool)) public isCollateralized; // @inheritdoc IPosManager

39:     mapping(address => mapping(uint => bool)) public isCollateralized; // @inheritdoc IPosManager

176:         extraInfo.totalInterest += (debtAmtCurrent - extraInfo.lastDebtAmt).toUint128();

176:         extraInfo.totalInterest += (debtAmtCurrent - extraInfo.lastDebtAmt).toUint128();

177:         uint newDebtShares = (currDebtShares.toInt256() + _deltaShares).toUint256();

198:         amtIn = newBalance - __collBalances[_pool];

203:             uint8 collCount = posCollInfo.collCount + 1;

208:         posCollInfo.collAmts[_pool] = posBalance + amtIn;

221:             uint8 collCount = posCollInfo.collCount + 1;

237:         uint newPosCollAmt = posCollInfo.collAmts[_pool] - _shares;

240:             posCollInfo.collCount -= 1;

256:         uint newWLpAmt = IBaseWrapLp(_wLp).balanceOfLp(_tokenId) - _amt;

259:             posCollInfo.collCount -= 1;

272:         uint nonce = nextNonces[_owner]++;

272:         uint nonce = nextNonces[_owner]++;

311:             pendingRewards[_posId][tokens[i]] += amts[i];

```

```solidity
File: contracts/helper/rebase_helper/BaseRebaseHelper.sol

4: import '../../common/library/InitErrors.sol';

4: import '../../common/library/InitErrors.sol';

4: import '../../common/library/InitErrors.sol';

4: import '../../common/library/InitErrors.sol';

5: import '../../interfaces/helper/rebase_helper/IRebaseHelper.sol';

5: import '../../interfaces/helper/rebase_helper/IRebaseHelper.sol';

5: import '../../interfaces/helper/rebase_helper/IRebaseHelper.sol';

5: import '../../interfaces/helper/rebase_helper/IRebaseHelper.sol';

5: import '../../interfaces/helper/rebase_helper/IRebaseHelper.sol';

```

```solidity
File: contracts/helper/rebase_helper/mUSDUSDYHelper.sol

4: import './BaseRebaseHelper.sol';

5: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

5: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

5: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

5: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

6: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

6: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

6: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

6: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

6: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

7: import {IMUSD} from '../../interfaces/helper/rebase_helper/IMUSD.sol';

7: import {IMUSD} from '../../interfaces/helper/rebase_helper/IMUSD.sol';

7: import {IMUSD} from '../../interfaces/helper/rebase_helper/IMUSD.sol';

7: import {IMUSD} from '../../interfaces/helper/rebase_helper/IMUSD.sol';

7: import {IMUSD} from '../../interfaces/helper/rebase_helper/IMUSD.sol';

```

```solidity
File: contracts/hook/MoneyMarketHook.sol

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

5: import '../common/library/UncheckedIncrement.sol';

5: import '../common/library/UncheckedIncrement.sol';

5: import '../common/library/UncheckedIncrement.sol';

6: import {IInitCore} from '../interfaces/core/IInitCore.sol';

6: import {IInitCore} from '../interfaces/core/IInitCore.sol';

6: import {IInitCore} from '../interfaces/core/IInitCore.sol';

7: import {IMulticall} from '../interfaces/common/IMulticall.sol';

7: import {IMulticall} from '../interfaces/common/IMulticall.sol';

7: import {IMulticall} from '../interfaces/common/IMulticall.sol';

8: import {IPosManager} from '../interfaces/core/IPosManager.sol';

8: import {IPosManager} from '../interfaces/core/IPosManager.sol';

8: import {IPosManager} from '../interfaces/core/IPosManager.sol';

9: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

9: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

9: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

10: import {IWNative} from '../interfaces/common/IWNative.sol';

10: import {IWNative} from '../interfaces/common/IWNative.sol';

10: import {IWNative} from '../interfaces/common/IWNative.sol';

11: import {IRebaseHelper} from '../interfaces/helper/rebase_helper/IRebaseHelper.sol';

11: import {IRebaseHelper} from '../interfaces/helper/rebase_helper/IRebaseHelper.sol';

11: import {IRebaseHelper} from '../interfaces/helper/rebase_helper/IRebaseHelper.sol';

11: import {IRebaseHelper} from '../interfaces/helper/rebase_helper/IRebaseHelper.sol';

12: import {IMoneyMarketHook} from '../interfaces/hook/IMoneyMarketHook.sol';

12: import {IMoneyMarketHook} from '../interfaces/hook/IMoneyMarketHook.sol';

12: import {IMoneyMarketHook} from '../interfaces/hook/IMoneyMarketHook.sol';

14: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

14: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

14: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

14: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

15: import {IERC721} from '@openzeppelin-contracts/token/ERC721/IERC721.sol';

15: import {IERC721} from '@openzeppelin-contracts/token/ERC721/IERC721.sol';

15: import {IERC721} from '@openzeppelin-contracts/token/ERC721/IERC721.sol';

15: import {IERC721} from '@openzeppelin-contracts/token/ERC721/IERC721.sol';

16: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

16: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

16: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

16: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

16: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

18:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

18:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

18:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

18:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

18:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

18:     '@openzeppelin-contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol';

85:         posId = ++lastPosIds[msg.sender];

85:         posId = ++lastPosIds[msg.sender];

116:             uint dataLength = _params.repayParams.length + (2 * _params.withdrawParams.length) + (changeMode ? 1 : 0)

116:             uint dataLength = _params.repayParams.length + (2 * _params.withdrawParams.length) + (changeMode ? 1 : 0)

116:             uint dataLength = _params.repayParams.length + (2 * _params.withdrawParams.length) + (changeMode ? 1 : 0)

117:                 + _params.borrowParams.length + (2 * _params.depositParams.length);

117:                 + _params.borrowParams.length + (2 * _params.depositParams.length);

117:                 + _params.borrowParams.length + (2 * _params.depositParams.length);

```

```solidity
File: contracts/lending_pool/DoubleSlopeIRM.sol

4: import {IIRM} from '../interfaces/lending_pool/IIRM.sol';

4: import {IIRM} from '../interfaces/lending_pool/IIRM.sol';

4: import {IIRM} from '../interfaces/lending_pool/IIRM.sol';

5: import {Math} from '@openzeppelin-contracts/utils/math/Math.sol';

5: import {Math} from '@openzeppelin-contracts/utils/math/Math.sol';

5: import {Math} from '@openzeppelin-contracts/utils/math/Math.sol';

5: import {Math} from '@openzeppelin-contracts/utils/math/Math.sol';

12:     uint public immutable BASE_BORR_RATE_E18; // rate per second

12:     uint public immutable BASE_BORR_RATE_E18; // rate per second

13:     uint public immutable BORR_RATE_MULTIPLIER_E18; // m1

13:     uint public immutable BORR_RATE_MULTIPLIER_E18; // m1

14:     uint public immutable JUMP_UTIL_E18; // utilization at which the BORROW_RATE_M2 is applied

14:     uint public immutable JUMP_UTIL_E18; // utilization at which the BORROW_RATE_M2 is applied

15:     uint public immutable JUMP_MULTIPLIER_E18; // m2

15:     uint public immutable JUMP_MULTIPLIER_E18; // m2

35:         uint totalAsset = _cash + _debt;

36:         uint util_e18 = totalAsset == 0 ? 0 : (_debt * ONE_E18) / totalAsset;

36:         uint util_e18 = totalAsset == 0 ? 0 : (_debt * ONE_E18) / totalAsset;

37:         borrow_rate_e18 = BASE_BORR_RATE_E18 + (Math.min(util_e18, JUMP_UTIL_E18) * BORR_RATE_MULTIPLIER_E18) / ONE_E18;

37:         borrow_rate_e18 = BASE_BORR_RATE_E18 + (Math.min(util_e18, JUMP_UTIL_E18) * BORR_RATE_MULTIPLIER_E18) / ONE_E18;

37:         borrow_rate_e18 = BASE_BORR_RATE_E18 + (Math.min(util_e18, JUMP_UTIL_E18) * BORR_RATE_MULTIPLIER_E18) / ONE_E18;

39:             borrow_rate_e18 += ((util_e18 - JUMP_UTIL_E18) * JUMP_MULTIPLIER_E18) / ONE_E18;

39:             borrow_rate_e18 += ((util_e18 - JUMP_UTIL_E18) * JUMP_MULTIPLIER_E18) / ONE_E18;

39:             borrow_rate_e18 += ((util_e18 - JUMP_UTIL_E18) * JUMP_MULTIPLIER_E18) / ONE_E18;

39:             borrow_rate_e18 += ((util_e18 - JUMP_UTIL_E18) * JUMP_MULTIPLIER_E18) / ONE_E18;

```

```solidity
File: contracts/lending_pool/LendingPool.sol

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

5: import {UnderACM} from '../common/UnderACM.sol';

5: import {UnderACM} from '../common/UnderACM.sol';

6: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

6: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

6: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

7: import {IIRM} from '../interfaces/lending_pool/IIRM.sol';

7: import {IIRM} from '../interfaces/lending_pool/IIRM.sol';

7: import {IIRM} from '../interfaces/lending_pool/IIRM.sol';

9: import {ERC20Upgradeable} from '@openzeppelin-contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';

9: import {ERC20Upgradeable} from '@openzeppelin-contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';

9: import {ERC20Upgradeable} from '@openzeppelin-contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';

9: import {ERC20Upgradeable} from '@openzeppelin-contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';

9: import {ERC20Upgradeable} from '@openzeppelin-contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';

10: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

10: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

10: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

10: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

10: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

11: import {SafeERC20} from '@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol';

12: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

12: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

12: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

12: import {IERC20} from '@openzeppelin-contracts/token/ERC20/IERC20.sol';

13: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

13: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

13: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

13: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

13: import {MathUpgradeable} from '@openzeppelin-contracts-upgradeable/utils/math/MathUpgradeable.sol';

30:     address public underlyingToken; // underlying tokens

30:     address public underlyingToken; // underlying tokens

31:     uint public cash; // total cash

31:     uint public cash; // total cash

32:     uint public totalDebt; // total debt

32:     uint public totalDebt; // total debt

33:     uint public totalDebtShares; // total debt shares

33:     uint public totalDebtShares; // total debt shares

34:     address public irm; // interest rate model

34:     address public irm; // interest rate model

35:     uint public lastAccruedTime; // last accrued timestamp

35:     uint public lastAccruedTime; // last accrued timestamp

36:     uint public reserveFactor_e18; // reserve factor

36:     uint public reserveFactor_e18; // reserve factor

37:     address public treasury; // treasury address

37:     address public treasury; // treasury address

103:         uint amt = newCash - _cash;

104:         shares = _toShares(amt, _cash + totalDebt, totalSupply());

115:         amt = _toAmt(sharesToBurn, _cash + totalDebt, totalSupply());

118:             cash = _cash - amt;

129:         totalDebtShares += shares;

130:         totalDebt = _totalDebt + _amt;

131:         cash -= _amt;

141:         _require(amt <= newCash - cash, Errors.INVALID_AMOUNT_TO_REPAY);

142:         totalDebtShares = _totalDebtShares - _shares;

143:         totalDebt = _totalDebt > amt ? _totalDebt - amt : 0;

150:         _require(newCash >= cash, Errors.INVALID_AMOUNT_TO_REPAY); // flash not repay

150:         _require(newCash >= cash, Errors.INVALID_AMOUNT_TO_REPAY); // flash not repay

161:             uint accruedInterest = (borrowRate_e18 * (block.timestamp - _lastAccruedTime) * _totalDebt) / ONE_E18;

161:             uint accruedInterest = (borrowRate_e18 * (block.timestamp - _lastAccruedTime) * _totalDebt) / ONE_E18;

161:             uint accruedInterest = (borrowRate_e18 * (block.timestamp - _lastAccruedTime) * _totalDebt) / ONE_E18;

161:             uint accruedInterest = (borrowRate_e18 * (block.timestamp - _lastAccruedTime) * _totalDebt) / ONE_E18;

162:             uint reserve = (accruedInterest * reserveFactor_e18) / ONE_E18;

162:             uint reserve = (accruedInterest * reserveFactor_e18) / ONE_E18;

164:                 _mint(treasury, _toShares(reserve, _cash + _totalDebt + accruedInterest - reserve, totalSupply()));

164:                 _mint(treasury, _toShares(reserve, _cash + _totalDebt + accruedInterest - reserve, totalSupply()));

164:                 _mint(treasury, _toShares(reserve, _cash + _totalDebt + accruedInterest - reserve, totalSupply()));

166:             totalDebt = _totalDebt + accruedInterest;

217:         supplyRate_e18 = _cash + _totalDebt > 0

218:             ? (borrowRate_e18 * (ONE_E18 - reserveFactor_e18) * _totalDebt) / ((_cash + _totalDebt) * ONE_E18)

218:             ? (borrowRate_e18 * (ONE_E18 - reserveFactor_e18) * _totalDebt) / ((_cash + _totalDebt) * ONE_E18)

218:             ? (borrowRate_e18 * (ONE_E18 - reserveFactor_e18) * _totalDebt) / ((_cash + _totalDebt) * ONE_E18)

218:             ? (borrowRate_e18 * (ONE_E18 - reserveFactor_e18) * _totalDebt) / ((_cash + _totalDebt) * ONE_E18)

218:             ? (borrowRate_e18 * (ONE_E18 - reserveFactor_e18) * _totalDebt) / ((_cash + _totalDebt) * ONE_E18)

218:             ? (borrowRate_e18 * (ONE_E18 - reserveFactor_e18) * _totalDebt) / ((_cash + _totalDebt) * ONE_E18)

229:         return cash + totalDebt;

257:         return _amt.mulDiv(_totalShares + VIRTUAL_SHARES, _totalAssets + VIRTUAL_ASSETS);

257:         return _amt.mulDiv(_totalShares + VIRTUAL_SHARES, _totalAssets + VIRTUAL_ASSETS);

267:         return _shares.mulDiv(_totalAssets + VIRTUAL_ASSETS, _totalShares + VIRTUAL_SHARES);

267:         return _shares.mulDiv(_totalAssets + VIRTUAL_ASSETS, _totalShares + VIRTUAL_SHARES);

```

```solidity
File: contracts/oracle/Api3OracleReader.sol

4: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

4: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

4: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

4: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

5: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

5: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

5: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

5: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

5: import {IERC20Metadata} from '@openzeppelin-contracts/token/ERC20/extensions/IERC20Metadata.sol';

6: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

6: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

6: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

6: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

6: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

8: import '../common/library/InitErrors.sol';

8: import '../common/library/InitErrors.sol';

8: import '../common/library/InitErrors.sol';

9: import '../common/library/UncheckedIncrement.sol';

9: import '../common/library/UncheckedIncrement.sol';

9: import '../common/library/UncheckedIncrement.sol';

10: import {UnderACM} from '../common/UnderACM.sol';

10: import {UnderACM} from '../common/UnderACM.sol';

12: import {IApi3OracleReader, IBaseOracle} from '../interfaces/oracle/api3/IApi3OracleReader.sol';

12: import {IApi3OracleReader, IBaseOracle} from '../interfaces/oracle/api3/IApi3OracleReader.sol';

12: import {IApi3OracleReader, IBaseOracle} from '../interfaces/oracle/api3/IApi3OracleReader.sol';

12: import {IApi3OracleReader, IBaseOracle} from '../interfaces/oracle/api3/IApi3OracleReader.sol';

13: import {IApi3ServerV1} from '../interfaces/oracle/api3/IApi3ServerV1.sol';

13: import {IApi3ServerV1} from '../interfaces/oracle/api3/IApi3ServerV1.sol';

13: import {IApi3ServerV1} from '../interfaces/oracle/api3/IApi3ServerV1.sol';

13: import {IApi3ServerV1} from '../interfaces/oracle/api3/IApi3ServerV1.sol';

24:     address public api3ServerV1; // @inheritdoc IApi3OracleReader

24:     address public api3ServerV1; // @inheritdoc IApi3OracleReader

25:     mapping(address => DataFeedInfo) public dataFeedInfos; // @inheritdoc IApi3OracleReader

25:     mapping(address => DataFeedInfo) public dataFeedInfos; // @inheritdoc IApi3OracleReader

87:         _require(block.timestamp - timestamp <= dataFeedInfo.maxStaleTime, Errors.MAX_STALETIME_EXCEEDED);

90:         price_e36 = (price.toUint256() * ONE_E18) / 10 ** decimals;

90:         price_e36 = (price.toUint256() * ONE_E18) / 10 ** decimals;

90:         price_e36 = (price.toUint256() * ONE_E18) / 10 ** decimals;

90:         price_e36 = (price.toUint256() * ONE_E18) / 10 ** decimals;

```

```solidity
File: contracts/oracle/InitOracle.sol

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

4: import '../common/library/InitErrors.sol';

5: import '../common/library/UncheckedIncrement.sol';

5: import '../common/library/UncheckedIncrement.sol';

5: import '../common/library/UncheckedIncrement.sol';

7: import {UnderACM} from '../common/UnderACM.sol';

7: import {UnderACM} from '../common/UnderACM.sol';

9: import {IInitOracle, IBaseOracle} from '../interfaces/oracle/IInitOracle.sol';

9: import {IInitOracle, IBaseOracle} from '../interfaces/oracle/IInitOracle.sol';

9: import {IInitOracle, IBaseOracle} from '../interfaces/oracle/IInitOracle.sol';

10: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

10: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

10: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

10: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

10: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

20:     mapping(address => address) public primarySources; // @inheritdoc IInitOracle

20:     mapping(address => address) public primarySources; // @inheritdoc IInitOracle

21:     mapping(address => address) public secondarySources; // @inheritdoc IInitOracle

21:     mapping(address => address) public secondarySources; // @inheritdoc IInitOracle

22:     mapping(address => uint) public maxPriceDeviations_e18; // @inheritdoc IInitOracle

22:     mapping(address => uint) public maxPriceDeviations_e18; // @inheritdoc IInitOracle

74:                 (maxPrice_e36 * ONE_E18) / minPrice_e36 <= maxPriceDeviations_e18[_token], Errors.TOO_MUCH_DEVIATION

74:                 (maxPrice_e36 * ONE_E18) / minPrice_e36 <= maxPriceDeviations_e18[_token], Errors.TOO_MUCH_DEVIATION

```

```solidity
File: contracts/risk_manager/RiskManager.sol

4: import {IRiskManager} from '../interfaces/risk_manager/IRiskManager.sol';

4: import {IRiskManager} from '../interfaces/risk_manager/IRiskManager.sol';

4: import {IRiskManager} from '../interfaces/risk_manager/IRiskManager.sol';

5: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

5: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

5: import {ILendingPool} from '../interfaces/lending_pool/ILendingPool.sol';

6: import '../common/library/InitErrors.sol';

6: import '../common/library/InitErrors.sol';

6: import '../common/library/InitErrors.sol';

7: import '../common/library/UncheckedIncrement.sol';

7: import '../common/library/UncheckedIncrement.sol';

7: import '../common/library/UncheckedIncrement.sol';

8: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

8: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

8: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

8: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

8: import {Initializable} from '@openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol';

9: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

9: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

9: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

9: import {SafeCast} from '@openzeppelin-contracts/utils/math/SafeCast.sol';

10: import {UnderACM} from '../common/UnderACM.sol';

10: import {UnderACM} from '../common/UnderACM.sol';

22:     address public immutable CORE; // core address

22:     address public immutable CORE; // core address

72:         uint newDebtShares = (debtCeilingInfo.debtShares.toInt256() + _deltaShares).toUint256();

```

### <a name="GAS-4"></a>[GAS-4] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (31)*:
```solidity
File: contracts/core/Config.sol

90:     function setPoolConfig(address _pool, PoolConfig calldata _config) external onlyGuardian {

128:     function setModeStatus(uint16 _mode, ModeStatus calldata _status) external onlyGuardian {

135:     function setMaxHealthAfterLiq_e18(uint16 _mode, uint64 _maxHealthAfterLiq_e18) external onlyGuardian {

143:     function setWhitelistedWLps(address[] calldata _wLps, bool _status) external onlyGovernor {

```

```solidity
File: contracts/core/InitCore.sol

216:     function collateralize(uint _posId, address _pool) public virtual onlyAuthorized(_posId) nonReentrant {

406:     function setConfig(address _config) external onlyGovernor {

411:     function setOracle(address _oracle) external onlyGovernor {

416:     function setLiqIncentiveCalculator(address _liqIncentiveCalculator) external onlyGuardian {

421:     function setRiskManager(address _riskManager) external onlyGuardian {

```

```solidity
File: contracts/core/LiqIncentiveCalculator.sol

94:     function setMaxLiqIncentiveMultiplier_e18(uint _maxLiqIncentiveMultiplier_e18) external onlyGovernor {

```

```solidity
File: contracts/core/PosManager.sol

170:     function updatePosDebtShares(uint _posId, address _pool, int _deltaShares) external onlyCore {

190:     function updatePosMode(uint _posId, uint16 _mode) external onlyCore {

195:     function addCollateral(uint _posId, address _pool) external onlyCore returns (uint amtIn) {

213:     function addCollateralWLp(uint _posId, address _wLp, uint _tokenId) external onlyCore returns (uint amtIn) {

271:     function createPos(address _owner, uint16 _mode, address _viewer) external onlyCore returns (uint posId) {

321:     function setMaxCollCount(uint8 _maxCollCount) external onlyGuardian {

327:     function setPosViewer(uint _posId, address _viewer) external onlyAuthorized(_posId) {

```

```solidity
File: contracts/lending_pool/LendingPool.sol

100:     function mint(address _receiver) external onlyCore accrue returns (uint shares) {

111:     function burn(address _receiver) external onlyCore accrue returns (uint amt) {

125:     function borrow(address _receiver, uint _amt) external onlyCore accrue returns (uint shares) {

136:     function repay(uint _shares) external onlyCore accrue returns (uint amt) {

148:     function syncCash() external accrue onlyCore returns (uint newCash) {

233:     function setIrm(address _irm) external accrue onlyGuardian {

239:     function setReserveFactor_e18(uint _reserveFactor_e18) external accrue onlyGuardian {

245:     function setTreasury(address _treasury) external onlyGovernor {

```

```solidity
File: contracts/oracle/Api3OracleReader.sol

48:     function setDataFeedIds(address[] calldata _tokens, bytes32[] calldata _dataFeedIds) external onlyGovernor {

58:     function setApi3ServerV1(address _api3ServerV1) external onlyGovernor {

64:     function setMaxStaleTimes(address[] calldata _tokens, uint[] calldata _maxStaleTimes) external onlyGovernor {

```

```solidity
File: contracts/oracle/InitOracle.sol

89:     function setPrimarySources(address[] calldata _tokens, address[] calldata _sources) external onlyGovernor {

98:     function setSecondarySources(address[] calldata _tokens, address[] calldata _sources) external onlyGovernor {

```

```solidity
File: contracts/risk_manager/RiskManager.sol

70:     function updateModeDebtShares(uint16 _mode, address _pool, int _deltaShares) external onlyCore {

```

### <a name="GAS-5"></a>[GAS-5] `++i` costs less gas than `i++`, especially when it's used in `for`-loops (`--i`/`i--` too)
*Saves 5 gas per loop*

*Instances (1)*:
```solidity
File: contracts/core/PosManager.sol

272:         uint nonce = nextNonces[_owner]++;

```

### <a name="GAS-6"></a>[GAS-6] Splitting require() statements that use && saves gas

*Instances (2)*:
```solidity
File: contracts/core/InitCore.sol

132:         _require(poolConfig.canBorrow && _config.getModeStatus(mode).canBorrow, Errors.BORROW_PAUSED);

535:         _require(_config.getPoolConfig(_pool).canRepay && _config.getModeStatus(_mode).canRepay, Errors.REPAY_PAUSED);

```

### <a name="GAS-7"></a>[GAS-7] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (10)*:
```solidity
File: contracts/core/InitCore.sol

499:         health_e18 = borrowCredit_e36 > 0

```

```solidity
File: contracts/core/PosManager.sol

179:         uint newDebtAmt = ILendingPool(_pool).totalDebtShares() > 0

185:         if (newDebtShares > 0) __posBorrInfos[_posId].pools.add(_pool);

235:         _require(_shares > 0, Errors.ZERO_VALUE);

```

```solidity
File: contracts/lending_pool/LendingPool.sol

128:         shares = _totalDebt > 0 ? _amt.mulDiv(totalDebtShares, _totalDebt, MathUpgradeable.Rounding.Up) : _amt;

163:             if (reserve > 0) {

173:         shares = totalDebt > 0 ? _amt.mulDiv(totalDebtShares, totalDebt, MathUpgradeable.Rounding.Up) : _amt;

183:         amt = totalDebtShares > 0 ? _shares.mulDiv(totalDebt, totalDebtShares, MathUpgradeable.Rounding.Up) : 0;

217:         supplyRate_e18 = _cash + _totalDebt > 0

```

```solidity
File: contracts/risk_manager/RiskManager.sol

73:         if (_deltaShares > 0) {

```


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) |  `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()` | 1 |
| [L-2](#L-2) | Do not use deprecated library functions | 3 |
| [L-3](#L-3) | Empty Function Body - Consider commenting why | 7 |
| [L-4](#L-4) | Initializers could be front-run | 21 |
### <a name="L-1"></a>[L-1]  `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`
Use `abi.encode()` instead which will pad items to 32 bytes, which will [prevent hash collisions](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html#non-standard-packed-mode) (e.g. `abi.encodePacked(0x123,0x456)` => `0x123456` => `abi.encodePacked(0x1,0x23456)`, but `abi.encode(0x123,0x456)` => `0x0...1230...456`). "Unless there is a compelling reason, `abi.encode` should be preferred". If there is only one argument to `abi.encodePacked()` it can often be cast to `bytes()` or `bytes32()` [instead](https://ethereum.stackexchange.com/questions/30912/how-to-compare-strings-in-solidity#answer-82739).
If all arguments are strings and or bytes, `bytes.concat()` should be used instead

*Instances (1)*:
```solidity
File: contracts/core/PosManager.sol

273:         posId = uint(keccak256(abi.encodePacked(_owner, nonce)));

```

### <a name="L-2"></a>[L-2] Do not use deprecated library functions

*Instances (3)*:
```solidity
File: contracts/helper/rebase_helper/mUSDUSDYHelper.sol

14:         IERC20(_yieldBearingToken).safeApprove(_rebaseToken, type(uint).max);

```

```solidity
File: contracts/hook/MoneyMarketHook.sol

95:             IERC20(_token).safeApprove(CORE, type(uint).max);

```

```solidity
File: contracts/lending_pool/LendingPool.sol

90:         IERC20(_underlyingToken).safeApprove(core, type(uint).max);

```

### <a name="L-3"></a>[L-3] Empty Function Body - Consider commenting why

*Instances (7)*:
```solidity
File: contracts/common/AccessControlManager.sol

9:     constructor() AccessControlDefaultAdminRules(0, msg.sender) {}

```

```solidity
File: contracts/core/Config.sol

46:     function initialize() external initializer {}

```

```solidity
File: contracts/hook/MoneyMarketHook.sol

49:     function initialize() external initializer {}

```

```solidity
File: contracts/oracle/InitOracle.sol

37:     function initialize() external initializer {}

51:         } catch {}

57:         } catch {}

```

```solidity
File: contracts/risk_manager/RiskManager.sol

46:     function initialize() external initializer {}

```

### <a name="L-4"></a>[L-4] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (21)*:
```solidity
File: contracts/core/Config.sol

46:     function initialize() external initializer {}

46:     function initialize() external initializer {}

```

```solidity
File: contracts/core/InitCore.sol

87:     function initialize(address _config, address _oracle, address _liqIncentiveCalculator, address _riskManager)

89:         initializer

91:         __ReentrancyGuard_init();

```

```solidity
File: contracts/core/LiqIncentiveCalculator.sol

41:     function initialize(uint _maxLiqIncentiveMultiplier_e18) external initializer {

41:     function initialize(uint _maxLiqIncentiveMultiplier_e18) external initializer {

```

```solidity
File: contracts/core/PosManager.sol

68:     function initialize(string calldata _name, string calldata _symbol, address _core, uint8 _maxCollCount)

70:         initializer

72:         __ERC721_init(_name, _symbol);

```

```solidity
File: contracts/hook/MoneyMarketHook.sol

49:     function initialize() external initializer {}

49:     function initialize() external initializer {}

```

```solidity
File: contracts/lending_pool/LendingPool.sol

75:     function initialize(

82:     ) external initializer {

84:         __ERC20_init(_name, _symbol);

```

```solidity
File: contracts/oracle/Api3OracleReader.sol

41:     function initialize(address _api3ServerV1) external initializer {

41:     function initialize(address _api3ServerV1) external initializer {

```

```solidity
File: contracts/oracle/InitOracle.sol

37:     function initialize() external initializer {}

37:     function initialize() external initializer {}

```

```solidity
File: contracts/risk_manager/RiskManager.sol

46:     function initialize() external initializer {}

46:     function initialize() external initializer {}

```

