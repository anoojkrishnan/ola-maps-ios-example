# Sample iOS App using OLAMaps SDK

This is a sample iOS application that demonstrates the integration of the OLAMaps iOS SDK.

# Prerequisites

 1. Create an account in OLAMaps from here: https://maps.olakrutrim.com/
 2. Create a project inside OLAMaps by following the instructions provided here: https://maps.olakrutrim.com/docs/auth
 3. Note down the API Key, Client ID and Client Secret from the project dashboard.
 4. [Download OlaMapNavigation SDK](https://maps.olakrutrim.com/downloads) and import all the `xcframeworks` in your iOS project. Make sure you `embed` all the frameworks in `General > Frameworks, Libraries and Embedded Content`
 5. Add Location Permission Authorization in your Info.plist file. See [Setup Map](https://maps.olakrutrim.com/docs/sdks/navigation-sdks/ios) section for more details
 


## Replace the constants

Open Constants.swift and make the following changes:

 1. Replace the value of `olaClientId` with your actual Client ID
 2. Replace the value of `olaApiKey` with your actual API Key
 3. Replace the value of `olaClientSecret` with your actual Client Secret Key

### Run the project to see the full screen MAP View with your current location