import Foundation

// A sample app model
public class Stuff {
    public var title = "Ahoy, Skipper!"
    public var things: [Thing] = []

    public init() {
        things.append(Thing(string: "App Success Checklist", number: 0.0))
    }

    public static let allThings: [Thing] = [
        Thing(string: "Build Requirements", number: 100.0),
        Thing(string: "Design User Experience", number: 100.0),
        Thing(string: "Evaluate Technologies", number: 100.0),
        //Thing(string: "Choose Skip", number: 100.0),
        Thing(string: "Develop App", number: 100.0),
        Thing(string: "Setup Continuous Integration", number: 100.0),
        Thing(string: "Deploy App Beta", number: 100.0),
        Thing(string: "Fix Bugs", number: 100.0),
        Thing(string: "Iterate on Features", number: 100.0),
        //Thing(string: "XXX", number: 100.0),
    ]
}

public struct Thing : Codable {
    public let string: String
    public let number: Double

    public init(string: String, number: Double) {
        self.string = string
        self.number = number
    }
}
