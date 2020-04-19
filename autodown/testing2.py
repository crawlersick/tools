#py3
import urllib.parse  
import urllib.request  
url = "http://www.python.org/" 
values = {  
'act' : 'login',  
'login[email]' : '',  
'login[password]' : ''  
}  
data = urllib.parse.urlencode(values)  
req = urllib.request.Request(url, data.encode())  
req.add_header('Referer', 'http://www.python.org/')  
response = urllib.request.urlopen(req)  
the_page = response.read()  
print(the_page.decode("utf8"))  
