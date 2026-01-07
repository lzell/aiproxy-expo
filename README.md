# About

This project is an Expo module that bridges [AIProxySwift](https://github.com/lzell/AIProxySwift) to JavaScript.
It is useful for iOS-only Expo apps.

## Requirements

- iOS 17.0+
- Expo SDK 52+

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

    npx expo prebuild --clean
    npx expo run:ios --device

## Running your Expo app on the iOS simulator with AIProxy

AIProxy integrations rely on an env variable called `AIPROXY_DEVICE_CHECK_BYPASS` to work on Apple's simulators.
However, I haven't found a good way to thread the env variable through from an expo app into the generated Xcode scheme.
Therefore, I recommend building and running on device using `npx expo run:ios --device`.
Alternatively, you may disable DeviceCheck on your AIProxy service in the left sidebar under 'Settings'.
Please remember to re-enable DeviceCheck before you ship your app.


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

