\l qqq.q

.qqq.debug:1;

t:{[name;res;expect]
	res:raze res;
	show (`teststart;name;res;expect);
	bool:res~expect;
	show $[not bool;[0N!res;'testfailed;exit 1];(string name),": success"]}

test:{
	attr0:(enlist `href)!enlist "test.html";
	attr1:(enlist `a)!enlist "b";
	STR:.qqq.str;
	TAG:.qqq.tag;
	TAG0:.qqq.tag0;
	t[`str1;STR["name"];"name"];
	t[`strs;STR[`name];"name"];
	t[`strss;STR[`name`name];"namename"];
	t[`strss1;STR[attr0];"href=\"test.html\""];
	t[`strss2;STR[(enlist "a")!enlist "1"];"a=\"1\""];
	t[`strss3;STR[(`a`b)!1 2];"a=\"1\" b=\"2\""];
	t[`strss3;STR[(enlist `aaaa)!enlist 1];"aaaa=\"1\""];
	t[`tag1;TAG0[`a;attr0;"Blah"];"<a href=\"test.html\">Blah</a>"];
	t[`tag2;TAG"Hello";"Hello"];
	t[`tag3;TAG(`a;"Hello");"<a>Hello</a>"];
	t[`tag3b;TAG(`a;"");"<a></a>"];
	t[`tag3c;TAG(`a;());"<a></a>"];
	t[`tag4;TAG(`a;attr0;"Hello");"<a href=\"test.html\">Hello</a>"];
	t[`tag5;TAG(`a;attr0;"Hello");"<a href=\"test.html\">Hello</a>"];
	t[`tag6;TAG(attr1;"Hello");"<span a=\"b\">Hello</span>"];
<<<<<<< HEAD
	t[`tag7;TAG(`a;(`b;"Hello"));"<a><b>Hello</b></a>"];
	t[`tag8;TAG(`a;(`b;`c;"Hello"));"<a><b class=\"c\">Hello</b></a>"];
	show `testspassed}
=======
	t[`tag3;TAG(`a;(`b;"Hello"));"<a><b>Hello</b></a>"];
	.qqq.hclass[`track]:{[ta] 
		.qqq.dshow(`ta1;ta); 
		ta[1;`onclick]:`$"t()";
		.qqq.dshow(`ta2;ta);
		:ta};
	t[`tag3;TAG(`a;`track;(`b;"Hello"));"<a class=\"track\" onclick=\"t()\"><b>Hello</b></a>"];
	t[`tag3;TAG(`a;attr1;(`b;attr1;"Hello"));"<a a=\"b\"><b a=\"b\">Hello</b></a>"];
	t[`tag3;TAG(`a;attr1;((`b;attr1;"Hello");(`c;"Goodbye")));"<a a=\"b\"><b a=\"b\">Hello</b><c>Goodbye</c></a>"];
	t[`tag3;TAG(`a;attr1;(`b;`bolder;"Hello"));"<a a=\"b\"><b class=\"bolder\">Hello</b></a>"];
	.qqq.htag[`fake]:{[tag].qqq.dshow(`faketag;(tag));tag[0]:`a;tag[1],:(enlist`class)!enlist`fake;tag};
	t[`tag3;TAG(`a;attr1;(`fake;"Hello"));"<a a=\"b\"><a class=\"fake\">Hello</a></a>"];
	show `testspassed;
	exit 0}
>>>>>>> 27a9baa58d275d7efb7eab0b737b1044012e3771

test[]

