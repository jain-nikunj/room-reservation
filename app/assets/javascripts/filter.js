function details_filter() {
    var paramsString = getParamsString();
    window.location.href = window.location.href.split('?')[0] + paramsString, true;
}

function clear_filters() {
    var roomType = document.getElementById('roomtype_column');
    var inputs = roomType.getElementsByTagName('input');
    for (var i = 0; i < inputs.length; i++) {
        inputs[i].checked = true;
    }
    
    var features = document.getElementById('facilities_column');
    inputs = features.getElementsByTagName('input');
    for (var i = 0; i < inputs.length; i++) {
        inputs[i].checked = false;
    }
    
    document.getElementById('filters-submit').click();
}

/*  Limit the value of capacity field to be greater than or equal to 0,
 *  and lower bound <= upper bound.
 */
function limit() {
    var capacityLower = document.getElementById("capacityLower");
    var capacityUpper = document.getElementById("capacityUpper");
    capacityLower.value = Math.max(0, capacityLower.value);
	capacityUpper.value = Math.max(capacityLower.value, capacityUpper.value);
}