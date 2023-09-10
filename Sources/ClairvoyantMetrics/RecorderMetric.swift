import Foundation
import Metrics
import Clairvoyant

final class RecorderMetric: RecorderHandler {

    let metric: Metric<Double>

    let scheduler: AsyncScheduler

    init(_ metric: Metric<Double>, scheduler: AsyncScheduler) {
        self.metric = metric
        self.scheduler = scheduler
    }

    func record(_ value: Int64) {
        record(Double(value))
    }

    func record(_ value: Double) {
        scheduler.schedule {
            try await self.metric.update(value)
        }
    }
}

extension RecorderMetric: TimerHandler {

    func recordNanoseconds(_ duration: Int64) {
        record(duration)
    }
}
