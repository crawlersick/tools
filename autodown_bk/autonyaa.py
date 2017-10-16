#!/bin/python
import urllib
import urllib.request
import sys
data = {}
data['page'] = 'search'
data['cats'] = '0_0'
data['filter'] = '0'
data['term'] = 'durarara'
url_values = urllib.parse.urlencode(data)
#http://www.nyaa.se/?page=search&cats=0_0&filter=0&term=durarara
print (url_values)  # The order may differ. 
#name=Somebody+Here&language=Python&location=Northampton
url = 'http://www.bilib-ili.com'
full_url = url + '?' + url_values
try: 
	requrl = urllib.request.urlopen(full_url)
except urllib.error.URLError as e:
	print (e.reason)
	sys.exit()
the_page = requrl.read()
print (the_page)
print (requrl.info())
print (requrl.getcode())