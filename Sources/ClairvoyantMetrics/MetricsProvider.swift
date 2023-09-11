import Foundation
import Metrics
import Clairvoyant

/**
 A wrapper for a `MetricsObserver` to use as a backend for `swift-metrics`.

 Set the provider as the backend:

 ```
 import Clairvoyant
 import ClairvoyantMetrics

 let observer = MetricObserver(...)
 let metrics = MetricsProvider(observer: observer)
 MetricsSystem.bootstrap(metrics)
 ```
 */
public final class MetricsProvider: MetricsFactory {

    private let observer: MetricObserver

    /**
     The object to provide async task scheduling.

     The logging of data is done using async operations on `Metric`s, but the functions on `LogHandler` are synchronous.
     The async scheduler provides the means to run the asynchronous metric updates.

     By default, Swift `Task`s are used:

     ```
     Task {
         try await asyncOperation() // Updates the metric
     }
     ```

     Other contexts, such as when using `SwiftNIO` event loops, may need a different type of scheduling.
     */
    public var asyncScheduler: AsyncScheduler = AsyncTaskScheduler()

    /**
     Create a metric provider with an observer.

     - Parameter observer: The observer to handle the metrics.
     */
    public init(observer: MetricObserver) {
        self.observer = observer
    }

    public func makeCounter(label: String, dimensions: [(String, String)]) -> CounterHandler {
        let metric: Metric<Int> = observer.addMetric(id: label)
        return CounterMetric(metric, scheduler: asyncScheduler)
    }

    public func makeRecorder(label: String, dimensions: [(String, String)], aggregate: Bool) -> RecorderHandler {
        let metric: Metric<Double> = observer.addMetric(id: label)
        return RecorderMetric(metric, scheduler: asyncScheduler)
    }

    public func makeTimer(label: String, dimensions: [(String, String)]) -> TimerHandler {
        let metric: Metric<Double> = observer.addMetric(id: label)
        return RecorderMetric(metric, scheduler: asyncScheduler)
    }

    public func destroyCounter(_ handler: CounterHandler) {
        guard let counter = handler as? CounterMetric else {
            return
        }
        observer.remove(counter.metric)
    }

    public func destroyRecorder(_ handler: RecorderHandler) {
        guard let recorder = handler as? RecorderMetric else {
            return
        }
        observer.remove(recorder.metric)
    }

    public func destroyTimer(_ handler: TimerHandler) {
        guard let recorder = handler as? RecorderMetric else {
            return
        }
        observer.remove(recorder.metric)
    }
}
