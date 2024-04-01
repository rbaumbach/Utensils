import Quick
import Moocher
@testable import Utensils

final class PequenoNetworking_ConstantsSpec: QuickSpec {
    override class func spec() {
        describe("PequenoNetworking+Constants") {
            it("has all required constants") {
                expect(PequenoNetworking.Keys.BaseURLKey).to.equal("PequenoNetworkingBaseURLKey")
                
                expect(PequenoNetworking.Keys.HeadersKey).to.equal("PequenoNetworkingHeadersKey")
            }
        }
    }
}
