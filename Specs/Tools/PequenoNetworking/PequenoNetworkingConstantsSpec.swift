import Quick
import Moocher
@testable import Utensils

final class PequenoNetworkingConstantsSpec: QuickSpec {
    override func spec() {
        describe("PequenoNetworkingConstants") {
            it("has all required constants") {
                expect(PequenoNetworkingConstants.BaseURLKey).to.equal("PequenoNetworkingBaseURLKey")
                
                expect(PequenoNetworkingConstants.HeadersKey).to.equal("PequenoNetworkingHeadersKey")
            }
        }
    }
}
