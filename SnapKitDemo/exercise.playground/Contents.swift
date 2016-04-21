//: Playground - noun: a place where people can play

import Cocoa

/*
给定一个数组，输出一个二维数组，连续相同的数组组成子数组。
比如：
输入：[7, 7, 3, 2, 2, 2, 1, 7, 5, 5]
输出：[[7, 7], [3], [2, 2, 2], [1], [7], [5, 5]]
*/

_ = {() -> Void in
    var res = [[Int]]()
    let a = [7, 7, 3, 2, 2, 2, 1, 7, 5, 5]
    
    
    res.append(a.reduce([], combine: { (var arr, elem) -> [Int] in
        if !arr.isEmpty {
            if arr.last! == elem {
                arr.append(elem)
                return arr
            }else {
                res.append(arr)
                return [elem]
            }
        }
        return [elem]
    }))
    print(res)
    
    res = a.reduce([[Int]](), combine: { (var res, elem) -> [[Int]] in
        if res.isEmpty {
            res.append([elem])
        }else {
            if res.last?.last == elem {
                res[res.count-1].append(elem)
            }else {
                res.append([elem])
            }
        }
        return res
    })
    
    print(res)
}()

/*
先按出现的数目排，数目相同的按大小排
*/


_ = {() -> Void in
    let a = [7, 7, 3, 2, 2, 2, 1, 7, 5, 5]

    var res = a.reduce([], combine: { (var arr, elem) -> [Int] in
        if !arr.contains(elem) {
            arr.append(elem)
        }
        return arr
    }).map({ (elem) -> (Int, Int) in
        var count = 0
        a.map({ (e) -> Void in
            if e == elem {
                count += 1
            }
        })
        return (elem, count)
    }).sort({ (m, n) -> Bool in
        if m.1 > n.1 {
            return true
        }else if m.1 == n.1 {
            if m.0 > n.0 {
                return true
            }
        }
        return false
    }).reduce([], combine: { (var a, elem) -> [Int] in
        for _ in 1...elem.1 {
            a.append(elem.0)
        }
        return a
    })
    print(res)
    
    res = a.reduce([Int: Int](), combine: { (var dict, elem) -> [Int:Int] in
        if let val = dict[elem] {
            dict[elem] = val+1
        }else{
            dict[elem] = 1
        }
        return dict
    }).map { (key, value) -> (Int,Int) in
        return (key, value)
    }.sort { (m, n) -> Bool in
            if m.1 > n.1 {
                return true
            }else if m.1 == n.1 {
                if m.0 > n.0 {
                    return true
                }
            }
            return false
    }.reduce([]) { (var arr, elem) -> [Int] in
            for _ in 1...elem.1 {
                arr.append(elem.0)
            }
            return arr
    }
    
    print(res)
}()

let res = Array(1...100).reduce(0) { $0+$1 }
print(res)

func removeOnce(itemToRemove: Int, var fromArray: [Int]) -> [Int]{
    for (index, item) in fromArray.enumerate(){
        if item == itemToRemove {
            fromArray.removeAtIndex(index)
            break
        }
    }
    return fromArray
}

func remove(itemToRemove: Int, fromArray: [Int]) -> [Int]{
    return fromArray.flatMap { (elem) -> Int? in
        if elem == itemToRemove {
            return nil
        }
        return elem
    }
}



func reverse(array: [Int]) -> [Int]{
    return array.reduce([], combine: { (var arr, elem) -> [Int] in
        arr.insert(elem, atIndex: 0)
        return arr
    })
}

//let a = [7, 7, 3, 2, 2, 2, 1, 7, 5, 5]
let a = [7, 7, 3, 2, 1]
print(removeOnce(2, fromArray: a))
print(remove(2, fromArray:a))
print(reverse(a))


func randomFromZeroTo(number: Int) -> Int {
    return Int(arc4random_uniform(UInt32(number)))
}

func randomArray(var array: [Int]) -> [Int]{
    
    for (index, _) in array.enumerate(){
        let random = randomFromZeroTo(array.count)
        if index != random {
            swap(&array[index], &array[random])
        }
        
    }
    /*
    array.map { (elem) -> Int in
        let random = randomFromZeroTo(array.count)
        let val = array[random]
        array[random] = elem
        
        print("random \(random) elem \(elem) value \(val)")
        return val
    }*/
    
    return array
}

print("")
print(a)
print(randomArray(a))

/*
var bobData = ["name": "Bob", "Profession":"Card Player", "country":"USA"]
for (key, val) in bobData{
    print("\(key) \(val)")
}

for key in bobData.keys{
    print("\(key)")
}

for val in bobData.values {
    print("\(val)")
}
*/

/*
var namesAndScores = ["Brian":2, "Anna":2, "Craig":8, "Donna":6]

let nameString = namesAndScores.reduce("") { (names, pair) -> String in
    return names + pair.0 + " "
}

let scores = namesAndScores.filter { (pair) -> Bool in
    return pair.1 < 5
}
print(scores)
*/

let stateCode = ["NY": "New York", "CA": "California"]

//dictionary filter 之后是元组组成的数组
let filterState = stateCode.filter { (pair) -> Bool in
    return pair.1.unicodeScalars.count > 8
}

print(filterState.map({$0.1}))

class ClassA {
    let numA: Int
    
    required init(num: Int){
        numA = num
    }
    
    convenience init(bigNum: Bool){
        self.init(num: bigNum ? 1000: 1)
    }
}

class ClassB : ClassA{
    let numB : Int
    
    required init(num: Int){
        numB = num + 1
        super.init(num: num)
    }
}

let newB = ClassB(bigNum: true)

for i in 1...3 {
    let _ = { () -> Void in
        print(i)
    }()
}

var arr:[Int] = [1, 5, 7, 3, 2, 4, 9, 8]

func bubble_sort<T:Comparable>(a: [T]) -> [T] {
    var arr = a
    for i in 0..<arr.count{
        for j in (i+1)..<arr.count{
            if arr[j] < arr[i] {
                swap(&arr[i], &arr[j])
            }
        }
    }
    
    return arr
}

print(bubble_sort(arr))

let stringArr = ["game", "alpha", "Alpha", "bravo"]
let orderdStringArr = stringArr.sort { (a, b) -> Bool in
    return a < b
}
print(orderdStringArr)

let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]

var largest = 0
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print("\(largest)")







