# Basket-DemoApp
An application in Objective-C to demonstrate some iOS technologies (KVO, Accessibility, Autolayout, MVC)

Basket is an iOS application written in Objective-C that aims to demonstrate what can be achaived with the Key-Observer protocole combined with an MVC architecture.

The application additional features are:
  - Localization
  - Accessibility
  - Multiple Interface Support

## Localization
The application supports 3 language: **English, French and Arabic**. This means there is support for **left-to-right** and **right-to-left** interfaces. This is acheived by using **auto-layout** features to set leading and trailing anchors.

The interface follow seamlessly the user choice of language and local.
  - Numbers follow the user selected local. Puctuation, numeric system, thousand separator.
  - Dates are also formatted following the user choice of local
  - Currency formatting is also following the user choice

*NB: To test the localization, you can either change your device/simulator language or in the Xcode project select a language in the scheme arguments*
    

## Accessibility
The application supports the standard iOS technologies for accessibility. 

### Voice Over
The application is fully adapted for voice over, all interactive elements contain a label and description, so visually impared people can still use the App.
*NB: To check that, from your device Settings app, you can enable voice over and take a look how every element will present hearing aids. If you are on a simulator, you can still acheive this by using the accessibility inspector.*

### Colors
The colors are chosen in a way that color blindness is taken into conideration. The colors are diccerable when inverted color is selected 

### Fonts
The app follows the Dynamic Font technology that allows users to set their prefered font size. The app will react and try to honour these choices so the user can feel more confortable reading through the elements of the app. Also the app supports Bold text accessibility.

### Tappable Areas
All tappable elements respect a minimum spacing between them so people with motricity difficulties can still use the application with ease.


## Multiple Interface Support
The application is optimized for any iOS device interface. Thanks to the **auto-layout** technology landscape, portrait and even split screen are supported and the application can switch seamlessly from one to another.

## Running the project
The application uses [CurrencyLayer](https://currencylayer.com) API to procure currency convertion rates.
To be able to run the project and get Currencies results, you must have an access key. *You can use the free account, the needs only basic information* once you have your access token insert it in the project **info.plist** under the key **AccessKey**

## External Libraries

The app uses the *[UICollectionViewLeftAlignedLayout](https://github.com/mokagio/UICollectionViewLeftAlignedLayout)* and *[UICollectionViewRightAlignedLayout](https://github.com/mokagio/UICollectionViewRightAlignedLayout)* classes written by **mokagio** to layout the collection views according to the interface direction.

## MIT License
Copyright (c) 2017 Joseph El Mallah

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


