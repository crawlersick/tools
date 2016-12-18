import sqlite3
import logging
from datetime import datetime
logger=logging.getLogger()
def doinit(dbpath,initsql):
    conn=sqlite3.connect(dbpath)
    with open(initsql) as f:
        sqlc=f.read()
    c=conn.cursor()
    c.executescript(sqlc)
    c.execute('select * from sqlite_master;')
    tempres=c.fetchall()
    logging.debug(tempres)
    conn.commit()
    conn.close()

def insertdhist(dbpath,name,maglink,tagdate):
    conn=sqlite3.connect(dbpath)
    c=conn.cursor()
    t=(name,maglink,tagdate,)
    c.execute('insert into dhist values(?,?,?)',t)
    conn.commit()
    conn.close()
def querydhist(dbpath,name):
    conn=sqlite3.connect(dbpath)
    c=conn.cursor()
    t=(name,)
    c.execute('select * from dhist where epname=?',t)
    resu=c.fetchall()
    conn.close()
    return resu

if __name__=='__main__':
    logging.basicConfig(level='DEBUG')
    doinit('getfix.db','getfix.sql')
    t=str(datetime.now())
    insertdhist('getfix.db','test1','test22222222this is link',t)
    temp=querydhist('getfix.db','test2')
    #temp=querydhist('getfix.db','test1')
    print(temp)


