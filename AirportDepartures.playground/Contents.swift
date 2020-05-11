import UIKit


//: ## 1. Create custom types to represent an Airport Departures display
//: ![Airport Departures](matthew-smith-5934-unsplash.jpg)
//: Look at data from [Departures at JFK Airport in NYC](https://www.airport-jfk.com/departures.php) for reference.
//:
//: a. Use an `enum` type for the FlightStatus (En Route, Scheduled, Canceled, Delayed, etc.)
//:
//: b. Use a struct to represent an `Airport` (Destination or Arrival)
//:
//: c. Use a struct to represent a `Flight`.
//:
//: d. Use a `Date?` for the departure time since it may be canceled.
//:
//: e. Use a `String?` for the Terminal, since it may not be set yet (i.e.: waiting to arrive on time)
//:
//: f. Use a class to represent a `DepartureBoard` with a list of departure flights, and the current airport

enum FlightStatus: String {
    case enRoute = "En Route" // raw value
    case scheduled = "Scheduled" // raw value
    case canceled = "Canceled" // raw value
    case delayed = "Delayed" // raw value
    case boarding = "Boarding" // raw value
}

struct Airport {
    let destination: String
//    let arrival: String
}

struct Flight {
    var departureTime: Date?
    var terminal: String?
    var airFlightNumber: String // added in
    var status: FlightStatus // added in
}

class DepartureBoard {
    var departureFlights: [Flight]
    let currentAirport: Airport
    init(departureFlights: [Flight], currentAirport: Airport) {
        self.departureFlights = departureFlights
        self.currentAirport = currentAirport
    }
    func printAlert() {
        for flight in self.departureFlights {
            switch flight.status {
            case .canceled:
                print("We're sorry your flight to \(self.currentAirport.destination) was cancelled, here is a $500 voucher")
            case .scheduled:
                var departureValue: String
                var terminalValue: String
                if flight.departureTime != nil || flight.terminal != nil {
                    if let unwrappedDepartureTime = flight.departureTime {
                        let dateFormat = DateFormatter()
                        dateFormat.dateFormat = "yyyy/MM/dd HH:mm"
                        departureValue = dateFormat.string(from: unwrappedDepartureTime)
                    } else {
                        departureValue = "TBD"
                    }
                    if let unwrappedTerminal = flight.terminal {
                        terminalValue = unwrappedTerminal
                    } else {
                        terminalValue = "TBD"
                    }
                    print("Your flight to \(self.currentAirport.destination) is scheduled to depart at: \(departureValue) from terminal: \(terminalValue)")
                } else {
                    print("Your flight to \(self.currentAirport.destination) is scheduled however departure time and terminal information is TBD")
                }
            case .boarding:
                if let unwrappedTerminal = flight.terminal {
                    print("Your flight is boarding, please head to terminal: \(unwrappedTerminal) immediately. The doors are closing soon")
                } else {
                    print("Your flight is boarding, please see nearest information desk for more details")
                }
            case .enRoute:
                print("Your flight is currently in route to \(self.currentAirport.destination), if you have missed your flight, please see nearest information desk to reschedule")
            case .delayed:
                print("Your flight to \(self.currentAirport.destination) is delayed, please wait for flight departure time and terminal information to update")
            }
        }
    }
}

//: ## 2. Create 3 flights and add them to a departure board
//: a. For the departure time, use `Date()` for the current time
//:
//: b. Use the Array `append()` method to add `Flight`'s
//:
//: c. Make one of the flights `.canceled` with a `nil` departure time
//:
//: d. Make one of the flights have a `nil` terminal because it has not been decided yet.
//:
//: e. Stretch: Look at the API for [`DateComponents`](https://developer.apple.com/documentation/foundation/datecomponents?language=objc) for creating a specific time

// create airport to assign to departure board
let jfkAirport = Airport(destination: "laxAirport")
// create dashboard to add flights to departure flights
let jfkDepartureBoard = DepartureBoard(departureFlights: [], currentAirport: jfkAirport)
// setup date format to create specific date
let dateFormat = DateFormatter()
dateFormat.dateFormat = "yyyy/MM/dd HH:mm"
let jfkDTime1 = dateFormat.date(from: "2020/05/01 23:11")
let jfkDTime2 = dateFormat.date(from: "2020/05/02 06:20")
// date = Date() for current time
// create 3 flights
let flightJFK1 = Flight(departureTime: jfkDTime1, terminal: "5", airFlightNumber: "American Airlines: AA220", status: .boarding)
let flightJFK2 = Flight(departureTime: jfkDTime2, terminal: nil, airFlightNumber: "American Airlines: AA330", status: .scheduled)
let flightJFK3 = Flight(departureTime: nil, terminal: "2", airFlightNumber: "JetBlue Airways: JB123", status: .canceled)
// add flights to departure board
jfkDepartureBoard.departureFlights.append(contentsOf: [flightJFK1, flightJFK2, flightJFK3])

//: ## 3. Create a free-standing function that can print the flight information from the `DepartureBoard`
//: a. Use the function signature: `printDepartures(departureBoard:)`
//:
//: b. Use a `for in` loop to iterate over each departure
//:
//: c. Make your `FlightStatus` enum conform to `String` so you can print the `rawValue` String values from the `enum`. See the [enum documentation](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html).
//:
//: d. Print out the current DepartureBoard you created using the function

