//
//  IceCream.swift
//
//  Created by Joao Pedro Monteiro Maia on 28/01/23.
//

import Foundation


/// Main IceCream Class
@available(iOS 15.0, *)
public class IceCream:ObservableObject{
    
    //Metadata
    static var priting:Bool = true
    //TODO: Local print & Local Level
    static var logLevel:ICLogLevelConfiguration =
    ICLogLevelConfiguration(rawValue:ProcessInfo.processInfo.environment["IceCream_logLevel"] ?? "DEBUG") ?? .DEBUG



    //MainData
    let category:String


    //Formating
    var prefix:String = "IC"
    var dateFormatter:DateFormatter = DateFormatter()
    var logInfo:[ICLogInfoConfiguration] = []

    //Observable Methods
    @Published var lastMessage:String = ""
    
    
    /// IceCream Init
    /// - Parameters:
    ///   - logLevel: Set customized IceCream Log Level or use this Default one (Static)
    ///   - category: IceCream Category, used for a better print
    ///   - prefix: Print prefix -> "IC" default
    ///   - dateFormatter: DataFormatter used
    ///   - logInfo: The info provided in the print (Default is nothing)x
    init(logLevel: ICLogLevelConfiguration = IceCream.logLevel,
         category: String,
         prefix: String = "IC",
         dateFormatter: DateFormatter? = nil,
         logInfo: [ICLogInfoConfiguration] = []) {
        
        IceCream.logLevel = logLevel
        self.category = category
        self.prefix = prefix
        self.logInfo = logInfo
        self.lastMessage = ""
        
        //Default format
        self.dateFormatter = dateFormatter ?? {
            let dtf = DateFormatter()
            dtf.dateFormat = "HH:mm:ss.SSS"
            return dtf
        }()
        
    }
    
    
    
    init(logLevel: ICLogLevelConfiguration = IceCream.logLevel,
         category: String,
         prefix: String = "IC",
         dateFormatter: DateFormatter?,
         logInfo:ICLogInfoConfiguration...) {
        
        IceCream.logLevel = logLevel
        self.category = category
        self.prefix = prefix
        self.logInfo = logInfo
        self.lastMessage = ""
        
        //Default format
        self.dateFormatter = dateFormatter ?? {
            let dtf = DateFormatter()
            dtf.dateFormat = "HH:mm:ss.SSS"
            return dtf
        }()
        
    }
    
    
    /// Function that handles the printing
    /// - Parameters:
    ///   - input: Input String
    ///   - logLevel: The amount logger level
    ///   - logInfo: The amount of information described by the ICLogInfoConfiguration enum
    ///   - filename: filename
    ///   - line: line
    ///   - columns: columns
    ///   - funcName: funcName
    /// - Returns: Formated string (Returns after printing)
    private func ICprint(_ input:String,_ logLevel:ICLogLevelConfiguration?, logInfo:[ICLogInfoConfiguration],
                       filename:String,line:Int,columns:Int,funcName:String)->String{
        
        if (!Self.priting){
            return ""
        }
        
        //Prefix
        var message = ""
        if let lLevel = logLevel{
            message += "<\(lLevel.rawValue)>"
        }
        message += self.prefix
        message = message.trimmingCharacters(in: .whitespaces)
        message += " [\(self.category)] "
        
        
        //Adding Info
        for info in logInfo{
            message = message.trimmingCharacters(in: .whitespaces)
            switch info {
            case .date:
                message += info.format(self.dateFormatter.string(from: .now))
            case .file:
                message += info.format(filename)
            case .function:
                message += info.format(funcName)
            case .lineAndColumn:
                message += info.format(" {ln:\(line) cl:\(columns)} ")
            }
        }
        
        //Finishing
        message = message.trimmingCharacters(in: .whitespaces)
        message += " |\(input)"
        
        lastMessage = message
        print(message)
        return message
    }
    
    func ic(_ message:String,
             filename: String = #fileID,
             line: Int = #line,
             column: Int = #column,
            funcName: String = #function){
        
         let _ = self.ICprint(message, nil,
                            logInfo: self.logInfo,
                            filename: filename, line: line, columns: column, funcName: funcName)
        
    }
    
    
    func ic(_ message:String,
            info:ICLogInfoConfiguration...,
             filename: String = #fileID,
             line: Int = #line,
             column: Int = #column,
            funcName: String = #function){
        
        let _ = self.ICprint(message,
                             nil,
                            logInfo: info,
                            filename: filename, line: line, columns: column, funcName: funcName)
        
    }
    
