import Quick
import Moocher
import Capsule
@testable import Utensils

struct Junk: Codable {
    
}

final class PequenoNetworkingIntegrationSpec: QuickSpec {
    override func spec() {
        describe("PequenoNetworking") {
            var subject: PequenoNetworking!
            
            beforeEach {
                subject = PequenoNetworking(baseURL: "https://zenquotes.io")
            }
            
            describe("request(endpoint:parameters:httpMethod:headers:completionHandler:)") {
                it("completes with deserialized json") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.request(endpoint: "/api/quotes",
                                        parameters: [:],
                                        httpMethod: .get,
                                        headers: nil) { result in
                            if case .success(let jsonResponse) = result {
                                guard let quotes = jsonResponse as? [Any] else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                expect(quotes).toNot.beEmpty()
                            } else {
                                failSpec()
                            }
                            
                            complete()
                        }
                    }
                }
            }
            
            describe("requestAndDeserialize(endpoint:parameters:httpMethod:headers:completionHandler:)") {
                it("completes with deserialized json") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.requestAndDeserialize(endpoint: "/api/quotes",
                                                      parameters: [:],
                                                      httpMethod: .get,
                                                      headers: nil) { (result: Result<[Quote], PequenoNetworking.Error>)  in
                            if case .success(let decodedResponse) = result {
                                expect(decodedResponse).toNot.beEmpty()
                            } else {
                                failSpec()
                            }

                            complete()
                        }
                    }
                }
            }
        }
    }
}
