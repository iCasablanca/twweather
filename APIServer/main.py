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

forecast = weather.WeatherForecast()

class ForecastController(webapp.RequestHandler):
	def get(self):
		location = self.request.get("location")
		if len(location) == 0:
			self.response.headers['Content-Type'] = 'text/html; charset=utf-8'
			locations = forecast.locations()
			for location in locations:
				self.response.out.write("<li>")
				self.response.out.write(location['location'] + " ")
				self.response.out.write(" <a href='?location=" + str(location['id']) + "'>Plist</a> ")
				self.response.out.write("|")
				self.response.out.write(" <a href='?location=" + str(location['id']) + "&output=json'>JSON</a> ")
				self.response.out.write("</li>")
			return
			
		key = "forecast_" + str(location)
		items = memcache.get(key)
		if items == None:
			items = forecast.fetchWithID(location)
		if len(items) == 0:
			return
		memcache.add(key, items, 30)
		locationName = forecast.locationNameWithID(location)

		outputtype = self.request.get("output")
		if outputtype == "json":
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			jsonText = json.write({"location":locationName,"forecast":items})
			self.response.out.write(jsonText)
			return

		pl = dict(location=locationName, forecast=items)
		output = plistlib.writePlistToString(pl)

		self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
		self.response.out.write(output)

overview = weather.WeatherOverview()

class OverviewController(webapp.RequestHandler):
	def get(self):
		overview.fetch()
		outputtype = self.request.get("output")
		if outputtype == "plain":
			text = memcache.get("overview_plain")
			if text == None:
				text = overview.plain
			memcache.add("overview_plain", text, 30)
			
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			self.response.out.write(text)
			return
		html = memcache.get("overview_html")
		if html == None:
			html = overview.html
		memcache.add("overview_html", html, 30)
		self.response.headers['Content-Type'] = 'text/html; charset=utf-8'
		self.response.out.write(html)

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
			('/forecast', ForecastController)
			],
 			debug=True)
	wsgiref.handlers.CGIHandler().run(application)


if __name__ == '__main__':
	main()
