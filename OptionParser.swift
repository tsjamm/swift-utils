/////   OptionParser.swift
////    Command Line Options Parser in Swift
///     Author: Sai Teja Jammalamadaka
//
class OptionParser {

    //// Returns true if parsed correctly, or false if error
    class func parse(optionsMap:[String:((String?)->Bool)], usage:String) -> Bool {
        let numOfArgs = Process.arguments.count
        for var i=1;i<numOfArgs;i++ {
            let currentArg = Process.arguments[i]
            if let callback = optionsMap[currentArg] {
                let j = i+1
                if j<numOfArgs {
                    let futureArg = Process.arguments[j]
                    if let _ = optionsMap[futureArg] {
                        if !callback(nil) {
                            print("Usage :: \(usage)")
                            print("\(currentArg) was not handled. Error. Terminating.")
                            return false
                        }
                    } else {
                        if callback(futureArg) {
                            i=i+1 /// doing this so future arg is skipped
                        } else {
                            print("Usage :: \(usage)")
                            print("\"\(currentArg) \(futureArg)\" was not handled. Error. Terminating.")
                            return false
                        }
                    }
                }
            } else {
                print("\(currentArg) not defined")
                print("Usage :: \(usage)")
            }
        }
        return true
    }
}


/////   ParamRepeater
////    Test Class the shows how to use OptionParser
///     call the start() function
//
class ParamRepeater {
    
    static var parameter = ""
    static var numOfTimes = 1
    
    class func start() {
    
        let usageString = "Options: -p <param> = to print the parameter, -r <int> = number of times"
        let optionsMap = [
            "-p":saveParam,
            "-r":saveNumOfRepeats
        ]
        
        if OptionParser.parse(optionsMap,usage:usageString) {
        
            for var i=0;i<numOfTimes;i++ {
                print(parameter)
            }
        }
    }
    
    class func saveParam(param:String?) -> Bool {
        if let unwrapped = param {
            parameter = unwrapped
            return true
        }
        return false
    }
    
    class func saveNumOfRepeats(numStr:String?) -> Bool {
        if let unwrapped = numStr {
            if let didCast = Int(unwrapped) {
                numOfTimes = didCast
                return true
            }
        }
        return false
    }
    
}

////
///     The ParamRepeater executes here
//  
ParamRepeater.start()
//
///
////


