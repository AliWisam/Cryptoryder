pragma solidity ^0.5.16;

import './Killable.sol';
import './Authentication.sol';

/*
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

library AddrArrayLib {
    using AddrArrayLib for Addresses;

    struct Addresses {
      address[]  _items;
    }

    /**
     * @notice push an address to the array
     * @dev if the address already exists, it will not be added again
     * @param self Storage array containing address type variables
     * @param element the element to add in the array
     */
    function pushAddress(Addresses storage self, address element) internal {
      if (!exists(self, element)) {
        self._items.push(element);
      }
    }

    /**
     * @notice remove an address from the array
     * @dev finds the element, swaps it with the last element, and then deletes it;
     *      returns a boolean whether the element was found and deleted
     * @param self Storage array containing address type variables
     * @param element the element to remove from the array
     */
    function removeAddress(Addresses storage self, address element) internal returns (bool) {
        for (uint i = 0; i < self.size(); i++) {
            if (self._items[i] == element) {
                self._items[i] = self._items[self.size() - 1];
                self._items.pop();
                return true;
            }
        }
        return false;
    }

    /**
     * @notice get the address at a specific index from array
     * @dev revert if the index is out of bounds
     * @param self Storage array containing address type variables
     * @param index the index in the array
     */
    function getAddressAtIndex(Addresses storage self, uint256 index) internal view returns (address) {
        require(index < size(self), "the index is out of bounds");
        return self._items[index];
    }

    /**
     * @notice get the size of the array
     * @param self Storage array containing address type variables
     */
    function size(Addresses storage self) internal view returns (uint256) {
      return self._items.length;
    }

    /**
     * @notice check if an element exist in the array
     * @param self Storage array containing address type variables
     * @param element the element to check if it exists in the array
     */
    function exists(Addresses storage self, address element) internal view returns (bool) {
        for (uint i = 0; i < self.size(); i++) {
            if (self._items[i] == element) {
                return true;
            }
        }
        return false;
    }

    /**
     * @notice get the array
     * @param self Storage array containing address type variables
     */
    function getAllAddresses(Addresses storage self) internal view returns(address[] memory) {
        return self._items;
    }

}

/**
 * Strings Library
 * 
 * In summary this is a simple library of string functions which make simple 
 * string operations less tedious in solidity.
 * 
 * Please be aware these functions can be quite gas heavy so use them only when
 * necessary not to clog the blockchain with expensive transactions.
 * 
 * @author James Lockhart <james@n3tw0rk.co.uk>
 */
