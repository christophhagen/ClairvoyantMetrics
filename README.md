# ClairvoyantMetrics

Useful extensions for using [swift-metrics](https://github.com/apple/swift-metrics) together with [Clairvoyant](https://github.com/christophhagen/Clairvoyant).

The package provides a `MetricsProvider` to serve as a `MetricFactory`, so you can do:

```swift
let metrics = MetricsProvider(...)
MetricsSystem.bootstrap(metrics)
```

For more information, see the [documentation](https://github.com/christophhagen/Clairvoyant#usage-with-swift-metrics) of the [Clairvoyant framework](https://github.com/christophhagen/Clairvoyant).

