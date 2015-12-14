#!/bin/python2.7
import re
import anaurl
import sys
import urllib
import pagelistprocess
if len(sys.argv)!=2:
    print 'only one parameter!'
    sys.exit(2)
else:
    targetname=sys.argv[1]
    targetname=urllib.quote(targetname)
    #print "start process {p1} for kat".format(p1=targetname)
kats='https://kat.cr/usearch/'+targetname
#print "full url {p1} for kat".format(p1=kats)
anares=anaurl.ana(kats,'data-sc-params="{ \'name\': \'(.*?)\', \'magnet\': \'(.*?)\' }"></div>')
if len(anares[0][0])==1:
    print 'None'
    sys.exit(3)
for i,e in enumerate(anares):
    temp=list(anares[i])
    temp[0]=urllib.unquote(temp[0])
    temp[1]=urllib.unquote(temp[1])
    #print temp[0]
    m=re.match(r'.*S([0-9]+)E([0-9]+).*',temp[0],re.IGNORECASE)
    if m:
        temp.append(m.group(1,2))
    else:
        temp.append('NA')

    #anares[i]=tuple(temp)
    anares[i]=temp

#print anares
e=pagelistprocess.procs9e9(anares,sys.argv[1])
print e
