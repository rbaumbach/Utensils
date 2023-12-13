import Quick
import Moocher
import Capsule
@testable import Utensils

final class FileLoaderIntegrationSpec: QuickSpec {
    override func spec() {
        describe("FileLoader") {
            var subject: FileLoader!
            
            beforeEach {
                let testBundle = Bundle(for: type(of: self))
                
                subject = FileLoader(bundle: testBundle)
            }
            
            describe("#loadJSON(name:fileExtension:)") {
                describe("when loading a valid JSON file") {
                    var dolphinData: DolphinData!
                    
                    beforeEach {
                        dolphinData = try! subject.loadJSON(name: "file",
                                                            fileExtension: "json")
                    }
                    
                    it("loads the decoded JSON") {
                        let expdectedDolphinData = DolphinData(data: [
                            Dolphin(name: "Flipper", favoriteToy: "toy-boat"),
                            Dolphin(name: "Snowflake", favoriteToy: "football"),
                            Dolphin(name: "Echo", favoriteToy: "conch-shell")
                        ])
                        
                        expect(dolphinData).to.equal(expdectedDolphinData)
                    }
                }
            }
        }
    }
}
