# ClairvoyantMetrics

Useful extensions for using [swift-metrics](https://github.com/apple/swift-metrics) together with [Clairvoyant](https://github.com/christophhagen/Clairvoyant).

## Usage 

Each `Counter`, `Recorder`, `Gauge` or `Timer` is forwarded to a metric with the same `label` (`id`). 
While counters become `Metric<Int>`, all others become `Metric<Double>` (be aware of the inaccuracy of `Double` when using `Recorder.record(Int64)`).

To use a `MetricObserver` as a metrics backend, add a dependency for ClairvoyantMetrics and import the module:

```swift
import Clairvoyant
import ClairvoyantMetrics
```

The package provides a `MetricsProvider` to serve as a `MetricFactory`:

```swift
let observer = MetricObserver(...)
let metrics = MetricsProvider(observer: observer)
MetricsSystem.bootstrap(metrics)
```

Now the metrics can be used:

```swift
let counter = Counter(label: "com.example.BestExampleApp.numberOfRequests")
counter.increment()
```

To access the values locally:

```swift
let metric = observer.getMetric(id: "...", type: String.self)
let lastValue = await metric.lastValue()
```

To expose the metrics through a web interface using a Vapor server, see [ClairvoyantVapor](https://github.com/christophhagen/ClairvoyantVapor).
