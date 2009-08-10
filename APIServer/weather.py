#!/usr/bin/env python
# encoding: utf-8
"""
weather.py

Copyright (c) 2009 Weizhong Yang (http://zonble.net)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"""

import sys
import os
import urllib
import re
import unittest
import urllib
from datetime import *
import time

os.environ['TZ'] = "Asia/Taipei"
time.tzset()

WeatherRootURL = "http://www.cwb.gov.tw/mobile/"
WeatherWarningURL = "http://www.cwb.gov.tw/mobile/warning/%(id)s.wml"
WeatherOverViewURL = "http://www.cwb.gov.tw/mobile/real.wml"
WeatherForecastURL = "http://www.cwb.gov.tw/mobile/forecast/city_%(#)02d.wml"
WeatherWeekURL = "http://www.cwb.gov.tw/mobile/week/%(location)s.wml"
WeatherTravelURL = "http://www.cwb.gov.tw/mobile/week_travel/%(location)s.wml"
Weather3DaySeaURL = "http://www.cwb.gov.tw/mobile/3sea/3sea%(#)d.wml"
WeatherNearSeaURL = "http://www.cwb.gov.tw/mobile/nearsea/nearsea%(#)d.wml"
WeatherTideURL = "http://www.cwb.gov.tw/mobile/tide/area%(#)d.wml"
WeatherOBSURL = "http://www.cwb.gov.tw/mobile/obs/%(location)s.wml"

class WeatherWarning(object):
	def __init__(self):
		pass
	def fetch(self):
		try:
			url = urllib.urlopen(WeatherRootURL)
		except:
			return
		warnings = []
		lines = url.readlines()
		for line in lines:
			m = re.search('<a href="warning/(.*).wml">(.*)</a>', line)
			if m is not None:
				id = m.group(1)
				name = m.group(2)
				item = {"id": id, "name": name.decode('utf-8')}
				warnings.append(item)
		for item in warnings:
			URLString = WeatherWarningURL % {"id": id}
			try:
				url = urllib.urlopen(URLString)
			except:
				continue
				pass
			lines = url.readlines()
			text = ""
			for line in lines:
				if line.find("<") == -1:
					line = line.replace("  ", "")
					line = line.replace("　", "")
					line = line.replace(" ", "")
					text = text + line
			item['text'] = text.decode('utf-8')
		return warnings

class TestWeatherWarning(unittest.TestCase):
	def setUp(self):
		self.warnings = WeatherWarning()
	def testOverview(self):
		result = self.warnings.fetch()
		self.assertTrue(result)

class WeatherOverview(object):
	def __init__(self):
		self.html = ""
		self.plain = ""
		pass
	def fetch(self):
		try:
			url = urllib.urlopen(WeatherOverViewURL)
		except:
			return
		lines = url.readlines()
		count = 0
		for line in lines:
			if count == 11:
				html = re.sub("　　", "</p>\n<p>", line) + "</p>"
				plain = re.sub("<p>", "", html)
				plain = re.sub("</p>", "\n", plain)
				self.html = html
				self.plain = plain
				return
			count += 1

class TestWeatherOverview(unittest.TestCase):
	def setUp(self):
		self.overview = WeatherOverview()
	def testOverview(self):
		self.overview.fetch()
		self.assertNotEqual(len(self.overview.html), 0)
		self.assertNotEqual(len(self.overview.plain), 0)

class Forecast(object):
	def locations(self):
		return []
	def locationNameWithID(self, id):
		for location in self.locations():
			locationID = location['id']
			if str(id) == str(locationID):
				return location['location']
		return None
	def locationItemWithID(self, id):
		for location in self.locations():
			locationID = location['id']
			if str(id) == str(locationID):
				return location
		return None


