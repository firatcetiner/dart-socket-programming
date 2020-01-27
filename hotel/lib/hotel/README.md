## Hotel API

Hotel Server's configuration is separated as 3 parts: HotelChannel, HotelController, HotelAPI.

## HotelChannel

HotelChannel will establish an initial connection to the database, then it will generate a special route for TravelAgency to make HTTP calls. A Router object is responsible for creating all the routes. 
Each route may be linked a special function.

## HotelController

The HotelController class is where we keep our linked functions together, those functions will be called when an HTTP request is came up tot the server.
