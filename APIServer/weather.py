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

WeatherOverViewURL = "http://www.cwb.gov.tw/mobile/real.wml"
WeatherForecastURL = "http://www.cwb.gov.tw/mobile/forecast/city_%(#)02d.wml"

class WeatherOverview(object):
	def __init__(self):
		self.html = ""
		self.plain = ""
		pass
	def fetch(self):
		url = urllib.urlopen(WeatherOverViewURL)
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

class WeatherForecast(object):
	def __init__(self):
		pass
	def locations(self):
		return WeatherForecastLocations
	def locationNameWithID(self, id):
		try:
			if int(id) > len(WeatherForecastLocations):
				return ""
		except:
			return ""
		for location in WeatherForecastLocations:
			locationID = location['id']
			if int(id) == int(locationID):
				return location['location']
		return ""
	def fetchWithID(self, id):
		try:
			if int(id) > len(WeatherForecastLocations):
				return []
		except:
			return []

		URLString = WeatherForecastURL % {"#": int(id)}
		url = urllib.urlopen(URLString)

		lines = url.readlines()
		items = []

		title = ""
		rain = ""
		temperature = ""
		description = ""
		time = ""
		
		isHandlingTime = False
		isHandlingDescription = False
		
		for line in lines:
			if line.startswith("今") or line.startswith("明"):
				title = line.decode("utf-8")
				isHandlingTime = True
			elif line.startswith("降雨機率："):
				line = line[15:-7]
				rain = line
				item = {"title":title, "time":time, "description":description, "temperature":temperature, "rain":rain}
				items.append(item)
			elif line.startswith("溫度(℃)："):
				line = line[14: -7]
				temperature = line
			elif isHandlingTime == True:
				time = line[0:-7]
				isHandlingTime = False
				isHandlingDescription = True
			elif isHandlingDescription == True:
				description = line[0:-7]
				description = description.decode("utf-8")
				isHandlingDescription = False
		self.items = items
		return items

class TestWeatherForecast(unittest.TestCase):
	def setUp(self):
		self.forecest = WeatherForecast()
	def testForetest(self):
		for i in range(1, 23):
			items = self.forecest.fetchWithID(i)
			self.assertEqual(int(len(items)), 3)

def main():
	unittest.main()
	pass


if __name__ == '__main__':
	main()

