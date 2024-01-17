import Quick
import Moocher
import Capsule
@testable import Utensils

final class PequenoNetworking_ErrorSpec: QuickSpec {
    override class func spec() {
        describe("PequenoNetworking+Error") {
            var emptyURLRequestInfo: URLRequestInfo!
            
            beforeEach {
                emptyURLRequestInfo = URLRequestInfo(baseURL: String.empty,
                                                     headers: nil,
                                                     httpMethod: .get,
                                                     endpoint: String.empty,
                                                     parameters: nil, 
                                                     body: nil)
            }
            
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    let expectedCases: [PequenoNetworking.Error] = [.urlRequestError(info: emptyURLRequestInfo),
                                                                    .dataTaskError(wrappedError: EmptyError.empty),
                                                                    .malformedResponseError,
                                                                    .invalidStatusCodeError(statusCode: 0),
                                                                    .dataError,
                                                                    .jsonDecodeError(wrappedError: EmptyError.empty),
                                                                    .jsonObjectDecodeError(wrappedError: EmptyError.empty),
                                                                    .downloadError,
                                                                    .downloadTaskError(wrappedError: EmptyError.empty),
                                                                    .downloadFileManagerError(wrappedError: EmptyError.empty),
                                                                    .uploadTaskError(wrappedError: EmptyError.empty)]
                    
                    expect(PequenoNetworking.Error.allCases).to.equal(expectedCases)
                }
            }
            
            describe("<Error>") {
                describe("#localizedDescription") {
                    describe(".urlRequestError") {
                        var urlRequestInfo: URLRequestInfo!
                        
                        describe("when all info properties have content") {
                            beforeEach {
                                urlRequestInfo = URLRequestInfo(baseURL: "https://cinemassacre.com",
                                                                headers: ["v": "1"],
                                                                httpMethod: .get,
                                                                endpoint: "/avgn",
                                                                parameters: ["item": "power-glove"],
                                                                body: ["2nd-player": "behind-couch"])
                            }
                            
                            it("has proper localized description") {
                                let urlRequestError = PequenoNetworking.Error.urlRequestError(info: urlRequestInfo)
                                let expectedRequestError = "Unable to build URLRequest:\nhost:       https://cinemassacre.com\nheaders:    [\"v\": \"1\"]\nhttp verb:  GET\nendpoint:   /avgn\nparameters: [\"item\": \"power-glove\"]\nbody:       [\"2nd-player\": \"behind-couch\"]"
                                                            
                                expect(urlRequestError.localizedDescription).to.equal(expectedRequestError)
                            }
                        }
                        
                        describe("when headers, parameters and body are nil") {
                            beforeEach {
                                urlRequestInfo = URLRequestInfo(baseURL: "https://cinemassacre.com",
                                                                headers: nil,
                                                                httpMethod: .get,
                                                                endpoint: "/avgn",
                                                                parameters: nil,
                                                                body: nil)
                            }
                            
                            it("has proper localized description") {
                                let urlRequestError = PequenoNetworking.Error.urlRequestError(info: urlRequestInfo)
                                let expectedRequestError = "Unable to build URLRequest:\nhost:       https://cinemassacre.com\nheaders:    N/A\nhttp verb:  GET\nendpoint:   /avgn\nparameters: N/A\nbody:       N/A"
                                                            
                                expect(urlRequestError.localizedDescription).to.equal(expectedRequestError)
                            }
                        }
                    }
                    
                    describe("all other errors") {
                        it("has proper localized description") {
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
                            
                            let downloadError = PequenoNetworking.Error.downloadError
                            
                            expect(downloadError.localizedDescription).to.equal("Download task does not contain url")
                            
                            let downloadTaskError = PequenoNetworking.Error.downloadTaskError(wrappedError: EmptyError.empty)
                            let expectedDownloadTaskError = "Unable to complete download task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                            
                            expect(downloadTaskError.localizedDescription).to.equal(expectedDownloadTaskError)
                            
                            let uploadTaskError = PequenoNetworking.Error.uploadTaskError(wrappedError: EmptyError.empty)
                            let expectedUploadTaskError = "Unable to complete upload task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                            
                            expect(uploadTaskError.localizedDescription).to.equal(expectedUploadTaskError)
                        }
                    }
                }
            }
            
