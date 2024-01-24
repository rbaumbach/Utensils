import Foundation

extension Result {
    func getError() -> Failure? {
        guard case let .failure(error) = self else {
            return nil
        }
        
        return error
    }
}