WeatherForecastLocations = [
	{"location": u"台北市", "id": 1 , "weekLocation":"Taipei"},
	{"location": u"高雄市", "id": 2 , "weekLocation":"South"},
	{"location": u"基隆",  "id": 3 , "weekLocation":"North-East"},
	{"location": u"台北",  "id": 4 , "weekLocation":"North"},
	{"location": u"桃園",  "id": 5 , "weekLocation":"North"},
	{"location": u"新竹",  "id": 6 , "weekLocation":"North"},
	{"location": u"苗栗",  "id": 7 , "weekLocation":"North"},
	{"location": u"台中",  "id": 8 , "weekLocation":"Center"},
	{"location": u"彰化",  "id": 9 , "weekLocation":"Center"},
	{"location": u"南投",  "id": 10, "weekLocation":"Center"},
	{"location": u"雲林",  "id": 11, "weekLocation":"Center"},
	{"location": u"嘉義",  "id": 12, "weekLocation":"Center"},
	{"location": u"台南",  "id": 13, "weekLocation":"South"},
	{"location": u"高雄",  "id": 14, "weekLocation":"South"},
	{"location": u"屏東",  "id": 15, "weekLocation":"South"},
	{"location": u"恆春",  "id": 16, "weekLocation":"South"},
	{"location": u"宜蘭",  "id": 17, "weekLocation":"North-East"},
	{"location": u"花蓮",  "id": 18, "weekLocation":"South-East"},
	{"location": u"台東",  "id": 19, "weekLocation":"South-East"},
	{"location": u"澎湖",  "id": 20, "weekLocation":"Penghu"},
	{"location": u"金門",  "id": 21, "weekLocation":"Kinmen"},
	{"location": u"馬祖",  "id": 22, "weekLocation":"Matsu"}
	]

class WeatherForecast(Forecast):
	def locations(self):
		return WeatherForecastLocations
	def fetchWithID(self, id):
		locationItem = self.locationItemWithID(id)
		if locationItem is None:
			return None
		locationName = locationItem['location']
		weekLocation = locationItem['weekLocation']

		URLString = WeatherForecastURL % {"#": int(id)}
		try:
			url = urllib.urlopen(URLString)
		except:
			return None

		lines = url.readlines()
		items = []

		title = ""
		rain = ""
		temperature = ""
		description = ""
		time = ""
		beginTime = ""
		endTime = ""
		
		isHandlingTime = False
		isHandlingDescription = False
		
		for line in lines:
			if line.startswith("今") or line.startswith("明"):
				title = line.replace("<br />", "")[:-1].decode("utf-8")
				isHandlingTime = True
			elif line.startswith("降雨機率："):
				line = line.replace("降雨機率：", "").replace("<br />", "").replace("%", "").replace(" ", "")[0:-1]
				rain = line
				item = {"title":title, "time":time, "beginTime":beginTime, "endTime":endTime, "description":description, "temperature":temperature, "rain":rain}
				items.append(item)
			elif line.startswith("溫度"):
				line = line.replace("溫度(℃)：", "").replace("<br />", "")[0:-1]
				temperature = line
			elif isHandlingTime is True:
				time = line
				today = date.today()
				month = int(today.month)
				year = int(today.year)
				if month == 12 and int(line[0:2]) == 1:
					year = year + 1
				begin = datetime(year, int(line[0:2]), int(line[3:5]), int(line[6:8]), int(line[9:11]))
				beginTime = begin.__str__()
				end = datetime(year, int(line[12:14]), int(line[15:17]), int(line[18:20]), int(line[21:23]))
				endTime = end.__str__()
				time = beginTime + "/" + endTime
				
				isHandlingTime = False
				isHandlingDescription = True
			elif isHandlingDescription is True:
				if line.startswith("<br />") is False and len(line) > 2:
					description = line.replace("<br />", "")[0:-1]
					description = description.decode("utf-8")
					isHandlingDescription = False
		return {"locationName":locationName, "items":items, "id": id, "weekLocation":weekLocation}

class TestWeatherForecast(unittest.TestCase):
	def setUp(self):
		self.forecest = WeatherForecast()
	def testForetest(self):
		for i in range(1, 23):
			result = self.forecest.fetchWithID(i)
			self.assertTrue(result['locationName'])
			self.assertTrue(result['weekLocation'])
			self.assertTrue(result['id'])
			items = result['items']
			self.assertEqual(int(len(items)), 3)
			for item in items:
				self.assertTrue(item['title'])
				self.assertEqual(item['title'].find("<"), -1)
				self.assertTrue(item['time'])
				self.assertTrue(item['beginTime'])
				self.assertTrue(item['endTime'])
				self.assertTrue(item['description'])
				self.assertTrue(item['temperature'])
				self.assertTrue(item['rain'])

