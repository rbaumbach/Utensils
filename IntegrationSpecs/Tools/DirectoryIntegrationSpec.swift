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
                            
                            url = subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/Documents/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/Documents/")
                            
                            expect(url.lastPathComponent).to.equal("Documents")
                            
                            // relativeString format: file://.../data/Documents/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/Documents/")
                            
                            // Note: The relativePath property does not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/Documents
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("Documents/")
                            expect(url.relativePath).to.contain("Documents")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                    
                    describe("when specifying another directory") {
                        it("has proper URL") {
                            subject = Directory(.documents(additionalPath: "filez/"))
                            
                            url = subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/Documents/filez/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/Documents/filez/")
                            
                            expect(url.lastPathComponent).to.equal("filez")
                            
                            // relativeString format: file://.../data/Documents/filez/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/Documents/filez/")
                            
                            // Note: The relativePath property does not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/Documents/filez
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("Documents/filez/")
                            expect(url.relativePath).to.contain("Documents/filez") // why is this passing?
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                }
                
                describe("Caches directory") {
                    describe("when using root directory") {
                        it("has proper URL") {
                            subject = Directory(.caches())
                            
                            url = subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/Library/Caches/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/Library/Caches/")
                            
                            expect(url.lastPathComponent).to.equal("Caches")
                            
                            // relativeString format: file://.../data/Library/Caches/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/Library/Caches/")
                            
                            // Note: The relativePath property does not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/Library/Caches
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("Caches/")
                            expect(url.relativePath).to.contain("Caches")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                    
                    describe("when specifying another directory") {
                        it("has proper URL") {
                            subject = Directory(.caches(additionalPath: "filez/"))
                            
                            url = subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/Library/Caches/filez/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/Library/Caches/filez")
                            
                            expect(url.lastPathComponent).to.equal("filez")
                            
                            // relativeString format: file://.../data/Library/Caches/filez/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/Library/Caches/filez/")
                            
                            // Note: The relativePath property does not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/Library/Caches/filez
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("Caches/filez/")
                            expect(url.relativePath).to.contain("Caches/filez")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                }
                
                describe("temp directory") {
                    describe("when using root directory") {
                        it("has proper URL") {
                            subject = Directory(.temp())
                            
                            url = subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/tmp/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/tmp/")
                            
                            expect(url.lastPathComponent).to.equal("tmp")
                            
                            // relativeString format: file://.../data/tmp/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/tmp/")
                            
                            // Note: The relativePath property does not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/tmp
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("tmp/")
                            expect(url.relativePath).to.contain("tmp")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                    
                    describe("when specifying another directory") {
                        it("has proper URL") {
                            subject = Directory(.temp(additionalPath: "filez/"))
                            
                            url = subject.url()
                            
                            // Note: The absolute/relativeString properties contain the scheme
                            // and closing forward slash '/' in path
                            
                            // absoluteString format -> file://.../data/tmp/filez/
                            
                            expect(url.absoluteString).to.contain("file://")
                            expect(url.absoluteString).to.contain("/data/tmp/filez")
                            
                            expect(url.lastPathComponent).to.equal("filez")
                            
                            // relativeString format: file://.../data/tmp/filez/
                            
                            expect(url.relativeString).to.contain("file://")
                            expect(url.relativeString).to.contain("/data/tmp/filez/")
                            
                            // Note: The relativePath property does not contain the scheme
                            // or closing forward slash '/' in path
                            
                            // relativePath format -> /.../data/tmp/filez
                            
                            expect(url.relativePath).toNot.contain("file://")
                            expect(url.relativePath).toNot.contain("tmp/filez/")
                            expect(url.relativePath).to.contain("tmp/filez")
                            
                            expect(url.scheme).to.equal("file")
                        }
                    }
                }
            }
        }
    }
}
