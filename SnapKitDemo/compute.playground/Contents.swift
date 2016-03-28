//: Playground - noun: a place where people can play

import Cocoa

//将数组先按出现次数排，次数相同的按大小排
var a = [1, 2, 2, 3, 5, 5]

var dict = [Int: Int]()
a.map { (key) -> Void in
    if let value = dict[key] {
        dict[key] = value + 1
    }else{
        dict[key] = 1
    }
}

var pair_array = [(Int, Int)]()
for (key, val) in dict{
    pair_array.append((key, val))
}

pair_array.sort {
    if $0.1 > $1.1 {
        return true
    }else if $0.1 == $1.1 {
        if $0.0 > $1.0 {
            return true
        }
    }
    return false
}

print(pair_array)

var res = [Int]()
pair_array.map { (a:Int, b:Int) -> Void in
    for _ in 1...b {
        res.append(a)
    }
}

print(res)

func memoize<T: Hashable, U>( body: (T)->U ) -> (T->U) {
    var memo = Dictionary<T, U>()
    return { x in
        if let q = memo[x] { return q }
        let r = body(x)
        memo[x] = r
        return r
    }
}

let array = [1, 2, 6, 3, 4, 5]
print(array.map({$0*2}))

let arr_reduce = array.reduce([]) { (a:[Int], element:Int) -> [Int] in
    var arr = Array(a)
    arr.append(element*2)
    return arr
}
print(arr_reduce)

let max = array.reduce(array[0]) { (last, element) -> Int in
    return element>last ? element : last
}
print(max)

let (oddsum, evenmulti) = array.reduce((0, 1)) { (last, element) -> (Int, Int) in
    if element % 2 == 0 {
        return (last.0, last.1*element)
    }else {
        return (last.0+element, last.1)
    }
}
print("oddsum:\(oddsum), evenmulti:\(evenmulti)")

let sum = array.filter { (elem) -> Bool in
    return elem % 2 == 0
}.reduce(0) { (sum, element) -> Int in
    return sum + element*element
}
4+36+16
print("sum:\(sum)")

let sum2 = array.reduce(0) { (sum, elem) -> Int in
    if elem%2 == 0{
        return sum + elem*elem
    }
    return sum
}
print("sum2:\(sum2)")

let sum3 = array.filter({$0%2==0}).map({$0 * $0}).reduce(0) {$0+$1}
print("sum3:\(sum3)")

let arr: [Int] = [1, 2, 4, 5]

print(Array(1...10).filter(){$0%2==0}.reduce(0, combine: {$0+$1}))

extension Array{
    func myReduce<T,U>(seed:U, combiner:(U,T)->U) -> U{
        var current = seed
        
        for item in self {
            current = combiner(current, item as! T)
        }
        
        return current
    }
}

typealias Entry = (Character, [String])

func buildIndex(words:[String]) -> [Entry]{
    
    var entryList = [Entry]()
    
    for word in words {
        let firstLetter = word.uppercaseString[word.startIndex]
        
        var find = false
        for (index, entry) in entryList.enumerate() {
            if firstLetter == entry.0 {
                find = true
                /*
                entry.1.append(word)
                //重点！！一定要记住值类型和引用类型
                //entry是值类型
                entryList[index] = entry
                */
                //优化
                entryList[index].1.append(word)
            }
        }
        
        if !find {
            let entry : (Character, [String]) = (firstLetter, [word])
            entryList.append(entry)
        }
    }
    
    return entryList
}

let words = ["Cat", "Chicken", "fish", "Dog", "Mouse", "Guinea Pig", "monkey"]
let entryList = buildIndex(words)
print(entryList)


let compute = words.reduce([]) { (var arr, word) -> [Character] in
    let letter = word.uppercaseString[word.startIndex]
    if !arr.contains(letter) {
        arr.append(letter)
    }
    return arr
}.map { (letter) -> Entry in
    return (letter, words.filter({ (word) -> Bool in
        return word.uppercaseString[word.startIndex] == letter
    }))
}

print(compute)


func myFilter<T>(source: [T], predicate:(T) -> Bool) -> [T] {
    var result = [T]()
    for i in source {
        if predicate(i) {
            result.append(i)
        }
    }
    return result
}

var product1: [String: Any] = ["name": "milk", "price": 3.2]
var product2: [String: Any] = ["name": "bread", "price": 2.9]
var product3: [String: Any] = ["name": "meat", "price": 4.1]
var product4: [String: Any] = ["name": "sweets", "price": 1.0]

var products = [product1, product2, product3, product4]
let sortedProducts = products.sort { (A, B) -> Bool in
    let priceA = A["price"] as! Double
    let priceB = B["price"] as! Double
    
    return priceA < priceB
}

let priceArray = sortedProducts.map { (product) -> Double in
    return product["price"] as! Double
}
print(priceArray)

let nameArray = sortedProducts.map { (product) -> String in
    return product["name"] as! String
}
print(nameArray)


func count(string:String) -> String.Index.Distance{
    return string.characters.count
}

let anotherwords = ["chick", "fish", "cat", "elephant"]
let longest = anotherwords.reduce("") { (last, current) -> String in
    if count(current) > count(last) {
        return current
    }
    return last
}
print(longest)

enum Shape: Int{
    case Rectangle
    case Square
    case Triangle
    case Circle
}

var triangle = Shape.Triangle
triangle.rawValue

enum ComplexShape {
    case Rectangle(Float, Float)
    case Square(Float)
    case Triangle(Float, Float)
    case Circle(Float)
}

var rectangle = ComplexShape.Rectangle(5, 10)

switch (rectangle) {
case .Rectangle(let width, let height) where width <= 10:
    print("Narrow rectangle: \(width) x \(height)")
case .Rectangle(let width, let height):
    print("Wide rectangle: \(width) x \(height)")
default:
    print("other shape")
}

let json = "{\"success\":true,\"data\":{\"numbers\":[1,2,3,4,5],\"animal\":\" dog\"}}"

let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding)

//enum 已经成了类型匹配的利器，尤其是一个值存在多种类型的时候

protocol MyFloats : Comparable {
    init(_ value: Double)
}

extension Double: MyFloats{}
extension Float : MyFloats{}

func sign<T: MyFloats>(value: T) -> T{
    if value < T(0.0) {
        return T(-1.0)
    }
    return T(0.0)
}

protocol CustomProtocol{
    init()
}

struct CustomStruct : CustomProtocol {
    init(){
        print("hello")
    }
}

let cs = CustomStruct()

class A {}
let aclass = A.self





















