import Quick
import Moocher
@testable import Utensils

final class HTTPMethodSpec: QuickSpec {
    override func spec() {
        describe("HTTPMethod") {
            it("has proper raw values") {
                expect(HTTPMethod.get.rawValue).to.equal("GET")
            }
            
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    expect(HTTPMethod.allCases).to.equal([.get])
                }
            }

            describe("<Equatable") {
                it("is equatable") {
                    expect(HTTPMethod.get).to.equal(HTTPMethod.get)
                }
            }
        }
    }
}
