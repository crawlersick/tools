from anaurl2 import ana
import logging
logger=logging.getLogger()
from urllib.parse   import quote
from urllib.parse   import unquote
import sys
import mmap

if __name__=='__main__':
    logging.basicConfig(level='DEBUG')
    keyw=sys.argv[1]
    filehist=sys.argv[2]
    logging.debug(keyw)
    if keyw is None or filehist is None: 
        print('input is null!!!!!')
        sys.exit()
    f=open(filehist)
    s = mmap.mmap(f.fileno(), 0, access=mmap.ACCESS_READ)

    epname=keyw
    epname_encode=quote(epname)
    pageurl='http://www.fixsub.com/portfolio/'+epname_encode
    logging.debug(pageurl)
    #resu=ana(pageurl,'<div>([0-9a-zA-Z]+).*?<a href="(magnet:\?xt=.*?)" target="_blank"')
    resu=ana(pageurl,'<div>([^\s]+).*?<a href="(magnet:\?xt=.*?)" target="_blank"')
    logging.debug(resu)
    maglink='None'
    tagname='None'
    for tempobj in resu[::-1]:
        tagname=unquote(epname)+tempobj[0]
        maglink=tempobj[1]
        logging.debug('tagname: '+tagname)
        logging.debug('maglink: '+maglink)
        if s.find(bytearray(tagname,'utf-8')) != -1:
            maglink='None'
            #continue
        else:
            break
        f.close()
    if(maglink!='None'):
        maglink=maglink.replace('&amp;','&')
    print(maglink+';'+tagname)
