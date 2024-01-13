import Quick
import Moocher
import Capsule
@testable import Utensils

final class TrunkIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("Trunk") {
            var subject: Trunk!
            
            var junkDrawer: [String]!
            var retrievedData: [String]!
            
            beforeEach {
                subject = Trunk()
                
                junkDrawer = ["sissors", "matches", "tape", "coins", "receipts"]
            }
            
            // Note: Both save tests suites also test out the sychronous load method as well
            
            describe("#save(data:directory:filename") {
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
                describe("using defaults") {
                    it("writes the data to disk") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.save(data: junkDrawer) { _ in
                                retrievedData = try? subject.load().get()
                                
                                expect(retrievedData).to.equal(junkDrawer)
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("setting directory and filename") {
                    it("writes the data to disk") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.save(data: junkDrawer,
                                         filename: "junkDrawerSaveAsync",
                                         directory: Directory(.temp(additionalPath: "junkDrawerSaveAsync/"))) { _ in
                                retrievedData = try? subject.load(filename: "junkDrawerSaveAsync",
                                                                  directory: Directory(.temp(additionalPath: "junkDrawerSaveAsync/"))).get()
                                
                                expect(retrievedData).to.equal(junkDrawer)
                                
                                complete()
                            }
                        }
                    }
                }
            }
            
            describe("#load(directory:filename:completionHandler:)") {
                describe("using defaults") {
                    beforeEach {
                        subject.save(data: junkDrawer)
                    }
                    
                    it("retrieves the data from disk") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.load { (result: Result<[String], Error>) in
                                let data = try? result.get()
                                
                                expect(data).to.equal(junkDrawer)
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("retrieving with custom directory and filename") {
                    beforeEach {
                        subject.save(data: junkDrawer,
                                     filename: "junkDrawerLoadAsync",
                                     directory: Directory(.caches(additionalPath: "junkDrawerLoadAsync/")))
                    }
                    
                    it("retrieves the data from disk") {
                        hangOn(for: .seconds(5)) { complete in
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
