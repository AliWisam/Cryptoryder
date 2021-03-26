// pragma solidity ^0.5.16;


// //import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-org/contracts/ownership/Ownable.sol";
// //import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/access/Ownable.sol";

// /*
//  * Killable
//  * Base contract that can be killed by owner. All funds in contract will be sent to the owner.
//  */
//  /**
//  * @title Ownable
//  * @dev The Ownable contract has an owner address, and provides basic authorization control
//  * functions, this simplifies the implementation of "user permissions".
//  */
// contract Ownable {
//   address private _owner;

//   event OwnershipTransferred(
//     address indexed previousOwner,
//     address indexed newOwner
//   );

//   /**
//    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
//    * account.
//    */
//   constructor() internal {
//     _owner = msg.sender;
//     emit OwnershipTransferred(address(0), _owner);
//   }

//   /**
//    * @return the address of the owner.
//    */
//   function owner() public view returns(address) {
//     return _owner;
//   }

//   /**
//    * @dev Throws if called by any account other than the owner.
//    */
//   modifier onlyOwner() {
//     require(isOwner());
//     _;
//   }

//   /**
//    * @return true if `msg.sender` is the owner of the contract.
//    */
//   function isOwner() public view returns(bool) {
//     return msg.sender == _owner;
//   }

//   /**
//    * @dev Allows the current owner to relinquish control of the contract.
//    * @notice Renouncing to ownership will leave the contract without an owner.
//    * It will not be possible to call the functions with the `onlyOwner`
//    * modifier anymore.
//    */
//   function renounceOwnership() public onlyOwner {
//     emit OwnershipTransferred(_owner, address(0));
//     _owner = address(0);
//   }

//   /**
//    * @dev Allows the current owner to transfer control of the contract to a newOwner.
//    * @param newOwner The address to transfer ownership to.
//    */
//   function transferOwnership(address newOwner) public onlyOwner {
//     _transferOwnership(newOwner);
//   }

//   /**
//    * @dev Transfers control of the contract to a newOwner.
//    * @param newOwner The address to transfer ownership to.
//    */
//   function _transferOwnership(address newOwner) internal {
//     require(newOwner != address(0));
//     emit OwnershipTransferred(_owner, newOwner);
//     _owner = newOwner;
//   }
// }

// contract Whitelist is Ownable {
//     // Mapping of address to boolean indicating whether the address is whitelisted
//     mapping(address => bool) private whitelistMap;

//     // flag controlling whether whitelist is enabled.
//     bool private whitelistEnabled = true;

//     event AddToWhitelist(address indexed _newAddress);
//     event RemoveFromWhitelist(address indexed _removedAddress);

//     /**
//    * @dev Enable or disable the whitelist
//    * @param _enabled bool of whether to enable the whitelist.
//    */
//     function enableWhitelist(bool _enabled) public onlyOwner {
//         whitelistEnabled = _enabled;
//     }

//     /**
//    * @dev Adds the provided address to the whitelist
//    * @param _newAddress address to be added to the whitelist
//    */
//     function addToWhitelist(address _newAddress) public onlyOwner {
//         _whitelist(_newAddress);
//         emit AddToWhitelist(_newAddress);
//     }

//     /**
//    * @dev Removes the provided address to the whitelist
//    * @param _removedAddress address to be removed from the whitelist
//    */
//     function removeFromWhitelist(address _removedAddress) public onlyOwner {
//         _unWhitelist(_removedAddress);
//         emit RemoveFromWhitelist(_removedAddress);
//     }

//     /**
//    * @dev Returns whether the address is whitelisted
//    * @param _address address to check
//    * @return bool
//    */
//     function isWhitelisted(address _address) public view returns (bool) {
//         if (whitelistEnabled) {
//             return whitelistMap[_address];
//         } else {
//             return true;
//         }
//     }

//     /**
//    * @dev Internal function for removing an address from the whitelist
//    * @param _removedAddress address to unwhitelisted
//    */
//     function _unWhitelist(address _removedAddress) internal {
//         whitelistMap[_removedAddress] = false;
//     }

//     /**
//    * @dev Internal function for adding the provided address to the whitelist
//    * @param _newAddress address to be added to the whitelist
//    */
//     function _whitelist(address _newAddress) internal {
//         whitelistMap[_newAddress] = true;
//     }
// }
// contract Killable is Ownable {
//   function kill() public onlyOwner  {
//      address owner;
//     address payable addr3 = address(uint160(owner));
    
//     selfdestruct(addr3);
//   }
// }