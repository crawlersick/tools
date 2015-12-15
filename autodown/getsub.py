#!/bin/python2.7
# -*- coding: utf-8 -*-
import anaurl
import urllib
import sys
import re
import zipfile
import os
def test(e):
    print e[0]
def fromabcd(epname,epnum):
    encode_epname=urllib.quote(epname)
    targeturl1='http://www.abcsub.com/?k='+encode_epname
    alist=anaurl.ana(targeturl1,'<a href="/([0-9]+)" target="_blank">(.*?)</a></span>')
    tempe='None'
    for i,e in enumerate(alist):
        if re.search(epnum,e[1],re.IGNORECASE):
            tempe=e
            break
    if not tempe=='None':
        page2='http://www.abcsub.com/'+tempe[0]
        blist=anaurl.ana(page2,'<div class="download-link"><span><font class="f1">.*?</font><a href="(.*?)" target="_blank">.*?</a></span></div>')
        print blist
        ret=urllib.urlretrieve(blist[0],"/tmp/"+tempe[0]+".zip")
        print ret
if __name__=="__main__":
    fromabcd('big bang','S09E10')


print "Processing File " + sys.argv[1]

file=zipfile.ZipFile(sys.argv[1],"r");
for name in file.namelist():
    try:
        utf8name=name.decode('gbk')
    except UnicodeEncodeError:
        utf8name=name
    print "Extracting " + utf8name
    pathname = os.path.dirname(utf8name)
    if not os.path.exists(pathname) and pathname!= "":
        os.makedirs(pathname)
    data = file.read(name)
    if not os.path.exists(utf8name):
        fo = open(utf8name, "w")
        fo.write(data)
        fo.close
file.close()