            describe("<LocalizedError>") {
                describe("#errorDescription") {
                    it("is the same as the localized description") {
                        let urlRequestError = PequenoNetworking.Error.urlRequestError(info: emptyURLRequestInfo)
                        let expectedRequestError = "Unable to build URLRequest:\nhost:       \nheaders:    N/A\nhttp verb:  GET\nendpoint:   \nparameters: N/A\nbody:       N/A"
                        
                        expect(urlRequestError.errorDescription).to.equal(expectedRequestError)
                        
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
                        
                        let downloadError = PequenoNetworking.Error.downloadError
                        
                        expect(downloadError.errorDescription).to.equal("Download task does not contain url")
                        
                        let downloadTaskError = PequenoNetworking.Error.downloadTaskError(wrappedError: EmptyError.empty)
                        let expectedDownloadTaskError = "Unable to complete download task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(downloadTaskError.errorDescription).to.equal(expectedDownloadTaskError)
                        
                        let uploadTaskError = PequenoNetworking.Error.uploadTaskError(wrappedError: EmptyError.empty)
                        let expectedUploadTaskError = "Unable to complete upload task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(uploadTaskError.localizedDescription).to.equal(expectedUploadTaskError)
                    }
                }
                
                describe("#failureReason") {
                    it("is the same as the localized description") {
                        let urlRequestError = PequenoNetworking.Error.urlRequestError(info: emptyURLRequestInfo)
                        let expectedRequestError = "Unable to build URLRequest:\nhost:       \nheaders:    N/A\nhttp verb:  GET\nendpoint:   \nparameters: N/A\nbody:       N/A"
                        
                        expect(urlRequestError.failureReason).to.equal(expectedRequestError)
                        
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
                        
                        let downloadError = PequenoNetworking.Error.downloadError
                        
                        expect(downloadError.failureReason).to.equal("Download task does not contain url")
                        
                        let downloadTaskError = PequenoNetworking.Error.downloadTaskError(wrappedError: EmptyError.empty)
                        let expectedDownloadTaskError = "Unable to complete download task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(downloadTaskError.failureReason).to.equal(expectedDownloadTaskError)
                        
                        let uploadTaskError = PequenoNetworking.Error.uploadTaskError(wrappedError: EmptyError.empty)
                        let expectedUploadTaskError = "Unable to complete upload task successfully.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(uploadTaskError.localizedDescription).to.equal(expectedUploadTaskError)
                    }
                }
                
                describe("#recoverySuggestion") {
                    it("has proper recovery suggestion") {
                        let urlRequestError = PequenoNetworking.Error.urlRequestError(info: emptyURLRequestInfo)
                        let expectedRequestError = "Verify that the URLRequest was built appropriately"
                        
                        expect(urlRequestError.recoverySuggestion).to.equal(expectedRequestError)
                        
                        let dataTaskError = PequenoNetworking.Error.dataTaskError(wrappedError: EmptyError.empty)
                        let expectedDataTaskError = "Verify that your data task was built appropriately"
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
                        
                        let downloadError = PequenoNetworking.Error.downloadError
                        
                        expect(downloadError.recoverySuggestion).to.equal("Verify your server is returning valid data")
                        
                        let downloadTaskError = PequenoNetworking.Error.downloadTaskError(wrappedError: EmptyError.empty)
                        let expectedDownloadTaskError = "Verify that your download task was built appropriately"
                        
                        expect(downloadTaskError.recoverySuggestion).to.equal(expectedDownloadTaskError)
                        
                        let uploadTaskError = PequenoNetworking.Error.uploadTaskError(wrappedError: EmptyError.empty)
                        let expectedUploadTaskError = "Verify that your upload task was built appropriately"
                        
                        expect(uploadTaskError.recoverySuggestion).to.equal(expectedUploadTaskError)
                    }
                }
            }
            
            describe("<Equatable") {
                it("is equatable") {
                    let urlRequestError = PequenoNetworking.Error.urlRequestError(info: emptyURLRequestInfo)
                    
                    expect(urlRequestError).to.equal(PequenoNetworking.Error.urlRequestError(info: emptyURLRequestInfo))
                    
                    let dataTaskError = PequenoNetworking.Error.dataTaskError(wrappedError: EmptyError.empty)
                    
                    expect(urlRequestError).toNot.equal(dataTaskError)
                }
            }
        }
    }
}
