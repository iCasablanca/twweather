# TWWeather iPhone App

Copyright © 2000 Weizhong Yang. All Rights Reserved.

## To build the applicaiton

You need

* Mac OS X 10.6 Snow Leopard or Mac OS X 10.5 Leopard
* Intel Mac
* Xcode and iPhone SDK 3.0 or later versions.

Plase follow the steps

* Checkout the source code from GitHub
* Update the git submodules by the following command
	* git submodule init
	* git submodule update
* Open `` TWWeather.xcodeproj`` with Xcode
* Build the application with Xcode

Chinese:

## 編譯

編譯這套程式，您需要

* Mac OS X 10.6 或 Mac OS X 10.5 作業系統
* Intel CPU 的麥金塔電腦
* Xcode 以及iPhone SDK 3.0，。您可以在 [Apple Developer Connection](http://developer.apple.com/iphone/) 上免費取得。在 10.5 與 10.6 上，需要下載安裝不同版本的 iPhone SDK。

請按照以下步驟編譯

1. 請先從 github 上 checkout 程式
2. 成功 check out 之後，請在程式的根目錄，下以下指令
	* git submodule init
	* git submodule update
3. 使用 Xcode 開啟 `` TWWeather.xcodeproj``
4. 選擇要使用 iPhone Simulator 或是 Device 執行，然後按下 build 或 build and run 按鈕