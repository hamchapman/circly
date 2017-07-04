import Foundation
import App

/// We have isolated all of our App's logic into
/// the App module because it makes our app
/// more testable.
///
/// In general, the executable portion of our App
/// shouldn't include much more code than is presented
/// here.
///
/// We simply initialize our Droplet, optionally
/// passing in values if necessary
/// Then, we pass it to our App's setup function
/// this should setup all the routes and special
/// features of our app
///
/// .run() runs the Droplet's commands,
/// if no command is given, it will default to "serve"




//class TestingTimer {
//    let drop: Droplet
//
//    init(drop: Droplet) {
//        self.drop = drop
//    }
//
//    @objc func printStuff() {
//
//    }
//}





let config = try Config()
try config.setup()

let drop = try Droplet(config)
try drop.setup()

//let testingTimer = TestingTimer(drop: drop)
//
//DispatchQueue.main.async {
//    let timer = Timer.scheduledTimer(timeInterval: 2.0, target: testingTimer, selector: #selector(testingTimer.printStuff), userInfo: nil, repeats: true)
//}

//RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
//
//timer.fire()

//let queue = DispatchQueue(label: "testing")

//queue.asyncAfter(deadline: .now() + 2.0, execute: workItem)




class Jobbly {
    let jobsQueue = DispatchQueue(label: "gg.hc.lovely-jobbly")

    public init() throws{
        DispatchQueue.global(qos: .background).async {
            self.runThatShit()
        }
    }

    private func runThatShit() {
        jobsQueue.asyncAfter(deadline: .now() + .seconds(2), execute: {
            DispatchQueue.global().async {
                drop.log.info("Butthole pleasures")
                self.runThatShit()
            }
        })
    }
}


try Jobbly()




drop.log.info("Informational log")

try drop.run()
