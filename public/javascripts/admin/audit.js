// Subclass DatePicker behavior to override the widget positioning and perform
// as an auto-submit field.

var AuditDatePicker = Behavior.create(DatePicker, {
  _positionWidget : function() {
  	var offset = this.element.cumulativeOffset();
  	this.nodes['widget'].setStyle({ "top" : (offset[1] + 24) + "px", "left" : (offset[0] - 86) + "px" });
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