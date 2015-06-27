\l ../qqq.q

hello:{h:.qqq.tag[`a;(enlist `href)!enlist "http://yahoo.com";"Hello world"];show h;h}
routes:(enlist `)!enlist hello

app:enlist .qqq.router[routes];
.qqq.install[app];
show `installed



