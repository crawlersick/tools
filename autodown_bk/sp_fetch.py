#!/bin/python2.7
# -*- coding: utf-8 -*-
import sys
import urllib
if __name__=="__main__":
    if len(sys.argv)==2:
        print urllib.quote(sys.argv[1])
        tt='http://www.suppig.net/search.php?mod=forum&searchid=1208&orderby=lastpost&ascdesc=desc&searchsubmit=yes&kw=%BD%F1%C8%D5%D7%D3'
        print urllib.unquote(tt).decode('gbk')

    else:
        print 'illegel para'
