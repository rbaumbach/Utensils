import Quick
import Moocher
import Capsule
@testable import Utensils

final class PequenoNetworking_UtensilsSpec: QuickSpec {
    override func spec() {
        describe("PequenoNetworking+Utensils") {
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    let expectedCases: [PequenoNetworking.Error] = [.requestError(String.empty),
                                                                    .dataTaskError(wrappedError: EmptyError.empty),
                                                                    .malformedResponseError,
                                                                    .invalidStatusCodeError(statusCode: 0),
                                                                    .dataError,
                                                                    .jsonDecodeError(wrappedError: EmptyError.empty),
                                                                    .jsonObjectDecodeError(wrappedError: EmptyError.empty)]
                    
                    expect(PequenoNetworking.Error.allCases).to.equal(expectedCases)
                }
            }
            
            describe("<Error>") {
                it("has proper localized description") {
                    let requestError = PequenoNetworking.Error.requestError("You Lose...")
                    let expectedRequestError = "Unable to build URLRequest:\nYou Lose..."
                    
                    expect(requestError.localizedDescription).to.equal(expectedRequestError)
                    
                    let dataTaskError = PequenoNetworking.Error.dataTaskError(wrappedError: EmptyError.empty)
                    let expectedDataTaskError = "Unable to complete data task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                    
                    expect(dataTaskError.localizedDescription).to.equal(expectedDataTaskError)
                    
                    let malformedResponseError = PequenoNetworking.Error.malformedResponseError
                    
                    expect(malformedResponseError.localizedDescription).to.equal("Unable to process response")
                    
                    let invalidStatusCodeError = PequenoNetworking.Error.invalidStatusCodeError(statusCode: 99)
                    
                    expect(invalidStatusCodeError.localizedDescription).to.equal("99: Invalid status code")
                    
                    let dataError = PequenoNetworking.Error.dataError
                    
                    expect(dataError.localizedDescription).to.equal("Data task does not contain data")
                    
                    let jsonDecodeError = PequenoNetworking.Error.jsonDecodeError(wrappedError: EmptyError.empty)
                    let expectedJSONDecodeError = "Unable to decode json. Wrapped Error: \(EmptyError.empty.localizedDescription)"
                    
                    expect(jsonDecodeError.localizedDescription).to.equal(expectedJSONDecodeError)
                    
                    let jsonObjectDecodeError = PequenoNetworking.Error.jsonObjectDecodeError(wrappedError: EmptyError.empty)
                    let expectedJSONObjectDecodeError = "Unable to decode json object. Wrapped Error: \(EmptyError.empty.localizedDescription)"
                    
                    expect(jsonObjectDecodeError.localizedDescription).to.equal(expectedJSONObjectDecodeError)
                }
            }
            