WeatherWeekLocations = [
	{"location": u"台北市", "id": "Taipei"},
	{"location": u"北部",  "id": "North"},
	{"location": u"中部",  "id": "Center"},
	{"location": u"南部",  "id": "South"},
	{"location": u"東北部", "id": "North-East"},
	{"location": u"東部",  "id": "East"},
	{"location": u"東南部", "id": "South-East"},
	{"location": u"澎湖",  "id": "Penghu"},
	{"location": u"金門",  "id": "Kinmen"},
	{"location": u"馬祖",  "id": "Matsu"},
	]

class WeatherWeek(Forecast):
	def locations(self):
		return WeatherWeekLocations
	def handleLines(self, URLString, locationName, name):
		try:
			url = urllib.urlopen(URLString)
		except:
			return None
		lines = url.readlines()
		publishTime = ""
		items = []
		
		isHandlingPublishTime = False
		isHandlingTime = False
		isHandlingTemprature = False
		isHandlingItems = False
		temperature = ""
		description = ""
		time = ""
		
		for line in lines:
			if isHandlingItems is True and len(line) is 1 and len(items) > 0:
				break
			if line.find("發布時間") > -1:
				isHandlingPublishTime = True
			elif isHandlingPublishTime is True:
				xdatetime = datetime(int(line[0:4]), int(line[5:7]), int(line[8:10]), int(line[11:13]), int(line[14:16]))
				publishTime = xdatetime.__str__()
				isHandlingPublishTime = False
			elif line.startswith("溫度"):
				isHandlingItems = True
				isHandlingTime = True
			elif isHandlingTemprature is True:
				temperature = line[:-5].decode("utf-8")
				isHandlingTemprature = False
				item = {"date": time, "description": description, "temperature": temperature}
				items.append(item)
			elif isHandlingTime is True:
				if line.startswith("<p>"):
					line = line[3:-7]
					parts = line.split("　")
					timeString = parts[0].decode("utf-8")
					timeParts = timeString.split("/")
					month = int(timeParts[0])
					day = int(timeParts[1])
					year = int(date.today().year)
					if date.today().month == 12 and month == 1:
						year = year + 1
					time = date(year, month, day).__str__()
					description = parts[1].decode("utf-8")
					isHandlingTemprature = True
		self.items = items
		result = {"locationName":locationName, "id":name, "publishTime": publishTime, "items": items}
		return result
	def fetchWithID(self, name):
		locationName = self.locationNameWithID(name)
		if locationName is None:
			return None
		URLString = WeatherWeekURL % {"location": name}
		return self.handleLines(URLString, locationName, name)


class TestWeatherWeek(unittest.TestCase):
	def setUp(self):
		self.week = WeatherWeek()
	def testForetest(self):
		for item in self.week.locations():
			locationName = item['id']
			items = self.week.fetchWithID(locationName)
			self.assertTrue(items)
			self.assertTrue(items["publishTime"])
			self.assertTrue(items["items"])
			self.assertEqual(len(items["items"]), 7)

WeatherWeekTravelLocations = [
	{"location": u"陽明山", "id": "Yang-ming-shan"},
	{"location": u"拉拉山", "id": "Lalashan"},
	{"location": u"梨山", "id": "Lishan"},
	{"location": u"合歡山", "id": "Hohuan-shan"},
	{"location": u"日月潭", "id": "Sun-Moon-Lake"},
	{"location": u"溪頭", "id": "Hsitou"},
	{"location": u"阿里山", "id": "Alishan"},
	{"location": u"玉山", "id": "Yushan"},
	{"location": u"墾丁", "id": "Kenting"},
	{"location": u"龍洞", "id": "Lung-tung"},
	{"location": u"太魯閣", "id": "Taroko"},
	{"location": u"三仙台", "id": "San-shiantai"},
	{"location": u"綠島", "id": "Lu-Tao"},
	{"location": u"蘭嶼", "id": "Lanyu"}
	]

