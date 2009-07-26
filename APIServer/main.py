#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#		 http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

import wsgiref.handlers
import weather
import plistlib
import json

from google.appengine.ext import webapp

forecast = weather.WeatherForecast()

class ForecastController(webapp.RequestHandler):
	def get(self):
		location = self.request.get("location")
		if len(location) == 0:
			self.response.headers['Content-Type'] = 'text/html; charset=utf-8'
			locations = forecast.locations()
			for location in locations:
				self.response.out.write("<li>")
				self.response.out.write("<a href=?location=" + str(location['id']) + ">")
				self.response.out.write(location['location'])
				self.response.out.write("</a></li>")
			return
		items = forecast.fetchWithID(location)
		if len(items) == 0:
			return
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
			text = overview.plain
			self.response.headers['Content-Type'] = 'text/plain; charset=utf-8'
			self.response.out.write(text)
			return

		html = overview.html
		self.response.headers['Content-Type'] = 'text/html; charset=utf-8'
		self.response.out.write(html)
		


class MainHandler(webapp.RequestHandler):
	def get(self):
		self.response.out.write('Hello world!')


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
