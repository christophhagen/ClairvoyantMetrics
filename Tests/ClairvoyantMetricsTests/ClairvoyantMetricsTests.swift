import XCTest
import Clairvoyant
import ClairvoyantMetrics
import Metrics

private var _observer: MetricObserver?

final class ClairvoyantMetricsTests: XCTestCase {

    var temporaryDirectory: URL {
        if #available(macOS 13.0, iOS 16.0, *) {
            return URL.temporaryDirectory
        } else {
            // Fallback on earlier versions
            return URL(fileURLWithPath: NSTemporaryDirectory())
        }
    }

    private func makeObserver() -> MetricObserver {
        if let _observer {
            return _observer
        }
        let observer = MetricObserver(
            logFolder: logFolder,
            logMetricId: "observer.log",
            encoder: JSONEncoder(),
            decoder: JSONDecoder())
        let metrics = MetricsProvider(observer: observer)
        MetricsSystem.bootstrap(metrics)
        _observer = observer
        return observer
    }

    var logFolder: URL {
        temporaryDirectory.appendingPathComponent("logs")
    }

    override func setUp() async throws {
        try removeAllFiles()
    }

    override func tearDown() async throws {
        try removeAllFiles()
    }

    private func removeAllFiles() throws {
        let url = logFolder
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
        MetricObserver.standard = nil
    }
    
    func testBootstrap() async throws {
        let observer = makeObserver()

        let counter = Counter(label: "count")
        let result = 5
        counter.increment(by: result)

        guard let metric = observer.getMetric(id: counter.label, type: Int.self) else {
            XCTFail("No valid metric for counter")
            return
        }

        // Need to wait briefly here, since forwarding the log entry to the metric is done in an async context,
        // which would otherwise happen after trying to access the log data
        sleep(1)

        let last = await metric.lastValue()
        XCTAssertEqual(last?.value, result)

        let history = await metric.fullHistory()
        XCTAssertEqual(history.count, 1)
        XCTAssertEqual(history.first?.value ?? 0, result)
    }

    func testCreateSameRecorderTwice() async throws {
        _ = makeObserver()

        let counter = Counter(label: "count")
        let result = 5
        counter.increment(by: result)

        let counter2 = Counter(label: "count")
        counter2.increment(by: result)

        // Need to wait briefly here, since forwarding the log entry to the metric is done in an async context
        sleep(1)
    }
}