library Strings {
    
    /**
     * Concat (High gas cost)
     * 
     * Appends two strings together and returns a new value
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string which will be the concatenated
     *              prefix
     * @param _value The value to be the concatenated suffix
     * @return string The resulting string from combinging the base and value
     */
    function concat(string memory _base, string memory _value)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length > 0);

        string memory _tmpValue = new string(_baseBytes.length +
            _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for (i = 0; i < _baseBytes.length; i++) {
            _newValue[j++] = _baseBytes[i];
        }

        for (i = 0; i < _valueBytes.length; i++) {
            _newValue[j++] = _valueBytes[i];
        }

        return string(_newValue);
    }

    /**
     * Index Of
     *
     * Locates and returns the position of a character within a string
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string acting as the haystack to be
     *              searched
     * @param _value The needle to search for, at present this is currently
     *               limited to one character
     * @return int The position of the needle starting from 0 and returning -1
     *             in the case of no matches found
     */
    function indexOf(string memory _base, string memory _value)
        internal
        pure
        returns (int) {
        return _indexOf(_base, _value, 0);
    }

    /**
     * Index Of
     *
     * Locates and returns the position of a character within a string starting
     * from a defined offset
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string acting as the haystack to be
     *              searched
     * @param _value The needle to search for, at present this is currently
     *               limited to one character
     * @param _offset The starting point to start searching from which can start
     *                from 0, but must not exceed the length of the string
     * @return int The position of the needle starting from 0 and returning -1
     *             in the case of no matches found
     */
    function _indexOf(string memory _base, string memory _value, uint _offset)
        internal
        pure
        returns (int) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        assert(_valueBytes.length == 1);

        for (uint i = _offset; i < _baseBytes.length; i++) {
            if (_baseBytes[i] == _valueBytes[0]) {
                return int(i);
            }
        }

        return -1;
    }

    /**
     * Length
     * 
     * Returns the length of the specified string
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string to be measured
     * @return uint The length of the passed string
     */
    function length(string memory _base)
        internal
        pure
        returns (uint) {
        bytes memory _baseBytes = bytes(_base);
        return _baseBytes.length;
    }

    /**
     * Sub String
     * 
     * Extracts the beginning part of a string based on the desired length
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string that will be used for 
     *              extracting the sub string from
     * @param _length The length of the sub string to be extracted from the base
     * @return string The extracted sub string
     */
    function substring(string memory _base, int _length)
        internal
        pure
        returns (string memory) {
        return _substring(_base, _length, 0);
    }

    /**
     * Sub String
     * 
     * Extracts the part of a string based on the desired length and offset. The
     * offset and length must not exceed the lenth of the base string.
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string that will be used for 
     *              extracting the sub string from
     * @param _length The length of the sub string to be extracted from the base
     * @param _offset The starting point to extract the sub string from
     * @return string The extracted sub string
     */
    function _substring(string memory _base, int _length, int _offset)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);

        assert(uint(_offset + _length) <= _baseBytes.length);

        string memory _tmp = new string(uint(_length));
        bytes memory _tmpBytes = bytes(_tmp);

        uint j = 0;
        for (uint i = uint(_offset); i < uint(_offset + _length); i++) {
            _tmpBytes[j++] = _baseBytes[i];
        }

        return string(_tmpBytes);
    }

    /**
     * String Split (Very high gas cost)
     *
     * Splits a string into an array of strings based off the delimiter value.
     * Please note this can be quite a gas expensive function due to the use of
     * storage so only use if really required.
     *
     * @param _base When being used for a data type this is the extended object
     *               otherwise this is the string value to be split.
     * @param _value The delimiter to split the string on which must be a single
     *               character
     * @return string[] An array of values split based off the delimiter, but
     *                  do not container the delimiter.
     */
    function split(string memory _base, string memory _value)
        internal
        pure
        returns (string[] memory splitArr) {
        bytes memory _baseBytes = bytes(_base);

        uint _offset = 0;
        uint _splitsCount = 1;
        while (_offset < _baseBytes.length - 1) {
            int _limit = _indexOf(_base, _value, _offset);
            if (_limit == -1)
                break;
            else {
                _splitsCount++;
                _offset = uint(_limit) + 1;
            }
        }

        splitArr = new string[](_splitsCount);

        _offset = 0;
        _splitsCount = 0;
        while (_offset < _baseBytes.length - 1) {

            int _limit = _indexOf(_base, _value, _offset);
            if (_limit == - 1) {
                _limit = int(_baseBytes.length);
            }

            string memory _tmp = new string(uint(_limit) - _offset);
            bytes memory _tmpBytes = bytes(_tmp);

            uint j = 0;
            for (uint i = _offset; i < uint(_limit); i++) {
                _tmpBytes[j++] = _baseBytes[i];
            }
            _offset = uint(_limit) + 1;
            splitArr[_splitsCount++] = string(_tmpBytes);
        }
        return splitArr;
    }

    /**
     * Compare To
     * 
     * Compares the characters of two strings, to ensure that they have an 
     * identical footprint
     * 
     * @param _base When being used for a data type this is the extended object
     *               otherwise this is the string base to compare against
     * @param _value The string the base is being compared to
     * @return bool Simply notates if the two string have an equivalent
     */
    function compareTo(string memory _base, string memory _value)
        internal
        pure
        returns (bool) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        if (_baseBytes.length != _valueBytes.length) {
            return false;
        }

        for (uint i = 0; i < _baseBytes.length; i++) {
            if (_baseBytes[i] != _valueBytes[i]) {
                return false;
            }
        }

        return true;
    }

    /**
     * Compare To Ignore Case (High gas cost)
     * 
     * Compares the characters of two strings, converting them to the same case
     * where applicable to alphabetic characters to distinguish if the values
     * match.
     * 
     * @param _base When being used for a data type this is the extended object
     *               otherwise this is the string base to compare against
     * @param _value The string the base is being compared to
     * @return bool Simply notates if the two string have an equivalent value
     *              discarding case
     */
    function compareToIgnoreCase(string memory _base, string memory _value)
        internal
        pure
        returns (bool) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        if (_baseBytes.length != _valueBytes.length) {
            return false;
        }

        for (uint i = 0; i < _baseBytes.length; i++) {
            if (_baseBytes[i] != _valueBytes[i] &&
            _upper(_baseBytes[i]) != _upper(_valueBytes[i])) {
                return false;
            }
        }

        return true;
    }

    /**
     * Upper
     * 
     * Converts all the values of a string to their corresponding upper case
     * value.
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string base to convert to upper case
     * @return string 
     */
    function upper(string memory _base)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = _upper(_baseBytes[i]);
        }
        return string(_baseBytes);
    }

    /**
     * Lower
     * 
     * Converts all the values of a string to their corresponding lower case
     * value.
     * 
     * @param _base When being used for a data type this is the extended object
     *              otherwise this is the string base to convert to lower case
     * @return string 
     */
    function lower(string memory _base)
        internal
        pure
        returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        for (uint i = 0; i < _baseBytes.length; i++) {
            _baseBytes[i] = _lower(_baseBytes[i]);
        }
        return string(_baseBytes);
    }

    /**
     * Upper
     * 
     * Convert an alphabetic character to upper case and return the original
     * value when not alphabetic
     * 
     * @param _b1 The byte to be converted to upper case
     * @return bytes1 The converted value if the passed value was alphabetic
     *                and in a lower case otherwise returns the original value
     */
    function _upper(bytes1 _b1)
        private
        pure
        returns (bytes1) {

        if (_b1 >= 0x61 && _b1 <= 0x7A) {
            return bytes1(uint8(_b1) - 32);
        }

        return _b1;
    }

    /**
     * Lower
     * 
     * Convert an alphabetic character to lower case and return the original
     * value when not alphabetic
     * 
     * @param _b1 The byte to be converted to lower case
     * @return bytes1 The converted value if the passed value was alphabetic
     *                and in a upper case otherwise returns the original value
     */
    function _lower(bytes1 _b1)
        private
        pure
        returns (bytes1) {

        if (_b1 >= 0x41 && _b1 <= 0x5A) {
            return bytes1(uint8(_b1) + 32);
        }

        return _b1;
    }

}

