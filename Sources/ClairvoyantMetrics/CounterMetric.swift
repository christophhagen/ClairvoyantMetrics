import Foundation
import Metrics
import Clairvoyant

final class CounterMetric: CounterHandler {

    let metric: Metric<Int>

    let scheduler: AsyncScheduler

    init(_ metric: Metric<Int>, scheduler: AsyncScheduler) {
        self.metric = metric
        self.scheduler = scheduler
    }

    func increment(by amount: Int64) {
        scheduler.schedule {
            let oldValue = await self.metric.lastValue()?.value ?? 0
            let result = oldValue.addingReportingOverflow(Int(amount))
            let newValue = result.overflow ? Int.max : result.partialValue
            try await self.metric.update(newValue)
        }
    }

    func reset() {
        scheduler.schedule {
            try await self.metric.update(0)
        }
    }
}
