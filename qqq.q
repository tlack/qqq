/

active attrs - 
	tag["a";(enlist `onclick)!enlist {[req] domupd[`message;"Clicked"]
\

\d .qqq
\c 2000 2000

/ Handy accessors. Our canonical example URL is:
/ https://example.com:8080/name.thing?name=Tom&age=36#id Different parts of the
/ code will refer to this.
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

	/ simulate scope with currying; awful
	{[routes;req]
		show(`routerf;routes;req;pg);
		matches:routes pg;
		show(`matches;matches);
		/ call handlers, collect output, str the whole thing
		/ sadly doesnt yet support returning null to terminate
		raze str each matches @\: req}[routes]}

/ LOW LEVEL

parsereq:{
	p:"?"vs x;
	pg::`$p[0];
	params::if [0~type v:"="vs x;v;()]
	headers::y}

/ create an html representation of a tag
tag:{[tag;attrs;contents]
	/ TODO: decode active attrs like `onclick
	curtag::tag;
	$[not(tag~null);
			str each ("<";tag;" ";attrs;">";contents;"</";tag;">");
			contents]}

/ Arg list converted to strings
/ tag"<a>content</a>"
/ tag("a";"content")
/ tag(`a;"content")
/ tag(`a;"href='https://example.com'";"content")
/ tag(`a;(enlist`href)!enlist"https://example.com";content1[],content2)
/ tag(`a;{func};(enlist`id)!enlist"mainpage";content1[],content2)
/ tag:{}(

attrstr:{
	show(`dictstr;x);
	j:{{x,z,"\"",y,"\""}[;;x]};
	eq:j["="]; 
	/ runplugins:{x};
	/ postplugins:runplugins[x];
	postplugins:x;
	left:str each key postplugins;
	right:str each value postplugins;
	show(`pp;postplugins);
	" " sv left eq' right}

str:{[v]
	show (`str;type v;v);
	r:$[99=type v;attrstr[v];    /dict
		  98=type v;"table";       /tbl
		  string v];
	raze r}

/ converts a string into a sym if necessary
sym:{[v]$[10=(abs type v);`$v;v]}

t:{[name;res;expect]
	res:raze res;
	show (`teststart;name;res;expect);
	bool:res~expect;
	show $[not bool;'testfailed;(string name),": success"]}

test:{
	t[`str1;str["name"];"name"];
	t[`strs;str[`name];"name"];
	t[`strss;str[`name`name];"namename"];
	t[`strss2;str[(enlist "a")!enlist "1"];"a=\"1\""];
	t[`strss3;str[(`a`b)!1 2];"a=\"1\" b=\"2\""];
	t[`strss3;str[(enlist `aaaa)!enlist 1];"aaaa=\"1\""];
	attrs:(enlist `href)!enlist "test.html";
	t[`tag1;tag[`a;attrs;"Blah"];"<a href=\"test.html\">Blah</a>"];
	show `testspassed}

show .z.f;
/if[.z.f~`qqq.q;test[]]
test[]