class WeatherWeekTravel(WeatherWeek):
	# def __init__(self):
	# 	pass
	def locations(self):
		return WeatherWeekTravelLocations
	def fetchWithID(self, name):
		locationName = self.locationNameWithID(name)
		if locationName is None:
			return None
		URLString = WeatherTravelURL % {"location": name}
		return self.handleLines(URLString, locationName, name)

class TestWeatherWeekTravel(TestWeatherWeek):
	def setUp(self):
		self.week = WeatherWeekTravel()

Weather3DaySeaLocations = [
	{"location": u"黃海南部海面", "id": 1},
	{"location": u"花鳥山海面", "id": 2},
	{"location": u"東海北部海面",  "id": 3},
	{"location": u"浙江海面", "id": 4},
	{"location": u"東海南部海面", "id": 5},
	{"location": u"台灣北部海面",  "id": 6},
	{"location": u"台灣海峽北部", "id": 7},
	{"location": u"台灣海峽南部",  "id": 8},
	{"location": u"台灣東北部海面",  "id": 9},
	{"location": u"台灣東南部海面",  "id": 10},
	{"location": u"巴士海峽", "id": 11},
	{"location": u"廣東海面", "id": 12},
	{"location": u"東沙島海面",  "id": 13},
	{"location": u"中西沙島海面",  "id": 14},
	{"location": u"南沙島海面",  "id": 15}
	]

class Weather3DaySea(Forecast):
	def locations(self):
		return Weather3DaySeaLocations
	def fetchWithID(self, id):
		locationName = self.locationNameWithID(id)
		if locationName is None:
			return None

		URLString = Weather3DaySeaURL % {"#": int(id)}
		try:
			url = urllib.urlopen(URLString)
		except:
			return None
		lines = url.readlines()
		didHandlingPublishTime = False
		items = []
		count = 0
		publishTime = ""
		time = ""
		description = ""
		wind = ""
		windLevel = ""
		wave = ""

		for line in lines:
			if didHandlingPublishTime:
				if line.startswith("<p>"):
					count = 0
				if count is 1:
					line = line[0:-7]
					parts = line.split("/")
					if len(parts) >  1:
						month = int(parts[0])
						day = int(parts[1])
						year = int(date.today().year)
						if date.today().month == 12 and month == 1:
							year = year + 1
						time = date(year, month, day).__str__()
				elif count is 2:
					description = line[0:-7].decode("utf-8")
				elif count is 3:
					wind = line[0:-7].decode("utf-8")
				elif count is 4:
					windLevel = line[0:-7].decode("utf-8")
				elif count is 5:
					wave = line[0:-7].decode("utf-8")
					item = {"date": time, "description": description, "wind": wind, "windLevel": windLevel, "wave": wave}
					items.append(item)
					if len(items) >= 3:
						break
				count = count + 1
			if line.find("發布時間") > -1:
				line = line[20:-7]
				month = int(line[0:2])
				year = int(date.today().year)
				if date.today().month == 12 and month == 1:
					year = year + 1
				publishTime = datetime(year, month, int(line[3:5]), int (line[6:8]), int(line[9:11])).__str__()
				didHandlingPublishTime = True
		result = {"locationName":locationName, "id":id, "publishTime": publishTime, "items": items}
		return result

class TestWeather3DaySea(unittest.TestCase):
	def setUp(self):
		self.sea = Weather3DaySea()
	def testForetest(self):
		for i in range(1, 15):
			result = self.sea.fetchWithID(i)
			self.assertTrue(result)
			self.assertTrue(result["publishTime"])
			self.assertTrue(result["items"])
			self.assertEqual(len(result["items"]), 3)

