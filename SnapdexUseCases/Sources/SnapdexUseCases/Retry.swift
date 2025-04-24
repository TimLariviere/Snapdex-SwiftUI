import Foundation

func getTimestamp() -> UInt64 {
    return UInt64(Date().timeIntervalSince1970 * 1000)
}

func retryOnCondition<T, E: Error>(
    task: @escaping () async -> Result<T, E>,
    shouldRetry: @escaping (E) -> Bool
) async -> Result<T, E> {
    let maxRetries = 3
    var attempt = 0

    while attempt < maxRetries {
        let result = await task()

        switch result {
            case .success:
                return result

            case .failure(let error):
                if !shouldRetry(error) || attempt == maxRetries - 1 {
                    return .failure(error)
                }

                attempt += 1
                let backoff = 1000 * pow(2.0, Double(attempt - 1))
                try? await Task.sleep(nanoseconds: UInt64(backoff * 1_000_000_000))
        }
    }

    fatalError("Unreachable: retry loop exited without returning")
}
