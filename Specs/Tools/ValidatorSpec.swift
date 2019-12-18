import Quick
import Nimble
import Capsule
@testable import Utensils

class ValidatorSpec: QuickSpec {
    override func spec() {
        describe("Validator") {
            var subject: AnyValidator<Dog>!

            beforeEach {
                subject = AnyValidator<Dog>()
            }
            
            it("validates the object given") {
                var dog = Dog()
                
                expect(subject.isValid(dog)).to(beTruthy())
                
                dog.breed = "Pit Bull"
                
                expect(subject.isValid(dog)).to(beFalsy())
                
                let anotherSubject = AnyValidator<Dude>()
                
                let dude = Dude()
                
                expect(anotherSubject.isValid(dude)).to(beTruthy())
            }
        }
    }
}