WeatherNearSeaLocations = [
	{"location": u"釣魚台海面", "id":1},
	{"location": u"彭佳嶼基隆海面", "id":2},
	{"location": u"宜蘭蘇澳沿海", "id":3},
	{"location": u"新竹鹿港沿海", "id":4},
	{"location": u"澎湖海面", "id":5},
	{"location": u"鹿港東石沿海", "id":6},
	{"location": u"東石安平沿海", "id":7},
	{"location": u"安平高雄沿海", "id":8},
	{"location": u"高雄枋寮沿海", "id":9},
	{"location": u"枋寮恆春沿海", "id":10},
	{"location": u"鵝鑾鼻沿海", "id":11},
	{"location": u"成功大武沿海", "id":12},
	{"location": u"綠島蘭嶼海面", "id":13},
	{"location": u"花蓮沿海", "id":14},
	{"location": u"金門海面", "id":15},
	{"location": u"馬祖海面", "id":16}
	]

class WeatherNearSea(Forecast):
	def locations(self):
		return WeatherNearSeaLocations
	def handleDate(self, line):
		today = date.today()
		month = int(today.month)
		year = int(today.year)
		if month == 12 and int(line[0:2]) == 1:
			year = year + 1
		theDate = datetime(year, int(line[0:2]), int(line[3:5]), int(line[6:8]), int(line[9:11]))
		return theDate.__str__()
	def fetchWithID(self, id):
		locationName = self.locationNameWithID(id)
		if locationName is None:
			return None

		URLString = WeatherNearSeaURL % {"#": int(id)}
		try:
			url = urllib.urlopen(URLString)
		except:
			return None
		
		lines = url.readlines()
		publishTime = ""
		validTime = ""
		validBeginTime = ""
		validEndTime = ""
		didHandledTime = False
		handlingData = False
		description = ""
		wind = ""
		windLevel = ""
		wave = ""
		waveLevel = ""
		lineCount = 0
		for line in lines:
			if line.find("發布時間:") > -1:
				line = line[20:-7]
				publishTime = self.handleDate(line)
			elif line.find("有效時間:") > -1:
				line = line[20:-1]
				parts = line.split("~")
				if len(parts) > 1:
					validBeginTime = self.handleDate(parts[0])
					validEndTime = self.handleDate(parts[1])
					validTime = validBeginTime + "/" + validEndTime
				didHandledTime = True
			elif didHandledTime is True and line.startswith("<p>"):
				handlingData = True
				lineCount = 1
			elif handlingData is True:
				if line.find("</p>") > -1:
					result = {"locationName": locationName, "id": id, "description": description,
						"publishTime": publishTime, "validBeginTime": validBeginTime, 
						"validEndTime": validEndTime, "validTime": validTime,
						"wind": wind, "windLevel": windLevel, "wave": wave,
						"waveLevel": waveLevel
						}
					return result
				line = line.replace("<br />", "")[0:-1].decode("utf-8")
				if lineCount is 1:
					description = line
				elif lineCount is 2:
					wind = line
				elif lineCount is 3:
					windLevel = line
				elif lineCount is 4:
					wave = line
				elif lineCount is 5:
					waveLevel = line
				lineCount = lineCount + 1
		return None

class TestWeatherNearSea(unittest.TestCase):
	def setUp(self):
		self.model = WeatherNearSea()
	def testForetest(self):
		for i in range(1, 16):
			result = self.model.fetchWithID(i)
			self.assertTrue(result)
			self.assertTrue(result["locationName"])
			self.assertTrue(result["id"])
			self.assertTrue(result["publishTime"])
			self.assertTrue(result["validBeginTime"])
			self.assertTrue(result["validEndTime"])
			self.assertTrue(result["validTime"])
			self.assertTrue(result["wind"])
			self.assertTrue(result["windLevel"])
			self.assertTrue(result["wave"])
			self.assertTrue(result["waveLevel"])

WeatherTideLocations = [
	{"location": u"基隆", "id":1},
	{"location": u"福隆", "id":2},
	{"location": u"鼻頭角", "id":3},
	{"location": u"石門", "id":4},
	{"location": u"淡水", "id":5},
	{"location": u"大園", "id":6},
	{"location": u"新竹", "id":7},
	{"location": u"苗栗", "id":8},
	{"location": u"梧棲", "id":9},
	{"location": u"王功", "id":10},
	{"location": u"台西", "id":11},
	{"location": u"東石", "id":12},
	{"location": u"將軍", "id":13},
	{"location": u"安平", "id":14},
	{"location": u"高雄", "id":15},
	{"location": u"東港", "id":16},
	{"location": u"南灣", "id":17},
	{"location": u"澎湖", "id":18},
	{"location": u"蘇澳", "id":19},
	{"location": u"頭城", "id":20},
	{"location": u"花蓮", "id":21},
	{"location": u"台東", "id":22},
	{"location": u"成功", "id":23},
	{"location": u"蘭嶼", "id":24},
	{"location": u"馬祖", "id":25},
	{"location": u"金門", "id":26},
	]

