\l ../qqq.q
\l ../qqq-wire.q

inc:{"hello"}

hello:{h:.qqq.tag[`a;(`wire;inc);"Hello world"];show h;h}

/ default route
routes:(enlist `)!enlist ui;

app:enlist .qqq.router[routes];
.qqq.install[app];
show `installed



