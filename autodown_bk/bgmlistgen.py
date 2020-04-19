#!/bin/env python
import libs.anaurl2
import re
if __name__=='__main__':
    print('aa') 
    resu=libs.anaurl2.ana("http://www.kansou.me/",'<td align="center">([0-9]{4}/[0-9]{2}/[0-9]{2})\(.*?\)</td>.*?<td align="center"><a href="(.*?)" target=')
    print(resu)
    for a in resu:
        print(a[1])
        tempstr=re.search('://[Ww\.]*([^\.]+)',a[1])
        print(tempstr.group(1))

