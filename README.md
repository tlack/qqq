qqq.q: www toolkit for q
========================

This is a toolkit of useful functions for those creating websites with Q and Kdb+.

This is not a framework and you don't have to use all of it. Feel free to mix this
with (.h)[http://code.kx.com/wiki/Doth), (.z.ph)[http://code.kx.com/wiki/Reference/dotzdotph],
etc. 

Included is an experimental approach to transforming Q data into an HTML tree structure. I've
also been experimenting with transmitting the raw Q data structures to the client via 
(.z.ws)[http://code.kx.com/wiki/Reference/dotzdotws] and (Kx's own c.js)[http://kx.com/q/c/c.js], 
then creating DOM elements using the excellent (https://github.com/Matt-Esch/virtual-dom]. This
approach has a lot of promise in terms of performance, expressivity, and productivity.

Status
------

Handy for my personal use, but not ready for prime time. Caveat emptor.

Usage
-----

As a URL parser:

To extract handy data from the passed-in data to .z.ph:

```
\l qqq/qqq.q
.z.ph:{.qqq.parsereq[x]; otherstuff[]}
```

Server-side DOM tree:

```
\l qqq/qqq.q
.z.ph:{.qqq.divv["Welcome to my humble website!"]}
```

Copyright
---------

MIT License. (c) Copyright 2015 @tlack 

OLD Notes/thinking/observations
-------------------------------

The following may be out of date:

Example single pager:

```
save: {reggedat:.z.P;
	`users insert (x.name;reggedat);
	div[`banner;"Welcome, you are user #",(string count users),"!"]
}
div (`banner;"Please login")
itext (`name; (`blur`placeholder)!(save;"Enter your username"))
.qqq.boot[]
```

It outputs:

```html
<header-stuff/>
<script src="qqq.js"></script>
<input type="text" name="name" id="qqq-name" 
	placeholder="Enter your username">
<script>
qqq.bind('name')
</script>
<other-content/>
<script>
// and later:
qqq.boot()
</script>
```

Need to figure out
------------------

How do we namespace "components" so I can compose pieces of the page into
a single unit, as a kind of programmatic "atomic design"?

TODO
----

Everything

Flexible calling syntax
-----------------------

This allows us to get around the fact that Q doesn't allow optional arguments;
use a list as the argument list.

```
func:{x[0] + x[1]}
func(1;2) = func[(1;2)]
```

Handlers on elements
--------------------

Let's try a pub-sub system based on Q symbol names - this can be tied easily to
Q variables or functions.

