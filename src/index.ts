import { requireNativeModule } from 'expo-modules-core';

interface AIProxyExpoModule {
  openAIChatCompletion(
    partialKey: string,
    serviceURL: string,
    model: string,
    systemMessage: string | null,
    userMessage: string
  ): Promise<string>;

  anthropicChatCompletion(
    partialKey: string,
    serviceURL: string,
    model: string,
    systemMessage: string | null,
    userMessage: string,
    maxTokens: number
  ): Promise<string>;
}

const NativeModule = requireNativeModule<AIProxyExpoModule>('AIProxyExpo');

export interface AIProxyConfig {
  partialKey: string;
  serviceURL: string;
}

export interface OpenAIChatOptions {
  model?: string;
  systemMessage?: string;
}

export interface AnthropicChatOptions {
  model?: string;
  systemMessage?: string;
  maxTokens?: number;
}

export function createOpenAIService(config: AIProxyConfig) {
  return {
    async chatCompletion(
      userMessage: string,
      options: OpenAIChatOptions = {}
    ): Promise<string> {
      const { model = 'gpt-4o', systemMessage } = options;
      return NativeModule.openAIChatCompletion(
        config.partialKey,
        config.serviceURL,
        model,
        systemMessage ?? null,
        userMessage
      );
    },
  };
}

export function createAnthropicService(config: AIProxyConfig) {
  return {
    async chatCompletion(
      userMessage: string,
      options: AnthropicChatOptions = {}
    ): Promise<string> {
      const { model = 'claude-sonnet-4-20250514', systemMessage, maxTokens = 1024 } = options;
      return NativeModule.anthropicChatCompletion(
        config.partialKey,
        config.serviceURL,
        model,
        systemMessage ?? null,
        userMessage,
        maxTokens
      );
    },
  };
}
