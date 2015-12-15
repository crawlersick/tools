#!/bin/python2.7
# -*- coding: utf-8 -*-
import anaurl
import urllib
import sys
import re
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
if __name__=="__main__":
    fromabcd('big bang','S09E10')
