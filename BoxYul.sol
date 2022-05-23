pragma solidity ^0.8.7;

contract Box {
    uint256 private _value;

    event NewValue(uint256 newValue);

    function store(uint256 newValue) public {
        assembly {
            sstore(0, newValue)                                                             // store newValue at slot0

            mstore(0x80, newValue)                                                          // need to move newValue from calldata to memory to read when emitting event

            log1(
                0x80,                                                                       // offset of variable to log
                0x20,                                                                       // size of variable to log (32 in decimals)
                0xac3e966f295f2d5312f973dc6d42f30a6dc1c1f76ab8ee91cc8ca5dad1fa60fd          // bytes32(keccak256("NewValue(uint256)"))
            )
        }

    }

    function retrieve() public view returns (uint256) {
        assembly {
            let v := sload(0)                           // this use call-stack to store v temporary
            
            mstore(0x80, v)                             // return opcode read from memory, so need to move v from call-stack to memory
                                                        // 0x80 because solidity reserve 4 of 32bytes memory slot for special functions
            
            return(0x80, 32)                            // v is uint256 so it is 32bytes length
        }
    }
}
