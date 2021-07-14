# About Smart Home app

Flutter based smart home application for your smart devices such as Light bulb, Fan, AC. Currently the app is configured for ESP based device. [Download Link](https://drive.google.com/file/d/12aQvDQUCBAMufb808jza_7_7Mxf1txus/view?usp=sharing)

## Documentation

### Getting Started
* [Install Flutter](https://flutter.dev/get-started/)
* Clone this repo
* Run pub get to install the dependencies
* Configure your ESP device as well as Andriod/iOS device and then Run the project

## Device adding process

Authentication process of the existing user or SignUp process if not an existing user.Once the user is logged in his/her devices(if any) will be shown on to the home page. The add device process is also simple, on to the first step the user needs to enter the details to home wifi network which will be passed on to the smart device via http request and then user will be requested to connect the smart device to the smartphone. Once the user connects phone with the smart device the device name will be auto verified in order to send the wifi network details. As the name gets verified your device will be added and now you can control that device's state from your mobile.

## Important 

Here to store the state of the application [Shared Preferences](https://pub.dev/packages/shared_preferences) is used. However the session/access token is valid for 1 day so if it gets expired the user will be automatically directed to Login screen.

Also to get the Wi-Fi SSID on Andriod 10 or higher, location permission is required. So for that i have used [Location](https://pub.dev/packages/location) package.

## New to Flutter
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view flutter's
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

<!-- ![Login Screen image](images/loginScreen.png) -->
<!-- <img src="images/loginScreen.png"
     alt="Login Screen"
     style="float: left; margin-right: 10px;"
     height="400px"
      /> -->

