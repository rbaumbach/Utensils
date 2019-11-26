import Quick
import Nimble
@testable import Utensils

class DebouncerSpec: QuickSpec {
    override func spec() {
        describe("Debouncer") {
            var subject: Debouncer!

            beforeEach {
                subject = Debouncer()
            }
            
            it("exists") {
                expect(subject).toNot(beNil())
            }
        }
    }
}

