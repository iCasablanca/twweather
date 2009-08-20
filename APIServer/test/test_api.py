#!/usr/bin/env python
# encoding: utf-8

import unittest
from google.appengine.ext import webapp
from webtest import TestApp
from main import *
import plistlib
import json
import weather

class TestAPI(unittest.TestCase):

	def setUp(self):
		self.application = webapp.WSGIApplication(
			[
				('/', MainHandler),
				('/overview', OverviewController),
				('/forecast', ForecastController),
				('/week', WeekController),
				('/week_travel', WeekTravelController),
				('/3sea', ThreeDaySeaController),
				('/nearsea', NearSeaController),
				('/tide', TideController),
				('/image', ImageHandler),
				('/obs', OBSController),
				('/warning', WarningController),
				],
	 			debug=True)
		self.app = TestApp(self.application)

	def tearDown(self):
		pass

	def testMain(self):
		response = self.app.get("/")
		self.assertEqual(response.status, "200 OK")
		self.assertNotEqual(type(response), "")

	def testOverview(self):
		response = self.app.get("/overview")
		self.assertEqual(response.status, "200 OK")
		html = response.body
		self.assertNotEqual(html, "")
		self.assertNotEqual(html.find("<p>"), -1)
		response = self.app.get("/overview?output=plain")
		self.assertEqual(response.status, "200 OK")
		plain = response.body
		self.assertNotEqual(plain, "")
		self.assertNotEqual(html.find("\n"), -1)
		self.assertNotEqual(plain, html)

	def _checkPlistResponse(self, response, l = None):
		self.assertEqual(response.status, "200 OK")
		body = response.body
		self.assertNotEqual(body, "")
		obj = plistlib.readPlistFromString(body)
		self.assertTrue(obj)
		self.assertTrue(obj['result'])
		if l != None:
			l(obj['result'])

	def testWarning(self):
		response = self.app.get("/warning")
		self._checkPlistResponse(response)

	def _handleForecasts(self, path, locations, l = None):
		response = self.app.get("/" + path)
		self._checkPlistResponse(response)
		for item in locations:
			location = str(item['id'])	
			response = self.app.get("/" + path + "?location=" + location)
			self._checkPlistResponse(response, l)

	def _testForecastItem(self, result):
		self.assertTrue(result['id'])
		self.assertTrue(result['locationName'])
		self.assertTrue(result['weekLocation'])
		self.assertTrue(result['items'])
		self.assertTrue(len(result['items']) == 3)
		for item in result['items']:
			self.assertTrue(item['beginTime'])
			self.assertTrue(item['description'])
			self.assertTrue(item['endTime'])
			self.assertTrue(item['rain'])
			self.assertTrue(item['temperature'])
			self.assertTrue(item['time'])
			self.assertTrue(item['title'])

	def testForecasts(self):
		l = lambda result: self._testForecastItem(result)
		self._handleForecasts("forecast", weather.WeatherForecastLocations, l)

	def _testWeekItem(self, result):
		self.assertTrue(result['id'])
		self.assertTrue(result['locationName'])
		self.assertTrue(result['publishTime'])
		self.assertTrue(result['items'])
		self.assertTrue(len(result['items']) == 7)
		for item in result['items']:
			self.assertTrue(item['date'])
			self.assertTrue(item['description'])
			self.assertTrue(item['temperature'])

	def testWeek(self):
		l = lambda result: self._testWeekItem(result)
		self._handleForecasts("week", weather.WeatherWeekLocations, l)

	def testWeekTravel(self):
		l = lambda result: self._testWeekItem(result)
		self._handleForecasts("week_travel", weather.WeatherWeekTravelLocations, l)

	def _testThreeDaySeaItem(self, result):
		self.assertTrue(result['id'])
		self.assertTrue(result['locationName'])
		self.assertTrue(result['publishTime'])
		self.assertTrue(result['items'])
		self.assertTrue(len(result['items']) == 3)
		for item in result['items']:
			self.assertTrue(item['date'])
			self.assertTrue(item['description'])
			self.assertTrue(item['wave'])
			self.assertTrue(item['wind'])
			self.assertTrue(item['windScale'])

	def testThreeDaySea(self):
		l = lambda result: self._testThreeDaySeaItem(result)
		self._handleForecasts("3sea", weather.Weather3DaySeaLocations, l)

	def _testNearSeaItem(self, result):
		self.assertTrue(result['id'])
		self.assertTrue(result['locationName'])
		self.assertTrue(result['description'])
		self.assertTrue(result['publishTime'])
		self.assertTrue(result['validBeginTime'])
		self.assertTrue(result['validEndTime'])
		self.assertTrue(result['validTime'])
		self.assertTrue(result['wave'])
		self.assertTrue(result['waveLevel'])
		self.assertTrue(result['wind'])
		self.assertTrue(result['windScale'])

	def testNearSea(self):
		l = lambda result: self._testNearSeaItem(result)
		self._handleForecasts("nearsea", weather.WeatherNearSeaLocations, l)

	def _testTideItem(self, result):
		self.assertTrue(result['id'])
		self.assertTrue(result['locationName'])
		self.assertTrue(len(result['items']) == 3)
		for item in result['items']:
			self.assertTrue(item['date'])
			self.assertTrue(item['lunarDate'])
			self.assertTrue(item['high'])
			self.assertTrue(item['high']['height'])
			self.assertTrue(item['high']['longTime'])
			self.assertTrue(item['high']['shortTime'])
			self.assertTrue(item['low'])
			self.assertTrue(item['low']['height'])
			self.assertTrue(item['low']['longTime'])
			self.assertTrue(item['low']['shortTime'])

	def testTide(self):
		l = lambda result: self._testTideItem(result)
		self._handleForecasts("tide", weather.WeatherTideLocations, l)

	def _testOBSItem(self, result):
		self.assertTrue(result['id'])
		self.assertTrue(result['locationName'])
		self.assertTrue(result['description'])
		self.assertTrue(result['gustWindScale'])
		self.assertTrue(result['rain'])
		self.assertTrue(result['temperature'])
		self.assertTrue(result['time'])
		self.assertTrue(result['windDirection'])
		self.assertTrue(result['windScale'])

	def testOBS(self):
		l = lambda result: self._testOBSItem(result)
		self._handleForecasts("obs", weather.WeatherOBSLocations, l)

	def testImage(self):
		for item in weather.WeatherImageURL:
			id = str(item['id'])
			response = self.app.get("/image?id=" + id)
			self.assertEqual(response.headers['Content-Type'], "image/jpg")
