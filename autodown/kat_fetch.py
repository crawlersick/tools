#!/bin/python2.7
import anaurl
import sys
import urllib
if len(sys.argv)!=2:
    print 'only one parameter!'
    sys.exit(2)
else:
    targetname=sys.argv[1]
    targetname=urllib.quote(targetname)
    print "start process {p1} for kat".format(p1=targetname)
kats='https://kat.cr/usearch/'+targetname
print "full url {p1} for kat".format(p1=kats)
anares=anaurl.ana(kats,'data-sc-params="{ \'name\': \'(.*?)\', \'magnet\': \'(.*?)\' }"></div>')
for i,e in enumerate(anares):
    temp=list(anares[i])
    temp[0]=urllib.unquote(temp[0])
    temp[1]=urllib.unquote(temp[1])
    anares[i]=tuple(temp)

print anares
