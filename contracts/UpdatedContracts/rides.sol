// pragma solidity ^0.5.16;

// import './Killable.sol';

// /*
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
// */

// library AddrArrayLib {
//     using AddrArrayLib for Addresses;

//     struct Addresses {
//       address[]  _items;
//     }

//     /**
//      * @notice push an address to the array
//      * @dev if the address already exists, it will not be added again
//      * @param self Storage array containing address type variables
//      * @param element the element to add in the array
//      */
//     function pushAddress(Addresses storage self, address element) internal {
//       if (!exists(self, element)) {
//         self._items.push(element);
//       }
//     }

//     /**
//      * @notice remove an address from the array
//      * @dev finds the element, swaps it with the last element, and then deletes it;
//      *      returns a boolean whether the element was found and deleted
//      * @param self Storage array containing address type variables
//      * @param element the element to remove from the array
//      */
//     function removeAddress(Addresses storage self, address element) internal returns (bool) {
//         for (uint i = 0; i < self.size(); i++) {
//             if (self._items[i] == element) {
//                 self._items[i] = self._items[self.size() - 1];
//                 self._items.pop();
//                 return true;
//             }
//         }
//         return false;
//     }

//     /**
//      * @notice get the address at a specific index from array
//      * @dev revert if the index is out of bounds
//      * @param self Storage array containing address type variables
//      * @param index the index in the array
//      */
//     function getAddressAtIndex(Addresses storage self, uint256 index) internal view returns (address) {
//         require(index < size(self), "the index is out of bounds");
//         return self._items[index];
//     }

//     /**
//      * @notice get the size of the array
//      * @param self Storage array containing address type variables
//      */
//     function size(Addresses storage self) internal view returns (uint256) {
//       return self._items.length;
//     }

//     /**
//      * @notice check if an element exist in the array
//      * @param self Storage array containing address type variables
//      * @param element the element to check if it exists in the array
//      */
//     function exists(Addresses storage self, address element) internal view returns (bool) {
//         for (uint i = 0; i < self.size(); i++) {
//             if (self._items[i] == element) {
//                 return true;
//             }
//         }
//         return false;
//     }

//     /**
//      * @notice get the array
//      * @param self Storage array containing address type variables
//      */
//     function getAllAddresses(Addresses storage self) internal view returns(address[] memory) {
//         return self._items;
//     }

// }
// //date time 
// contract DateTime {
//         struct _DateTime {
//                 uint16 year;
//                 uint8 month;
//                 uint8 day;
//                 uint8 hour;
//                 uint8 minute;
//                 uint8 second;
//                 uint8 weekday;
//         }

//         uint constant DAY_IN_SECONDS = 86400;
//         uint constant YEAR_IN_SECONDS = 31536000;
//         uint constant LEAP_YEAR_IN_SECONDS = 31622400;

//         uint constant HOUR_IN_SECONDS = 3600;
//         uint constant MINUTE_IN_SECONDS = 60;

//         uint16 constant ORIGIN_YEAR = 1970;

//         function isLeapYear(uint16 year) public pure returns (bool) {
//                 if (year % 4 != 0) {
//                         return false;
//                 }
//                 if (year % 100 != 0) {
//                         return true;
//                 }
//                 if (year % 400 != 0) {
//                         return false;
//                 }
//                 return true;
//         }

//         function leapYearsBefore(uint year) public pure returns (uint) {
//                 year -= 1;
//                 return year / 4 - year / 100 + year / 400;
//         }

//         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
//                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
//                         return 31;
//                 }
//                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
//                         return 30;
//                 }
//                 else if (isLeapYear(year)) {
//                         return 29;
//                 }
//                 else {
//                         return 28;
//                 }
//         }

//         function parseTimestamp(uint timestamp) internal pure returns (_DateTime memory dt) {
//                 uint secondsAccountedFor = 0;
//                 uint buf;
//                 uint8 i;

//                 // Year
//                 dt.year = getYear(timestamp);
//                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

//                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
//                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

//                 // Month
//                 uint secondsInMonth;
//                 for (i = 1; i <= 12; i++) {
//                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
//                         if (secondsInMonth + secondsAccountedFor > timestamp) {
//                                 dt.month = i;
//                                 break;
//                         }
//                         secondsAccountedFor += secondsInMonth;
//                 }

//                 // Day
//                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
//                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
//                                 dt.day = i;
//                                 break;
//                         }
//                         secondsAccountedFor += DAY_IN_SECONDS;
//                 }

//                 // Hour
//                 dt.hour = getHour(timestamp);

//                 // Minute
//                 dt.minute = getMinute(timestamp);

//                 // Second
//                 dt.second = getSecond(timestamp);

//                 // Day of week.
//                 dt.weekday = getWeekday(timestamp);
//         }

