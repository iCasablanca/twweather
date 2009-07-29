#!/usr/bin/env python
# encoding: utf-8

import os
import wsgiref.handlers
import weather
import plistlib
import json

from google.appengine.ext import webapp
from google.appengine.api import memcache
from google.appengine.ext.webapp import template

siteURL = "http://twweatherapi.appspot.com/"

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
			memcache.add("overview_plain", text, 30)
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			self.response.out.write(text)
		else:
			html = memcache.get("overview_html")
			if html is None:
				self.overview.fetch()
				html = self.overview.html
			memcache.add("overview_html", html, 30)
			self.response.headers['Content-Type'] = 'text/html; charset=utf-8'
			self.response.out.write(html)


class ForecastController(webapp.RequestHandler):
	def __init__(self):
		self.forecast = weather.WeatherForecast()
	def get(self):
		location = self.request.get("location")
		outputtype = str(self.request.get("output"))
		if len(location) is 0:
			locations = self.forecast.locations()
			items = []
			for location in locations:
				locationName = location['location']
				plistURL = self.request.url + "?location=" + str(location['id'])
				jsonURL = self.request.url + "?location=" + str(location['id']) + "&output=json"
				item = {"locationName":locationName, "plistURL":plistURL, "jsonURL":jsonURL}
				items.append(item)
			if outputtype == "json":
				self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
				jsonText = json.write({"locations":items})
				self.response.out.write(jsonText)
			else:
				pl = dict(locations=items)
				output = plistlib.writePlistToString(pl)
				self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
				self.response.out.write(output)
			return
			
		key = "forecast_" + str(location)
		items = memcache.get(key)
		if items is None:
			items = self.forecast.fetchWithID(location)
		if len(items) is 0:
			return
		memcache.add(key, items, 30)
		locationName = self.forecast.locationNameWithID(location)
		if outputtype == "json":
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			jsonText = json.write({"location":locationName, "forecast":items})
			self.response.out.write(jsonText)
		else:
			pl = dict(location=locationName, forecast=items)
			output = plistlib.writePlistToString(pl)
			self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
			self.response.out.write(output)


class WeekController(webapp.RequestHandler):
	def __init__(self):
		self.week = weather.WeatherWeek()
	def get(self):
		location = self.request.get("location")
		outputtype = str(self.request.get("output"))
		hasLocation = False
		locations = self.week.locations()
		for item in locations:
			name = item['id']
			if name == location:
				hasLocation = True
				break
		if hasLocation is False:
			return
		key = "week_" + str(location)
		result = memcache.get(key)
		if result is None:
			result = self.week.fetchWithLocationName(location)
		if len(result) is 0:
			return
		
		if outputtype == "json":
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			jsonText = json.write({"week":result})
			self.response.out.write(jsonText)
		else:
			pl = dict(week=result)
			output = plistlib.writePlistToString(pl)
			self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
			self.response.out.write(output)


class MainHandler(webapp.RequestHandler):
	def get(self):

		template_values = {
			# 'url': url,
			# 'url_linktext': url_linktext,
		}
		path = os.path.join(os.path.dirname(__file__), 'html', 'main.html')
		self.response.out.write(template.render(path, template_values))


def main():
	application = webapp.WSGIApplication(
		[
			('/', MainHandler),
			('/overview', OverviewController),
			('/forecast', ForecastController),
			('/week', WeekController)
			],
 			debug=True)
	wsgiref.handlers.CGIHandler().run(application)


if __name__ is '__main__':
	main()
