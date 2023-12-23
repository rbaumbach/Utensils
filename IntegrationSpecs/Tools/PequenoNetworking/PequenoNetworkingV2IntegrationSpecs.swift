import Quick
import Moocher
import Capsule
@testable import Utensils

final class PequenoNetworkingV2IntegrationSpec: QuickSpec {
    override func spec() {
        describe("PequenoNetworkingV2") {
            var subjectV2: PequenoNetworkingV2!
            
            describe("using JSONSerialization") {
                describe("GET request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.get(endpoint: "/get",
                                          parameters: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
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
                
                describe("DELETE request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(20)) { complete in
                            subjectV2.delete(endpoint: "/delete",
                                             parameters: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
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
                                
                describe("POST request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.post(endpoint: "/post",
                                           body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
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
                
                describe("PUT request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.put(endpoint: "/put",
                                          body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
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
                
                describe("PATCH request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.patch(endpoint: "/patch",
                                            body: nil) { result in
                                if case .success(let jsonResponse) = result {
                                    guard let quotes = jsonResponse as? [String: Any] else {
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
            }
            
            describe("using Codable") {
                describe("GET request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.get(endpoint: "/get",
                                          parameters: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/get")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("DELETE request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.delete(endpoint: "/delete",
                                             parameters: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/delete")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("POST request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.post(endpoint: "/post",
                                           body: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/post")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PUT request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.put(endpoint: "/put",
                                          body: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/put")
                                } else {
                                    failSpec()
                                }
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("PATCH request") {
                    beforeEach {
                        subjectV2 = PequenoNetworkingV2(baseURL: "https://httpbin.org",
                                                        headers: nil)
                    }
                    
                    it("completes with deserialized json") {
                        hangOn(for: .seconds(5)) { complete in
                            subjectV2.patch(endpoint: "/patch",
                                            body: nil) { (result: Result<HTTPBin, PequenoNetworking.Error>) in
                                if case .success(let response) = result {
                                    expect(response.url).to.equal("https://httpbin.org/patch")
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
}
