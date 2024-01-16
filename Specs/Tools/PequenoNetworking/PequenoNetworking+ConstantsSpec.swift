import Quick
import Moocher
@testable import Utensils

final class PequenoNetworking_ConstantsSpec: QuickSpec {
    override class func spec() {
        describe("PequenoNetworking+Constants") {
            it("has all required constants") {
                expect(PequenoNetworking.Constants.BaseURLKey).to.equal("PequenoNetworkingBaseURLKey")
                
                expect(PequenoNetworking.Constants.HeadersKey).to.equal("PequenoNetworkingHeadersKey")
            }
        }
    }
}
