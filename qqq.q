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
sessid:"";                                                 / session guid - module?
history:();                                                / session history - module?
clientstate:()!();                                         / js state coupling - module?
curtag:"";                                                 / tag currently being rendered (for callbacks)

/ HIGH LEVEL

globalize:{
	tags:`a`body`divv`h1`h2`h3`h4`h5`h6`head`html`link`title;
	{(`$string x) set stag[x;]}each tags}

/ take over for .z.ph
/ pass in an array of handler functions. 
/ func:{[url; params; requestdata] "<div>Hello ",params`name,"</div>"}
/ return a null to terminate processing 'nyi
/ otherwise results will be catenated and returned 
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

parsereq:{
	'nyi;
	p:"?"vs x;
	pg::`$p[0];
	params::if [0~type v:"="vs x;v;()]
	headers::y}
/ create an html representation of a tag
/ Arg list converted to strings
/ tag"<a>content</a>"
/ tag("a";"content")
/ tag(`a;"content")
/ tag(`a;"href='https://example.com'";"content")
/ tag(`a;(enlist`href)!enlist"https://example.com";content1[],content2)
/ tag(`a;{func};(enlist`id)!enlist"mainpage";content1[],content2) 'nyi

/ convert crazy mixed list of content into an html string
/ guaranteed to return a string!(tm)
tag:{[args]
	dshow(`tagargs;args);
	if[10h=abs type args;:args];                             / string? pass thru
	if[not 0h=type args;`badtag];                            / arg must be a mixed list

	/ examine each arg one at a time. this is awful and very un-q-like
	a:first args; ta:type a;                                 / very first item in list
	dshow(`sa;a);
	if[0h=abs ta; :""vs .z.s each args];                     / list of lists = array of content, recurse
	tag:$[-11h=type first args;[args:1 _ args;a];`span];     / symbol first = tag name; default to span

	a:first args; ta:type a;                                 / second item; dictionary or content
	dshow(`aa;a);
	attrs:$[99h=ta;[args:1 _ args;a];()!()];                  / dictionary = attrs
	contents:$[0h=type args; ""sv .z.s each args; args];      / everything else is child content; recurse on general list
	dshow(`ca;contents);
	raze tag0[tag;attrs;contents]}

tag0:{[tag;attrs;contents]
	/ TODO: decode active attrs like `onclick
	dshow(`tag0;tag;attrs;type attrs;contents);
	curtag::tag;
	space:$[count key attrs and 99h=type attrs;" ";""];      / simpler way to detect empty dict? ^/fill?
	dshow(`tag0space;space);
	dshow(`tag0contents;contents);
	thing:("<";maprealtag[tag];space;attrs;">";contents;"</";maprealtag[tag];">");
	dshow(`tag0thing;thing);
	str each thing}

/ some html tags dont work as function names - like div. map these. 
maprealtag:{[tag]
	$[`divv=tag;`div;tag]}

/ Return the beginnings of a shortcut tag
stag:{[t;args]
	:{tag[(x;y)]}[t;args]}

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

dshow:{if[debug;0N!x]}

\d .

/

TODO
----
	active attrs - 
		tag["a";(enlist `onclick)!enlist {[req] domupd[`message;"Clicked"]

vim: set noet ci pi sts=0 sw=2 ts=2
\

