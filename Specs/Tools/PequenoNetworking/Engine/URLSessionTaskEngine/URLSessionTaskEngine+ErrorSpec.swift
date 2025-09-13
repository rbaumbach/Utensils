import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLSessionTaskEngine_ErrorSpec: QuickSpec {
    override class func spec() {
        describe("URLSessionTaskEngine.Error") {
            
            describe(".invalidSessionResponse") {
                it("provides correct errorDescription") {
                    let actualError = URLSessionTaskEngine.Error.invalidSessionResponse
                    
                    expect(actualError.errorDescription)
                        .to.equal("Invalid networking response")
                }

                it("provides correct failureReason") {
                    let actualError = URLSessionTaskEngine.Error.invalidSessionResponse

                    expect(actualError.failureReason).to.equal("Networking did not return a valid response")
                }

                it("provides correct recoverySuggestion") {
                    let actualError = URLSessionTaskEngine.Error.invalidSessionResponse

                    expect(actualError.recoverySuggestion)
                        .to.equal("Verify your networking reuqest isn't malformed. The server is returning an invalid response.")
                }
            }

            describe(".invalidStatusCode") {
                it("provides correct errorDescription") {
                    let actualError = URLSessionTaskEngine.Error.invalidStatusCode(statusCode: 404)
                    
                    expect(actualError.errorDescription).to.equal("Invalid status code: 404")
                }

                it("provides correct failureReason") {
                    let actualError = URLSessionTaskEngine.Error.invalidStatusCode(statusCode: 404)

                    expect(actualError.failureReason)
                        .to.equal("The server responded with a status code outside the 200–299 success range")
                }

                it("provides correct recoverySuggestion") {
                    let actualError = URLSessionTaskEngine.Error.invalidStatusCode(statusCode: 404)

                    expect(actualError.recoverySuggestion)
                        .to.equal("Verify your networking request isn't malformed. The server may be rejecting your input.")
                }
            }

            describe(".missingResponseItem") {
                it("provides correct errorDescription") {
                    let actualError = URLSessionTaskEngine.Error.missingResponseItem
                    
                    expect(actualError.errorDescription)
                        .to.equal("Missing response content")
                }

                it("provides correct failureReason") {
                    let actualError = URLSessionTaskEngine.Error.missingResponseItem

                    expect(actualError.failureReason)
                        .to.equal("The response content is missing")
                }

                it("provides correct recoverySuggestion") {
                    let actualError = URLSessionTaskEngine.Error.missingResponseItem

                    expect(actualError.recoverySuggestion)
                        .to.equal("Verify that the server returns a valid response item")
                }
            }

            describe("<Equatable>") {
                it("equates two identical invalidSessionResponse errors") {
                    let actualError = URLSessionTaskEngine.Error.invalidSessionResponse
                    let expectedError = URLSessionTaskEngine.Error.invalidSessionResponse

                    expect(actualError).to.equal(expectedError)
                }

                it("equates two identical invalidStatusCode errors with same code") {
                    let actualError = URLSessionTaskEngine.Error.invalidStatusCode(statusCode: 403)
                    let expectedError = URLSessionTaskEngine.Error.invalidStatusCode(statusCode: 403)

                    expect(actualError).to.equal(expectedError)
                }

                it("equates two identical missingResponseItem errors") {
                    let actualError = URLSessionTaskEngine.Error.missingResponseItem
                    let expectedError = URLSessionTaskEngine.Error.missingResponseItem

                    expect(actualError).to.equal(expectedError)
                }

                it("does not equate different errors") {
                    let actualError = URLSessionTaskEngine.Error.invalidStatusCode(statusCode: 500)
                    let differentError = URLSessionTaskEngine.Error.missingResponseItem

                    expect(actualError).toNot.equal(differentError)
                }
            }
        }
    }
}
