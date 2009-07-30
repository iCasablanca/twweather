#!/usr/bin/env python
# encoding: utf-8

import unittest
from google.appengine.ext import webapp
from webtest import TestApp
from main import *
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
	def tearDown(self):
		pass
	def testMain(self):
		app = TestApp(self.application)
		response = app.get("/")
		self.assertEqual(response.status, "200 OK")
		self.assertNotEqual(response.body, "")
		pass
	def testOverview(self):
		app = TestApp(self.application)
		response = app.get("/overview")
		self.assertEqual(response.status, "200 OK")
		html = response.body
		self.assertNotEqual(html, "")
		self.assertNotEqual(html.find("<p>"), -1)
		response = app.get("/overview?output=plain")
		self.assertEqual(response.status, "200 OK")
		plain = response.body
		self.assertNotEqual(plain, "")
		self.assertNotEqual(html.find("\n"), -1)
		self.assertNotEqual(plain, html)
		pass

