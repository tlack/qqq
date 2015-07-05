/

active attrs - 
	tag["a";(enlist `onclick)!enlist {[req] domupd[`message;"Clicked"]
\

\d .qqq
\c 50 2000

debug:1;

/ Handy accessors. Our canonical example URL is:
/ https://example.com:8080/name.thing?name=Tom&age=36#id Different parts of the
/ code will refer to this.
/ SO FAR 'NYI
/ `name
pg:"";
/ `thing
ext:"";
params:()!();
/ this sessions history
history:();
/ dictionay of req headers as per .z.ph x[1]
headers:()!();
/ session id
sessid:"";
clientstate:()!();
curtag:"";

/ HIGH LEVEL

globalize:{
	tags:`a`body`divv`h1`h2`h3`h4`h5`h6`head`html`link`title;
	{(`$string x) set stag[x;]}each tags}
/ take over for .z.ph
/ pass in an array of handler functions. 
/ func:{[url; params; requestdata] "<div>Hello ",params`name,"</div>"}
/ return a null to terminate processing
/ otherwise results will be catenated and returned 
install:{[handlers]
	func:{[req;handlers] 
		.[parsereq;req];
		show(`installf;req;handlers);raze handlers @\: req};
	.z.ph:func[;handlers]}
router:{
	routes:x;
	{[routes;req]
		show(`routerf;routes;req;pg);
		matches:routes pg;
		show(`matches;matches);
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
/ tag(`a;{func};(enlist`id)!enlist"mainpage";content1[],content2)

/ convert crazy mixed list of content into an html string
/ guaranteed to return a string!(tm)
tag:{[args]
	show(`tagargs;args);
	if[10h=abs type args;:args];                             / string? pass thru
	if[not 0h=type args;`badtag];                            / arg must be a mixed list
	/ examine each arg one at a time. this is awful and very un-q-like
	a:first args; ta:type a;
	show(`sa;a);
	if[0h=abs ta; :""vs .z.s each args];                     / list of lists = array of content, recurse
	tag:$[-11h=type first args;[args:1 _ args;a];`span];     / symbol first = tag name; default to span
	a:first args; ta:type a;
	show(`aa;a);
	attrs:$[99h=ta;[args:1 _ args;a];()!()];                  / dictionary = attrs
	contents:$[0h=type args; ""sv .z.s each args; args];      / everything else is child content; recurse on general list
	show(`ca;contents);
	raze tag0[tag;attrs;contents]}

tag0:{[tag;attrs;contents]
	/ TODO: decode active attrs like `onclick
	show(`tag0;tag;attrs;type attrs;contents);
	curtag::tag;
	space:$[count key attrs and 99h=type attrs;" ";""];
	show(`tag0space;space);
	show(`tag0contents;contents);
	thing:("<";maprealtag[tag];space;attrs;">";contents;"</";maprealtag[tag];">");
	show(`tag0thing;thing);
	str each thing}

maprealtag:{[tag]
	$[`divv=tag;`div;
		tag]}

/ Return the beginnings of a shortcut tag
stag:{[t;args]
	:{tag[(x;y)]}[t;args]}

/ The following functions basically convert Q data types to HTML
attrstr:{:" "sv{(str y),"=\"",(str x[y]),"\""}[x;]each key x}
str:{[v]
	tv:type v;
	show(`str;v;tv);
	r:$[99h=tv;attrstr[v];    /dict
		  98h=tv;'tablenyi;       
			0h=tv;.z.s each v;   /recurse on vectors
		  string v];
	raze r}

dshow:{
	if[debug;0N!x]}

\d .

