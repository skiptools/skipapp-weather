import Foundation

// A sample app model
public class Stuff {
    public var title = "Ahoy, Skipper!"
    public var things: [Thing] = []

    public init() {
        things.append(Thing(string: "Thing One", number: 1.1))
        things.append(Thing(string: "Thing Two", number: 2.2))
        things.append(Thing(string: "Thing Three", number: 3.3))
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
