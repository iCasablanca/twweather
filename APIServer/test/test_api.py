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

	def _checkPlistResponse(self, response):
		self.assertEqual(response.status, "200 OK")
		body = response.body
		self.assertNotEqual(body, "")
		obj = plistlib.readPlistFromString(body)
		self.assertTrue(obj)
		self.assertTrue(obj['result'])

	def _handleForecasts(self, path, locations):
		response = self.app.get("/" + path)
		self._checkPlistResponse(response)
		response = self.app.get("/" + path + "?location=all")
		self._checkPlistResponse(response)
		for item in locations:
			location = str(item['id'])	
			response = self.app.get("/" + path + "?location=" + location)
			self._checkPlistResponse(response)

	def testForecasts(self):
		self._handleForecasts("forecast", weather.WeatherForecastLocations)

	def testWeek(self):
		self._handleForecasts("week", weather.WeatherWeekLocations)

	def testWeekTravel(self):
		self._handleForecasts("week_travel", weather.WeatherWeekTravelLocations)

	def testThreeDaySea(self):
		self._handleForecasts("3sea", weather.Weather3DaySeaLocations)

	def testNearSea(self):
		self._handleForecasts("nearsea", weather.WeatherNearSeaLocations)

	def testTide(self):
		self._handleForecasts("tide", weather.WeatherTideLocations)

	def testImage(self):
		for item in weather.WeatherImageURL:
			id = str(item['id'])
			response = self.app.get("/image?id=" + id)
			self.assertEqual(response.headers['Content-Type'], "image/jpg")
