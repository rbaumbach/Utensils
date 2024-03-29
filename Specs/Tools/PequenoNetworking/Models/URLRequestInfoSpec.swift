import Quick
import Moocher
@testable import Utensils

final class URLRequestInfoSpec: QuickSpec {
    override class func spec() {
        describe("URLRequestInfo") {
            var subject: URLRequestInfo!
            
            beforeEach {
                subject = URLRequestInfo(baseURL: "https://3s.company",
                                         headers: ["version": "1"],
                                         httpMethod: .get,
                                         endpoint: "/home",
                                         parameters: ["address": "2912-4th-st."],
                                         body: ["occupants": ["jack-tripper",
                                                              "janet-wood",
                                                              "chrissy-snow"]])
            }
            
            it("has a baseURL") {
                expect(subject.baseURL).to.equal("https://3s.company")
            }
            
            it("has headers") {
                expect(subject.headers).to.equal(["version": "1"])
            }
            
            it("has httpMethod") {
                expect(subject.httpMethod).to.equal(.get)
            }
            
            it("has endpoint") {
                expect(subject.endpoint).to.equal("/home")
            }
            
            it("has parameters") {
                expect(subject.parameters).to.equal(["address": "2912-4th-st."])
            }
            
            it("has body") {
                let expectedBody = ["occupants": ["jack-tripper",
                                                  "janet-wood",
                                                  "chrissy-snow"]]
                
                let actualBody = subject.body as! [String: [String]]
                
                expect(actualBody).to.equal(expectedBody)
            }
            
            describe("<Equatable>") {
                it("is equatable") {
                    let moreInfo = URLRequestInfo(baseURL: "https://3s.company",
                                                  headers: ["version": "1"],
                                                  httpMethod: .get,
                                                  endpoint: "/home",
                                                  parameters: ["address": "2912-4th-st."],
                                                  body: ["occupants": ["jack-tripper",
                                                                       "janet-wood",
                                                                       "chrissy-snow"]])
                    expect(subject).to.equal(moreInfo)
                }
            }
        }
    }
}
