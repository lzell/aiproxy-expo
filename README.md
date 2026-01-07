# About

This project is an Expo module that bridges [AIProxySwift](https://github.com/lzell/AIProxySwift) to JavaScript.
It is useful for iOS-only Expo apps.

## Requirements

- iOS 17.0+
- Expo SDK 52+

## Installation

Which of these do I want?

    npm install aiproxy-expo

Or

    npx expo install aiproxy-expo

Then set your bundle identifier to a string that exactly matches one of your registered [App Identifiers](https://developer.apple.com/account/resources/identifiers/list):

```json
{
  "expo": {
      "ios": {
      "bundleIdentifier": "<your-bundle-identifier>",
      "appleTeamId": "<your-apple-team>",
      "deploymentTarget": "17.0"
    },
  }
}
```

## Building

    npm install
    npm run build

## How it works

This is an Expo Module that bridges native Swift code to JavaScript at runtime.

The [native AIProxy pod](https://github.com/lzell/AIProxySwift/blob/main/AIProxy.podspec) is automatically included as a transitive dependency via `AIProxyExpo.podspec`.

Expo's autolinking discovers the module via `expo-module.config.json`.

```
aiproxy-expo/
├── expo-module.config.json       # Tells Expo this package has native modules
├── ios/
│   ├── AIProxyExpo.podspec       # CocoaPods spec (depends on AIProxy pod)
│   └── AIProxyExpoModule.swift   # Swift ↔ JS bridge
└── src/
    └── index.ts                  # TypeScript API
```

## Instructions for AIs

- You do not need to create a Config Plugin for this to work with expo iOS apps
