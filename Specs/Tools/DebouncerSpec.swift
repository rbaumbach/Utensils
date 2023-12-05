import Quick
import Moocher
import Capsule
@testable import Utensils

final class DebouncerSpec: QuickSpec {
    override func spec() {
        describe("Debouncer") {
            var subject: Debouncer!
            
            var fakeDispatchQueueWrapper: FakeDispatchQueueWrapper!
            var fakeDispatchWorkItemWrapperBuilder: FakeDispatchWorkItemWrapperBuilder!

            beforeEach {
                fakeDispatchQueueWrapper = FakeDispatchQueueWrapper()
                fakeDispatchWorkItemWrapperBuilder = FakeDispatchWorkItemWrapperBuilder()
                fakeDispatchWorkItemWrapperBuilder.shouldUseDispatchWorkItemWrappersArray = true
                
                subject = Debouncer(dispatchQueueWrapper: fakeDispatchQueueWrapper,
                                    dispatchWorkItemWrapperBuilder: fakeDispatchWorkItemWrapperBuilder)
            }
            
            describe("#mainDebounce(seconds:qos:execute:)") {
                var previousDispatchWorkItemWrapper: FakeDispatchWorkItemWrapper!
                                
                beforeEach {
                    previousDispatchWorkItemWrapper = (subject.currentDispatchWorkItemWrapper as! FakeDispatchWorkItemWrapper)
                                        
                    subject.mainDebounce(seconds: 33.33) { }
                }
                
                it("cancels previous work item wrapper execution") {
                    expect(previousDispatchWorkItemWrapper.didCancel).to.beTruthy()
                }
                
                it("creates a new work item wrapper to execute") {
                    let updatedDispatchWorkItemWrapper = (subject.currentDispatchWorkItemWrapper as! FakeDispatchWorkItemWrapper)
                    
                    expect(updatedDispatchWorkItemWrapper === previousDispatchWorkItemWrapper).toNot.beTruthy()
                }
                
                it("dispatches the new work item wrapper using debounce seconds and qos") {
                    expect(fakeDispatchQueueWrapper.capturedMainAfterWorkItemWrapperSecondsDouble).to.equal(33.33)
                    
                    let actualDispatchWorkItemWrapper = (fakeDispatchQueueWrapper.capturedMainAfterWorkItemWrapperSecondsDoubleProtocol as! FakeDispatchWorkItemWrapper)
                    let updatedDispatchWorkItemWrapper = (subject.currentDispatchWorkItemWrapper as! FakeDispatchWorkItemWrapper)
                    
                    expect(actualDispatchWorkItemWrapper === updatedDispatchWorkItemWrapper).to.beTruthy()
                }
            }
        }
    }
}