class WeatherTide(Forecast):
	def locations(self):
		return WeatherTideLocations
	def handelWave(self, line, theDate):
		line = line[7:-10]
		parts = line.split(" ")
		if len(parts) > 1:
			shortTime = parts[0]
			height = parts[1]
			hour = int(shortTime[0:2])
			minute = int(shortTime[3:5])
			longTime = datetime(theDate.year, theDate.month, theDate.day, hour, minute).__str__()
			return {"longTime": longTime, "shortTime": shortTime, "height": height}
		
	def fetchWithID(self, id):
		locationName = self.locationNameWithID(id)
		if locationName is None:
			return None

		URLString = WeatherTideURL % {"#": int(id)}
		try:
			url = urllib.urlopen(URLString)
		except:
			return None
		lines = url.readlines()
		items = []
		theDate = None
		time = ""
		lunarTime = ""
		isHandlingItem = False
		low = []
		high = []
		for line in lines:
			if isHandlingItem is False and line.startswith("<p>") and line.find("<br />") > -1:
				isHandlingItem = True
			if isHandlingItem is True:
				if line.startswith("<p>") and line.find("<br />") > -1:
					line = line[3:-7]
					year = int(line[0:4])
					month = int(line[5:7])
					day = int(line[8:10])
					theDate = date(year, month, day)
					time = theDate.__str__()
				elif line.find("農曆") > -1:
					lunarTime = line[0:-7].decode("utf-8")
				elif line.find("乾潮") > -1:
					low = self.handelWave(line, theDate)
				elif line.find("滿潮") > -1:
					high = self.handelWave(line, theDate)
				elif line.find("--------") > -1:
					item = {"date": time, "lunarDate": lunarTime, "low": low, "high": high}
					items.append(item)
					if len(items) >= 3:
						result = {"locationName": locationName, "id": id, "items": items}
						return result

class TestWeatherTide(unittest.TestCase):
	def setUp(self):
		self.model = WeatherTide()
	def testForetest(self):
		for i in range(1, 26):
			result = self.model.fetchWithID(i)
			self.assertEqual(int(len(result['items'])), 3)
			for item in result['items']:
				self.assertTrue(item['date'])
				self.assertTrue(item['lunarDate'])
				self.assertTrue(item['high'])
				self.assertTrue(item['low'])

WeatherImageURL = [
	{"id": "rain", "URL":"http://www.cwb.gov.tw/V6/observe/rainfall/Data/hk.jpg"},
	{"id": "radar", "URL":"http://www.cwb.gov.tw/V6/observe/radar/Data/MOS2_1024/MOS2.jpg"},
	{"id": "color_taiwan", "URL":"http://www.cwb.gov.tw/V6/observe/satellite/Data/s3p/s3p.jpg"},
	{"id": "color_asia", "URL":"http://www.cwb.gov.tw/V6/observe/satellite/Data/s1p/s1p.jpg"},
	{"id": "hilight_taiwan", "URL":"http://www.cwb.gov.tw//V6/observe/satellite/Data/s3q/s3q.jpg"},
	{"id": "hilight_asia", "URL":"http://www.cwb.gov.tw/V6/observe/satellite/Data/s1q/s1q.jpg"},
]

