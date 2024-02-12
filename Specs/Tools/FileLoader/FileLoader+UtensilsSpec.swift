import Quick
import Moocher
import Capsule
@testable import Utensils

// Note: The FileLoader class is a departure from how protocols are used throughout the project
// Rather than use protocols directly, it uses a generic type that can use concrete types.
// This is a pattern that will show up more once Swift 6.0 is released and the "any" keyword
// is required for using a protocol as a type.

final class FileLoader_UtensilsSpec: QuickSpec {
    // Note: Using typealias so that the generic type isn't required for each instance of
    // FileLoader
    
    typealias FileLoaderError = FileLoader<Bundle,
                                           StringWrapper,
                                           JSONDecoder>.Error
    
    override class func spec() {
        describe("FileLoader+Utensils") {
            describe("<CaseIterable>)") {
                it("has all required cases") {
                    let expectedCases: [FileLoaderError] = [.unableToFindFile(fileName: String.empty),
                                                             .unableToLoadJSONData(wrappedError: EmptyError.empty),
                                                             .unableToDecodeJSONData(wrappedError: EmptyError.empty)]
                    
                    expect(FileLoader.Error.allCases).to.equal(expectedCases)
                }
            }
            
            describe("<Error>") {
                it("has proper localized description") {
                    let unableToFindFile = FileLoaderError.unableToFindFile(fileName: "file.json")
                    let expectedUnableToFindFileDescription = "Unable to find file: file.json"
                    
                    expect(unableToFindFile.localizedDescription).to.equal(expectedUnableToFindFileDescription)
                    
                    
                    let unableToLoadJSONData = FileLoaderError.unableToLoadJSONData(wrappedError: EmptyError.empty)
                    let expectedUnableToLoadJSONDataDescription = "Unable to load json data.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                    
                    expect(unableToLoadJSONData.localizedDescription).to.equal(expectedUnableToLoadJSONDataDescription)
                    
                    let unableToDecodeJSONData = FileLoaderError.unableToDecodeJSONData(wrappedError: EmptyError.empty)
                    let expectedUnableToDecodeJSONData = "Unable to load decoded json data.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                    
                    expect(unableToDecodeJSONData.localizedDescription).to.equal(expectedUnableToDecodeJSONData)
                }
            }
            
            describe("<LocalizedError>") {
                describe("#errorDescription") {
                    it("is the same as the localized description") {
                        let unableToFindFile = FileLoaderError.unableToFindFile(fileName: "file.json")
                        let expectedUnableToFindFileDescription = "Unable to find file: file.json"
                        
                        expect(unableToFindFile.errorDescription).to.equal(expectedUnableToFindFileDescription)
                        
                        
                        let unableToLoadJSONData = FileLoaderError.unableToLoadJSONData(wrappedError: EmptyError.empty)
                        let expectedUnableToLoadJSONDataDescription = "Unable to load json data.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(unableToLoadJSONData.errorDescription).to.equal(expectedUnableToLoadJSONDataDescription)
                        
                        let unableToDecodeJSONData = FileLoaderError.unableToDecodeJSONData(wrappedError: EmptyError.empty)
                        let expectedUnableToDecodeJSONData = "Unable to load decoded json data.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(unableToDecodeJSONData.errorDescription).to.equal(expectedUnableToDecodeJSONData)
                    }
                }
                
                describe("#failureReason") {
                    it("is the same as the localized description") {
                        let unableToFindFile = FileLoaderError.unableToFindFile(fileName: "file.json")
                        let expectedUnableToFindFileDescription = "Unable to find file: file.json"
                        
                        expect(unableToFindFile.failureReason).to.equal(expectedUnableToFindFileDescription)
                        
                        
                        let unableToLoadJSONData = FileLoaderError.unableToLoadJSONData(wrappedError: EmptyError.empty)
                        let expectedUnableToLoadJSONDataDescription = "Unable to load json data.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(unableToLoadJSONData.failureReason).to.equal(expectedUnableToLoadJSONDataDescription)
                        
                        let unableToDecodeJSONData = FileLoaderError.unableToDecodeJSONData(wrappedError: EmptyError.empty)
                        let expectedUnableToDecodeJSONData = "Unable to load decoded json data.  Wrapped Error: \(EmptyError.empty.localizedDescription)"
                        
                        expect(unableToDecodeJSONData.failureReason).to.equal(expectedUnableToDecodeJSONData)
                    }
                }
                
                describe("#recoverySuggestion") {
                    it("has proper recovery suggestion") {
                        let unableToFindFile = FileLoaderError.unableToFindFile(fileName: "file.json")
                        let expectedUnableToFindFileDescription = "Verify that the fileName: file.json is spelled correclty or exists inside Bundle"
                        
                        expect(unableToFindFile.recoverySuggestion).to.equal(expectedUnableToFindFileDescription)
                        
                        
                        let unableToLoadJSONData = FileLoaderError.unableToLoadJSONData(wrappedError: EmptyError.empty)
                        let expectedUnableToLoadJSONDataDescription = "Verify that the file can be loaded as String Data"
                        
                        expect(unableToLoadJSONData.recoverySuggestion).to.equal(expectedUnableToLoadJSONDataDescription)
                        
                        let unableToDecodeJSONData = FileLoaderError.unableToDecodeJSONData(wrappedError: EmptyError.empty)
                        let expectedUnableToDecodeJSONData = "Verify that your Codable types match what is contained in the json file"
                        
                        expect(unableToDecodeJSONData.recoverySuggestion).to.equal(expectedUnableToDecodeJSONData)
                    }
                }
            }
            
            describe("<Equatable") {
                it("is equatable") {
                    let unableToFindFile = FileLoaderError.unableToFindFile(fileName: "file.json")
                    expect(unableToFindFile).to.equal(FileLoaderError.unableToFindFile(fileName: "file.json"))
                    
                    let unableToLoadJSONData = FileLoaderError.unableToLoadJSONData(wrappedError: EmptyError.empty)
                    expect(unableToLoadJSONData).to.equal(FileLoaderError.unableToLoadJSONData(wrappedError: EmptyError.empty))
                    
                    let unableToDecodeJSONData = FileLoaderError.unableToDecodeJSONData(wrappedError: EmptyError.empty)
                    expect(unableToDecodeJSONData).to.equal(FileLoaderError.unableToDecodeJSONData(wrappedError: EmptyError.empty))
                }
            }
        }
    }
}
