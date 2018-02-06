import urllib.parse
import urllib.request
from io import StringIO
import gzip
import re
import logging
def ana(urlstr,expstr,cks=None,postdata=None):
    #print "this is ana moudle start",urlstr,expstr
    matlist=['init','init']
    #print "1"
    headers = {  
    'User-Agent':'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6'  
    }  
    #print "2"
    if (cks is not None and cks.strip() !=''):
        #print "2.1"
        #cks_dict=dict(item.strip().split("=") for item in cks.split(";"))
        #cks_dict=dict(item.split("=") for item in cks.split(";"))
        cks_dict={}
        for item in cks.split(";"):
            if item and not item.isspace():
                #print "22222222221"+item
                sitem=item.split("=")
                cks_dict[sitem[0]]=sitem[1]

        #print "2.2"
        logging.info('coockies passed in:')
        logging.info(cks)
        logging.info(cks_dict)
        headers.update({'Cookie':"; ".join('%s=%s' % (k,v) for k,v in cks_dict.items())})
        #headers.update({'Cookie':'a=b'})
    #print "3"
    logging.info(headers)
    #if data=postdata is set, then it call POST, or it call GET
    print('opening '+urlstr )
    print('1**********************')
    if postdata is not None:
        postdata=urllib.parse.urlencode(postdata)
    print('2**********************')
    req=urllib.request.Request(urlstr,postdata.encode('UTF-8'),headers)
    print('3**********************')
    resp=urllib.request.urlopen(req)
    #print resp.read() 
    print (resp.info())
    if resp.info().get('Content-Encoding') == 'gzip':
        buf=StringIO(resp.read())
        f=gzip.GzipFile(fileobj=buf)
        data=f.read()
    else:
        data=resp.read()
    #print data
    try:
        logging.info('start re')
        matlist=re.findall(expstr,data)
    except:
        logging.info('exception when findall')
        matlist=['sick_tako_reply_code_000_0_003','regex exception,illigle regex!']
    return matlist

if __name__=='__main__':
    #resu=ana("http://share.popgo.org",'(?<=<td class="inde_tab_hot"><a href=").*?(?=&)')
    a={"all":"one"}
    resu=ana("http://www.kansou.me/",'(?<=<td align="center"><a href=").*?(?=" target="_blank">)',None,a)
    print (resu)
