// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function clearOrderFields() {
    var desc = Element.descendants($('common_items'));
    
    for(var i = 0; i < desc.length; i++) {
        var elem = desc[i];
        if(elem.hasClassName("quantity_field") || 
                elem.hasClassName("description_field")) {
            elem.value = "";
        }
        var j = 0;
    }
    
    var element = $('item_quantity');
    if(element)
        element.value = "";
    element = $('item_description');
    if(element)
        element.value = "";
}

function updateDateNeeded(radioButton) {
    params = { date_needed: radioButton.value }
    
    new Ajax.Request (  '/order/set_date_needed',
                        {
                          asynchronous : true,
                          method: 'get',
                          parameters : params,
                          evalScripts : true,
                          onSuccess:
                              function ( transport )
                              {
                              }
                        } );

}

//callback for the calendar in /reports/daily_report
function onDailyReportDateSelect(type, args, obj) {
    //var selected = args[0];
    //var selDate = this.toDate(selected[0]);
    var year = args[0][0][0]
    var month = args[0][0][1]
    var day = args[0][0][2]
    params = { year: year, month: month, day: day }
    
    new Ajax.Request (  '/reports/update_daily_report',
                        {
                          asynchronous : true,
                          method: 'get',
                          parameters : params,
                          evalScripts : true,
                          onSuccess:
                              function ( transport )
                              {
                              }
                        } );
}


