.qqq.tryfiles:{x:first x;
	$[count c:@[read1;`$.h.HOME,"/",x;""];
		.h.hy[`$last"."vs x;"c"$c];
		[show c;""]]}

/

tryfiles[request] 
	request = .z.ph style ("/uri";(`Host`Connection)!("a";"b"))
	Returns content and headers as string, or ""

Try to find the requested file inside the .h.HOME folder (defaults to html/)
and return its contents along with a proper content-type string.

This is part of .z.ph, but we need it separately if we want to mix our logic
with static file serving.

Returns "" in case of failure.

Use like

\l qqq.q
\l qqq-tryfiles.q
.z.ph:{
	if[stf:.qqq.tryfiles x;:stf]; / return static content if found
	other_logic_here[];
}
\

	

