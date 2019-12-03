@testable import Utensils

class FakeAppLaunchViewControllerDelegate: AppLaunchViewControllerDelegate {
    // MARK: - Captured properties
    
    var capturedDidStartLaunchingCompletionHandler: (() ->Void)?
    
    var didFinishLaunchingCalled = false
    
    // MARK: - <AppLaunchViewControllerDelegate>
    
    func didStartLaunching(completionHandler: @escaping () -> Void) {
        capturedDidStartLaunchingCompletionHandler = completionHandler
    }
    
    func didFinishLaunching() {
        didFinishLaunchingCalled = true
    }
}