//         function getYear(uint timestamp) public pure returns (uint16) {
//                 uint secondsAccountedFor = 0;
//                 uint16 year;
//                 uint numLeapYears;

//                 // Year
//                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
//                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

//                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
//                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);

//                 while (secondsAccountedFor > timestamp) {
//                         if (isLeapYear(uint16(year - 1))) {
//                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
//                         }
//                         else {
//                                 secondsAccountedFor -= YEAR_IN_SECONDS;
//                         }
//                         year -= 1;
//                 }
//                 return year;
//         }

//         function getMonth(uint timestamp) public pure returns (uint8) {
//                 return parseTimestamp(timestamp).month;
//         }

//         function getDay(uint timestamp) public pure returns (uint8) {
//                 return parseTimestamp(timestamp).day;
//         }

//         function getHour(uint timestamp) public pure returns (uint8) {
//                 return uint8((timestamp / 60 / 60) % 24);
//         }

//         function getMinute(uint timestamp) public pure returns (uint8) {
//                 return uint8((timestamp / 60) % 60);
//         }

//         function getSecond(uint timestamp) public pure returns (uint8) {
//                 return uint8(timestamp % 60);
//         }

//         function getWeekday(uint timestamp) public pure returns (uint8) {
//                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
//         }

//         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
//                 return toTimestamp(year, month, day, 0, 0, 0);
//         }

//         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
//                 return toTimestamp(year, month, day, hour, 0, 0);
//         }

//         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
//                 return toTimestamp(year, month, day, hour, minute, 0);
//         }

//         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
//                 uint16 i;

//                 // Year
//                 for (i = ORIGIN_YEAR; i < year; i++) {
//                         if (isLeapYear(i)) {
//                                 timestamp += LEAP_YEAR_IN_SECONDS;
//                         }
//                         else {
//                                 timestamp += YEAR_IN_SECONDS;
//                         }
//                 }

//                 // Month
//                 uint8[12] memory monthDayCounts;
//                 monthDayCounts[0] = 31;
//                 if (isLeapYear(year)) {
//                         monthDayCounts[1] = 29;
//                 }
//                 else {
//                         monthDayCounts[1] = 28;
//                 }
//                 monthDayCounts[2] = 31;
//                 monthDayCounts[3] = 30;
//                 monthDayCounts[4] = 31;
//                 monthDayCounts[5] = 30;
//                 monthDayCounts[6] = 31;
//                 monthDayCounts[7] = 31;
//                 monthDayCounts[8] = 30;
//                 monthDayCounts[9] = 31;
//                 monthDayCounts[10] = 30;
//                 monthDayCounts[11] = 31;

//                 for (i = 1; i < month; i++) {
//                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
//                 }

//                 // Day
//                 timestamp += DAY_IN_SECONDS * (day - 1);

//                 // Hour
//                 timestamp += HOUR_IN_SECONDS * (hour);

//                 // Minute
//                 timestamp += MINUTE_IN_SECONDS * (minute);

//                 // Second
//                 timestamp += second;

//                 return timestamp;
//         }
// }

// contract Rideshare is  Killable, DateTime {
  
//   using AddrArrayLib for AddrArrayLib.Addresses;
  
    
    
//   struct Passenger {
//     uint price;
//     string state; // initial, driverConfirmed, passengerConfirmed, enRoute, completion, canceled
//   }

//   struct Ride {
//     address driver;
//     uint drivingCost;
//     uint capacity;
//     string originAddress;
//     string destAddress;
//     uint createdAt;
//     uint confirmedAt;
//     uint destinationDate;
//     uint departureTime;
//     uint arrivaltime;
//     mapping (address => Passenger) passengers;
//     address[] passengerAccts;
    
//   }
  
//   Ride[] public rides;
  
//   //uint public rideCount;
  
//   address[] addressesEnRoute;
  
//   mapping (address => uint) reputation;
//   //to store addresses of bidder for ride
// //   address[] public bidderAddressesList;
  
// //   address[] public approvedAddressesList;

//     AddrArrayLib.Addresses bidderAddressesList;
//     AddrArrayLib.Addresses approvedAddressesList;
    
//     mapping(address => Status) public reqStatus;
//     enum Status {noBidSubmitted ,bidSubmitted, bidRejected, bidApproved}
//     Status bidStatus;
  
//   mapping(address => DriverRides) public DRides;
//   struct DriverRides{
//     uint totalRides;
//     uint cancelledRides;
//     uint totalEarning;
//   } 
  
  
//   mapping (address => Bid) public Bids;
//   struct Bid {
//     uint rideNumberToBid;
//     string bidderName;
//     address bidderAddress;
//     bool accepted;
//   }
//       constructor() public {
          
