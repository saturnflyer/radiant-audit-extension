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

// And add our behaviors

Event.addBehavior({ 
  ".AuditDatePicker" : AuditDatePicker
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
	
	var log = $("log");
	var msg = "Message";
	if (log && !log.value.length > 0 && !(log.value && log.value == msg)) {
		log.value = msg;
		log.observe("focus", function() { if (log.value == msg) log.value = ""; });
	}
});