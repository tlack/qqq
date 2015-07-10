/ as per https://github.com/tastejs/todomvc/blob/gh-pages/examples/react/js/app.jsx
\l qqq.q

addTodo:{`todos insert (uuid[]; x; active)
todoItem:{
	li (classSet(`completed`editing)!(x`completed x`editing));
		div ("className=view";
			input (onToggle; (`class`type`checked)!(`toggle;`checkbox;x`completed));
			label ((enlist`dblc)!enlist handleEdit; x.title);
			button (destroy; (enlist `class)!onDestroy));
				input (`editfield; (`class)!enlistdomdom "edit")
}
render:{
	/ active completed etc
	shown:select from todos where state like .qqq.pg[]
	active:shown where state~`active;
	footer:TodoFooter[]
	main:section ("#main";
		input ((enlist `checked)!enlist {active~0};toggleAll);
		todoItem each shown
	)
	div (
		header ("id=header";
			h1 "todos";
			inputtext (addTodo;
						`id`autofocus`placeholder!("new-todo";"true";"What needs to be done"))
		);
		main;
		footer
	)}

todomvc:{
	.qqq.start[];
	render[]}
