import Foundation
import Vapor

public class Jobbly {
    let jobsQueue = DispatchQueue(label: "gg.hc.lovely-jobbly")
    let logger: LogProtocol

    public init(logger: LogProtocol) throws {
        self.logger = logger

        DispatchQueue.global(qos: .background).async {
            self.runThatShit(logger: self.logger)
        }
    }

    private func runThatShit(logger: LogProtocol) {
        jobsQueue.asyncAfter(deadline: .now() + .seconds(5), execute: {
            DispatchQueue.global().async {
                logger.info("Butthole pleasures")
                self.runThatShit(logger: self.logger)
            }
        })
    }
}
