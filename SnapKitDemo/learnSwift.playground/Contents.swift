//: Playground - noun: a place where people can play

import UIKit

//通过类型推断识别出类型，然后调用对应类型的初始化构造器对变量进行初始化
var tmpInteger = 12
tmpInteger.bigEndian
tmpInteger.littleEndian

// <==>
var tmpInteger2 = Int(12)
tmpInteger.bigEndian
tmpInteger.littleEndian

//Int Float Bool Character

//swift 使用值传递作为默认字符串拷贝方式
//编译时进行优化

//可选绑定：
// type? <==> Optional<type>

var optionalValue : Optional<Int>

if var maxVal = optionalValue {
    maxVal += 1
    print("max value:\(maxVal)")
}

//隐式解析可选
// type! <==> ImplicitlyUnwrappedOptional<type>

var implicitUnwrappedString : String!
var implicitUnwrappedString2 : ImplicitlyUnwrappedOptional<String>

let (appType, appName) = ("game", "2048")
let myProject = (oneElement:"game", twoElement:2048)

print("tuple: \(appType), \(appName)")
print("myProject: \(myProject.oneElement), \(myProject.twoElement)")

func tupleReturn() -> (first:String, sec:Int){
    return ("hello", 2)
}

let tuple = tupleReturn()
print("func \(tuple.first), \(tuple.sec)")



enum CompassPoint{
    case North
    case South
    case East
    case West
}

var directionToHead = CompassPoint.West
directionToHead = .East

var direct: CompassPoint = .East


switch directionToHead {
case .North:
    print("north")
case .South:
    print("South")
case .East:
    print("East")
case .West:
    print("West")
}


enum PressType{
    case PressTypeTouch
    case PressTypeHit
}

/*
define an enumeration type called Barcode, which can take either a value of UPCA with an associated value of type (Int, Int, Int, Int), or a value of QRCode with an associated value of type String
*/

//swift的enum 更像 c 的union， 先进的是可以通过swicth，动态的知道类型信息，进入分支
//而C语音的union只能是开发者预定义
/*
eg:
struct structure{
    union un{
        int a,
        char *b
    },
    enum untype;
}

通过设定untype指定union的具体类型是什么，swift将这一过程隐藏简化
*/

/*
The different barcode types can be checked using a switch statement, as before.
This time, however, the associated values can be extracted as part of the switch statement. You extract each associated value as a constant or a variable for use within the switch case's body

swift 的enum要结合switch来解包
*/
enum Barcode{
    case UPCA(Int, Int, Int, Int)
    case QRCode(String)
}

var productBarcode = Barcode.UPCA(9, 8983, 88321, 8)
//productBarcode = .QRCode("ABCDEFGHIJKLMN")


switch productBarcode {
case .UPCA(let numberSystem, let manufacturer, let product, let check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case .QRCode(let productCode):
    print("QR code: \(productCode)")
}

//简化，不用每次都声明变量，将var 或let 提到前面
switch productBarcode {
case var .UPCA(numberSystem, manufacturer, product, check):
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
    numberSystem = 88822
    print("UPC-A: \(numberSystem), \(manufacturer), \(product), \(check).")
case let .QRCode(productCode):
    print("QR code: \(productCode)")
}


/*
之前的enumeration能存储不同类型的值声明，作为另一种关联值，enumeration 能预先计算同类型的默认值
*/

enum ASCIIControlCharacter: Character {
    case Tab = "\t"
    case LineFeed = "\n"
    case CarriageReturn = "\r"
}

/*
原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。
*/

/*
在使用原始值为整数或者字符串类型的枚举时，不需要显式地为每一个枚举成员设置原始值，Swift 将会自动为你赋值。

例如，当使用整数作为原始值时，隐式赋值的值依次递增1。如果第一个枚举成员没有设置原始值，其原始值将为0。
*/
enum Planet: Int{
    case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

//当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称。
enum CompassPointStringEnum: String{
    case North, South, East, West
}

let earthsOrder = Planet.Earth.rawValue
let sunsetDirection = CompassPointStringEnum.West.rawValue

//如果在定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法接收一个叫做rawValue的参数，参数类型即为原始值类型，返回值则是枚举成员或nil。

let possiblePlant = Planet(rawValue: 7)
let possiblePlant2 = Planet(rawValue: 9)

let positionToFind = 9

if let somePlanet = Planet(rawValue: positionToFind){
    switch somePlanet {
    case .Earth:
        print("Mostly hrmless")
    default:
        print("Not a safe place for humans")
    }
}else {
    print("There isn't a planet at position \(positionToFind)")
}

protocol ChageState{
    mutating func chageState()
}

enum LightState : ChageState{
    case LightStateOn
    case LightStateOff
    
    mutating func chageState() {
        switch self {
        case .LightStateOn:
            self = .LightStateOff
        
        case .LightStateOff:
            self = .LightStateOn
        }
    }
}

var currLightState = LightState.LightStateOn
currLightState.chageState()

class MyObject{
    var num = 0
}

var myObject = MyObject()
var a = [myObject]
var b = a

b.append(myObject)

myObject.num = 100
print(b[0].num)
print(b[1].num)

var someInts = [Int]()
someInts.append(3)

var threeDoubles = [Double](count: 3, repeatedValue: 9)
var anotherThreeDoubles = Array(count: 3, repeatedValue: 2.5)

var sixDoubles = threeDoubles + anotherThreeDoubles

var testArr = Array<String>()
var testArr2 = [String]()
testArr.append("aaa")
testArr.append("bbb")

var shoppingList : [String] = ["Eggs", "Milk"]

//create empty dict
var dict = Dictionary<Int, String>()
var dict2 = [Int:String]()


dict2[0] = "peer"
dict2[2] = "world"

for (key, val) in dict2{
    print("key: \(key), val:\(val)")
}

class ReverseGenerator : GeneratorType {
    typealias Element = Int
    
    var counter : Element
    
    init<T>(array:[T]){
        self.counter = array.count-1
    }
    
    init(start: Int){
        self.counter = start
    }
    
    func next() -> Element? {
        return self.counter < 0 ? nil : counter--
    }
}

struct ReverseSequence<T>: SequenceType {
    var array:[T]
    
    init(array: [T]){
        self.array = array
    }
    
    typealias Generator = ReverseGenerator
    func generate() -> Generator {
        return ReverseGenerator(array: self.array)
    }
}

let arr = [0, 1, 2, 3, 4]

for i in ReverseSequence(array: arr){
    print("index \(i) is \(arr[i])")
}

let string = "Hello World"
print(string.lowercaseString)

print(string.componentsSeparatedByString(" "))

let nsstring = string as NSString
print(nsstring.lastPathComponent)
print(nsstring.dynamicType)
print(string.dynamicType)

var emptyArr = [Int]()
var emptyDict = [String:Int]()
print(emptyArr.dynamicType)
print(emptyDict.dynamicType)

var anemptyArr : [Int] = []
var anemptyDict : [String: Int] = [:]
print(anemptyArr.dynamicType)
print(anemptyDict.dynamicType)
















































