import Quick
import Moocher
import Capsule
@testable import Utensils

final class PequenoNetworkingSpec: QuickSpec {
    override func spec() {
        describe("PequenoNetworking") {
            var subject: PequenoNetworking!
            
            var fakeClassicNetworkingEngine: FakeClassicNetworkingEngine!
            var fakeNetworkingEngine: FakeNetworkingEngine!
            
            var fakeUserDefaults: FakeUserDefaults!
            
            beforeEach {
                fakeClassicNetworkingEngine = FakeClassicNetworkingEngine()
                fakeNetworkingEngine = FakeNetworkingEngine()
                
                fakeUserDefaults = FakeUserDefaults()
                fakeUserDefaults.stubbedString = "https://ghost.busters"
                fakeUserDefaults.stubbedObject = ["city": "new-york"]
            }
            
            it("has a convience init method that uses user defaults for baseURL and headers") {
                subject = PequenoNetworking(userDefaults: fakeUserDefaults)
                
                expect(subject.baseURL).to.equal("https://ghost.busters")
                expect(subject.headers).to.equal(["city": "new-york"])
            }
            
            it("has a baseURL") {
                subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                            headers: ["city": "new-york"],
                                            classicNetworkingEngine: fakeClassicNetworkingEngine,
                                            networkingEngine: fakeNetworkingEngine)
                
                expect(subject.baseURL).to.equal("https://ghost.busters")
            }
            
            it("has headers") {
                subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                            headers: ["city": "new-york"],
                                            classicNetworkingEngine: fakeClassicNetworkingEngine,
                                            networkingEngine: fakeNetworkingEngine)
                
                expect(subject.headers).to.equal(["city": "new-york"])
            }
            
            describe("JSONSerialization (ol' skoo)") {
                var stubbedResult: Result<Any, PequenoNetworking.Error>!
                var actualResult: Result<Any, PequenoNetworking.Error>!
                
                beforeEach {
                    subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                                headers: ["city": "new-york"],
                                                classicNetworkingEngine: fakeClassicNetworkingEngine,
                                                networkingEngine: fakeNetworkingEngine)
                    
                    stubbedResult = .success("Back off man! I'm a scientist!")
                }
                
                describe("GET") {
                    beforeEach {
                        subject.get(endpoint: "/containment-unit",
                                    parameters: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                                                
                        fakeClassicNetworkingEngine.capturedGetCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedGetBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedGetHeaders).to.equal(["city": "new-york"])
                        expect(fakeClassicNetworkingEngine.capturedGetParameters).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
                
                describe("DELETE") {
                    beforeEach {
                        subject.delete(endpoint: "/containment-unit",
                                       parameters: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        fakeClassicNetworkingEngine.capturedDeleteCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedDeleteBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedDeleteHeaders).to.equal(["city": "new-york"])
                        expect(fakeClassicNetworkingEngine.capturedDeleteParameters).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
                
                describe("POST") {
                    beforeEach {
                        subject.post(endpoint: "/containment-unit",
                                     body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        fakeClassicNetworkingEngine.capturedPostCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedPostBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedPostHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeClassicNetworkingEngine.capturedPostBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
                
                describe("PUT") {
                    beforeEach {
                        subject.put(endpoint: "/containment-unit",
                                    body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        fakeClassicNetworkingEngine.capturedPutCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedPutBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedPutHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeClassicNetworkingEngine.capturedPutBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
                
                describe("PATCH") {
                    beforeEach {
                        subject.patch(endpoint: "/containment-unit",
                                      body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        fakeClassicNetworkingEngine.capturedPatchCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(fakeClassicNetworkingEngine.capturedPatchBaseURL).to.equal("https://ghost.busters")
                        expect(fakeClassicNetworkingEngine.capturedPatchHeaders).to.equal(["city": "new-york"])
                        
                        let typedBody = fakeClassicNetworkingEngine.capturedPatchBody as! [String: String]
                        
                        expect(typedBody).to.equal(["ghost": "slimer"])
                        
                        let typedResult = try! actualResult.get() as! String
                        
                        expect(typedResult).to.equal("Back off man! I'm a scientist!")
                    }
                }
            }
            
            describe("codable networking") {
                var stubbedResult: Result<String, PequenoNetworking.Error>!
                var actualResult: Result<String, PequenoNetworking.Error>!
                
                beforeEach {
                    subject = PequenoNetworking(baseURL: "https://ghost.busters",
                                                headers: ["city": "new-york"],
                                                classicNetworkingEngine: fakeClassicNetworkingEngine,
                                                networkingEngine: fakeNetworkingEngine)
                    
                    stubbedResult = .success("Back off man! I'm a scientist!")
                }
                
                describe("GET") {
                    beforeEach {
                        subject.get<String>(endpoint: "/containment-unit",
                                            parameters: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedGetCompletionHandler as? (Result<String, PequenoNetworking.Error>) -> Void
                                                
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(actualResult).to.equal(stubbedResult)
                    }
                }
                
                describe("DELETE") {
                    beforeEach {
                        subject.delete<String>(endpoint: "/containment-unit",
                                               parameters: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedDeleteCompletionHandler as? (Result<String, PequenoNetworking.Error>) -> Void
                        
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(actualResult).to.equal(stubbedResult)
                    }
                }
                
                describe("POST") {
                    beforeEach {
                        subject.post<String>(endpoint: "/containment-unit",
                                             body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedPostCompletionHandler as? (Result<String, PequenoNetworking.Error>) -> Void
                        
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(actualResult).to.equal(stubbedResult)
                    }
                }
                
                describe("PUT") {
                    beforeEach {
                        subject.put<String>(endpoint: "/containment-unit",
                                            body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedPutCompletionHandler as? (Result<String, PequenoNetworking.Error>) -> Void
                        
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(actualResult).to.equal(stubbedResult)
                    }
                }
                
                describe("PATCH") {
                    beforeEach {
                        subject.patch<String>(endpoint: "/containment-unit",
                                              body: ["ghost": "slimer"]) { result in
                            actualResult = result
                        }
                        
                        let typedCompletionHandler = fakeNetworkingEngine.capturedPatchCompletionHandler as? (Result<String, PequenoNetworking.Error>) -> Void
                        
                        typedCompletionHandler?(stubbedResult)
                    }
                    
                    it("returns the proper result") {
                        expect(actualResult).to.equal(stubbedResult)
                    }
                }
            }
        }
    }
}
