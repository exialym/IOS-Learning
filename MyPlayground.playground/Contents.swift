//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
let a = (3,4)
let b = a.0
let tuple: (day: Int, month: Int, year: Int) = (15, 8, 2015)
let day = tuple.day
var str1 = "asdf"
str += str1
var aa = "cz" < "a"
let stringA = "café"
let stringB = "cafe\u{0301}"
stringA.characters.count
stringB.characters.count
let isEqual = stringA == stringB
max(1,2,3,22)
let count = 10
var sum = 0
for i in 0..<count {
    sum += i
}
//*****************************************************chapter 7 Function*************************
func isNumDivi(num:Int,byNum:Int)->Bool{
    return (num%byNum) == 0 ? true : false
}
func isPrime(number:Int)->Bool{
    if number <= 0 {
        return false
    }
    if number < 3 {
        return true
    }
    
    for i in 2..<number {
        if isNumDivi(number, byNum: i) {
            return false
        }
    }
    return true
}
isPrime(13)
//1,1,2,3,5,8,13
func fibonacci(num:Int) -> Int {
    switch num{
    case let i where i <= 0:
        return 0
    case 1:
        return 1
    case 2:
        return 1
    default:
        return fibonacci(num-1) + fibonacci(num-2)
    }
}
fibonacci(7)
//***************************************************chapter 10 Array****************************
let myIntArray = [1,2,3,23,4,5,23,43,45,65]
func removeOnce(itemToMove:Int, fromArray:[Int]) -> [Int] {
    var value = fromArray
    var isDeleted = false
    //你试图在对数组的for循环中更改本数组，会出现不可预料的后果，永远不要这么做。
    //这里没有出问题的原因是你只修改了一次，在修改之前当然还是原数组，如果修改多次，尤其是涉及到下标则要非常小心
    for (index,num) in value.enumerate() {
        if num == itemToMove && !isDeleted{
            value.removeAtIndex(index)
            isDeleted = true
        }
    }
    return value
}
func remove(itemToMove:Int, fromArray:[Int]) -> [Int] {
    var value = [Int]()
    for num in fromArray {
        if num != itemToMove {
            value.append(num)
        }
    }
    return value
}
removeOnce(23, fromArray: myIntArray)
remove(23, fromArray: myIntArray)
func reverse(origin:[Int])->[Int]{
    var value = origin
    let size:Int = origin.count/2
    for (index,num) in origin[0...size].enumerate() {
        value[index] = origin[origin.count-1-index]
        value[value.count-1-index] = num
    }
    return value
}
reverse(myIntArray)
func randomFromZeroTo(number: Int) -> Int {
    return Int(arc4random_uniform(UInt32(number)))
}
func randomArray(origin:[Int])->[Int]{
    var value = origin
    for (index,_) in origin.enumerate() {
        let randomIndex = randomFromZeroTo(origin.count-1)
        let num = value[index]
        value[index] = value[randomIndex]
        value[randomIndex] = num
    }
    return value
}
randomArray(myIntArray)
//***************************************************chapter 11 Dictionary************************
//print(0.hashValue)
//print("0".hashValue)
//***************************************************chapter 13 Structures ************************
struct people {
    var name:String
    var age:Int
    //结构体自己的方法想改变自己的属性必须使用mutating修饰
    mutating func changeAge(age:Int) -> Bool {
        self.age = age
        return true
    }
}
//通过属性观察器可以发现，只要修改了结构体里的属性，就代表整个结构体发生了变化
var tuji:people = people(name: "rabbit", age: 11) {
    didSet{
        print(tuji.age)
    }
}
tuji.changeAge(1)
tuji.changeAge(2)
tuji.age = 18

