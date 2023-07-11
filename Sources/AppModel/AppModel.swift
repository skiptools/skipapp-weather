import Foundation

// A sample app model
public class Stuff {
    public var title = "Ahoy, Skipper!"
    public var things: [Thing] = []

    public init() {
        things.append(Thing(string: "App Success Checklist", number: 0.0))
    }
}

public struct Thing : Codable {
    public let string: String
    public let number: Double

    public init(string: String, number: Double) {
        self.string = string
        self.number = number
    }
}

public extension Stuff {
    /// The list of things needed for building a successful app
    static let allThings: [Thing] = [
        Thing(string: "Build Requirements", number: 10.0),
        Thing(string: "Design User Experience", number: 20.0),
        Thing(string: "Evaluate Technologies", number: 30.0),
        //Thing(string: "Choose Skip", number: 100.0),
        Thing(string: "Develop App", number: 40.0),
        Thing(string: "Setup Continuous Integration", number: 50.0),
        Thing(string: "Deploy App Beta", number: 60.0),
        Thing(string: "Fix Bugs", number: 70.0),
        Thing(string: "Iterate on Features", number: 80.0),
        //Thing(string: "XXX", number: 100.0),
    ]

}
