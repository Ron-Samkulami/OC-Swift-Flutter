//
//  SwiftPage.swift
//  TEST
//
//  Created by 111 on 2021/7/19.
//

import Foundation

var atext = "SwiftObject-Name"
let babyChick = "\u{1F425}"
let cha = "\u{4E20}"

class SwiftObject: NSObject {
    @objc var text = "SwiftObject-Name"
    @objc var Desc = #"""
        This is a multiline string literal \#(atext) a sequence of characters surrounded by \#n three double quotation marks \#(cha)
        """#    //前后加#，转义失效
    @objc public func changeLabel(){
        Desc = "截图成功"
    }
}

// MARK: - ViewController
class SwiftViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton()
        self.edgesForExtendedLayout = []
        btn.frame = CGRect(x: 0, y: 50, width: 100, height: 20)
        btn.backgroundColor = .systemRed
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }

    @objc var hide = false

    override var prefersStatusBarHidden: Bool {
        return self.hide
    }

    @objc func btnClick() {
        let aTool = SwiftSyntax()
        aTool.structTest()
        
    }

}



class SwiftSyntax: NSObject {
    let minValue = UInt8.min
    typealias AType = UInt32
    var UInt32_Max = AType.max
    override init() {
        UInt32_Max = 1
        super.init()
    }
    deinit {
        //do something
    }
    
    func aboutArray() -> Bool {
        var shoppingList:[String] = ["Eggs","Milk"]
        shoppingList.append("Apple")
        shoppingList.insert("peach", at: 0)
        if shoppingList.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func aboutSet() {
        let houseAnimals:Set = ["dog","cat"]
        let farmAnimals:Set = ["cow","chicken","sheep","dog","cat"]
        let cityAnimals:Set = ["bird","rat"]
        print(houseAnimals.isSubset(of: farmAnimals))
        print(farmAnimals.isSuperset(of: houseAnimals))
        print(farmAnimals.isDisjoint(with: cityAnimals))
    
    }
    
    func aboutDictionary() {
        var airports = ["YYZ": "Tornoto Pearson"]
        airports["LHR"] = "London"
        print(airports.count)
        for (airportCode, airportName) in airports {
            print("\(airportName)'s code is \(airportCode)")
        }
        
        _ = airports.sorted{$0 > $1}
        var anotherDict = airports
        
        anotherDict["SGP"] = "singpore"
        print(airports.map{$0})
        print(anotherDict.map {$0})
    }
    
    
    func controlFlow() {
        let minutes = 60
        let minuteInterval = 5
        for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
            print(tickMark)
            if #available(iOS 10, macOS 10.12 ,*) {
                //newAPI
            } else {
                //oldAPI
            }
        }

    }
    
    func structTest() {
        struct Point {
            var x = 0.0, y = 0.0
        }
        struct Size {
            var width = 0.0, height = 0.0
        }
        struct Rect {
            var origin = Point()
            var size = Size()
            var center: Point {
                get {
                    Point(x: origin.x + (size.width / 2), y: origin.y + (size.height / 2))
                }
                set {
                    origin.x = newValue.x - (size.width / 2)
                    origin.y = newValue.y - (size.height / 2)
                }
            }
        }
    }
    
    
    @propertyWrapper
    struct SmallNumber {
        var number = 0
        var projectedValue = false
        var wrappedValue: Int {
            get { return number }
            set {
                if newValue > 12 {
                    number = 12
                    projectedValue = true
                } else {
                    number = newValue
                    projectedValue = false
                }
            }
        }
    }
    
    struct Vector3D: Equatable {
        var x = 0.0, y = 0.0, z = 0.0
    }
    
}

// MARK:- Protocol
protocol SomeProtocol {
    init(someParameter: Int)
}

class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        //
    }
}


// MARK:-
struct Stack<Element> {
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count-1]
    }
    
}


protocol Container {
    associatedtype Item //associatedtype关联类型，表示这里的Item由具体协议使用者指定
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }

//    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
//    func makeIterator() -> Iterator
}

struct IntStack: Container {
    var items: [Int] = []            // original IntStack implementation
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }

//    typealias Item = Int        // conformance to the Container protocol
    mutating func append(_ item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }

}

struct BStack<Element>: Container {
    // original Stack<Element> implementation
    var items: [Element] = []
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
    
}
 

protocol Drawable {
    func draw() -> String
}

struct AllCaps: Drawable {
    func draw() -> String {
        content.draw().uppercased()
    }
    
    var content: Drawable
    
}

/**
 @resultBuilder
 结果生成器
 */




