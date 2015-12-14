#!/bin/python2.7
# -*- coding: utf-8 -*-
import re
from os.path import expanduser
import os.path
import mmap
def procs9e9(eplist,epname):
    dfolder=expanduser("~")+"/Downloads"
    if not os.path.exists(dfolder):
        os.makedirs(dfolder)
    complist=dfolder+"/kat_comp_list.txt"
    if not os.path.exists(complist):
        f=open(complist, 'w')
        f.write('this is index file for kat py\n')
        f.close()

    f = open(complist)
    s = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)

    #print eplist 
    for i,e in enumerate(eplist):
        #print e[0]
        #print e
        if e[2] != "NA":
            #print e[2][0]
            #print e[2][1]
            #print "tring "+epname+"_S"+e[2][0]+"E"+e[2][1]
            if s.find(epname+"_S"+e[2][0]+"E"+e[2][1]) != -1:
                continue
            else:
                f.close()
                return e
    f.close()

if __name__=="__main__":
    procs9e9([])


