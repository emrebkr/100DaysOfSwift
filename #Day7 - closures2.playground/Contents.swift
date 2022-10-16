import UIKit

var greeting = "Hello, playground"

/* Using closures as parameters when they accept parameters */

func travel(action: (String) -> Void) {
    print("I'm getting ready to go.")
    action("London")
    print("I arrived!")
}

travel { (place: String) in
    print("I'm going to \(place) in my car")
}

/* Using closures as parameters when they return values */

func travel1(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}

travel1 { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

/* Shorthand parameter names */

func travel(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}
/*
travel { (place: String) -> String in
    return "I'm going to \(place) in my car"
}
travel { place -> String in
    return "I'm going to \(place) in my car"
}
travel { place in
    return "I'm going to \(place) in my car"
}
travel { place in
    "I'm going to \(place) in my car"
}
 */

travel {
    "I'm going to \($0) in my car"
}