//date time 
contract DateTime {
        struct _DateTime {
                uint16 year;
                uint8 month;
                uint8 day;
                uint8 hour;
                uint8 minute;
                uint8 second;
                uint8 weekday;
        }

        uint constant DAY_IN_SECONDS = 86400;
        uint constant YEAR_IN_SECONDS = 31536000;
        uint constant LEAP_YEAR_IN_SECONDS = 31622400;

        uint constant HOUR_IN_SECONDS = 3600;
        uint constant MINUTE_IN_SECONDS = 60;

        uint16 constant ORIGIN_YEAR = 1970;

        function isLeapYear(uint16 year) public pure returns (bool) {
                if (year % 4 != 0) {
                        return false;
                }
                if (year % 100 != 0) {
                        return true;
                }
                if (year % 400 != 0) {
                        return false;
                }
                return true;
        }

        function leapYearsBefore(uint year) public pure returns (uint) {
                year -= 1;
                return year / 4 - year / 100 + year / 400;
        }

        function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
                if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
                        return 31;
                }
                else if (month == 4 || month == 6 || month == 9 || month == 11) {
                        return 30;
                }
                else if (isLeapYear(year)) {
                        return 29;
                }
                else {
                        return 28;
                }
        }

        function parseTimestamp(uint timestamp) internal pure returns (_DateTime memory dt) {
                uint secondsAccountedFor = 0;
                uint buf;
                uint8 i;

                // Year
                dt.year = getYear(timestamp);
                buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
                secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

                // Month
                uint secondsInMonth;
                for (i = 1; i <= 12; i++) {
                        secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
                        if (secondsInMonth + secondsAccountedFor > timestamp) {
                                dt.month = i;
                                break;
                        }
                        secondsAccountedFor += secondsInMonth;
                }

                // Day
                for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
                        if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                                dt.day = i;
                                break;
                        }
                        secondsAccountedFor += DAY_IN_SECONDS;
                }

                // Hour
                dt.hour = getHour(timestamp);

                // Minute
                dt.minute = getMinute(timestamp);

                // Second
                dt.second = getSecond(timestamp);

                // Day of week.
                dt.weekday = getWeekday(timestamp);
        }

        function getYear(uint timestamp) public pure returns (uint16) {
                uint secondsAccountedFor = 0;
                uint16 year;
                uint numLeapYears;

                // Year
                year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
                numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

                secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
                secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

                while (secondsAccountedFor > timestamp) {
                        if (isLeapYear(uint16(year - 1))) {
                                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                secondsAccountedFor -= YEAR_IN_SECONDS;
                        }
                        year -= 1;
                }
                return year;
        }

        function getMonth(uint timestamp) public pure returns (uint8) {
                return parseTimestamp(timestamp).month;
        }

        function getDay(uint timestamp) public pure returns (uint8) {
                return parseTimestamp(timestamp).day;
        }

        function getHour(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / 60 / 60) % 24);
        }

        function getMinute(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / 60) % 60);
        }

        function getSecond(uint timestamp) public pure returns (uint8) {
                return uint8(timestamp % 60);
        }

        function getWeekday(uint timestamp) public pure returns (uint8) {
                return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, 0, 0, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, hour, 0, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
                return toTimestamp(year, month, day, hour, minute, 0);
        }

        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
                uint16 i;

                // Year
                for (i = ORIGIN_YEAR; i < year; i++) {
                        if (isLeapYear(i)) {
                                timestamp += LEAP_YEAR_IN_SECONDS;
                        }
                        else {
                                timestamp += YEAR_IN_SECONDS;
                        }
                }

                // Month
                uint8[12] memory monthDayCounts;
                monthDayCounts[0] = 31;
                if (isLeapYear(year)) {
                        monthDayCounts[1] = 29;
                }
                else {
                        monthDayCounts[1] = 28;
                }
                monthDayCounts[2] = 31;
                monthDayCounts[3] = 30;
                monthDayCounts[4] = 31;
                monthDayCounts[5] = 30;
                monthDayCounts[6] = 31;
                monthDayCounts[7] = 31;
                monthDayCounts[8] = 30;
                monthDayCounts[9] = 31;
                monthDayCounts[10] = 30;
                monthDayCounts[11] = 31;

                for (i = 1; i < month; i++) {
                        timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
                }

                // Day
                timestamp += DAY_IN_SECONDS * (day - 1);

                // Hour
                timestamp += HOUR_IN_SECONDS * (hour);

                // Minute
                timestamp += MINUTE_IN_SECONDS * (minute);

                // Second
                timestamp += second;

                return timestamp;
        }
}

