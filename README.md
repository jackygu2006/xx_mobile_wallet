## Introduction
> Thanks [Polkawallet](https://github.com/polkawallet-io) for this fantastic framework to develop customized substrate-based blockchain mobile wallet.

xxWallet has the following features:
* Create Quantum Secured(QS) Kyepair, import/export QS mnemonic
* Add [cmix](https://xx.network/cmix-whitepaper.pdf) functions in xxnetwork plugin
* Special features for xxnetwork
* Update UI
* ...

[Download APK](https://xxnetwork.asia/download)

## Dependencies
* Flutter 2.2.2
* Dart 2.13.3
* Node v14.16+

Note: use flutter/dart exactly as aboved version, be sure that `flutter doctor` is well running.

## Repos and Structure
This app was built with several repos.
```
__ xxWallet
    |
    |__ /xx_mobile_wallet
    |    |__ Mobile wallet main code
    |
    |__ /mobile_wallet_sdk
    |    |__ jackygu2006/mobile_wallet_sdk/js_api
    |         |__ Managing Standard and Quantum Secured keyPairs(QSK)
    |         |__ Connect to remote node and call polkadot-js/api methods
    |    |__ Interface writen by dart to connect SDK
    |
    |__ /xxwallet_ui
    |    |__ Some common used flutter widgets, like AddressInputForm, TxConfirmPage, ScanPage...
    |
    |__ /polkawallet_plugin_xxnetwork
    |    |__ Plugin for xxnetwork by mobx framework
    |    |__ Add customized pallets and functions here
    |
    |__ github.com/polkawallet-io/polkawallet_plugin_kusama
    |    |__ Plugin for polkadot/kusama
    |
    |__ <plugin of another substrate based chain>
    |__ <...>
```

## Wallet and Subpuppy framework
The wallet get data from `SubPuppy`(https://github.com/jackygu2006/subpuppy), a indexed database service.

The framework is following:
![](https://tva1.sinaimg.cn/large/008i3skNgy1gygtkyouopj30ri0xaq4h.jpg)

## Installation
### For Android
If you don't want to build release package, just pass step 1-2, forward to step 3.

#### Step 1. Open a new Firebase App
Go to [Filebase console](https://console.firebase.google.com/project/_/overview) to open a new APP, download `google-services.json`.

Refer to [Android Installation for FlutterFire](https://firebase.flutter.dev/docs/installation/android) for more information.

#### Step 2. Generate Key Store file
Generate a Key Store file for signing the App, let's set the file name `sign.jks`.

[Click here](https://developer.android.com/studio/publish/app-signing#generate-key) to get more information on how to generate key store file.

#### Step 3. Build SDK
```
git clone https://github.com/jackygu2006/mobile_wallet_sdk.git`
cd mobile_wallet_sdk
flutter pub get
cd js_api
yarn & yarn build
cd ..
```
After building, the wrapped single `main.js` file will be in `js_api/dist/`. This file will be called by `webViewRunner.dart`.

The Quantum Secured Keyring(QSK) was operated in `lib/service/keyring.dart`, loading `/assets/wasm/sleeve.wasm` and create QSK.

* Note:
After `yarn install`, you need to change `js_api/node-modules/@polkadot/types/augment/lookup/types-substrate.d.ts` a little bit. Add an element `cmix_root?` into interface `PalletStakingValidatorPrefs`, put the type is `Hash`. 

The new `PalletStakingValidatorPrefs` will be like this:
```
    interface PalletStakingValidatorPrefs extends Struct {
        readonly commission: Compact<Perbill>;
        readonly blocked: bool;
        readonly cmix_root?: Hash;
    }
```

#### Step 4. Get xxWallet ui and xxnetwork plugin
```
git clone https://github.com/jackygu2006/xxwallet_ui.git
git clone https://github.com/jackygu2006/polkawallet_plugin_xxnetwork.git
cd xxwallet_ui
flutter pub get
cd ..
cd polkawallet_plugin_xxnetwork
flutter pub get
cd ..
```
Just clone and run `flutter pub get`, don't do anything else.

#### Step 5. Get main xxWallet
```
git clone https://github.com/jackygu2006/xx_mobile_wallet.git
cd xx_mobile_wallet
```

#### Step 6. Config `key.properties`
Copy `google-services.json`(see step 1) into path `xx_mobile_wallet/android/app/`

Copy the key file `sign.jks`(see step 2) into path: `xx_mobile_wallet/android/app/key/`

```
cd android/app/
cp key.properties.sample key.properties
```
Change the following params:
```
storePassword=              # key's store password
keyPassword=                # key's password
keyAlias=sign               # key's alias
storeFile=                  # key file name, ex. app/key/sign.jks
```

#### Step 7. Config `local.properties`
Go to `./android/app/`, copy `local.properties.sample` to `local.properties`, set the params as your development environment.
```
sdk.dir=                    # Android SDK path, ex. /Users/username/Library/Android/sdk 
flutter.sdk=                # Flutter SDK path, ex. /Users/username/web/flutter
flutter.buildMode=release
flutter.versionName=1.0.0
flutter.versionCode=1
jpush.apiKey=               # JiGuang Push service SDK API Key
```

#### Step 8. Build and run
```
cd xx_mobile_wallet
flutter pub get
flutter build apk
```
The `apk` file is `build/app/outputs/flutter-apk/app-release.apk`, download it to Android mobile and install it.

For development on simulator, run `flutter run ./lib/main.dart --flavor=prod`

### For IOS
Refer to [IOS Installation for FlutterFire](https://firebase.flutter.dev/docs/installation/ios)
