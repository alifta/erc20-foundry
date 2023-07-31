// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ERC20 {
    // Only owner can perform action
    // modifier onlyOwner() {
    //     // Check if caller is owner
    //     require(msg.sender == owner);
    //     _;
    // }

    // Run only if no re-entrancy
    modifier noReentrant() {
        require(!locked, "Reentrancy");
        locked = true;
        _;
        locked = false;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    // ERC20 properties
    string public name; // Token Name
    string public symbol; // Token Symbol
    uint8 public immutable decimals; // 1e18
    uint256 public totalSupply; // Total number of tokens
    mapping(address => uint256) public balanceOf; // Balance of addresses
    mapping(address => mapping(address => uint256)) public allowance;

    // Owner
    // address public owner;

    // Reentrant Lock
    bool private locked;

    // Constructor
    // constructor(address _owner, string memory _name, string memory _symbol, uint8 _decimals) {name = _name; symbol = _symbol; decimals = _decimals; owner = _owner;}

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    // ERC20 functions
    function transfer(
        address _to,
        uint256 _value
    ) external returns (bool success) {
        return _transfer(msg.sender, _to, _value);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success) {
        require(
            allowance[_from][msg.sender] >= _value,
            "ERC20: Insufficient allowance"
        );

        allowance[_from][msg.sender] -= _value;

        emit Approval(_from, msg.sender, allowance[_from][msg.sender]);

        return _transfer(_from, _to, _value);
    }

    function approve(
        address _spender,
        uint256 _value
    ) external returns (bool success) {
        allowance[msg.sender][_spender] -= _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    // Private helper functions
    function _transfer(
        address _from,
        address _to,
        uint256 _value
    ) private returns (bool success) {
        // Check balance of sender
        require(
            balanceOf[msg.sender] >= _value,
            "ERC20: Insufficient sender balance"
        );

        // Logging transfer events
        emit Transfer(_from, _to, _value);

        // Decrease token balance of sender by value
        balanceOf[_from] -= _value;

        // Increase token balance of receiver by value
        balanceOf[_to] += _value;

        // Successful transaction
        return true;
    }

    function mint(address _to, uint256 _value) internal {
        balanceOf[_to] += _value;
        totalSupply += _value;

        emit Transfer(address(0), _to, _value);
    }

    // Mint for creating tokens
    // function _mint(address _to, uint256 _value) private {
    //     balanceOf[_to] += _value;
    //     totalSupply += _value;

    //     emit Transfer(address(0), _to, _value);
    // }

    // External mint
    // function mint(address _to, uint256 _value) external onlyOwner {
    //     _mint(_to, _value);
    // }

    // Burn for destroying tokens
    // function _burn(address _from, uint256 _value) private {
    //     balanceOf[_from] -= _value;
    //     totalSupply -= _value;

    //     emit Transfer(_from, address(0), _value);
    // }

    // External burn
    // function burn(address _from, uint256 _value) external onlyOwner {
    //     _mint(_from, _value);
    // }
}
