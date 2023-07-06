
public struct Thing : Codable {
    public let string: String
    public let number: Double

    public init(string: String, number: Double) {
        self.string = string
        self.number = number
    }
}
