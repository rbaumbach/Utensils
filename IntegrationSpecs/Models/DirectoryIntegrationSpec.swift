import Quick
import Moocher
import Capsule
@testable import Utensils

final class DirectoryIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("Directory") {
            var subject: Directory!
            
            describe("#url()") {
                var url: URL!
                
                describe("Documents directory") {
                    describe("when using root directory") {
                        it("has proper URL") {
                            subject = Directory()
                            
                            url = try! subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/Documents/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/Documents/")
                            
                            expect(url.lastPathComponent).to.equal("Documents")
                            
                            // relativeString format: file://.../data/Documents/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/Documents/")
                            
                            // Note: The relativePath and path properties do not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/Documents
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("Documents/")
                            expect(url.relativePath).to.contain("Documents")
                            
                            // path format -> /.../data/Documents
                            
                            expect(url.path).toNot.contain("file://")
                            expect(url.path).toNot.contain("Documents/")
                            expect(url.path).to.contain("Documents")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                    
                    describe("when specifying another directory") {
                        it("has proper URL") {
                            subject = Directory(.documents(additionalPath: "filez/"))
                            
                            url = try! subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/Documents/filez/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/Documents/filez/")
                            
                            expect(url.lastPathComponent).to.equal("filez")
                            
                            // relativeString format: file://.../data/Documents/filez/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/Documents/filez/")
                            
                            // Note: The relativePath and path properties do not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/Documents/filez
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("Documents/filez/")
                            expect(url.relativePath).to.contain("Documents/filez")
                            
                            // path format -> /.../data/Documents/filez
                            
                            expect(url.path).toNot.contain("file://")
                            expect(url.path).toNot.contain("Documents/filez/")
                            expect(url.path).to.contain("Documents/filez")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                }
                
                describe("Caches directory") {
                    describe("when using root directory") {
                        it("has proper URL") {
                            subject = Directory(.caches())
                            
                            url = try! subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/Library/Caches/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/Library/Caches/")
                            
                            expect(url.lastPathComponent).to.equal("Caches")
                            
                            // relativeString format: file://.../data/Library/Caches/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/Library/Caches/")
                            
                            // Note: The relativePath and path properties do not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/Library/Caches
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("Caches/")
                            expect(url.relativePath).to.contain("Caches")
                            
                            // path format -> /.../data/Library/Caches
                            
                            expect(url.path).toNot.contain("file://")
                            expect(url.path).toNot.contain("Caches/")
                            expect(url.path).to.contain("Caches")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                                        
                    describe("when specifying another directory") {
                        it("has proper URL") {
                            subject = Directory(.caches(additionalPath: "filez/"))
                            
                            url = try! subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/Library/Caches/filez/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/Library/Caches/filez")
                            
                            expect(url.lastPathComponent).to.equal("filez")
                            
                            // relativeString format: file://.../data/Library/Caches/filez/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/Library/Caches/filez/")
                            
                            // Note: The relativePath and path properties do not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/Library/Caches/filez
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("Caches/filez/")
                            expect(url.relativePath).to.contain("Caches/filez")
                            
                            // path format -> /.../data/Library/Caches/filez
                            
                            expect(url.path).toNot.contain("file://")
                            expect(url.path).toNot.contain("Caches/filez/")
                            expect(url.path).to.contain("Caches/filez")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                }
                
                describe("temp directory") {
                    describe("when using root directory") {
                        it("has proper URL") {
                            subject = Directory(.temp())
                            
                            url = try! subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/tmp/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/tmp/")
                            
                            expect(url.lastPathComponent).to.equal("tmp")
                            
                            // relativeString format: file://.../data/tmp/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/tmp/")
                            
                            // Note: The relativePath and path properties do not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/tmp
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("tmp/")
                            expect(url.relativePath).to.contain("tmp")
                            
                            // path format -> /.../data/tmp
                            
                            expect(url.path).toNot.contain("file://")
                            expect(url.path).toNot.contain("tmp/")
                            expect(url.path).to.contain("tmp")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                    
                    describe("when specifying another directory") {
                        it("has proper URL") {
                            subject = Directory(.temp(additionalPath: "filez/"))
                            
                            url = try! subject.url()
                                                        
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/tmp/filez/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/tmp/filez")
                            
                            expect(url.lastPathComponent).to.equal("filez")
                            
                            // relativeString format: file://.../data/tmp/filez/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/tmp/filez/")
                            
                            // Note: The relativePath and path properties do not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/tmp/filez
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("tmp/filez/")
                            expect(url.relativePath).to.contain("tmp/filez")
                            
                            // path format -> /.../data/tmp/filez
                            
                            expect(url.path).toNot.contain("file://")
                            expect(url.path).toNot.contain("tmp/filez/")
                            expect(url.path).to.contain("tmp/filez")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                }
                
                describe("additional path sanitiziation") {
                    describe("when the additional path string has uppercase letters") {
                        it("lowercases the uppercased letters and can build the url properly") {
                            subject = Directory(.temp(additionalPath: "FiLEz"))
                            
                            url = try! subject.url()
                            
                            expect(url.absoluteString).to.contain("/filez/")
                        }
                    }
                    
                    describe("when there is extra space before and after the additional path string") {
                        it("removes it and can build the url properly") {
                            subject = Directory(.temp(additionalPath: "    filez   \n\t"))
                            
                            url = try! subject.url()
                            
                            expect(url.absoluteString).to.contain("/filez/")
                        }
                    }
                    
                    describe("when there is a forward slash before the additional path string") {
                        it("it removes it and can build the url properly") {
                            subject = Directory(.temp(additionalPath: "/filez"))
                            
                            url = try! subject.url()
                            
                            expect(url.absoluteString).toNot.contain("//filez/")
                            expect(url.absoluteString).to.contain("/filez/")
                            
                            subject = Directory(.temp(additionalPath: "    /filez"))
                            
                            url = try! subject.url()
                            
                            expect(url.absoluteString).toNot.contain("//filez/")
                            expect(url.absoluteString).to.contain("/filez/")
                        }
                    }
                }
            }
        }
    }
}
