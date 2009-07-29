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
		outputtype = self.request.get("output")
		
		if location == "all":
			key = "forecast_all"
			allItems = memcache.get(key)
			if allItems is None:
				allItems = []
				for i in range(1, 22):
					key = "forecast_" + str(i)
					partItems = memcache.get(key)
					if partItems is None:
						partItems = self.forecast.fetchWithID(i)
						if partItems is None:
							return
					locationName = self.forecast.locationNameWithID(i)
					allItems.append({"location":locationName, "forecast":partItems})
				memcache.add(key, allItems, 30)
			if outputtype == "json":
				self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
				jsonText = json.write({"all":allItems})
				self.response.out.write(jsonText)
			else:
				pl = dict(all=allItems)
				output = plistlib.writePlistToString(pl)
				self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
				self.response.out.write(output)
			return
		
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
		else:
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
		self.key_prefix = "week_"
	def get(self):
		location = self.request.get("location")
		outputtype = self.request.get("output")
		locations = self.week.locations()
		
		if location == "all":
			key = self.key_prefix + "all"
			allItems = memcache.get(key)
			if allItems is None:
				allItems = []
				for item in locations:
					name = item['id']
					chineseName = item['location']
					key = "forecast_" + str(name)
					result = memcache.get(key)
					if result is None:
						result = self.week.fetchWithLocationName(name)
						if result is None:
							return
					allItems.append({"week":result, "location":chineseName, "id":name})
				memcache.add(key, allItems, 30)
			if outputtype == "json":
				self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
				jsonText = json.write({"all":allItems})
				self.response.out.write(jsonText)
			else:
				pl = dict(all=allItems)
				output = plistlib.writePlistToString(pl)
				self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
				self.response.out.write(output)
			return

		hasLocation = False
		chineseName = ""

		for item in locations:
			name = item['id']
			if name == location:
				chineseName = item['location']
				hasLocation = True
				break
		if hasLocation is False:
			return
		key = self.key_prefix + str(location)
		result = memcache.get(key)
		if result is None:
			result = self.week.fetchWithLocationName(location)
		if len(result) is 0:
			return
		else:
			memcache.add(key, result, 30)
		
		if outputtype == "json":
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			jsonText = json.write({"week":result, "location":chineseName, "id":name})
			self.response.out.write(jsonText)
		else:
			pl = dict(week=result, location=chineseName, id=name)
			output = plistlib.writePlistToString(pl)
			self.response.headers['Content-Type'] = 'text/plist; charset=utf-8'
			self.response.out.write(output)

class WeekTravelController(WeekController):
	def __init__(self):
		self.week = weather.WeatherWeekTravel()
		self.key_prefix = "weekTravel_"

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
			('/week', WeekController),
			('/week_travel', WeekTravelController)
			],
 			debug=True)
	wsgiref.handlers.CGIHandler().run(application)


if __name__ is '__main__':
	main()
