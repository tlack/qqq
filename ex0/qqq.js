function qqq() {

	// private api
	var $=function(sel) {
		return document.querySelectorAll(sel)
	}
	var $q=function(name) {
		return this.$('qqq-'+name)
	}
	var qqq = {
		bind: function(names) {
			names.forEach(function(n){
				$n=$q(n);
				qqq.binders[$n.tagName+($n.attributes.type||'')](n, $n);
			})
		},

		// map js types to default behavior handlers
		binders: {
			// default binder for objects with "value"s
			_: function(name, elem) {
				elem.addEventListener('change', function() {
					qqq.upd(name, elem.value);
				})
			},
			inputtext: function(name, elem) {
				qqq.binders._(name, elem)
			},
			textarea: function(name, elem) {
				return elem.value
			}
		},

		boot: {

		},

		// this is called whenever a value changes
		upd: function(name, newValue) {
			// send ajax shit to q
			this.state[name] = newValue;

		}
	}
	return qqq
}
