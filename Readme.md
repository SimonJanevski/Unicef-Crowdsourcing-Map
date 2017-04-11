# UNICEF Crowdsourcing Map

iOS Application that uses crowdsourcing and Firebase to provide a way for users with disabilities to report difficulties that they are experiencing throughout the day. Started as a project for Macedonia but I don't see any problem for using it anywhere else.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* You will need a Google Maps API key. You can get it at https://developers.google.com/maps/documentation/ios-sdk/get-api-key. Add it to the AppDelegate.swift like

```
GMSServices.provideAPIKey("INSERT KEY HERE")
```

* Firebase project https://firebase.google.com/

* Firebase config file. You can get it at https://support.google.com/firebase/answer/7015592 and add it to the project

### Installing

If you don't have it already first install cocoapods

```
$ sudo gem install cocoapods
```

then install the dependencies 

```
pod install
```

## Authors

* **[SimonJanevski](https://github.com/SimonJanevski)** - *Initial work* - 
