# About

This project is an Expo module that bridges [AIProxySwift](https://github.com/lzell/AIProxySwift) to JavaScript.
It is useful for iOS-only Expo apps.

## Requirements

- iOS 17.0+
- Expo SDK 52+

## Installation

From the root of your expo app:

    npx expo install https://github.com/lzell/aiproxy-expo

Then update your `app.json` to add the config plugin and set your bundle identifier to a string that exactly matches one of your registered [App Identifiers](https://developer.apple.com/account/resources/identifiers/list):

```json
{
  "expo": {
    "plugins": ["aiproxy-expo"],
    "ios": {
      "bundleIdentifier": "<your-bundle-identifier>",
      "appleTeamId": "<your-apple-team>",
      "deploymentTarget": "17.0"
    }
  }
}
```

## How to reload the module

    npm uninstall aiproxy-expo && npm install https://github.com/lzell/aiproxy-expo

## Building

    npm install
    npm run build

## How it works

This is an Expo Module that bridges native Swift code to JavaScript at runtime.

The [native AIProxy pod](https://github.com/lzell/AIProxySwift/blob/main/AIProxy.podspec) is injected into your app's Podfile via the config plugin in `app.plugin.js`. This plugin runs during `expo prebuild` and adds the AIProxy pod dependency.

Expo's autolinking discovers the module via `expo-module.config.json`.

```
aiproxy-expo/
├── app.plugin.js                 # Config plugin that injects AIProxy pod into Podfile
├── expo-module.config.json       # Tells Expo this package has native modules
├── ios/
│   ├── AIProxyExpo.podspec       # CocoaPods spec for the bridge module
│   └── AIProxyExpoModule.swift   # Swift ↔ JS bridge
└── src/
    └── index.ts                  # TypeScript API
```

