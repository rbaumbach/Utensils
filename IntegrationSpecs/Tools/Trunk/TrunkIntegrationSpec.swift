import Quick
import Moocher
import Capsule
@testable import Utensils

final class TrunkIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("Trunk") {
            // Note: Both save tests suites also test out the sychronous load method as well
            
            let junkDrawer = ["sissors", "matches", "tape", "coins", "receipts"]
            
            describe("#save(data:directory:filename") {
                var subject: Trunk!
                
                var retrievedData: [String]!
                
                beforeEach {
                    subject = Trunk()
                }
                
                describe("using defaults") {
                    beforeEach {
                        subject.save(data: junkDrawer)
                        
                        retrievedData = try? subject.load().get()
                    }
                    
                    it("writes the data to disk") {
                        expect(retrievedData).to.equal(junkDrawer)
                    }
                }
                
                describe("setting directory and filename") {
                    beforeEach {
                        subject.save(data: junkDrawer,
                                     filename: "junkDrawer",
                                     directory: Directory(.library(additionalPath: "junkDrawer/")))
                        
                        retrievedData = try? subject.load(filename: "junkDrawer",
                                                          directory: Directory(.library(additionalPath: "junkDrawer/"))).get()
                    }
                    
                    it("writes the data to disk") {
                        expect(retrievedData).to.equal(junkDrawer)
                    }
                }
            }
            
            describe("#save(data:directory:filename:completionHandler:)") {
                let subject = Trunk()
                
                describe("using defaults") {
                    it("writes the data to disk") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.save(data: junkDrawer) { _ in
                                let retrievedData: [String]? = try? subject.load().get()
                                
                                expect(retrievedData).to.equal(junkDrawer)
                                
                                complete()
                            }
                        }
                    }
                }
            }
            
            describe("setting directory and filename") {
                it("writes the data to disk") {
                    hangOn(for: .seconds(5)) { complete in
                        let subject = Trunk()
                        
                        subject.save(data: junkDrawer,
                                     filename: "junkDrawerSaveAsync",
                                     directory: Directory(.temp(additionalPath: "junkDrawerSaveAsync/"))) { _ in
                            let retrievedData: [String]? = try? subject.load(filename: "junkDrawerSaveAsync",
                                                                             directory: Directory(.temp(additionalPath: "junkDrawerSaveAsync/"))).get()
                            
                            expect(retrievedData).to.equal(junkDrawer)
                            
                            complete()
                        }
                    }
                }
            }
            
            describe("#load(directory:filename:completionHandler:)") {
                let subject = Trunk()
                
                describe("using defaults") {
                    it("retrieves the data from disk") {
                        hangOn(for: .seconds(50)) { complete in
                            subject.save(data: junkDrawer)
                                                        
                            subject.load { (result: Result<[String], Error>) in
                                let data = try? result.get()
                                
                                expect(data).to.equal(junkDrawer)
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("retrieving with custom directory and filename") {
                    it("retrieves the data from disk") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.save(data: junkDrawer,
                                         filename: "junkDrawerLoadAsync",
                                         directory: Directory(.caches(additionalPath: "junkDrawerLoadAsync/")))
                            
                            subject.load(filename: "junkDrawerLoadAsync",
                                         directory: Directory(.caches(additionalPath: "junkDrawerLoadAsync/")))
                            { (result: Result<[String], Error>) in
                                let data = try? result.get()
                                
                                expect(data).to.equal(junkDrawer)
                                
                                complete()
                            }
                        }
                    }
                }
            }
        }
    }
}