// make flight status enum have raw values of string
// create function to print departure board
func printDepartures(departureBoard: DepartureBoard) {
    for flight in departureBoard.departureFlights {
        print("jfkAirport -> Destination: \(departureBoard.currentAirport.destination) / Flight: \(flight.airFlightNumber) / Departure Time: \(flight.departureTime) / Teminal: \(flight.terminal) / Status: \(flight.status.rawValue)")
    }
}
// print current departure board using function
//printDepartures(departureBoard: jfkDepartureBoard) // bad implementation no optional binding

//: ## 4. Make a second function to print print an empty string if the `departureTime` is nil
//: a. Createa new `printDepartures2(departureBoard:)` or modify the previous function
//:
//: b. Use optional binding to unwrap any optional values, use string interpolation to turn a non-optional date into a String
//:
//: c. Call the new or udpated function. It should not print `Optional(2019-05-30 17:09:20 +0000)` for departureTime or for the Terminal.
//:
//: d. Stretch: Format the time string so it displays only the time using a [`DateFormatter`](https://developer.apple.com/documentation/foundation/dateformatter) look at the `dateStyle` (none), `timeStyle` (short) and the `string(from:)` method
//:
//: e. Your output should look like:
//:
//:     Destination: Los Angeles Airline: Delta Air Lines Flight: KL 6966 Departure Time:  Terminal: 4 Status: Canceled
//:     Destination: Rochester Airline: Jet Blue Airways Flight: B6 586 Departure Time: 1:26 PM Terminal:  Status: Scheduled
//:     Destination: Boston Airline: KLM Flight: KL 6966 Departure Time: 1:26 PM Terminal: 4 Status: Scheduled

func printDepartures2(departureBoard: DepartureBoard) {
    var flightString: String = ""
    for flight in departureBoard.departureFlights {
        flightString = flightString + "jfkAirport -> Deistination: \(departureBoard.currentAirport.destination) / Flight: \(flight.airFlightNumber) / "
        if let unwrappedDepartureTime = flight.departureTime {
            flightString = flightString + "Departure Time: \(unwrappedDepartureTime) / "
        } else {
            flightString = flightString + "Departure Time: / "
        }
        if let unwrappedTerminal = flight.terminal {
            flightString = flightString + "Terminal: \(unwrappedTerminal) / "
        } else {
            flightString = flightString + "Terminal: / "
        }
        flightString = flightString + "Status: \(flight.status.rawValue)"
        print(flightString)
        flightString = ""
    }
}
printDepartures2(departureBoard: jfkDepartureBoard)

//: ## 5. Add an instance method to your `DepatureBoard` class (above) that can send an alert message to all passengers about their upcoming flight. Loop through the flights and use a `switch` on the flight status variable.
//: a. If the flight is canceled print out: "We're sorry your flight to \(city) was canceled, here is a $500 voucher"
//:
//: b. If the flight is scheduled print out: "Your flight to \(city) is scheduled to depart at \(time) from terminal: \(terminal)"
//:
//: c. If their flight is boarding print out: "Your flight is boarding, please head to terminal: \(terminal) immediately. The doors are closing soon."
//:
//: d. If the `departureTime` or `terminal` are optional, use "TBD" instead of a blank String
//:
//: e. If you have any other cases to handle please print out appropriate messages
//:
//: d. Call the `alertPassengers()` function on your `DepartureBoard` object below
//:
//: f. Stretch: Display a custom message if the `terminal` is `nil`, tell the traveler to see the nearest information desk for more details.

jfkDepartureBoard.printAlert()


//: ## 6. Create a free-standing function to calculate your total airfair for checked bags and destination
//: Use the method signature, and return the airfare as a `Double`
//:
//:     func calculateAirfare(checkedBags: Int, distance: Int, travelers: Int) -> Double {
//:     }
//:
//: a. Each bag costs $25
//:
//: b. Each mile costs $0.10
//:
//: c. Multiply the ticket cost by the number of travelers
//:
//: d. Call the function with a variety of inputs (2 bags, 2000 miles, 3 travelers = $750)
//:
//: e. Make sure to cast the numbers to the appropriate types so you calculate the correct airfare
//:
//: f. Stretch: Use a [`NumberFormatter`](https://developer.apple.com/documentation/foundation/numberformatter) with the `currencyStyle` to format the amount in US dollars.

let currencyFormatter = NumberFormatter()
currencyFormatter.usesGroupingSeparator = true
currencyFormatter.numberStyle = .currency
currencyFormatter.locale = Locale.current
//func totalAirfair(checkedBags: Int, distance: Int, travelers: Int) -> Double {
func totalAirfair(checkedBags: Int, distance: Int, travelers: Int) -> String {
    let totalBagCost: Double = 25.0 * Double(checkedBags)
    let ticketCost: Double = 0.10 * Double(distance)
    let totalTicketCost: Double = ticketCost * Double(travelers)
//    return totalBagCost + totalTicketCost
    let total: Double = totalBagCost + totalTicketCost
    let cost = currencyFormatter.string(from: NSNumber(value: total))
    if let unwrappedCost = cost {
        return unwrappedCost
    } else {
        return "Cost unknown"
    }
}

print(totalAirfair(checkedBags: 5, distance: 2000, travelers: 3))
print(totalAirfair(checkedBags: 2, distance: 25000, travelers: 5))
print(totalAirfair(checkedBags: 5, distance: 16000, travelers: 1))
