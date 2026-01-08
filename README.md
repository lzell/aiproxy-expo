# About

This project is an Expo module that bridges [AIProxySwift](https://github.com/lzell/AIProxySwift) to JavaScript.
It is useful for iOS-only Expo apps.

## Requirements

- iOS 17.0+
- Expo 54+
- An iOS device

### A physical device is required

AIProxy integrations that use AIProxySwift can normally run on Apple simulators.
However, I have not found a way to thread one of the required env variables, `AIPROXY_DEVICE_CHECK_BYPASS`, through Expo's tooling and into the Xcode scheme.
For now, you will need a physical device while you are working on your app's AIProxy integration.


## Installation

From the root of your expo app:

    npx expo install https://github.com/lzell/aiproxy-expo
    npx expo install expo-build-properties

Then update your `app.json` to set your bundle identifier to a string that exactly matches one of your registered [App Identifiers](https://developer.apple.com/account/resources/identifiers/list):

```json
{
  "expo": {
    "plugins": [
      [
        "expo-build-properties",
        {
          "ios": {
            "deploymentTarget": "18.0"
          }
        }
      ]
    ],
    "ios": {
      "bundleIdentifier": "<your-bundle-identifier>",
      "appleTeamId": "<your-apple-team>",
    }
  }
}
```

Then build and run:

    npx expo prebuild --clean && npx expo run:ios --device


## How to reload the module

    npm uninstall aiproxy-expo && npm install https://github.com/lzell/aiproxy-expo


## How it works

This is an Expo Module that bridges native Swift code to JavaScript at runtime.

The [native AIProxy pod](https://github.com/lzell/AIProxySwift/blob/main/AIProxy.podspec) is automatically included as a transitive dependency via `ios/AIProxyExpo.podspec`.

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


## How to debug wonkiness in an Expo app that relies on AIProxy

Notes on things I've had to do to make Expo pick up my changes, in no particular order:

- Reinstall the `aiproxy-expo` dependency:

    ```
    npm uninstall aiproxy-expo && npm install https://github.com/lzell/aiproxy-expo
    ```

- Clear the node modules cache:

    ```
    rm -rf node_modules/.cache
    ```

- Rebuild native modules:

    ```
    npx expo prebuild --clean && npx expo run:ios --device
    ```

- Restart the dev client (this only works if no native files were changed):

    ```
    npx expo start --dev-client --clear
    ```

- Fiddle with the generated Xcode project in the `ios/` folder. This folder gets regenerated on each build, so don't expect changes to stick.

