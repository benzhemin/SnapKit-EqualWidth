//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

func returnFifteen() -> Int{
    var y = 10
    func add(){
        y += 5
    }
    
    add()
    
    return y
}
returnFifteen()

func hasAnyMatches(list:[Int], condition:(Int)->Bool) -> Bool {
    for elem in list {
        if condition(elem) {
            return true
        }
    }
    return false
}

var numbers = [20, 19, 7, 12]

hasAnyMatches(numbers) { (num) -> Bool in
    return num < 10
}

print(numbers.map { $0*2 })

enum Rank : Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
    func simpleDescription() -> String{
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

enum Suit {
    case Spades, Hearts, Diamonds, Clubs
    
    func simpleDescription() -> String{
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        
        }
    }
}

struct Card {
    var rank: Rank
    var suit: Suit
    
    func simpleDescription() -> String{
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())"
    }
}

let threeOfSpades = Card(rank: .Three, suit: .Spades)
let threeOfSpadesDescription = threeOfSpades.simpleDescription()

protocol ExampleProtocol {
    var simpleDescription: String {get}
    mutating func adjust()
}

extension Int: ExampleProtocol {
    var simpleDescription : String {
        return "The number \(self)"
    }
    
    mutating func adjust() {
        self += 42
    }
}

print(7.simpleDescription)

enum PrinterError: ErrorType {
    case OutOfPaper
    case NoToner
    case OnFire
}

func sendToPrinter(printerName: String) throws -> String {
    if printerName != "Never Has Toner" {
        throw PrinterError.NoToner
    }
    return "Job sent"
}

do {
    let printerResponse = try sendToPrinter("Bi Sheng")
    print(printerResponse)
} catch{
    print(error)
}

extension Int {
    func repetitions(task:()->()){
        for _ in 1...self {
            task()
        }
    }
    
    subscript(digitIndex:Int) -> Int {
        var base = 1
        for _ in 0..<digitIndex {
            base = base * 10
        }
        
        return (self/base) % 10
    }
}

3.repetitions { 
    print("Hello")
}

123456789[0]
123456789[1]

extension Int {
    enum Kind {
        case Zero, Positive, Negative
    }
    
    var kind: Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
}
1.kind
(-1).kind


protocol Container {
    associatedtype ItemType
    
    mutating func append(item: ItemType)
    var count : Int { get }
    
    subscript(i:Int) -> ItemType { get }
}

struct GenericStack <Element> : Container {
    var items = [Element]()
    
    mutating func push(item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element {
        return items.removeLast()
    }
    
    //typealias ItemType = Int
    
    mutating func append(item: Element) {
        self.push(item)
    }
    
    var count : Int {
        return items.count
    }
    
    subscript(i:Int) -> Element{
        return items[i]
    }
}

extension Array : Container {}

func deferTest() -> Int{
    defer {
        print("hello defer")
    }
    return 1
}

print(deferTest())

protocol DoubleInitProtocol {
    init(_ param: Double)
}

func sign<T: protocol<Comparable, DoubleInitProtocol> >(value:T) -> T{
    if value < T(0.0) {
        return T(-1.0)
    }
    if value > T(0.0) {
        return T(1.0)
    }
    return T(0.0)
}

extension Double : DoubleInitProtocol{}

sign(2.0)






















