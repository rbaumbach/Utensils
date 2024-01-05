import Quick
import Moocher
@testable import Utensils

final class HTTPMethodSpec: QuickSpec {
    override class func spec() {
        describe("HTTPMethod") {
            it("has proper raw values") {
                expect(HTTPMethod.get.rawValue).to.equal("GET")
                expect(HTTPMethod.delete.rawValue).to.equal("DELETE")
                expect(HTTPMethod.post.rawValue).to.equal("POST")
                expect(HTTPMethod.put.rawValue).to.equal("PUT")
                expect(HTTPMethod.patch.rawValue).to.equal("PATCH")
            }
            
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    let expectedCases: [HTTPMethod] = [.get, .delete, .post, .put, .patch]
                    
                    expect(HTTPMethod.allCases).to.equal(expectedCases)
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
