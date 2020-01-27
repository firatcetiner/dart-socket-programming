# dart-socket-programming
Simple implementations of Application and Transport Layer protocols: HTTP and TCP with Dart programming language (Flutter & Dart), Aqueduct Framework and PostgreSQL.

## How does it work?
Since we are dealing with a 3-Tier-Architecture, there are 3 sides of the project: Client, Server, Database.

The client in this project is a mobile application, which is build with Flutter framework. 
On the back-end side of the project, we have a TravelAgency that maintains the communication between the Client and the Database.
The idea is simple: The data flow between the Client and Database must be implemented as basic samples of TCP and HTTP. Client and TravelAgency are communicating with only and only TCP. 
The TravelAgency acquire the data from the Database by using several HTTP calls. 

The PostgreSQL databases (3) are hold the neccessary information about Hotels and Airlines.

## The Flow
Below figure demonstrates the data flow between Client, Servers and Databases.
![alt text](https://i.imgur.com/UP9D8BR.png)
