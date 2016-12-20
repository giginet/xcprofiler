# xctracker

Analyze build times of Swift projects

## Installation

```ruby
gem install xctracker
```

## Usage

```
$ xctracker [PRODUCT_NAME] [options]
```

Sample output is here

```
+-------------------------------------------------------------------------------------------+------+------------------------------------------------------------------------------------------------------------------------------------------+----------+
| File                                                                                      | Line | Method name                                                                                                                              | Time(ms) |
+-------------------------------------------------------------------------------------------+------+------------------------------------------------------------------------------------------------------------------------------------------+----------+
| Phakchi/Sources/Phakchi/Interaction.swift        | 17   | get {}                                                                                                                                   | 69.9     |
| Phakchi/Sources/Phakchi/Matcher.swift            | 7    | get {}                                                                                                                                   | 68.9     |
| Phakchi/Sources/Phakchi/InteractionBuilder.swift | 87   | func clean()                                                                                                                             | 49.8     |
| Phakchi/Sources/Phakchi/Session.swift            | 74   | public func run(completionBlock: TestCompletionBlock? = default, executionBlock: @escaping TestExecutionBlock)                           | 49.6     |
| Phakchi/Sources/Phakchi/Session.swift            | 65   | @discardableResult public func willRespondWith(status: Int, headers: Headers? = default, body: Body? = default) -> Self                  | 28.3     |
| Phakchi/Sources/Phakchi/ControlServer.swift      | 20   | public func startSession(consumerName: String, providerName: String, completion completionBlock: StartSessionCompletionBlock? = default) | 24.6     |
| Phakchi/Sources/Phakchi/ControlServer.swift      | 24   | (closure)                                                                                                                                | 23.9     |
| Phakchi/Sources/Phakchi/InteractionBuilder.swift | 19   | private func makeHeaders(_ headers: Headers?, defaultHeaders: Headers?) -> Headers?                                                      | 21.5     |
| Phakchi/Sources/Phakchi/ServiceClient.swift      | 47   | func registerInteraction(_ interaction: Interaction, completionHandler: CompletionHandler? = default)                                    | 16.4     |
| Phakchi/Sources/Phakchi/ServiceClient.swift      | 60   | func verify(_ completionHandler: VerificationCompletionHandler? = default)                                                               | 14.3     |
| Phakchi/Sources/Phakchi/ServiceClient.swift      | 27   | func resumeSessionTask(_ request: URLRequest, completionHandler: CompletionHandler? = default)                                           | 13.3     |
| Phakchi/Sources/Phakchi/ControlServer.swift      | 32   | public func session(forConsumerName consumerName: String, providerName: String) -> Session?                                              | 9.7      |
| Phakchi/Sources/Phakchi/InteractionBuilder.swift | 94   | get {}                                                                                                                                   | 5.9      |
| Phakchi/Sources/Phakchi/ServiceClient.swift      | 15   | func makePactRequest(to endpoint: String, method: HTTPMethod, headers: [String : String] = default) -> URLRequest                        | 5.3      |
| Phakchi/Sources/Phakchi/ServiceClient.swift      | 51   | func registerInteractions(_ interactions: [Interaction], completionHandler: CompletionHandler? = default)                                | 5.1      |
| Phakchi/Sources/Phakchi/Encodable.swift          | 39   | get {}                                                                                                                                   | 4.8      |
| Phakchi/Sources/Phakchi/ServiceClient.swift      | 121  | func start(session consumerName: String, providerName: String, completionHandler: @escaping CreateSessionCompletionHandler)              | 3.7      |
| Phakchi/Sources/Phakchi/Encodable.swift          | 29   | get {}                                                                                                                                   | 3.4      |
| Phakchi/Sources/Phakchi/ServiceClient.swift      | 72   | func writePact(for providerName: String, consumerName: String, exportPath: URL?, completionHandler: CompletionHandler? = default)        | 3.3      |
| Phakchi/Sources/Phakchi/ServiceClient.swift      | 125  | (closure)                                                                                                                                | 3.1      |
+-------------------------------------------------------------------------------------------+------+------------------------------------------------------------------------------------------------------------------------------------------+----------+
```

### Available Options

|option|shorthand|description|
|------|---------|-----------|
|--limit|-l|Limit for display|
|--verbose|-v|Show invalid location results|
|--order|-o|Sort order (time,file)|


## Use custom reporters

```ruby
require 'xctracker'

tracker = Xctracker::Tracker.new('Phakchi')
tracker.reporters = [
  Xctracker::StandardOutputReporter.new(limit: 20, order: :time)],
  Xctracker::JSONReporter.new({output_path: 'result.json'})
]
tracker.report!
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/xctracker.

