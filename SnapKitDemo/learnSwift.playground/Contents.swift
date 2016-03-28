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
*/

/*
之前的enumeration能存储不同类型的值声明，作为另一种关联值，enumeration 能预先计算同类型的默认值


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
*/

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


var address0 = (742, "Evergreen Terrace")
print(address0.0)
print(address0.1)


var address: (Int, String) = (742, "Evergreen Terrace")
var address1: (Double, String) = (742, "Evergreen Terrace")
var address2 = (Double(742), "Evergreen Terrace")
var address3 = (742.0, "Evergreen Terrace")

let (house, street) = address
print(house)
print(street)

var addressFinal:(number:Int, street:String) = (72, "Evergreen Terrace")
print(addressFinal.number)
print(addressFinal.street)

let greeting = "Swift by Tutorials Rocks"

for i in 1...5 {
    print("\(i) - \(greeting)")
}

//var range = 1...5
var range = Range(start: 1, end: 6)
for i in range{
    print("\(i) = \(greeting)")
}

for i in "swift".unicodeScalars {
    print("\(i)")
}


var direction = "up"
switch direction {
    case "down" :
    print("going down")
    case "up":
    print("going up")
default:
    print("going nowhere")
}

switch direction {
    case "down", "up":
    print("go somewhere")
default:
    print("go nowhere")
}

var arr_int = [1, 2, 3, 4, 5, 6, 7, 8, 9]
for (var i=1; i<arr_int.count; i++){
    arr_int.removeAtIndex(i)
}

print(arr_int)

var str:String? = "Hello Swift by Tutorials"
str = str?.uppercaseString


var dictionaryA = [1:1, 2:4, 3:9, 4:16]
var dictionaryB = dictionaryA

print(dictionaryA)
print(dictionaryB)

dictionaryB[4] = nil
print(dictionaryA)
print(dictionaryB)

var constantArray = [4, 3, 6, 1, 2, 3, 4, 5]

var dictionaryC = ["aa": "AA", "bb": "BB"]

constantArray.insert(10, atIndex: constantArray.count)


let arrInt = [1, 2, 3, 4, 5, 6]
let arrString = arrInt.map(){ "\($0) --" }
print(arrString)

let oddInt = arrInt.filter({ $0 > 2})
print(oddInt)

let sum = arrInt.reduce(1, combine: {$0+$1})
print(sum)

func addOne(val : Float) -> Float{
    return val+1;
}

func applyTwice(f:((Float) -> Float), x:Float) -> Float{
    return f(f(x))
}

let res = applyTwice({ $0+1 }, x: 0)
print(res)

/*
func applyKTimes(f:(Float->Float), x:Float, k:Int) -> Float{
    var result = x
    for _ in 0..<k {
        result = f(result)
    }
    return result
}
*/

func applyKTimes<T>(f:T->T, x:T, k:Int) -> T{
    var res = x
    for _ in 1..<k {
        res = f(res)
    }
    return res
}

let apply_res = applyKTimes({$0*2}, x: 2, k: 4)
print(apply_res)

struct User{
    var name: String
    var age: Int
}

let user_arr = [User(name: "peer", age: 11), User(name: "aaa", age: 13), User(name: "ben", age: 22)]

let user_map = ["peer":11, "aaa":13, "ben":22];
let user_create_arr = user_map.map { (name, age) -> User in
    return User(name: name, age: age)
}

let user_names = user_create_arr.map { (user) -> String in
    return user.name
}

print(user_names)

let filter_odd = arrInt.filter { $0%2==1 }
print(filter_odd)

let int_strings = ["11", "aa", "22", "1eg", "33"]
/*
let filter_int = int_strings.filter { (string) -> Bool in
    return Int(string) != nil
}
*/

let reduce_strings = int_strings.reduce("") { $0+$1+"\n" }
print(reduce_strings)

var find_largest = [4, 3, 6, 1, 2, 3, 4, 5, 1]
let largest = find_largest.reduce(find_largest[0]){ max($0, $1) }
print(largest)


var array = [1, 2, 3, 4, 5, 6]
var mean = array.reduce(0, combine: { $0 + Float($1)/Float(array.count)})
print(mean)

var sub_array = array[3...array.count-1]
print(sub_array)


class Person{
    var name: String {
        didSet{
            self.greeting = "Hello, \(self.name)"
        }
    }
    lazy var greeting: String = {
        [unowned self] in
        return "hello, \(self.name)"
    }()
    
    init(name: String){
        self.name = name
    }
}

var p = Person(name: "WHY")
p
p.greeting

class Time{
    var seconds: Double = 0
    
    init(seconds: Double){
        self.seconds = seconds
    }
    
    var minutes: Double{
        get {
            return (seconds/60)
        }
        set {
            self.seconds = newValue * 60
        }
    }
}

class A{}
class B : A{}
class C : A{}

var array_obj = [B(), A(), C(), A()]

for item in array_obj{
    if item is B {
        print("B")
    }
    if item is C {
        print("C")
    }
    if item is A {
        print("C")
    }
}

protocol FullyNamed{
    var fullName: String {get}
}

struct PersonFull: FullyNamed {
    var fullName: String
}

var john = PersonFull(fullName: "WHY")
john.fullName = "WHY"

let none_a = Optional<Int>.None

enum Barcode{
    case UPCA(Int, Int, Int, Int)
    case QRCode(String)
}

var productBarcode = Barcode.UPCA(8, 85909, 51226, 3)
productBarcode = .QRCode("ABCDEFGHIJKLMNOP")

switch productBarcode{
case Barcode.UPCA(let numberSystem, let manufacture, let product, let check):
    print("UPC-A: \(numberSystem), \(manufacture), \(product), \(check)")
case Barcode.QRCode(let productCode):
    print("QR code: \(productCode).")
}




















