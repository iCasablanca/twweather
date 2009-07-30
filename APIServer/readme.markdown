#  台灣天氣預報 API Server

2009 © Weizhong Yang (a.k.a zonble). All Rights Reserved

## 簡介

台灣天氣預報 API Server 是一個以 [Google App Engine](http://code.google.com/appengine/) 開發的簡單 web 服務，使用的程式語言為 Python。這個服務的主要功能，在於將[中央氣象局](http://www.cwb.gov.tw/)所提供的天氣預報資料，轉換成可以讓各種 client 端軟體容易取用的格式。

目前支援兩種格式，其一是 [Property list][1]（Plist），是 Mac OS X、iPhone、NextStep 與 GNUStep 所使用的格式，可以讓您快速的將網路上的資料，轉換成 NSArray 或是 NSDictionary 的格式。另外一種則是 Javascript 語言所使用的 [JSON][2] 格式。

## API 格式

這個服務的所在位置為－ [http://twweatherapi.appspot.com/](http://twweatherapi.appspot.com/) 。目前所支援的資料包括：

### 關心天氣

位置：/overview

* 參數：
	* output 輸出格式
		* html：HTML 格式（預設）
		* plain：純文字
		
### 48 小時天氣預報

位置：/forecast

* 參數：
	* output 輸出格式
		* plis Plist 格式（預設）
		* json JSON 格式
	* location 地區
		* all 全部地區的天氣預報
		* 不加 顯示地區列表及對應 URL
		* 1 台北市
		* 2 高雄市
		* 3 基隆
		* 4 台北
		* 5 桃園
		* 6 新竹
		* 7 苗栗
		* 8 台中
		* 9 彰化
		* 10 南投
		* 11 雲林
		* 12 嘉義
		* 13 台南
		* 14 高雄
		* 15 屏東
		* 16 恆春
		* 17 宜蘭
		* 18 花蓮
		* 19 台東
		* 20 澎湖
		* 21 金門
		* 22 馬祖
		
### 一週天氣預報

位置：/week

* 參數：
	* output 輸出格式
		* plis Plist 格式（預設）
		* json JSON 格式
	* location 地區
		* all 全部地區的天氣預報
		* 不加 顯示地區列表及對應 URL
		* Taipei 台北市
		* North 北部
		* Center 中部
		* South 南部
		* North-East 東北部
		* East 東部
		* South-East 東南部
		* Penghu 澎湖
		* Kinmen 金門
		* Matsu 馬祖

### 一週旅遊天氣

位置：/week_travel

* 參數：
	* output 輸出格式
		* plis Plist 格式（預設）
		* json JSON 格式
	* location 地區
		* all 全部地區的天氣預報
		* 不加 顯示地區列表及對應 URL
		* Yang-ming-shan 陽明山
		* Lalashan 拉拉山
		* Lishan 梨山
		* Hohuan-shan 合歡山
		* Sun-Moon-Lake 日月潭
		* Hsitou 溪頭
		* Alishan 阿里山
		* Yushan 玉山
		* Kenting 墾丁
		* Lung-tung 龍洞
		* Taroko 太魯閣
		* San-shiantai 三仙台
		* Lu-Tao 綠島
		* Lanyu 蘭嶼

[1]: http://en.wikipedia.org/wiki/Property_list
[2]: http://www.json.org/ "JSON"
