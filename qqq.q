\d .qqq
\c 50 2000

debug:1;

/ request data for your use. URL in examples below:
/ https://example.com:8080/pagename.type?name=Tom&age=36#id 
/ SO FAR 'NYI
pg:"";                                                     / `pagename
ext:"";                                                    / `type
params:()!();                                              / (`name`age)!("Tom";"36")
headers:()!();                                             / HTTP request parameters ala .z.ph x[1]
curtag:"";                                                 / tag currently being rendered (for callbacks from tag[])
curtitle:"";                                               / see htag`title below
sessid:"";                                                 / session guid - module?
history:();                                                / session history - module?
clientstate:()!();                                         / js state coupling - module?

/ HIGH LEVEL

globalize:{
	d:string system"d";
	{(`$y,".",string x) set get (`$".qqq.",string x)}[;d] each taglist}

/ HIGH LEVEL

/ its more convenient to write handlers that run *after* the inner content is resolved, so these work via
/ callbacks.
htag:()!();
htag[`title]:{[ta]dshow(`htt;(ta));curtitle::ta[2];ta}   / save <title> contents to global

/ set handlers for classes here. classes can be specified in tags; they become DOM classNames, but you can
/ also define callbacks that can transform the tag they're in arbitrarily. they're called as 
/ func[class;taginfo] taginfo:("a";(enlist`href)!enlist"test.html";contentslist)
hclass:()!();
hclass[`qqq]:{[ta]ta}

/ take over for .z.ph
/ pass in an array of handler functions. 
/ func:{[url; params; requestdata] "<div>Hello ",params`name,"</div>"}
/ return a null to terminate processing 'nyi
/ otherwise results will be catenated and returned 
/ you can override .z.ph yourself if you don't want to use this
install:{[handlers]
	func:{[req;handlers] 
		.[parsereq;req];
		dshow(`installf;req;handlers);raze handlers @\: req};
	.z.ph:func[;handlers]}

/ iterate over routes dictionary - exact matches only. needs work
router:{
	routes:x;
	{[routes;req]
		dshow(`routerf;routes;req;pg);
		matches:routes pg;
		dshow(`matches;matches);
		/ call handlers, collect output, str the whole thing
		/ sadly doesnt yet support returning null to terminate
		raze str each matches @\: req}[routes]}

/ LOW LEVEL

/ populate globals with .z.ph-style (`url;headers) list
parsereq:{
	dshow(`pri;x);
	p:"?"vs x[0];
	p0:"."vs p[0];
	pg::`$p0[0];
	ext::`$p0[1];
	params::if[0~type v:"&"vs p[1];"="vs v;()];
	headers::x[1];
	dshow(`prr;(pg;ext;params;headers))}

/ convert crazy mixed list of content into an html string
/ guaranteed to return a string!(tm)
tag:{[args]
	dshow(`tagargs;args);
	class:`;                                                 / class to apply
	if[10h=abs type args;:args];                             / string? pass thru
	if[not 0h=type args;`badtag];                            / arg must be a mixed list

	/ examine each arg one at a time. this is awful and very un-q-like
	a:first args; ta:type a; dshow(`arg1;a);                 / processing very first item in list
	if[0h=abs ta; :""vs .z.s each args];                     / list of lists = array of content, recurse
	tag:$[-11h=ta;[args:1 _ args;a];`span];                  / symbol first = tag name; default to span

	a:first args; ta:type a; dshow(`arg2;a);                 / processing second item; tag attrs (dict), symbol=`id!sym or content
	attrs:$[99h=ta;[args:1 _ args;a];                        / dictionary = attrs
				  -11h=ta;[args:1 _ args;class:a;(enlist`class)!enlist a]; / sym second arg = classname shortcut. good place for plugins.
					()!()];

	a:first args;ta:type a;
	dshow(`contents;args);
	contents:$[0h=ta;""sv .z.s each args;args];                / everything else is child content; recurse on general list
	tagargs:dshow(`tagpreplugins;(tag;attrs;contents));
	if[not null class;tagargs:applyclass[class;tagargs]];
	tagargs:applytag[tagargs];
	dshow(`tag0finalargs;tagargs);
	dshow(`tag0fn;tag0);
	xx:raze tag0 . tagargs;
	dshow(`tag0done;xx)}

tag0:{[tag;attrs;contents]
	/ TODO: decode active attrs like `onclick
	dshow(`tag0;(tag;attrs;type attrs;contents));
	curtag::tag;
	space:$[(count key attrs) and 99h=type attrs;" ";""];      / simpler way to detect empty dict? ^/fill?
	dshow(`tag0space;space);
	dshow(`tag0contents;contents);
	thing:("<";maprealtag[tag];space;attrs;">";contents;"</";maprealtag[tag];">");
	dshow(`tag0thing;thing);
	str each thing}

/ some html tags dont work as function names - like div. map these. 
maprealtag:{[tag]
	$[`divv=tag;`div;tag]}

/ Return the beginnings of a shortcut tag
stag:{[t;args]:{dshow(`stag;tag(x,y))}[t;args]}                       / create projected function, basically

/ Plugin stuff
applyclass:{[class;tag]
	dshow(`ac;(class;tag));
	dshow(`r;r:hclass@class);
	dshow(`e;e:r@\:tag);
	:e}

applytag:{[tag]
	tagName:first tag;
	dshow(`at;tag);
	dshow(`htag;htag);
	m:htag@tagName;
	dshow(`atm;m);
	r:m @\: tag;
	dshow(`r;r);
	:r}

taglist:`a`body`divv`h1`h2`h3`h4`h5`h6`head`html`link`nav`title;
mktags:{{(`$string x) set stag[x;]}each taglist}

/ The following functions basically convert Q data types to HTML

attrstr:{:" "sv{(str y),"=\"",(str x[y]),"\""}[x;]each key x}
str:{[v]
	tv:type v;
	dshow(`str;v;tv);
	r:$[99h=tv;attrstr[v];                                   / dict=>attrs
		  98h=tv;'tablenyi;                                    / need good data tables - module?
			0h=tv;.z.s each v;                                   / recurse on general list
		  string v];
	raze r}

wheret:{y where x=type each a}
dshow:{
	v:x[1];
	if[not debug;:v]
	tv:type v;
	0N!raze "DEBUG: ",(string x[0])," type = ",string tv;
	if[0>tv;0N!type each v];
	0N!v;
	v}

\d .

/

TODO
----
	active attrs - 
		tag["a";(enlist `onclick)!enlist {[req] domupd[`message;"Clicked"]};"Click me"]

vim: set noet ci pi sts=0 sw=2 ts=2
\

