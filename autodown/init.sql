create table if not exists loglist (epname varchar(50),epnum varchar(15));
CREATE INDEX if not exists x1_idx_000123a7 ON loglist(epname, epnum);
