import Foundation
import FoundationModels

@_cdecl("isModelAvailable")
@available(iOS 26.0, *)
public func isModelAvailable() -> Bool {
    return SystemLanguageModel.default.isAvailable
}
@_cdecl("generateText")
@available(iOS 26.0, *)
public func generateText(_ cPrompt: UnsafePointer<CChar>?) -> UnsafeMutablePointer<CChar>? {
    guard let cPrompt else { return strdup("Error: empty prompt") }

    let prompt = String(cString: cPrompt)
    var output = "No response"
    let semaphore = DispatchSemaphore(value: 0)

    Task {
        do {
            guard SystemLanguageModel.default.isAvailable else {
                output = "⚠️ System model unavailable. Enable Apple Intelligence in Settings."
                semaphore.signal()
                return
            }

            let session = LanguageModelSession()
            let reply = try await session.respond(to: prompt)
            output = reply.content
        } catch {
            output = "❌ \(error.localizedDescription)"
        }
        semaphore.signal()
    }

    _ = semaphore.wait(timeout: .now() + 15)
    return strdup(output)
}

