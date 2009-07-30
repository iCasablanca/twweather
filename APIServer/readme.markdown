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

### 三天漁業

位置：/3sea

* 參數：
	* output 輸出格式
		* plis Plist 格式（預設）
		* json JSON 格式
	* location 地區
		* 1 黃海南部海面
		* 2 花鳥山海面
		* 3 東海北部海面
		* 4 浙江海面
		* 5 東海南部海面
		* 6 台灣北部海面
		* 7 台灣海峽北部
		* 8 台灣海峽南部
		* 9 台灣東北部海面
		* 10 台灣東南部海面
		* 11 巴士海峽
		* 12 廣東海面
		* 13 東沙島海面
		* 14 中西沙島海面
		* 15 南沙島海面  

### 台灣近海

位置：/nearsea

* 參數：
	* output 輸出格式
		* plis Plist 格式（預設）
		* json JSON 格式
	* location 地區
		* 1 釣魚台海面
		* 2 彭佳嶼基隆海面
		* 3 宜蘭蘇澳沿海
		* 4 新竹鹿港沿海
		* 5 澎湖海面
		* 6 鹿港東石沿海
		* 7 東石安平沿海
		* 8 安平高雄沿海
		* 9 高雄枋寮沿海
		* 10 枋寮恆春沿海
		* 11 鵝鑾鼻沿海
		* 12 成功大武沿海
		* 13 綠島蘭嶼海面
		* 14 花蓮沿海
		* 15 金門海面
		* 16 馬祖海面

### 三天潮汐資料

位置：/tide

* 參數：
	* output 輸出格式
		* plis Plist 格式（預設）
		* json JSON 格式
	* location 地區
		* 1 基隆
		* 2 福隆
		* 3 鼻頭角
		* 4 石門
		* 5 淡水
		* 6 大園
		* 7 新竹
		* 8 苗栗
		* 9 梧棲
		* 10 王功
		* 11 台西
		* 12 東石
		* 13 將軍
		* 14 安平
		* 15 高雄
		* 16 東港
		* 17 南灣
		* 18 澎湖
		* 19 蘇澳
		* 20 頭城
		* 21 花蓮
		* 22 台東
		* 23 成功
		* 24 蘭嶼
		* 25 馬祖
		* 26 金門

## 氣象雲圖

位置 /image

* 參數：
	* id 代號
		* rain 雨量累積圖
		* radar 雷達示波圖
		* color_taiwan 台灣彩色天氣雲圖
		* color_asia 亞洲彩色天氣雲圖
		* hilight_taiwan 台灣色彩強化天氣雲圖
		* hilight_asia 亞洲色彩強化天氣雲圖 

[1]: http://en.wikipedia.org/wiki/Property_list
[2]: http://www.json.org/ "JSON"
