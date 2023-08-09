// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/UniswapV2Factory.sol";
import "../src/UniswapV2Pair.sol";
import "./mocks/ERC20Mintable.sol";

contract UniswapV2FactoryTest is Test {
    UniswapV2Factory factory;

    ERC20Mintable token0;
    ERC20Mintable token1;
    ERC20Mintable token2;
    ERC20Mintable token3;
    address testUser1;
    address testUser2;
    address testUser3;

    function setUp() public {
        testUser1= vm.addr(0x1);
        testUser2 = vm.addr(0x2);
        testUser3 = vm.addr(0x3);
        factory = new UniswapV2Factory(testUser1);

        token0 = new ERC20Mintable("Token A", "TKNA");
        token1 = new ERC20Mintable("Token B", "TKNB");
        token2 = new ERC20Mintable("Token C", "TKNC");
        token3 = new ERC20Mintable("Token D", "TKND");
    }

    function encodeError(string memory error)
        internal
        pure
        returns (bytes memory encoded)
    {
        encoded = abi.encodeWithSignature(error);
    }

    function testCreatePair() public {
        address pairAddress = factory.createPair(
            address(token1),
            address(token0)
        );

        UniswapV2Pair pair = UniswapV2Pair(pairAddress);

        assertEq(pair.token0(), address(token0));
        assertEq(pair.token1(), address(token1));
    }

    function testsetFeeToSetterByNotSetter() public {
        vm.expectRevert("UniswapV2: FORBIDDEN");
        vm.prank(testUser2);
        factory.setFeeToSetter(testUser3);
    }

    function testsetFeeToSetterBySetter() public {
        // vm.expectRevert("UniswapV2: FORBIDDEN");
        vm.prank(testUser1);
        factory.setFeeToSetter(testUser2);
    }

    function testSetFeeToByNotSetter() public {
        vm.expectRevert("UniswapV2: FORBIDDEN");
        vm.prank(testUser2);
        factory.setFeeTo(testUser3);
    }

    function testSetFeeToBySetter() public {
        // vm.expectRevert("UniswapV2: FORBIDDEN");
        vm.prank(testUser1);
        factory.setFeeTo(testUser2);
    }

    function testCreatePairZeroAddress() public {
        vm.expectRevert("UniswapV2: ZERO_ADDRESS");
        factory.createPair(address(0), address(token0));

        vm.expectRevert("UniswapV2: ZERO_ADDRESS");
        factory.createPair(address(token1), address(0));
    }

    function testCreatePairPairExists() public {
        factory.createPair(address(token1), address(token0));

        vm.expectRevert("UniswapV2: PAIR_EXISTS");
        factory.createPair(address(token1), address(token0));
    }

    function testPairLength() public view {
        factory.allPairsLength();
    }

    function testCreatePairIdenticalTokens() public {
        vm.expectRevert("UniswapV2: IDENTICAL_ADDRESSES");
        factory.createPair(address(token0), address(token0));
    }
}
