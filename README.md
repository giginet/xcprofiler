# xcprofiler

[![Build Status](https://travis-ci.org/giginet/xcprofiler.svg?branch=master)](https://travis-ci.org/giginet/xcprofiler)
[![Coverage Status](https://coveralls.io/repos/github/giginet/xcprofiler/badge.svg?branch=master)](https://coveralls.io/github/giginet/xcprofiler?branch=master)
[![Gem Version](https://badge.fury.io/rb/xcprofiler.svg)](https://badge.fury.io/rb/xcprofiler)
[![Gem Download](https://img.shields.io/gem/dt/xcprofiler.svg)](https://badge.fury.io/rb/xcprofiler)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

Command line utility to profile compilation time of Swift project.

![](https://raw.githubusercontent.com/giginet/xcprofiler/master/assets/sample_output.png)

This tool is developed in working time for Cookpad.

## Installation

```
gem install xcprofiler
```

xcprofiler is tested on latest Ruby 2.3/2.4.

## Usage

1. Add `-Xfrontend -debug-time-function-bodies` build flags in `Build Settings` -> `Other Swift Flags` section of your Xcode project.
    ![](https://raw.githubusercontent.com/giginet/xcprofiler/master/assets/build_flags.png)

2. Build your project
3. Execute `xcprofiler`

```
$ xcprofiler [PRODUCT_NAME or ACTIVITY_LOG_PATH] [options]
```

`xcprofiler` searches the latest build log on your DerivedData directory.

You can also specify the `.xcactivitylog`.

```
$ xcprofiler MyApp
$ xcprofiler ~/Library/Developer/Xcode/DerivedData/MyApp-xxxxxxxxxxx/Logs/Build/0761C73D-3B6C-449A-BE89-6D11DAB748FE.xcactivitylog
```

Sample output is here

```
+----------------------+------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+
| File                 | Line | Method name                                                                                                                                                   | Time(ms) |
+----------------------+------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+
| ResultProtocol.swift | 132  | public func ==<T : ResultProtocol where T.Value : Equatable, T.Error : Equatable>(left: T, right: T) -> Bool                                                  | 14.2     |
| Result.swift         | 66   | get {}                                                                                                                                                        | 13.1     |
| Result.swift         | 78   | public static func error(_ message: String? = default, function: String = #function, file: String = #file, line: Int = #line) -> NSError                      | 6.3      |
| Result.swift         | 69   | get {}                                                                                                                                                        | 2.2      |
| Result.swift         | 132  | public func `try`<T>(_ function: String = #function, file: String = #file, line: Int = #line, try: (NSErrorPointer) -> T?) -> Result<T, NSError>              | 1.7      |
| Result.swift         | 95   | get {}                                                                                                                                                        | 1.4      |
| Result.swift         | 21   | public init(_ value: T?, failWith: @autoclosure () -> Error)                                                                                                  | 0.9      |
| Result.swift         | 142  | public func `try`(_ function: String = #function, file: String = #file, line: Int = #line, try: (NSErrorPointer) -> Bool) -> Result<(), NSError>              | 0.9      |
| ResultProtocol.swift | 172  | @available(*, unavailable, renamed: "recover(with:)") public func recoverWith(_ result: @autoclosure () -> Self) -> Self                                      | 0.7      |
| Result.swift         | 72   | get {}                                                                                                                                                        | 0.6      |
| Result.swift         | 75   | get {}                                                                                                                                                        | 0.6      |
| ResultProtocol.swift | 72   | public func recover(_ value: @autoclosure () -> Value) -> Value                                                                                               | 0.5      |
| ResultProtocol.swift | 111  | public func &&&<L : ResultProtocol, R : ResultProtocol where L.Error == R.Error>(left: L, right: @autoclosure () -> R) -> Result<(L.Value, R.Value), L.Error> | 0.5      |
| ResultProtocol.swift | 144  | public func !=<T : ResultProtocol where T.Value : Equatable, T.Error : Equatable>(left: T, right: T) -> Bool                                                  | 0.5      |
| ResultProtocol.swift | 92   | public func tryMap<U>(_ transform: (Value) throws -> U) -> Result<U, Error>                                                                                   | 0.4      |
| Result.swift         | 175  | @available(*, unavailable, renamed: "success") public static func Success(_: T) -> Result<T, Error>                                                           | 0.3      |
| ResultProtocol.swift | 55   | public func mapError<Error2>(_ transform: (Error) -> Error2) -> Result<Value, Error2>                                                                         | 0.3      |
| ResultProtocol.swift | 77   | public func recover(with result: @autoclosure () -> Self) -> Self                                                                                             | 0.3      |
| ResultProtocol.swift | 93   | (closure)                                                                                                                                                     | 0.3      |
| Result.swift         | 31   | public init(attempt f: () throws -> T)                                                                                                                        | 0.2      |
+----------------------+------+---------------------------------------------------------------------------------------------------------------------------------------------------------------+----------+
```

### Available Options

|option|shorthand|description|
|------|---------|-----------|
|--limit|-l|Limit for display|
|--threshold||Threshold of time to display (ms)|
|--show-invalids||Show invalid location results|
|--order|-o|Sort order (default,time,file)|
|--derived-data-path||Root path of DerivedData directory|
|--truncate-at|-t|Truncate the method name with specified length|
|--no-unique||Show the duplicated results|

## Use custom reporters

You can use reporters to output tracking logs.

```ruby
require 'xcprofiler'

profiler = Xcprofiler::Profiler.by_product_name('MyApp')
profiler.reporters = [
  Xcprofiler::StandardOutputReporter.new(limit: 20, order: :time),
  Xcprofiler::JSONReporter.new(output_path: 'result.json'),
  Xcprofiler::BlockReporter.new do |executions|
    do_something(executions)
  end,
]
profiler.report!
```

You can also implement your own reporters.

See implementation of [built-in reporters](https://github.com/giginet/xcprofiler/tree/master/lib/xcprofiler/reporters) for detail.

## danger-xcprofiler

You can integrate xcprofiler to [danger](https://github.com/danger/danger).

https://github.com/giginet/danger-xcprofiler

## License

MIT License

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/giginet/xcprofiler.