WeatherOBSLocations = [
	{"location": u"基隆", "id": "46694", "area":u"北部", "areaID":"north"},
	{"location": u"台北", "id": "46692", "area":u"北部", "areaID":"north"},
	{"location": u"板橋", "id": "46688", "area":u"北部", "areaID":"north"},
	{"location": u"陽明山","id": "46693", "area":u"北部", "areaID":"north"},
	{"location": u"淡水", "id": "46690", "area":u"北部", "areaID":"north"},
	{"location": u"新店", "id": "A0A9M", "area":u"北部", "areaID":"north"},
	{"location": u"桃園", "id": "46697", "area":u"北部", "areaID":"north"},
	{"location": u"新屋", "id": "C0C45", "area":u"北部", "areaID":"north"},
	{"location": u"新竹", "id": "46757", "area":u"北部", "areaID":"north"},
	{"location": u"雪霸", "id": "C0D55", "area":u"北部", "areaID":"north"},
	{"location": u"三義", "id": "C0E53", "area":u"北部", "areaID":"north"},
	{"location": u"竹南", "id": "C0E42", "area":u"北部", "areaID":"north"},

	{"location": u"台中", "id": "46749", "area":u"中部", "areaID":"center"},
	{"location": u"梧棲", "id": "46777", "area":u"中部", "areaID":"center"},
	{"location": u"梨山", "id": "C0F86", "area":u"中部", "areaID":"center"},
	{"location": u"員林", "id": "C0G65", "area":u"中部", "areaID":"center"},
	{"location": u"鹿港", "id": "C0G64", "area":u"中部", "areaID":"center"},
	{"location": u"日月潭","id": "46765", "area":u"中部", "areaID":"center"},
	{"location": u"廬山", "id": "C0I01", "area":u"中部", "areaID":"center"},
	{"location": u"合歡山","id": "C0H9C", "area":u"中部", "areaID":"center"},
	{"location": u"虎尾", "id": "C0K33", "area":u"中部", "areaID":"center"},
	{"location": u"草嶺", "id": "C0K24", "area":u"中部", "areaID":"center"},
	{"location": u"嘉義", "id": "46748", "area":u"中部", "areaID":"center"},
	{"location": u"阿里山","id": "46753", "area":u"中部", "areaID":"center"},
	{"location": u"玉山", "id": "46755", "area":u"中部", "areaID":"center"},

	{"location": u"台南", "id": "46741", "area":u"南部", "areaID":"south"},
	{"location": u"高雄", "id": "46744", "area":u"南部", "areaID":"south"},
	{"location": u"甲仙", "id": "C0V25", "area":u"南部", "areaID":"south"},
	{"location": u"三地門","id": "C0R15", "area":u"南部", "areaID":"south"},
	{"location": u"恆春", "id": "46759", "area":u"南部", "areaID":"south"},

	{"location": u"宜蘭", "id": "46708", "area":u"東部", "areaID":"east"},
	{"location": u"蘇澳", "id": "46706", "area":u"東部", "areaID":"east"},
	{"location": u"太平山","id": "C0U71", "area":u"東部", "areaID":"east"},
	{"location": u"花蓮", "id": "46699", "area":u"東部", "areaID":"east"},
	{"location": u"玉里", "id": "C0Z06", "area":u"東部", "areaID":"east"},
	{"location": u"成功", "id": "46761", "area":u"東部", "areaID":"east"},
	{"location": u"台東", "id": "46766", "area":u"東部", "areaID":"east"},
	{"location": u"大武", "id": "46754", "area":u"東部", "areaID":"east"},

	{"location": u"澎湖",  "id": "46735", "area":u"外島", "areaID":"island"},
	{"location": u"金門",  "id": "46711", "area":u"外島", "areaID":"island"},
	{"location": u"馬祖",  "id": "46799", "area":u"外島", "areaID":"island"},
	{"location": u"綠島",  "id": "C0S73", "area":u"外島", "areaID":"island"},
	{"location": u"蘭嶼",  "id": "46762", "area":u"外島", "areaID":"island"},
	{"location": u"彭佳嶼", "id": "46695", "area":u"外島", "areaID":"island"},
	{"location": u"東吉島", "id": "46730", "area":u"外島", "areaID":"island"},
	{"location": u"琉球嶼", "id": "C0R27", "area":u"外島", "areaID":"island"},
]

