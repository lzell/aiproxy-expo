# About

This project is an Expo module that bridges [AIProxySwift](https://github.com/lzell/AIProxySwift) to JavaScript.
It is useful for iOS-only Expo apps.

## Requirements to add this to your Expo app

- iOS 17.0+
- Expo 54+
- An iOS device

### A physical device is required

AIProxy integrations that use AIProxySwift can normally run on Apple simulators.
However, I have not found a way to thread one of the required env variables, `AIPROXY_DEVICE_CHECK_BYPASS`, through Expo's tooling and into the Xcode scheme.
For now, you will need a physical device while you are working on your app's AIProxy integration.

# How to add aiproxy-expo to an existing Expo app

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

# How to create a new AIProxy expo app

- Ensure node.js is installed on your mac. Our preference is to use [nvm](https://github.com/nvm-sh/nvm) to install `nvm install --lts`.

- Create a new app:

    ```
    cd ~/dev  // Or your preferred source dir
    npx create-expo-app@latest
    :: name the app 'my-app'
    ```

- Reset the project to remove Expo's example app

    ```
    cd my-app
    npm run reset-project
    ```

- Set a bundle ID in `app.json` to exactly match one that is in your [Apple identifier list](https://developer.apple.com/account/resources/identifiers/list):


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
          ],
          // ...
        ],
        "ios": {
          "bundleIdentifier": "<your-bundle-identifier>",
          "appleTeamId": "<your-apple-team>",
        }
      }
    }
    ```

- Optionally remove the `android` and `web` sections from `app.json`

- Install deps

    ```
    npx expo install aiproxy-expo@https://github.com/lzell/aiproxy-expo
    npx expo install expo-build-properties
    ```

- Build and run on device:

    ```
    npx expo prebuild --clean && npx expo run:ios --device
    ```

- Edit `app/index.tsx`, plug in your own `partialKey` and `serviceURL` into the snippet below

    ```
    import { useState } from 'react';
    import { Text, View, Button, ActivityIndicator } from 'react-native';
    import { createOpenAIService } from 'aiproxy-expo';

    export default function Index() {
      const [response, setResponse] = useState<string | null>(null);
      const [loading, setLoading] = useState(false);

      const handlePress = async () => {
        setLoading(true);
        setResponse(null);

        try {
          const openai = createOpenAIService({
            partialKey: '<your-partial-key>',
            serviceURL: '<your-service-url>'
          });

          const result = await openai.chatCompletion('Hello!', {
            model: 'gpt-4o-mini',
            systemMessage: 'You are a helpful assistant'
          });

          setResponse(result);
        } catch (error) {
          setResponse(`Error: ${error}`);
        } finally {
          setLoading(false);
        }
      };

      return (
        <View>
          <Button title="Make request" onPress={handlePress} disabled={loading} />
          {loading && <ActivityIndicator />}
          {response && <Text>{response}</Text>}
        </View>
      );
    }
    ```

- You should see the app on your device update automatically. Tap the `Make request` button on your device.


## Troubleshooting tricks

Notes on things I've had to do to make Expo pick up my changes, in no particular order:

- Verify that AIProxyExpo is found in this output (run from the root of the app):

    ```
    npx expo-modules-autolinking resolve --platform ios
    ```

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

- Fiddle with the generated Xcode workspace. This folder gets regenerated on each build, so don't expect changes to stick.

    ```
    xed ios/myapp.xcworkspace
    ```

   - A handy sanity check is to look inside the `Pods` folder in the xcode project tree and verify that `AIProxy` is there
   - Also look at the `Development Pods` folder and verify that `AIProxyExpo` is there


## Implementation notes

- The [native AIProxy pod](https://github.com/lzell/AIProxySwift/blob/main/AIProxy.podspec) is included as a transitive dependency of this repo's `ios/AIProxyExpo.podspec`.
- `expo-module.config.json` tells Expo that this package has native modules
- `ios/AIProxyExpoModule.swift` exposes the swift bridge
- `src/index.ts` exposes the typescript API
