#!/usr/bin/env python
# encoding: utf-8
"""
weather.py

Created by zonble on 2009-07-26.
"""

import sys
import os
import urllib
import re
import unittest
from datetime import *

WeatherOverViewURL = "http://www.cwb.gov.tw/mobile/real.wml"
WeatherForecastURL = "http://www.cwb.gov.tw/mobile/forecast/city_%(#)02d.wml"
WeatherWeekURL = "http://www.cwb.gov.tw/mobile/week/%(location)s.wml"
WeatherTravelURL = "http://www.cwb.gov.tw/mobile/week_travel/%(location)s.wml"
Weather3DaySeaURL = "http://www.cwb.gov.tw/mobile/3sea/3sea%(#)d.wml"
WeatherNearSeaURL = "http://www.cwb.gov.tw/mobile/nearsea/nearsea%(#)d.wml"

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

WeatherForecastLocations = [
	{"location": u"台北市", "id": 1},
	{"location": u"高雄市", "id": 2},
	{"location": u"基隆", "id": 3},
	{"location": u"台北", "id": 4},
	{"location": u"桃園", "id": 5},
	{"location": u"新竹", "id": 6},
	{"location": u"苗栗", "id": 7},
	{"location": u"台中", "id": 8},
	{"location": u"彰化", "id": 9},
	{"location": u"南投", "id": 10},
	{"location": u"雲林", "id": 11},
	{"location": u"嘉義", "id": 12},
	{"location": u"台南", "id": 13},
	{"location": u"高雄", "id": 14},
	{"location": u"屏東", "id": 15},
	{"location": u"恆春", "id": 16},
	{"location": u"宜蘭", "id": 17},
	{"location": u"花蓮", "id": 18},
	{"location": u"台東", "id": 19},
	{"location": u"澎湖", "id": 20},
	{"location": u"金門", "id": 21},
	{"location": u"馬祖", "id": 22}
	]

class WeatherForecast(Forecast):
	def locations(self):
		return WeatherForecastLocations
	def fetchWithID(self, id):
		locationName = self.locationNameWithID(id)
		if locationName is None:
			return None

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
				title = line[:-7].decode("utf-8")
				isHandlingTime = True
			elif line.startswith("降雨機率："):
				line = line[15:-3]
				rain = line
				item = {"title":title, "time":time, "beginTime":beginTime, "endTime":endTime, "description":description, "temperature":temperature, "rain":rain}
				items.append(item)
			elif line.startswith("溫度(℃)："):
				line = line[14: -7]
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
				description = line[0:-7]
				description = description.decode("utf-8")
				isHandlingDescription = False
		return {"locationName":locationName, "items":items, "id": id}

class TestWeatherForecast(unittest.TestCase):
	def setUp(self):
		self.forecest = WeatherForecast()
	def testForetest(self):
		for i in range(1, 23):
			items = self.forecest.fetchWithID(i)
			self.assertEqual(int(len(items)), 3)

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
			# if line.startswith("<p>發布時間"):
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
					item = {"time": time, "description": description, "wind": wind, "windLevel": windLevel, "wave": wave}
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

def main():
	# print WeatherNearSea().fetchWithID(1)
	unittest.main()
	pass


if __name__ == '__main__':
	main()

