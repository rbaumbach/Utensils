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
                        
                        retrievedData = subject.load()
                    }
                    
                    it("writes the data to disk") {
                        expect(retrievedData).to.equal(junkDrawer)
                    }
                }
                
                describe("setting directory and filename") {
                    beforeEach {
                        subject.save(data: junkDrawer,
                                     directory: Directory(.library(additionalPath: "junkDrawer/")),
                                     filename: "junkDrawer")
                        
                        retrievedData = subject.load(directory: Directory(.library(additionalPath: "junkDrawer/")),
                                                     filename: "junkDrawer")
                    }
                    
                    it("writes the data to disk (usi") {
                        expect(retrievedData).to.equal(junkDrawer)
                    }
                }
            }
            
            describe("#save(data:directory:filename:completionHandler:)") {
                describe("using defaults") {
                    it("writes the data to disk") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.save(data: junkDrawer) {
                                retrievedData = subject.load()
                                
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
                                         directory: Directory(.temp(additionalPath: "junkDrawerSaveAsync/")),
                                         filename: "junkDrawerSaveAsync") {
                                retrievedData = subject.load(directory: Directory(.temp(additionalPath: "junkDrawerSaveAsync/")),
                                                             filename: "junkDrawerSaveAsync")
                                
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
                            subject.load { data in
                                expect(data).to.equal(junkDrawer)
                                
                                complete()
                            }
                        }
                    }
                }
                
                describe("retrieving with custom directory and filename") {
                    beforeEach {
                        subject.save(data: junkDrawer,
                                     directory: Directory(.caches(additionalPath: "junkDrawerLoadAsync/")),
                                     filename: "junkDrawerLoadAsync")
                    }
                    
                    it("retrieves the data from disk") {
                        hangOn(for: .seconds(5)) { complete in
                            subject.load(directory: Directory(.caches(additionalPath: "junkDrawerLoadAsync/")),
                                         filename: "junkDrawerLoadAsync") { data in
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
