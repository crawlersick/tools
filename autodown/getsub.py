#!/bin/python2.7
# -*- coding: utf-8 -*-
import anaurl
import urllib
def fromabcd(epname,epnum):
    encode_epname=urllib.quote(epname)
    targeturl1='http://www.abcsub.com/?k='+encode_epname
    temp1=anaurl.ana(targeturl1,'<a href="/([0-9]+)" target="_blank">(.*?)</a></span>')
    print temp1[0][1]
if __name__=="__main__":
                     fromabcd('big bang','S09E10')
