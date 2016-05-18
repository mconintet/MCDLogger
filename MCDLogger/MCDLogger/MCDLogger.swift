//
//  MCDLogger.swift
//  MCDLogger
//
//  Created by mconintet on 5/18/16.
//  Copyright © 2016 mconintet. All rights reserved.
//

import Foundation

public struct LogLevel: OptionSetType {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }

    public static let None = LogLevel(rawValue: 0)
    public static let Info = LogLevel(rawValue: 1 << 1)
    public static let Alert = LogLevel(rawValue: 1 << 2)
    public static let Error = LogLevel(rawValue: 1 << 3)
    public static let Debug = LogLevel(rawValue: 1 << 4)
    public static let All: LogLevel = [Info, Alert, Error, Debug]
}

public struct StdOutputStream: OutputStreamType {
    public mutating func write(string: String) {
        fputs(string, __stdoutp)
    }
}

public struct StringOutputStream: OutputStreamType {
    public var out = ""

    public mutating func write(string: String) {
        out += string
    }

    public mutating func reset() {
        out = ""
    }
}

var defaultDateFormatterToken: dispatch_once_t = 0
let _defaultDateFormatter = NSDateFormatter()

public class MCDLogger {
    static var level: LogLevel = .All

    static var outStream = StdOutputStream()

    static var includeCaller = false

    static var defaultDateFormatter: NSDateFormatter {
        get {
            dispatch_once(&defaultDateFormatterToken) {
                _defaultDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            }
            return _defaultDateFormatter
        }
    }

    static var dateFormatter = defaultDateFormatter

    static func _log(level: LogLevel, _ items: [Any], separator: String = " ", terminator: String = "\n",
        _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
        guard self.level.contains(level) else {
            return
        }

        if level == .Debug && !_isDebugAssertConfiguration() {
            return
        }

        var str = ""
        switch level {
        case LogLevel.Info:
            str = "[INFO]"
        case LogLevel.Alert:
            str = "[Alert]"
        case LogLevel.Error:
            str = "[Error]"
        case LogLevel.Debug:
            str = "[Debug]"
        default:
            break
        }

        var strStream = StringOutputStream()
        str += separator + dateFormatter.stringFromDate(NSDate()) + separator

        if includeCaller {
            str += file + ":\(line):" + function + separator
        }

        var i = 1
        let len = items.count
        for item in items {
            debugPrint(item, separator: "", terminator: "", toStream: &strStream)
            str += strStream.out
            strStream.reset()
            if i == len {
                str += terminator
                break
            }
            str += separator
            i += 1
        }
        outStream.write(str)
    }

    static func log(level: LogLevel, _ items: Any ..., separator: String = " ", terminator: String = "\n",
        _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
        _log(level, items, separator: separator, terminator: terminator, file, line, function)
    }
}

#if NOCONVENIENT
#else
    public func INFO(items: Any ..., separator: String = " ", terminator: String = "\n",
        _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
        MCDLogger._log(.Info, items, separator: separator, terminator: terminator, file, line, function)
    }

    public func ALERT(items: Any ..., separator: String = " ", terminator: String = "\n",
        _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
        MCDLogger._log(.Alert, items, separator: separator, terminator: terminator, file, line, function)
    }

    public func DEBUG(items: Any ..., separator: String = " ", terminator: String = "\n",
        _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
        MCDLogger._log(.Debug, items, separator: separator, terminator: terminator, file, line, function)
    }

    public func ERROR(items: Any ..., separator: String = " ", terminator: String = "\n",
        _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
        MCDLogger._log(.Error, items, separator: separator, terminator: terminator, file, line, function)
    }
#endif
