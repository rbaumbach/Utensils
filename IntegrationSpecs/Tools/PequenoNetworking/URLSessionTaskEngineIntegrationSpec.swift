import Quick
import Moocher
import Capsule
@testable import Utensils

final class URLSessionTaskEngineIntegrationSpec: QuickSpec {
    override class func spec() {
        describe("URLSessionTaskEngine") {
            var subject: URLSessionTaskEngine!
            
            var urlRequest: URLRequest!
            
            var testBundle: Bundle!
                        
            beforeEach {
                testBundle = Bundle(for: self)
                                
                subject = URLSessionTaskEngine()
            }
            
            describe("data tasks") {
                beforeEach {
                    var urlComponents = URLComponents(string: "https://httpbin.org")!
                    urlComponents.path = "/get"
                    
                    urlRequest = URLRequest(url: urlComponents.url!)
                }
                
                it("completes with url to downloaded image") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.dataTask(urlRequest: urlRequest) { result in
                            if case .success(let responseData) = result {
                                let deserializedResponse = try! JSONDecoder().decode(HTTPBin.self,
                                                                                     from: responseData)
                                
                                expect(deserializedResponse.url).to.equal("https://httpbin.org/get")
                            } else {
                                failSpec()
                            }
                                                        
                            complete()
                        }
                    }
                }
            }
            
            describe("download tasks") {
                beforeEach {
                    var urlComponents = URLComponents(string: "https://httpbin.org")!
                    urlComponents.path = "/image/jpeg"
                    
                    urlRequest = URLRequest(url: urlComponents.url!)
                }
                
                it("completes with url to downloaded image") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.downloadTask(urlRequest: urlRequest) { result in
                            if case .success(let url) = result {
                                guard let data = try? Data(contentsOf: url) else {
                                    failSpec()
                                    
                                    return
                                }
                                
                                expect(data.count).to.beGreaterThan(0)
                            } else { failSpec() }
                            
                            complete()
                        }
                    }
                }
            }
            
            describe("upload tasks") {
                var multipartFormData: Data!
                
                beforeEach {
                    var urlComponents = URLComponents(string: "https://httpbin.org")!
                    urlComponents.path = "/post"
                    
                    urlRequest = URLRequest(url: urlComponents.url!)
                    urlRequest.httpMethod = HTTPMethod.post.rawValue
                    
                    let fileURL = testBundle.url(forResource: "file",
                                                 withExtension: "json")!
                    let fileData = try! Data(contentsOf: fileURL)
                    
                    let boundaryUUID = UUID().uuidString
                    
                    multipartFormData = MultipartFormDataBuilder().buildMultipartFormData(data: fileData,
                                                                                          filename: "file.json",
                                                                                          boundaryUUID: boundaryUUID,
                                                                                          contentType: .octetStream)
                    
                    urlRequest.setValue("multipart/form-data; boundary=Boundary-\(boundaryUUID)",
                                        forHTTPHeaderField: "Content-Type")
                }
                
                it("completes successfully") {
                    hangOn(for: .seconds(5)) { complete in
                        subject.uploadTask(urlRequest: urlRequest,
                                           data: multipartFormData) { result in
                            if case .success(let responseData) = result {
                                let deserializedResponse = try! JSONDecoder().decode(HTTPBin.self,
                                                                                     from: responseData)
                                
                                expect(deserializedResponse.url).to.equal("https://httpbin.org/post")
                                expect(deserializedResponse.files!.file).to.contain("Flipper")
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
