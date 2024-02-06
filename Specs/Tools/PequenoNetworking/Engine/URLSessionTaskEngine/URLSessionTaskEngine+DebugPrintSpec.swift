import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLSessionTaskEngine_DebugPrintSpec: QuickSpec {
    override class func spec() {
        describe("URLSessionTaskEngine+DebugPrint") {
            describe("URLSessionTaskEngine.DebugPrint.Option") {
                it("has all the required cases") {
                    let expectedCases: [URLSessionTaskEngine.DebugPrint.Option] = [
                        .none, .request, .response, .all
                    ]
                    
                    expect(URLSessionTaskEngine.DebugPrint.Option.allCases).to.equal(expectedCases)
                }
            }
        }
    }
}
