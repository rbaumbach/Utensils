import Quick
import Moocher
import Capsule
@testable import Utensils

// Note: This file isn't really to test the networking calls,
// but can be used to manually verify the debug printing

final class DebugPrinterTester: QuickSpec {
    override class func spec() {
        describe("debug printing tester") {
            describe(".lite") {
                it("prints the request and response") {
                    doPrinting(option: .all, printType: .lite)
                }
            }
            
            describe(".verbose") {
                it("prints the request and response") {
                    doPrinting(option: .all, printType: .verbose)
                }
            }
            
            describe(".raw") {
                it("prints the request and response") {
                    doPrinting(option: .all, printType: .raw)
                }
            }
        }
    }
}

func doPrinting(option: URLSessionTaskEngine.DebugPrint.Option,
                printType: PrintType) {
    let subject = PequenoNetworking(baseURL: "https://httpbin.org",
                                    headers: nil)
    
    let printer = Printer(printType: printType)
    
    subject.debugPrint = URLSessionTaskEngine.DebugPrint(option: .all,
                                                         printer: printer)
    
    print("")
    print("Attempting to debug print, option: \(option), printype: \(printType)")
    
    hangOn(for: .seconds(5)) { complete in
        subject.get(endpoint: "/get",
                    parameters: nil) { result in
            switch result {
            case .success:
                break
            case .failure:
                failSpec()
            }
            
            complete()
        }
    }
}