//         bidStatus = Status.noBidSubmitted;
//            }
//   // for now, only drivers can create Rides
//   function createRide(
//   uint _driverCost,
//   uint _capacity,
//   string memory _originAddress,
//   string memory _destAddress,
//   uint _confirmedAt,
//   uint _destinationDate,
//   uint _departureTime,
//   uint _arrivaltime
//   ) public {
//     address[] memory _passengerAccts;
    
//     rides.push(Ride(msg.sender, _driverCost,
//     _capacity, _originAddress, _destAddress,
//     block.timestamp, _confirmedAt, _destinationDate,
//     _departureTime,_arrivaltime,
//     _passengerAccts));
//   }
  
//   //myRides function
//     // function getMyRides() public view returns(){
        
//     // }
    
//     //reset state
//     function resetReqState() public returns(Status) {
//         require(reqStatus[msg.sender] == Status.bidRejected);
        
//         bidStatus = Status.noBidSubmitted;
//         reqStatus[msg.sender] = bidStatus;
        
//         return reqStatus[msg.sender];
//     }
//     //passengers requests #bids
//   function BidOnRide(uint rideNumber,string memory _bidderName) public  returns(uint rideNo,string memory bidderName)  {
//     require(reqStatus[msg.sender] == Status.noBidSubmitted,"req is rejected or submitted already");
//       //for storing bidder details
//       Bids[msg.sender].rideNumberToBid = rideNumber;
//       Bids[msg.sender].bidderName = _bidderName;
//       Bids[msg.sender].bidderAddress = msg.sender;
//       Bids[msg.sender].accepted = false;
     
//       bidderAddressesList.pushAddress(msg.sender);

//       bidStatus = Status.bidSubmitted;
//       reqStatus[msg.sender] = bidStatus;
//       return (rideNo,bidderName);
//   }
//   //getbids
//   function getUnApprovedBidAddresses() public view returns(uint256,address[] memory) {
            
//         return (bidderAddressesList.size(), bidderAddressesList.getAllAddresses());
//     }
//     //<<<<<call Bids mapping to get bidder details>>>>
    
//     //approve Bids
//   function approveBids(address _addressToApprove) public{
//     require(reqStatus[msg.sender] == Status.bidSubmitted,"no submiited req to join ride by this user");
//         if(bidderAddressesList.exists(_addressToApprove)){
//             approvedAddressesList.pushAddress(_addressToApprove);
//             Bids[_addressToApprove].accepted = true;
            
//      bidStatus = Status.bidApproved;
//      reqStatus[msg.sender] = bidStatus;
     
     
//         }
//     }
//     //rejec Bids
//     function rejectBids(address _removeAddress) public {
//     require(reqStatus[msg.sender] == Status.bidSubmitted &&
//             reqStatus[msg.sender] != Status.bidApproved,"req is not submitted or approved");
            
//     if(bidderAddressesList.exists(_removeAddress)){
//         bidderAddressesList.removeAddress(_removeAddress);
        
//     bidStatus = Status.bidRejected;
//     reqStatus[msg.sender] = bidStatus;
    
//     delete Bids[_removeAddress];
//     }
//     }
    
//     //approved 
//     function getApprovedBidAddresses() public view returns(uint256,address[] memory){
         
//         return (approvedAddressesList.size() ,approvedAddressesList.getAllAddresses());
//         }
  
//   // called by passenger
//   function joinRide(uint rideNumber) public payable {
//     require(reqStatus[msg.sender] == Status.bidApproved,"your request to join ride ride should be approved by driver");
//     Ride storage curRide = rides[rideNumber];
//     require(msg.value == curRide.drivingCost,"value must be equal to driving cost");
//     if(approvedAddressesList.exists(msg.sender)){
//         Passenger storage passenger = curRide.passengers[msg.sender];    
        
//         passenger.price = msg.value;
//         passenger.state = "initial";
        
//         rides[rideNumber].passengerAccts.push(msg.sender) -1; //***
        
//         approvedAddressesList.removeAddress(msg.sender);
        
//         delete Bids[msg.sender];
        
//     }
//          delete Bids[msg.sender];
//     }
  
//   function getPassengers(uint rideNumber) view public returns(address[] memory) {
//     return rides[rideNumber].passengerAccts;
//   }

//   function getPassengerRideState(uint rideNumber, address passenger) view public returns(string memory) {
//     return rides[rideNumber].passengers[passenger].state;
//   }

//   function getRide(uint rideNumber) public view returns (
//     address _driver,
//     uint _drivingCost,
//     uint _capacity,
//     string memory _originAddress,
//     string memory _destAddress,
//     uint _createdAt,
//     uint _confirmedAt,
//     uint _destinationDate,
//     uint _departureTime,
//     uint _arrivaltime
//   ) {
//     Ride memory ride = rides[rideNumber];
//     return (
//       ride.driver,
//       ride.drivingCost,
//       ride.capacity,
//       ride.originAddress,
//       ride.destAddress,
//       ride.createdAt,
//       ride.confirmedAt,
//       ride.destinationDate,
//       ride.departureTime,
//       ride.arrivaltime
      