contract Rideshare is  Killable, DateTime {
  
  using AddrArrayLib for AddrArrayLib.Addresses;
  using Strings for string;
    
    
  struct Passenger {
    uint price;
    string state; // initial, driverConfirmed, passengerConfirmed, enRoute, completion, canceled
  }

  struct Ride {
    address driver;
    uint drivingCost;
    uint capacity;
    string originAddress;
    string destAddress;
    uint createdAt; 
    uint confirmedAt;//confirmed by
    uint destinationDate;
    uint departureTime;
    uint arrivaltime;
    mapping (address => Passenger) passengers;
    address[] passengerAccts;
    
    
  }
  
  Ride[] public rides;
  
  //uint public rideCount;
  
  address[] addressesEnRoute;
  
  mapping (address => uint) reputation;

    // AddrArrayLib.Addresses bidderAddressesList;
    // AddrArrayLib.Addresses approvedAddressesList;
    
  
  mapping(address => DriverRides) public DRides;
  struct DriverRides{
    uint totalRides;
    uint cancelledRides;
    uint totalEarning;
  } 
  
  Authentication public authentication;
  
      constructor(address _authentication) public {
       require(
            _authentication != address(0),
            "constructor::Cannot have null address for _authentication"
        );
        authentication = Authentication(_authentication);
           }
  // for now, only drivers can create Rides
  function createRide(
  uint _driverCost,
  uint _capacity,
  string memory _originAddress,
  string memory _destAddress,
  uint _confirmedAt, //confirmed by pessangers
  uint _destinationDate,//initial 0, now in arrived function
  uint _departureTime,// has to given by user in timestamp
  uint _arrivaltime // initial 0
  ) public {
    address[] memory _passengerAccts;
    
    
    rides.push(Ride(msg.sender, _driverCost,
    _capacity, _originAddress, _destAddress,
    block.timestamp, _confirmedAt, _destinationDate,
    _departureTime,_arrivaltime,
    _passengerAccts));
  }
  
  
  // called by passenger
  function joinRide(uint rideNumber) public payable {
    Ride storage curRide = rides[rideNumber];
    require(msg.value == curRide.drivingCost,"value must be equal to driving cost");
        Passenger storage passenger = curRide.passengers[msg.sender];    
        
        passenger.price = msg.value;
        passenger.state = "initial";
        
        rides[rideNumber].passengerAccts.push(msg.sender) -1; //***
         }
  
  function getPassengers(uint rideNumber) view public returns(address[] memory) {
    return rides[rideNumber].passengerAccts;
  }

  function getPassengerRideState(uint rideNumber, address passenger) view public returns(string memory) {
    return rides[rideNumber].passengers[passenger].state;
  }

  function getRide(uint rideNumber) public view returns (
    address _driver,
    uint _drivingCost,
    uint _capacity,
    string memory _originAddress,
    string memory _destAddress,
    uint _createdAt,
    uint _confirmedAt, 
    uint _destinationDate,
    uint _departureTime,
    uint _arrivaltime
  ) {
    Ride memory ride = rides[rideNumber];
    return (
      ride.driver,
      ride.drivingCost,
      ride.capacity,
      ride.originAddress,
      ride.destAddress,
      ride.createdAt,
      ride.confirmedAt,
      ride.destinationDate,
      ride.departureTime,
      ride.arrivaltime
      
    );
  }

  function getRideCount() public view returns(uint) {
    return rides.length;
  }
  
  function passengerInRide(uint rideNumber, address passengerAcct) public view returns (bool) {
    Ride storage curRide = rides[rideNumber];
    for(uint i = 0; i < curRide.passengerAccts.length; i++) {
      if (curRide.passengerAccts[i] == passengerAcct) {
        return true;
      }
    }
    return false;
  }
  
  function cancelRide(uint rideNumber) public{
    Ride storage curRide = rides[rideNumber];
    require(block.timestamp < curRide.confirmedAt);
    //
    // DriverRides memory dRides;
   
    if (msg.sender == curRide.driver) {
      for (uint i = 0; i < curRide.passengerAccts.length; i++) {
       // curRide.passengerAccts[i].transfer(curRide.passengers[curRide.passengerAccts[i]].price);
        address(uint160(curRide.passengerAccts[i])).transfer(curRide.passengers[curRide.passengerAccts[i]].price);
        //
        if(DRides[msg.sender].cancelledRides >0){DRides[msg.sender].cancelledRides--;}
        // DRides[msg.sender].cancelledRides--;
      }
    } else if (passengerInRide(rideNumber, msg.sender)) {
      msg.sender.transfer(curRide.passengers[msg.sender].price);
      //
      if(DRides[msg.sender].cancelledRides >0){DRides[msg.sender].cancelledRides--;}
    }
    
  }

  // called by passenger
  function confirmDriverMet(uint rideNumber) public {
    require(passengerInRide(rideNumber, msg.sender));
    Ride storage curRide = rides[rideNumber];
    // uint(keccak256(abi.encodePacked(source))); was in 0.4.0
    if (keccak256(abi.encodePacked(curRide.passengers[msg.sender].state)) == keccak256("passengersConfirmed")) {
      curRide.passengers[msg.sender].state = "enRoute";
    } else {
      curRide.passengers[msg.sender].state = "driverConfirmed";
    }
    
  }
  
  // called by driver
  function confirmPassengersMet(uint rideNumber, address[] memory passengerAddresses)  public {
    Ride storage curRide = rides[rideNumber];
    require(msg.sender == curRide.driver);
    address _userAddress = curRide.driver;
    for(uint i=0; i < passengerAddresses.length; i++) {
      //string memory curState = curRide.passengers[passengerAddresses[i]].state;
      if (keccak256(abi.encodePacked(curRide.passengers[passengerAddresses[i]].state)) == keccak256("driverConfirmed")) {
        curRide.passengers[passengerAddresses[i]].state = "enRoute";
        DRides[msg.sender].totalRides++;
        authentication.numberOfRidesTaken(_userAddress);
      } else {
        curRide.passengers[passengerAddresses[i]].state = "passengersConfirmed";
        DRides[msg.sender].totalRides++;
        authentication.numberOfRidesTaken(_userAddress);
      }
    }
    // require(rides[rideNumber].state == "confirmed");
  }
   
  function enRouteList(uint rideNumber) public returns(address[] memory) {
    Ride storage curRide = rides[rideNumber];
    //for version 5x
    address[] memory tempAddressesEnRoute;
    addressesEnRoute = tempAddressesEnRoute;
    for(uint i = 0; i < curRide.passengerAccts.length; i++) {
      if (keccak256(abi.encodePacked(curRide.passengers[curRide.passengerAccts[i]].state)) == keccak256("enRoute")) {
        addressesEnRoute.push(curRide.passengerAccts[i]);
      }
    }
  }
  
  // called by passenger
  function arrived(uint rideNumber, uint _rate) public returns(uint256) {
    require(passengerInRide(rideNumber, msg.sender));
    Ride storage curRide = rides[rideNumber];
    address _userAddress = curRide.driver;
    address(uint160(curRide.driver)).transfer(curRide.passengers[msg.sender].price);
    curRide.passengers[msg.sender].state = "completion";
    authentication.driverRating(_userAddress, _rate);
    authentication.numberOfRidesGiven(_userAddress);
    DRides[curRide.driver].totalEarning += curRide.drivingCost;
    //destinationDate
    curRide.destinationDate = block.timestamp;
    curRide.arrivaltime = block.timestamp;
    curRide.destinationDate = block.timestamp;
    
    return curRide.drivingCost;
    
  }
  //called by driver
  function riderRating(uint rideNumber, uint _rate) public{
    Ride storage curRide = rides[rideNumber];
    address _userAddress = curRide.driver;
    
    authentication.riderRating(_userAddress,_rate);
    
  }
  
  //filters by origin
  function filterByOrigin(uint rideNumber, string memory _origin) public view returns (
    address _driver,
    uint _drivingCost,
    uint _capacity,
    string memory _originAddress,
    string memory _destAddress,
    uint _createdAt,
    uint _confirmedAt,
    uint _destinationDate,
    uint _departureTime,
    uint _arrivaltime
  ){
     Ride memory ride = rides[rideNumber];
     if(Strings.compareTo(ride.originAddress,_origin)){
      return (
      ride.driver,
      ride.drivingCost,
      ride.capacity,
      ride.originAddress,
      ride.destAddress,
      ride.createdAt,
      ride.confirmedAt,
      ride.destinationDate,
      ride.departureTime,
      ride.arrivaltime
    );
     }
    
  }
  //filter by destinationDate
  function filtetbyDestinationDate(uint rideNumber,uint _DestinationDate) public view returns(   
    address _driver,
    uint _drivingCost,
    uint _capacity,
    string memory _originAddress,
    string memory _destAddress,
    uint _createdAt,
    uint _confirmedAt,
    uint _destinationDate,
    uint _departureTime,
    uint _arrivaltime) {
     Ride memory ride = rides[rideNumber];
     if(ride.destinationDate == _DestinationDate){
      return (
      ride.driver,
      ride.drivingCost,
      ride.capacity,
      ride.originAddress,
      ride.destAddress,
      ride.createdAt,
      ride.confirmedAt,
      ride.destinationDate,
      ride.departureTime,
      ride.arrivaltime
    );
     }
      
  }
  //filter by time of departureTime
  function filterByTimeOfDeparture(uint rideNumber,uint _DepartureTime ) public view returns(   
    address _driver,
    uint _drivingCost,
    uint _capacity,
    string memory _originAddress,
    string memory _destAddress,
    uint _createdAt,
    uint _confirmedAt,
    uint _destinationDate,
    uint _departureTime,
    uint _arrivaltime) {
     Ride memory ride = rides[rideNumber];
     if(ride.departureTime == _DepartureTime){
      return (
      ride.driver,
      ride.drivingCost,
      ride.capacity,
      ride.originAddress,
      ride.destAddress,
      ride.createdAt,
      ride.confirmedAt,
      ride.destinationDate,
      ride.departureTime,
      ride.arrivaltime
    );
     }}
       
  
  //filter by arrival time
  function filterByArrivalTime(uint rideNumber,uint _Arrivaltime ) public view returns(   
    address _driver,
    uint _drivingCost,
    uint _capacity,
    string memory _originAddress,
    string memory _destAddress,
    uint _createdAt,
    uint _confirmedAt,
    uint _destinationDate,
    uint _departureTime,
    uint _arrivaltime) {
     Ride memory ride = rides[rideNumber];
     if(ride.arrivaltime == _Arrivaltime){
      return (
      ride.driver,
      ride.drivingCost,
      ride.capacity,
      ride.originAddress,   
      ride.destAddress,
      ride.createdAt,
      ride.confirmedAt,
      ride.destinationDate,
      ride.departureTime,
      ride.arrivaltime
    );
     }}
  
  
}
