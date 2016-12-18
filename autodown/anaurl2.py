#!/bin/env python
# -*- coding: utf-8 -*-
import urllib.request
from io import StringIO
import gzip
import re
import logging
def ana(urlstr,expstr,cks=None,postdata=None):
    matlist=['init','init']
    headers = {  
    'User-Agent':'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'  
    }  
    if (cks is not None and cks.strip() !=''):
        cks_dict={}
        for item in cks.split(";"):
            if item and not item.isspace():
                sitem=item.split("=")
                cks_dict[sitem[0]]=sitem[1]
        logging.debug('coockies passed in:')
        logging.debug(cks)
        logging.debug(cks_dict)
        headers.update({'Cookie':"; ".join('%s=%s' % (k,v) for k,v in cks_dict.items())})
    logging.debug(headers)
    try:
        req = urllib.request.Request(  
                                url = urlstr,  
                                data = postdata,  
                                headers = headers  
        ) 
        resp=urllib.request.urlopen(req)
        if resp.info().get('Content-Encoding') == 'gzip':
            buf=StringIO(resp.read())
            f=gzip.GzipFile(fileobj=buf)
            data=f.read().decode("UTF-8")
        else:
            data=resp.read().decode("UTF-8")
        #logging.debug(data)
        try:
            logging.debug('start re')
            matlist=re.findall(expstr,data,re.S|re.U)
        except:
            logging.debug('exception when findall')
            matlist=['sick_tako_reply_code_000_0_003','regex exception,illigle regex!']
    except:
        handleError(e)
        matlist=['sick_tako_reply_code_000_0_004','url error!']
    finally:
        return matlist

if __name__=='__main__':
    logging.basicConfig(level='INFO')
    resu=ana("http://www.vpngate.net/cn/","<tr>\r\n<td class='vg_table_row_([01])' style='text-align: center;'><img src='../images/flags/[A-Z]+.png' width='32' height='32' /><br>([a-zA-Z]+)</td>.*?<a href='([^']+)'><img height='33' src='../images/yes_33.png' width='33' /><br><b>OpenVPN<BR>.*?</td></tr>")
    #resu=ana("http://www.vpngate.net/cn/do_openvpn.aspx?fqdn=&ip=219.118.128.235&tcp=995&udp=1195&sid=1477224598655&hid=817201",'(/common/openvpn_download.aspx.*?\.ovpn)')
    print(resu)
