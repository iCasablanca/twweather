#!/usr/bin/env python
# encoding: utf-8

"""

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

import os
import wsgiref.handlers
import weather
import plistlib
import json
import urllib

from google.appengine.ext import webapp
from google.appengine.api import memcache
from google.appengine.ext.webapp import template

siteURL = "http://twweatherapi.appspot.com/"

class WarningController(webapp.RequestHandler):
	def __init__(self):
		self.model = weather.WeatherWarning()
	def get(self):
		outputtype = self.request.get("output")
		warnings = memcache.get("warnings")
		if warnings is None:
			warnings = self.model.fetch()
			memcache.add("warnings", warnings, 30 * 60)
		if warnings is None:
			return
		if outputtype == "json":
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			jsonText = json.write({"result":warnings})
			self.response.out.write(jsonText)
		else:
			pl = dict(result=warnings)
			output = plistlib.writePlistToString(pl)
			self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
			self.response.out.write(output)
		

class OverviewController(webapp.RequestHandler):
	def __init__(self):
		self.overview = weather.WeatherOverview()
	def get(self):
		outputtype = self.request.get("output")
		if outputtype == "plain":
			text = memcache.get("overview_plain")
			if text is None:
				self.overview.fetch()
				text = self.overview.plain
			memcache.add("overview_plain", text, 30 * 60)
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			self.response.out.write(text)
		else:
			html = memcache.get("overview_html")
			if html is None:
				self.overview.fetch()
				html = self.overview.html
			memcache.add("overview_html", html, 30 * 60)
			self.response.headers['Content-Type'] = 'text/html; charset=utf-8'
			self.response.out.write(html)


class ForecastController(webapp.RequestHandler):
	def __init__(self):
		self.model = weather.WeatherForecast()
		self.key_prefix = "forecast_"
	def getAll(self):
		outputtype = self.request.get("output")
		key = self.key_prefix + "_all"
		allItems = memcache.get(key)
		if allItems is None:
			allItems = []
			for location in self.model.locations():
				id = location['id']
				key = self.key_prefix + str(id)
				result = memcache.get(key)
				if result is None:
					result = self.model.fetchWithID(id)
					if result is None:
						return
				allItems.append(result)
			memcache.add(key, allItems, 30 * 60)
		if outputtype == "json":
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			jsonText = json.write({"result":allItems})
			self.response.out.write(jsonText)
		else:
			pl = dict(result=allItems)
			output = plistlib.writePlistToString(pl)
			self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
			self.response.out.write(output)
	def get(self):
		location = self.request.get("location")
		outputtype = self.request.get("output")
		
		if location == "all":
			self.getAll()
			return
		
		if len(location) == 0:
			locations = self.model.locations()
			items = []
			for location in locations:
				locationName = location['location']
				plistURL = self.request.url + "?location=" + str(location['id'])
				jsonURL = self.request.url + "?location=" + str(location['id']) + "&output=json"
				item = {"locationName":locationName, "plistURL":plistURL, "jsonURL":jsonURL}
				items.append(item)
			if outputtype == "json":
				self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
				jsonText = json.write({"result":items})
				self.response.out.write(jsonText)
			else:
				pl = dict(result=items)
				output = plistlib.writePlistToString(pl)
				self.response.headers['Content-Type'] = 'text/xml; charset=utf-8'
				self.response.out.write(output)
			return
			
		key = self.key_prefix + str(location)
		result = memcache.get(key)
		if result is None:
			result = self.model.fetchWithID(location)
			if result is None:
				return
		else:
			memcache.add(key, result, 30 * 60)

		if outputtype == "json":
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			jsonText = json.write({"result":result})
			self.response.out.write(jsonText)
		else:
			pl = dict(result=result)
			output = plistlib.writePlistToString(pl)
			self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
			self.response.out.write(output)


class WeekController(ForecastController):
	def __init__(self):
		self.model = weather.WeatherWeek()
		self.key_prefix = "week_"

class WeekTravelController(ForecastController):
	def __init__(self):
		self.model = weather.WeatherWeekTravel()
		self.key_prefix = "weekTravel_"

class ThreeDaySeaController(ForecastController):
	def __init__(self):
		self.model = weather.Weather3DaySea()
		self.key_prefix = "3sea_"

class NearSeaController(ForecastController):
	def __init__(self):
		self.model = weather.WeatherNearSea()
		self.key_prefix = "nearsea_"

class TideController(ForecastController):
	def __init__(self):
		self.model = weather.WeatherTide()
		self.key_prefix = "tide_"

class OBSController(ForecastController):
	def __init__(self):
		self.model = weather.WeatherOBS()
		self.key_prefix = "obs_"

class ImageHandler(webapp.RequestHandler):
	def __init__(self):
		self.imageURL = weather.WeatherImageURL
		self.key_prefix = "image_"
	def get(self):
		imageID = self.request.get("id")
		URL = None
		for item in self.imageURL:
			if str(imageID) == str(item['id']):
				URL = item["URL"]
				break
		if URL is None:
			self.error(404)
			return

		redirect = self.request.get("redirect")
		if redirect:
			self.redirect(URL)
			pass

		key = self.key_prefix + str(imageID)
		imageData = memcache.get(key)
		if imageData is None:
			url = urllib.urlopen(URL)
			imageData = url.read()
			if imageData is None:
				self.error(404)
				return
		else:
			memcache.add(key, imageData, 30 * 60)

		self.response.headers["Content-Type"] = "image/jpg"
		self.response.out.write(imageData)

class MainHandler(webapp.RequestHandler):
	def get(self):
		path = os.path.join(os.path.dirname(__file__), 'html', 'main.html')
		self.response.out.write(template.render(path, {}))

def main():
	application = webapp.WSGIApplication(
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
	wsgiref.handlers.CGIHandler().run(application)


if __name__ is '__main__':
	main()
