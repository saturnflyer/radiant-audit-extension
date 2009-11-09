// Subclass DatePicker behavior to override the widget positioning and perform
// as an auto-submit field.
var AuditDatePicker = Behavior.create(DatePicker, {
	_positionWidget : function() {
		var offset = this.element.cumulativeOffset();
		this.nodes['widget'].setStyle({ "bottom" : "50px", "left" : offset[0] + "px" });
	},
	cellClickHandler : function(e, td_date) {
		clearTimeout(this.hide_timeout);
		e.stop();
		this.element.value = td_date.format(this.CONFIG['field_date_format']);
		this.hide();
		this.element.form.submit();
	}
});
// Steal the default CONIFG from the original DatePicker
AuditDatePicker.CONFIG = DatePicker.CONFIG;

// Generic Overlabel for in-field label
var OverLabel = Behavior.create({
	initialize : function(){
		this.element.hide();
		this.overlabel = this.element.innerHTML;
		this.input = $(this.element.htmlFor);
		if (!this.overLabelIsWriteable()) return;
		this.initializeOverLabel();
		this.element.up('form').observe("submit", this.clearOverLabelValue.bind(this));
	},
	initializeOverLabel : function(){
		this.input.observe('click', this.overLabelFocusHandler.bindAsEventListener(this)).value = this.overlabel;
	},
	overLabelFocusHandler : function(){
		if (this.overLabelIsWriteable) {
			this.input_blur_handler = this.overLabelBlurHandler.bindAsEventListener(this);
			this.input.observe('blur', this.input_blur_handler).clear();
		}
	},
	overLabelBlurHandler : function(){
		Event.stopObserving(this.input, 'blur', this.input_blur_handler);
		if ($F(this.input).empty())
			this.replaceOverLabel();
	},
	replaceOverLabel : function(){
		this.input.value = this.overlabel;
	},
	overLabelIsWriteable : function(){
		var val = $F(this.input);
		return val == "" || val == this.overlabel;
	},
	clearOverLabelValue : function(){
		if (this.input.value == this.overlabel)
			this.input.clear();
	}
});

// And add our behaviors
Event.addBehavior({ 
  ".AuditDatePicker" : AuditDatePicker,
	".OverLabel" : OverLabel
});

document.observe("dom:loaded", function(){
  var date_filter_form = $("date_filter_form");
  if (date_filter_form) {
    date_filter_form.select(".FormAction").invoke("hide");
  }
	var metadata_toggle = $("more-or-less-metadata");
	var metadata = $("audit_filter_form");
	var filtering_options = $("filtering-options");
	function toggleFilteringOptions(){
		metadata.toggle();
		filtering_options.toggleClassName("Active");
		metadata_toggle.update(metadata_toggle.innerHTML.indexOf("More") > -1 ? "Hide Filtering Options" : "More Filtering Options");
	}
	metadata_toggle.observe("click", toggleFilteringOptions);
	if (document.location.href.indexOf("Filter") > -1)
		toggleFilteringOptions();
});