//     );
//   }

//   function getRideCount() public view returns(uint) {
//     return rides.length;
//   }
  
//   function passengerInRide(uint rideNumber, address passengerAcct) public view returns (bool) {
//     Ride storage curRide = rides[rideNumber];
//     for(uint i = 0; i < curRide.passengerAccts.length; i++) {
//       if (curRide.passengerAccts[i] == passengerAcct) {
//         return true;
//       }
//     }
//     return false;
//   }
  
//   function cancelRide(uint rideNumber) public{
//     Ride storage curRide = rides[rideNumber];
//     require(block.timestamp < curRide.confirmedAt);
//     //
//     // DriverRides memory dRides;
   
//     if (msg.sender == curRide.driver) {
//       for (uint i = 0; i < curRide.passengerAccts.length; i++) {
//        // curRide.passengerAccts[i].transfer(curRide.passengers[curRide.passengerAccts[i]].price);
//         address(uint160(curRide.passengerAccts[i])).transfer(curRide.passengers[curRide.passengerAccts[i]].price);
//         //
//         if(DRides[msg.sender].cancelledRides >0){DRides[msg.sender].cancelledRides--;}
//         // DRides[msg.sender].cancelledRides--;
//       }
//     } else if (passengerInRide(rideNumber, msg.sender)) {
//       msg.sender.transfer(curRide.passengers[msg.sender].price);
//       //
//       if(DRides[msg.sender].cancelledRides >0){DRides[msg.sender].cancelledRides--;}
//     }
    
//   }

//   // called by passenger
//   function confirmDriverMet(uint rideNumber) public {
//     require(reqStatus[msg.sender] == Status.bidApproved,"please send req first to join");
//     require(passengerInRide(rideNumber, msg.sender));
//     Ride storage curRide = rides[rideNumber];
//     // uint(keccak256(abi.encodePacked(source))); was in 0.4.0
//     if (keccak256(abi.encodePacked(curRide.passengers[msg.sender].state)) == keccak256("passengersConfirmed")) {
//       curRide.passengers[msg.sender].state = "enRoute";
//     } else {
//       curRide.passengers[msg.sender].state = "driverConfirmed";
//     }
//     delete Bids[msg.sender];
//   }
  
//   // called by driver
//   function confirmPassengersMet(uint rideNumber, address[] memory passengerAddresses)  public {
//     Ride storage curRide = rides[rideNumber];
//     require(msg.sender == curRide.driver);
//     // DriverRides memory dRides;
    
//     for(uint i=0; i < passengerAddresses.length; i++) {
//       //string memory curState = curRide.passengers[passengerAddresses[i]].state;
//       if (keccak256(abi.encodePacked(curRide.passengers[passengerAddresses[i]].state)) == keccak256("driverConfirmed")) {
//         curRide.passengers[passengerAddresses[i]].state = "enRoute";
//         DRides[msg.sender].totalRides++;
//       } else {
//         curRide.passengers[passengerAddresses[i]].state = "passengersConfirmed";
//       }
//     }
//     // require(rides[rideNumber].state == "confirmed");
//   }
   
//   function enRouteList(uint rideNumber) public returns(address[] memory) {
//     Ride storage curRide = rides[rideNumber];
//     //for version 5x
//     address[] memory tempAddressesEnRoute;
//     addressesEnRoute = tempAddressesEnRoute;
//     for(uint i = 0; i < curRide.passengerAccts.length; i++) {
//       if (keccak256(abi.encodePacked(curRide.passengers[curRide.passengerAccts[i]].state)) == keccak256("enRoute")) {
//         addressesEnRoute.push(curRide.passengerAccts[i]);
//       }
//     }
//   }
  
//   // called by passenger
//   function arrived(uint rideNumber) public returns(uint256) {
//     require(reqStatus[msg.sender] == Status.bidApproved,"please send req first to join ride");
//     require(passengerInRide(rideNumber, msg.sender));
//     Ride storage curRide = rides[rideNumber];
//     address(uint160(curRide.driver)).transfer(curRide.passengers[msg.sender].price);
//     curRide.passengers[msg.sender].state = "completion";
    
//     DRides[curRide.driver].totalEarning += curRide.drivingCost;
    
//     return curRide.drivingCost;
    
//   }
  
//   //filters by origin
//   function filterByOrigin() public{
      
//   }
//   //filter by destinationDate
//   function filtetbyDestinationDate() public {
      
//   }
//   //filter by time of departureTime
//   function filterByTimeOfDeparture() public {
      
//   }
  
//   //filter by arrival time
//   function filterByArrivalTime() public{
      
//   }
  
// }