            describe("<LocalizedError>") {
                describe("#errorDescription") {
                    it("is the same as the localized description") {
                        let requestError = PequenoNetworking.Error.requestError("You Lose...")
                        let expectedRequestError = "Unable to build URLRequest:\nYou Lose..."
                        
                        expect(requestError.errorDescription).to.equal(expectedRequestError)
                        
                        let dataTaskError = PequenoNetworking.Error.dataTaskError(wrappedError: EmptyError.empty)
                        let expectedDataTaskError = "Unable to complete data task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(dataTaskError.errorDescription).to.equal(expectedDataTaskError)
                        
                        let malformedResponseError = PequenoNetworking.Error.malformedResponseError
                        
                        expect(malformedResponseError.errorDescription).to.equal("Unable to process response")
                        
                        let invalidStatusCodeError = PequenoNetworking.Error.invalidStatusCodeError(statusCode: 99)
                        
                        expect(invalidStatusCodeError.errorDescription).to.equal("99: Invalid status code")
                        
                        let dataError = PequenoNetworking.Error.dataError
                        
                        expect(dataError.errorDescription).to.equal("Data task does not contain data")
                        
                        let jsonDecodeError = PequenoNetworking.Error.jsonDecodeError(wrappedError: EmptyError.empty)
                        let expectedJSONDecodeError = "Unable to decode json. Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(jsonDecodeError.errorDescription).to.equal(expectedJSONDecodeError)
                        
                        let jsonObjectDecodeError = PequenoNetworking.Error.jsonObjectDecodeError(wrappedError: EmptyError.empty)
                        let expectedJSONObjectDecodeError = "Unable to decode json object. Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(jsonObjectDecodeError.errorDescription).to.equal(expectedJSONObjectDecodeError)
                    }
                }
                
                describe("#failureReason") {
                    it("is the same as the localized description") {
                        let requestError = PequenoNetworking.Error.requestError("You Lose...")
                        let expectedRequestError = "Unable to build URLRequest:\nYou Lose..."
                        
                        expect(requestError.failureReason).to.equal(expectedRequestError)
                        
                        let dataTaskError = PequenoNetworking.Error.dataTaskError(wrappedError: EmptyError.empty)
                        let expectedDataTaskError = "Unable to complete data task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(dataTaskError.failureReason).to.equal(expectedDataTaskError)
                        
                        let malformedResponseError = PequenoNetworking.Error.malformedResponseError
                        
                        expect(malformedResponseError.failureReason).to.equal("Unable to process response")
                        
                        let invalidStatusCodeError = PequenoNetworking.Error.invalidStatusCodeError(statusCode: 99)
                        
                        expect(invalidStatusCodeError.failureReason).to.equal("99: Invalid status code")
                        
                        let dataError = PequenoNetworking.Error.dataError
                        
                        expect(dataError.failureReason).to.equal("Data task does not contain data")
                        
                        let jsonDecodeError = PequenoNetworking.Error.jsonDecodeError(wrappedError: EmptyError.empty)
                        let expectedJSONDecodeError = "Unable to decode json. Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(jsonDecodeError.failureReason).to.equal(expectedJSONDecodeError)
                        
                        let jsonObjectDecodeError = PequenoNetworking.Error.jsonObjectDecodeError(wrappedError: EmptyError.empty)
                        let expectedJSONObjectDecodeError = "Unable to decode json object. Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(jsonObjectDecodeError.failureReason).to.equal(expectedJSONObjectDecodeError)
                    }
                }
                
                describe("#recoverySuggestion") {
                    it("has proper recovery suggestion") {
                        let requestError = PequenoNetworking.Error.requestError("You Lose...")
                        let expectedRequestError = "Verify that the request was built appropriately"
                        
                        expect(requestError.recoverySuggestion).to.equal(expectedRequestError)
                        
                        let dataTaskError = PequenoNetworking.Error.dataTaskError(wrappedError: EmptyError.empty)
                        let expectedDataTaskError = "Verify that your data task was build appropriately"
                        expect(dataTaskError.recoverySuggestion).to.equal(expectedDataTaskError)
                        
                        let malformedResponseError = PequenoNetworking.Error.malformedResponseError
                        
                        expect(malformedResponseError.recoverySuggestion).to.equal("Verify that your response returned is not malformed")
                        
                        let invalidStatusCodeError = PequenoNetworking.Error.invalidStatusCodeError(statusCode: 99)
                        
                        expect(invalidStatusCodeError.recoverySuggestion).to.equal("200 - 299 are valid status codes")
                        
                        let dataError = PequenoNetworking.Error.dataError
                        
                        expect(dataError.recoverySuggestion).to.equal("Verify server is returning valid data")
                        
                        let jsonDecodeError = PequenoNetworking.Error.jsonDecodeError(wrappedError: EmptyError.empty)
                        let expectedJSONDecodeError = "Verify that your Codable types match what is contained data from response"
                        
                        expect(jsonDecodeError.recoverySuggestion).to.equal(expectedJSONDecodeError)
                        
                        let jsonObjectDecodeError = PequenoNetworking.Error.jsonObjectDecodeError(wrappedError: EmptyError.empty)
                        let expectedJSONObjectDecodeError = "Verify that your json data is can be deserialized to Foundation objects"
                        
                        expect(jsonObjectDecodeError.recoverySuggestion).to.equal(expectedJSONObjectDecodeError)
                    }
                }
            }
            
            describe("<Equatable") {
                it("is equatable") {
                    let requestError = PequenoNetworking.Error.requestError("You Lose...")
                    
                    expect(requestError).to.equal(PequenoNetworking.Error.requestError("You Lose..."))
                    
                    let dataTaskError = PequenoNetworking.Error.dataTaskError(wrappedError: EmptyError.empty)
                    
                    expect(requestError).toNot.equal(dataTaskError)
                }
            }
        }
    }
}