class WeatherOBS(Forecast):
	def locations(self):
		return WeatherOBSLocations
	def fetchWithID(self, id):
		locationName = self.locationNameWithID(id)
		if locationName is None:
			return None

		URLString = WeatherOBSURL % {"location": id}
		try:
			url = urllib.urlopen(URLString)
		except:
			return None

		isHandlingTime = False
		isHandlingDescription = False
		isHandlingTemperature = False
		isHandlingRain = False
		isHandlingWindDirection = False
		isHandlingWindLevel = False
		isHandlingWindStrongestLevel = False
		
		lines = url.readlines()
		time = ""
		description = ""
		temperature = ""
		rain = ""
		windDirection = ""
		windLevel = ""
		windStrongestLevel = ""
		
		for line in lines:
			if isHandlingTime is True:
				if line.startswith("<") is not True:
					year = int(line[0:4])
					month = int(line[5:7])
					day = int(line[8:10])
					hour = int(line[12:14])
					minute = int(line[15:17])
					time = datetime(year, month, day, hour, minute).__str__()
					isHandlingTime = False
			elif line.find("地面觀測") > -1:
				isHandlingTime = True
			elif line.find("天氣現象") > -1:
				isHandlingDescription = True
			elif isHandlingDescription is True:
				line = line.replace("<br />", "")[0:-1]
				if line == "X":
					description = "X"
				else:
					try:
						description = line.decode("ascii")
					except:
						description = line.decode("utf-8")
				isHandlingDescription = False
			elif line.find("溫度") > -1:
				isHandlingTemperature = True
			elif isHandlingTemperature is True:
				line = line.replace("<br />", "")[0:-1]
				try:
					temperature = str(float(line))
				except:
					try:
						temperature = line.decode("ascii")
					except:
						temperature = line.decode("utf-8")
				isHandlingTemperature = False
			elif line.find("累積雨量") > -1:
				isHandlingRain = True
			elif isHandlingRain is True:
				line = line.replace("<br />", "")[0:-1]
				try:
					rain = str(float(line))
				except:
					rain = line.decode("utf-8")
				isHandlingRain = False
			elif line.find("風向") > -1:
				isHandlingWindDirection = True
			elif isHandlingWindDirection is True:
				line = line.replace("<br />", "")[0:-1]
				try:
					windDirection = line.decode("ascii")
				except:
					windDirection = line.decode("utf-8")
				isHandlingWindDirection = False
			elif line.find("風力") > -1:
				isHandlingWindLevel = True
			elif isHandlingWindLevel is True:
				line = line.replace("<br />", "")[0:-1]
				try:
					if int(line)> 0:
						windLevel = str(int(line))
				except:
					try:
						windLevel = line.decode("ascii")
					except:
						windLevel = line.decode("utf-8")
				isHandlingWindLevel = False
			elif line.find("陣風") > -1:
				isHandlingWindStrongestLevel = True
			elif isHandlingWindStrongestLevel is True:
				line = line.replace("<br />", "")[0:-1]
				if line == "X":
					windStrongestLevel = "X"
				else:
					try:
						if int(line)> 0:
							windStrongestLevel = str(int(line))
					except:
						try:
							windStrongestLevel = line.decode("ascii")
						except:
							windStrongestLevel = line.decode("utf-8")
				isHandlingWindStrongestLevel = False
				result = {"locationName": locationName, "id": id, "time": time, "description": description, "temperature": temperature, "rain": rain, "windDirection": windDirection, "windLevel": windLevel, "windStrongestLevel": windStrongestLevel}
				return result
		pass

class TestWeatherOBS(unittest.TestCase):
	def setUp(self):
		self.model = WeatherOBS()
	def testForetest(self):
		for item in self.model.locations():
			result = self.model.fetchWithID(item['id'])
			self.assertTrue(result)
			self.assertTrue(result["locationName"])
			self.assertTrue(result["id"])
			self.assertTrue(result["time"])
			self.assertTrue(result["description"])
			self.assertTrue(result["temperature"])
			self.assertTrue(result["rain"])
			self.assertTrue(result["windDirection"])
			self.assertTrue(result["windLevel"])
			self.assertTrue(result["windStrongestLevel"])

def main():
	unittest.main()

if __name__ == '__main__':
	main()

