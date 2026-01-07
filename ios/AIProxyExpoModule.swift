import ExpoModulesCore
import AIProxy

public class AIProxyExpoModule: Module {
    public func definition() -> ModuleDefinition {
        Name("AIProxyExpo")

        // This function is not named well. I want the user to be able to supply the partialKey and serviceURL to a service, then call chatCompletion on that.
        AsyncFunction("openAIChatCompletion") { (partialKey: String, serviceURL: String, model: String, systemMessage: String?, userMessage: String) -> String in

            let service = AIProxy.openAIService(
                partialKey: partialKey,
                serviceURL: serviceURL
            )

            var messages: [OpenAIChatCompletionRequestBody.Message] = []
            if let systemMessage = systemMessage {
                messages.append(.system(content: .text(systemMessage)))
            }
            messages.append(.user(content: .text(userMessage)))

            let requestBody = OpenAIChatCompletionRequestBody(
                model: model,
                messages: messages
            )

            do {
                let response = try await service.chatCompletionRequest(body: requestBody)
                return response.choices.first?.message.content ?? ""
            } catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
                throw Exception(name: "AIProxyError", description: "HTTP \(statusCode): \(responseBody)")
            } catch {
                throw Exception(name: "AIProxyError", description: error.localizedDescription)
            }
        }

        AsyncFunction("anthropicChatCompletion") { (partialKey: String, serviceURL: String, model: String, systemMessage: String?, userMessage: String, maxTokens: Int) -> String in
            let service = AIProxy.anthropicService(
                partialKey: partialKey,
                serviceURL: serviceURL
            )

            let requestBody = AnthropicMessageRequestBody(
                maxTokens: maxTokens,
                messages: [AnthropicMessageParam(content: .text(userMessage), role: .user)],
                model: model,
                system: systemMessage.map { .text($0) }
            )

            do {
                let response = try await service.messageRequest(body: requestBody)
                if case .textBlock(let textBlock) = response.content.first {
                    return textBlock.text
                }
                return ""
            } catch AIProxyError.unsuccessfulRequest(let statusCode, let responseBody) {
                throw Exception(name: "AIProxyError", description: "HTTP \(statusCode): \(responseBody)")
            } catch {
                throw Exception(name: "AIProxyError", description: error.localizedDescription)
            }
        }
    }
}