    func ic(filename: String = #fileID,
             line: Int = #line,
             column: Int = #column,
             funcName: String = #function){
        
        let _ = self.ICprint("", nil,
                   logInfo: self.logInfo,
                   filename: filename, line: line, columns: column, funcName: funcName)
    
        
    }
    
    
    static func asFunction(category:String? = nil,
                           prefix:String = "ic",
                           withDate:Bool = false,
                           usingFormat:String = "HH:mm:ss")->(String)->Void{
        return { input in
            
            if (!Self.priting){
                return
            }
            
            var message = "\(prefix) "
            
            if(withDate){
                let dtFormater = DateFormatter()
                dtFormater.dateFormat = usingFormat
                message += "(\(dtFormater.string(from: .now))) "
            }
            
            if let maybeCategory = category{
                message += "\(maybeCategory) "
            }
            
            message += "| "
            message += input
            
            print(message)
        }
        
    }
    
    static func asFunction(
        level:ICLogLevelConfiguration,
        category:String? = nil,
                           prefix:String = "ic",
                           withDate:Bool = false,
                           usingFormat:String = "HH:mm:ss")->(String)->Void{
        return { input in
            
            if (!Self.priting){
                return
            }
            
            if (IceCream.logLevel.asInt < level.asInt){
                return
            }
            
            var message = "<\(level)> \(prefix) "
            
            if(withDate){
                let dtFormater = DateFormatter()
                dtFormater.dateFormat = usingFormat
                message += "(\(dtFormater.string(from: .now))) "
            }
            
            if let maybeCategory = category{
                message += "\(maybeCategory) "
            }
            
            message += "| "
            message += input
            
            print(message)
        }
        
    }
    
    
    
    
    func debug(_ message:String,
             filename: String = #fileID,
             line: Int = #line,
             column: Int = #column,
            funcName: String = #function){
        
        let mySelfLevel:Int = ICLogLevelConfiguration.DEBUG.asInt
        
        if (IceCream.logLevel.asInt < mySelfLevel){
            return
        }
        
        let _ = self.ICprint(message,
                            .DEBUG,
                            logInfo: self.logInfo,
                            filename: filename, line: line, columns: column, funcName: funcName)
    }
    
    func info(_ message:String,
             filename: String = #fileID,
             line: Int = #line,
             column: Int = #column,
            funcName: String = #function){
        
        let mySelfLevel:Int = ICLogLevelConfiguration.INFO.asInt
        
        if (IceCream.logLevel.asInt < mySelfLevel){
            return
        }
        
        let _ = self.ICprint(message,
                            .INFO,
                            logInfo: self.logInfo,
                            filename: filename, line: line, columns: column, funcName: funcName)
    }
    
    func notice(_ message:String,
             filename: String = #fileID,
             line: Int = #line,
             column: Int = #column,
            funcName: String = #function){
        
        let mySelfLevel:Int = ICLogLevelConfiguration.NOTICE.asInt
        
        if (IceCream.logLevel.asInt < mySelfLevel){
            return
        }
        
        let _ = self.ICprint(message,
                            .NOTICE,
                            logInfo: self.logInfo,
                            filename: filename, line: line, columns: column, funcName: funcName)
    }
    
    
    func error(_ message:String,
             filename: String = #fileID,
             line: Int = #line,
             column: Int = #column,
            funcName: String = #function){
        
        let mySelfLevel:Int = ICLogLevelConfiguration.ERROR.asInt
        
        if (IceCream.logLevel.asInt < mySelfLevel){
            return
        }
        
        let _ = self.ICprint(message,
                            .ERROR,
                            logInfo: self.logInfo,
                            filename: filename, line: line, columns: column, funcName: funcName)
    }
    
    func fault(_ message:String,
             filename: String = #fileID,
             line: Int = #line,
             column: Int = #column,
            funcName: String = #function){
        
        let mySelfLevel:Int = ICLogLevelConfiguration.FAULT.asInt
        
        if (IceCream.logLevel.asInt < mySelfLevel){
            return
        }
        
        let _ = self.ICprint(message,
                            .FAULT,
                            logInfo: self.logInfo,
                            filename: filename, line: line, columns: column, funcName: funcName)
    }
    
    


}

// https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code
public enum ICLogLevelConfiguration:String {
    case DEBUG
    case INFO
    case NOTICE
    case ERROR
    case FAULT
    
    var asInt:Int{
        switch self {
        case .DEBUG:
            return 4
        case .INFO:
            return 3
        case .NOTICE:
            return 2
        case .ERROR:
            return 1
        case .FAULT:
            return 0
        }
    }
}

public enum ICLogInfoConfiguration{
    case date
    case file
    case function
    case lineAndColumn
    
    func format(_ stringToBeFormated:String?) -> String {
        switch self {
        case .date:
            guard let string = stringToBeFormated else{
                return " date? "
            }
            return " (\(string)) "
        case .file:
            guard let string = stringToBeFormated else{
                return " file? "
            }
            return ":\(string):"
        case .function:
            guard let string = stringToBeFormated else{
                return " function? "
            }
            return " .\(string) "
        case .lineAndColumn:
            guard let string = stringToBeFormated else{
                return " ln?:cl? "
            }
            return "\(string)"
        }
    }
}



