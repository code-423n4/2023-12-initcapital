
# INIT Capital audit details
- Total Prize Pool: $38,500 USDC
  - HM awards: $29,340 USDC 
  - Analysis awards: $1,630 USDC 
  - QA awards: $815 USDC 
  - Gas awards: $815 USDC 
  - Judge awards: $5,400 USDC 
  - Scout awards: $500 USDC 
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2023-12-initcapital/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts December 15, 2023 20:00 UTC
- Ends December 21, 2023 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2023-12-initcapital/blob/main/4naly3er-report.md).

Automated findings output for the audit can be found [here](https://github.com/code-423n4/2023-12-initcapital/blob/main/bot-report.md) within 24 hours of audit opening.

_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

Known issues:
- Users can avoid paying flashloan fee (if set to non-zero) by atomically borrowing and then repaying in the same transaction.
- `totalInterest` may slightly overestimate the actual interest accrual due to rounding up (in the order of wei).

# Overview


## Links

- **Previous audits:** private (2)
- **Documentation:** 
  - Gitbook: https://init-capital.gitbook.io/
  - Overview: https://docsend.com/view/mwwb5ptmyjkk86ih (password: Audit)
- **Website:** https://init.capital/
- **Twitter:** [https://twitter.com/InitCapital_](https://twitter.com/InitCapital_)
- **Discord:** https://discord.gg/hW3YZSMzvv


# Scope

## Contracts

| Contract | SLOC | Purpose | 
| ----------- | ----------- | ----------- | 
| [contracts/common/library/UncheckedIncrement.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/common/library/UncheckedIncrement.sol) | 8 | Unchecked Increment for `uint` iterators | 
| [contracts/common/AccessControlManager.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/common/AccessControlManager.sol) | 9 | Manage access controls | 
| [contracts/common/UnderACM.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/common/UnderACM.sol) | 8 | Extensible contract for access control manager | 
| [contracts/core/Config.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/core/Config.sol) | 106 | Config manager | 
| [contracts/core/InitCore.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/core/InitCore.sol) | 423 | Main contract for most interactions to INIT | 
| [contracts/core/LiqIncentiveCalculator.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/core/LiqIncentiveCalculator.sol) | 80 | Liquidation incentive calculation  | 
| [contracts/core/PosManager.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/core/PosManager.sol) | 263 | Position manager  | 
| [contracts/hook/MoneyMarketHook.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/hook/MoneyMarketHook.sol) | 183 | Hook for regular money market actions, for example, deposit, withdraw, borrow, repay  | 
| [contracts/lending_pool/DoubleSlopeIRM.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/lending_pool/DoubleSlopeIRM.sol) | 29 | Interest rate model utilizing a 2-slope mechanism  | 
| [contracts/lending_pool/LendingPool.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/lending_pool/LendingPool.sol) | 183 | ERC20 lending pool | 
| [contracts/oracle/Api3OracleReader.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/oracle/Api3OracleReader.sol) | 55 | API3 oracle integration | 
| [contracts/oracle/InitOracle.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/oracle/InitOracle.sol) | 77 | Oracle source manager contract | 
| [contracts/risk_manager/RiskManager.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/risk_manager/RiskManager.sol) | 61 | Risk manager contract |
| [contracts/helper/rebase_helper/mUSDUSDYHelper.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/helper/rebase_helper/mUSDUSDYHelper.sol) | 23 | Wrapper contract helper for wrapping/unwrapping mUSD to/from USDY |
| [contracts/helper/rebase_helper/BaseRebaseHelper.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/helper/rebase_helper/BaseRebaseHelper.sol) | 11 | Base wrapper contract helper for wrapping/unwrapping rebase tokens |
| [contracts/common/TransparentUpgradeableProxyReceiveETH.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/common/TransparentUpgradeableProxyReceiveETH.sol) | 9 | Transparent upgradeable proxy that allows receiving ETH at the proxy level to avoid out-of-gas errors |
| [contracts/common/Multicall.sol](https://github.com/code-423n4/2023-12-initcapital/tree/main/contracts/common/Multicall.sol) | 20 | Extensible multicall base logic |


## Out of scope

- `contracts/common/library/InitErrors.sol`
- `contracts/common/library/LogExpMath.sol`
- `contracts/interfaces/*`
- `contracts/mock/*`
- `contracts/oracle/PythOracleReader.sol`

# Additional Context

- [ ] Describe any novel or unique curve logic or mathematical models implemented in the contracts
- [ ] Please list specific ERC20 that your protocol is anticipated to interact with. Could be "any" (literally anything, fee on transfer tokens, ERC777 tokens and so forth) or a list of tokens you envision using on launch.
  - No fee-on-transfer tokens
- [ ] Please list specific ERC721 that your protocol is anticipated to interact with.
  - In general, we do not support ERC721. However, we may be able to support UniswapV3-like LP tokens, which is a form of ERC721 if minted through the NPM.
- [ ] Which blockchains will this code be deployed to, and are considered in scope for this audit?
  - Mantle blockchain
- [ ] Please list all trusted roles (e.g. operators, slashers, pausers, etc.), the privileges they hold, and any conditions under which privilege escalation is expected/allowable
- [ ] In the event of a DOS, could you outline a minimum duration after which you would consider a finding to be valid? This question is asked in the context of most systems' capacity to handle DoS attacks gracefully for a certain period.
- [ ] Is any part of your implementation intended to conform to any EIP's? If yes, please list the contracts in this format: 
  - Positions should be `ERC721`.

## Attack ideas (Where to look for bugs)

- Infinite collateralization or borrowing.
- Malicious custom callbacks that can steal funds, either directly or indirectly (for example, via token approvals)
- Incorrect interest accrual or debt calculations
- Bypassing position health check, especially when performing `multicall`


## Main invariants

- Over-collateralization of the positions

## Scoping Details 

```
- If you have a public code repo, please share it here: -
- How many contracts are in scope?: 17   
- Total SLoC for these contracts?: 1548 
- How many external imports are there?: Many (most are OpenZeppelin's library)
- How many separate interfaces and struct definitions are there for the contracts within scope?: 21 interfaces, 16 structs
- Does most of your code generally use composition or inheritance?: Composition   
- How many external calls?: major one is via InitCore's callback
- What is the overall line coverage percentage provided by your tests?: >95%
- Is this an upgrade of an existing system?: False
- Check all that apply (e.g. timelock, NFT, AMM, ERC20, rollups, etc.): ERC-20 Token, Multi-Chain 
- Is there a need to understand a separate part of the codebase / get context in order to audit this part of the protocol?: False  
- Please describe required context: see documentation above.  
- Does it use an oracle?: Yes, API3 & Chronicle.
- Describe any novel or unique curve logic or mathematical models your code uses: -
- Is this either a fork of or an alternate implementation of another project?: False   
- Does it use a side-chain?: No
- Describe any specific areas you would like addressed: -
```

# Tests

1. Install Foundry's Forge and ApeWorX's ape.
- Forge: https://github.com/foundry-rs/forge-std
- Ape: https://github.com/ApeWorX/ape

2. Installing libraries via Ape and Forge.
    ```shell
    ape plugins install .
    ape compile
    forge install foundry-rs/forge-std --no-commit
    ```

(To compile the code, you can use either `ape compile` or `forge build` after installing the libraries)

3. Spin up an anvil fork node

    ```shell
    anvil -f https://rpc.mantle.xyz --chain-id 5000
    ```

4. Run tests

    ```shell
    forge test
    ```

For coverage testing, run the following intead of step 3, and a new window will pop up on your browser. 
*NOTE: Make sure you have an up-to-date `lcov` installed.*

```shell
sh run_coverage.sh
```