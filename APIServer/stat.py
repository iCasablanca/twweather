#!/usr/bin/env python
# encoding: utf-8
"""
stat.py

Created by zonble on 2010-05-17.
Copyright (c) 2010 Lithoglypc Inc. All rights reserved.
"""

import sys
import os

from google.appengine.ext import webapp
from google.appengine.api import memcache
from google.appengine.ext.webapp import template
from google.appengine.ext.webapp.util import run_wsgi_app

import device

class StatHandler(webapp.RequestHandler):
	def count(self, query):
		count = 0
		current_count = 0
		while 1:
			current_count = query.count()
			count += current_count
			if current_count == 1000:
				last_key = query.fetch(1, 999)[0].key()
				query = query.filter('__key__ > ', last_key)
			else:
				break
		return count
		
	def get(self):
		iphone = device.Device.all().order('__key__').filter('device_model =', "iPhone")
		iphone_count = self.count(iphone)
		self.response.out.write("<p>iPhone: " + str(iphone_count) + "</p>")

		self.response.out.write("<ul>")

		iphone_jb = device.Device.all().order('__key__').filter('device_model =', "iPhone").filter('note =', "Has Cydia")
		iphone_jb_count = self.count(iphone_jb)
		self.response.out.write("<li>iPhone JB: " + str(iphone_jb_count) + "</li>")

		iphone_40 = device.Device.all().order('__key__').filter('device_model =', "iPhone").filter('os_version =', "4.0")
		iphone_40_count = self.count(iphone_40)
		self.response.out.write("<li>iPhone 4.0: " + str(iphone_40_count) + "</li>")

		iphone_313 = device.Device.all().order('__key__').filter('device_model =', "iPhone").filter('os_version =', "3.1.3")
		iphone_313_count = self.count(iphone_313)
		self.response.out.write("<li>iPhone 3.1.3: " + str(iphone_313_count) + "</li>")

		iphone_312 = device.Device.all().order('__key__').filter('device_model =', "iPhone").filter('os_version =', "3.1.2")
		iphone_312_count = self.count(iphone_312)
		self.response.out.write("<li>iPhone 3.1.2: " + str(iphone_312_count) + "</li>")

		iphone_311 = device.Device.all().order('__key__').filter('device_model =', "iPhone").filter('os_version =', "3.1.1")
		iphone_311_count = self.count(iphone_311)
		self.response.out.write("<li>iPhone 3.1.1: " + str(iphone_311_count) + "</li>")

		iphone_31 = device.Device.all().order('__key__').filter('device_model =', "iPhone").filter('os_version =', "3.1")
		iphone_31_count = self.count(iphone_31)
		self.response.out.write("<li>iPhone 3.1: " + str(iphone_31_count) + "</li>")

		iphone_30 = device.Device.all().order('__key__').filter('device_model =', "iPhone").filter('os_version =', "3.0")
		iphone_30_count = self.count(iphone_30)
		self.response.out.write("<li>iPhone 3.0: " + str(iphone_30_count) + "</li>")

		self.response.out.write("</ul>")

		ipod = device.Device.all().order('__key__').filter('device_model =', "iPod touch")
		ipod_count = self.count(ipod)
		self.response.out.write("<p>iPod: " + str(ipod_count) + "</p>")

		self.response.out.write("<ul>")

		ipod_jb = device.Device.all().order('__key__').filter('device_model =', "iPod touch").filter('note =', "Has Cydia")
		ipod_jb_count = self.count(ipod_jb)
		self.response.out.write("<li>iPod JB: " + str(ipod_jb_count) + "</li>")

		ipod_40 = device.Device.all().order('__key__').filter('device_model =', "iPod touch").filter('os_version =', "4.0")
		ipod_40_count = self.count(ipod_40)
		self.response.out.write("<li>iPod 4.0: " + str(ipod_40_count) + "</li>")

		ipod_313 = device.Device.all().order('__key__').filter('device_model =', "iPod touch").filter('os_version =', "3.1.3")
		ipod_313_count = self.count(ipod_313)
		self.response.out.write("<li>iPod 3.1.3: " + str(ipod_313_count) + "</li>")

		ipod_312 = device.Device.all().order('__key__').filter('device_model =', "iPod touch").filter('os_version =', "3.1.2")
		ipod_312_count = self.count(ipod_312)
		self.response.out.write("<li>iPod 3.1.2: " + str(ipod_312_count) + "</li>")

		ipod_311 = device.Device.all().order('__key__').filter('device_model =', "iPod touch").filter('os_version =', "3.1.1")
		ipod_311_count = self.count(ipod_311)
		self.response.out.write("<li>iPod 3.1.1: " + str(ipod_311_count) + "</li>")

		ipod_31 = device.Device.all().order('__key__').filter('device_model =', "iPod touch").filter('os_version =', "3.1")
		ipod_31_count = self.count(ipod_31)
		self.response.out.write("<li>iPod 3.1: " + str(ipod_31_count) + "</li>")

		ipod_30 = device.Device.all().order('__key__').filter('device_model =', "iPod touch").filter('os_version =', "3.0")
		ipod_30_count = self.count(ipod_30)
		self.response.out.write("<li>iPod 3.0: " + str(ipod_30_count) + "</li>")

		
		self.response.out.write("</ul>")

		ipad = device.Device.all().order('__key__').filter('device_model =', "iPad")
		ipad_count = self.count(ipad)
		self.response.out.write("<p>iPad: " + str(ipad_count) + "</p>")

		self.response.out.write("<ul>")

		ipad_jb = device.Device.all().order('__key__').filter('device_model =', "iPad").filter('note =', "Has Cydia")
		ipad_jb_count = self.count(ipad_jb)
		self.response.out.write("<li>iPad JB: " + str(ipad_jb_count) + "</li>")
		
		ipad_32 = device.Device.all().order('__key__').filter('device_model =', "iPad").filter('os_version =', "3.2")
		ipad_32_count = self.count(ipad_32)
		self.response.out.write("<li>iPad 3.2: " + str(ipad_32_count) + "</li>")
		

		self.response.out.write("</ul>")


def main():
	application = webapp.WSGIApplication(
		[
			('/stat', StatHandler),
			],
 			debug=True)
	run_wsgi_app(application)