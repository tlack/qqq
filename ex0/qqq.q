\d .qqq
/ CONFIG: - see q4a.co/qqq
appjs:1;

/ Handy accessor functions. Our canonical example URL is:
/ https://example.com:8080/name.thing?name=Tom&age=36#id
/ Different parts of the code will refer to this.
/ `name
pg:{}
/ `thing
ext:{}
params:{}
/ this sessions history
history:{}
/ session id
sessid:{}

/ tag"<a>content</a>"
/ tag("a";"content")
/ tag(`a;"content")
/ tag(`a;"href='https://example.com'";"content")
/ tag(`a;(enlist`href)!(enlist"https://example.com");content1[],content2)
/ tag(`a;{func};(enlist`id)!(enlist"mainpage");content1[],content2)
tag:{}

