#!/bin/python2.7
# -*- coding: utf-8 -*-
import anaurl
import urllib
import sys
import re
import zipfile
import os
from os.path import expanduser
from subprocess import call
def uzfile(zipfilex,dlfolder):
    filez=zipfile.ZipFile(zipfilex,"r");
    for name in filez.namelist():
        try:
            utf8name=name.decode('gbk')
        except UnicodeEncodeError:
            utf8name=name
        pathname = os.path.dirname(utf8name)
        if not os.path.exists(dlfolder+pathname) and pathname!= "":
            os.makedirs(dlfolder+pathname)
        data = filez.read(name)
        if not os.path.exists(dlfolder+utf8name):
            fo = open(dlfolder+utf8name, "w")
            fo.write(data)
            fo.close
    filez.close()
def test(e):
    print e[0]
def fromabcd(epname,epnum,targetfolder):
    encode_epname=urllib.quote_plus(epname)
    #targeturl1='http://www.abcsub.com/?k='+encode_epname
    targeturl1='http://www.zimuzu.tv/search/index?keyword='+encode_epname
    #alist=anaurl.ana(targeturl1,'<a href="/([0-9]+)" target="_blank">(.*?)</a></span>')
    alist=anaurl.ana(targeturl1,'<div class="t f14"><a href="/subtitle/([0-9]+)"><strong class="list_title">(.*?)</strong>')
    tempe='None'
    for i,e in enumerate(alist):
        if re.search(epnum,e[1],re.IGNORECASE):
            tempe=e
            break
    if not tempe=='None':
        #page2='http://www.abcsub.com/'+tempe[0]
        page2='http://www.zimuzu.tv/subtitle/'+tempe[0]
        #blist=anaurl.ana(page2,'<div class="download-link"><span><font class="f1">.*?</font><a href="(.*?)" target="_blank">.*?</a></span></div>')
        blist=anaurl.ana(page2,'<h3>字幕下载：<a href="(.*?)" target="_blank">.*?</a></h3>')
        print blist
        fext=blist[0].split(".")[-1]
        if fext=='zip':
            ret=urllib.urlretrieve(blist[0],"/tmp/"+tempe[0]+".zip")
            uzfile(ret[0],targetfolder)
        elif fext=='rar':
            ret=urllib.urlretrieve(blist[0],"/tmp/"+tempe[0]+".rar")
            retcode=call(["unrar","x",ret[0],targetfolder])
            if retcode!=0:
                print 'unrar error '+ret[0]
                sys.exit[97]
        else:
            print 'unkonw file type for '+blist[0]
            sys.exit[98]

    else:
        print 'not sub found!'
        sys.exit(99)
if __name__=="__main__":
    print "getsub start"
    print sys.argv
    a=sys.argv[1]
    b=sys.argv[2]
    c=sys.argv[3]
    fromabcd(a,b,c)
    #fromabcd('big bang','S09E10',"/home/john/Downloads/big bang/")


