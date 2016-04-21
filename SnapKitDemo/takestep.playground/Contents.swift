//: Playground - noun: a place where people can play

import Cocoa

func print_step(trace:[Int]){
    for step in trace {
        print("\(step)", separator: " ", terminator: "")
    }
    print("")
}

func take_step(n : Int, trace:[Int], steps:[Int]){
    
    for step in steps {
        var tra = trace
        tra.append(step)
        
        if n-step == 0 {
            print_step(tra)
        }else {
            take_step(n-step, trace: tra, steps: steps)
        }
    }
}

take_step(3, trace:[Int](), steps:[1, 2])