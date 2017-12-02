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

function filter_update(e) {
    var classroom = document.getElementById("Classroom").checked;
    var lectureHall = document.getElementById("LectureHall").checked;
    var auditorium = document.getElementById("Auditorium").checked;
    var seminarRoom = document.getElementById("SeminarRoom").checked;
    var studentAccessible = document.getElementById("StudentAccessible").checked;
    var board = document.getElementById("Board").checked;
    var AV = document.getElementById("AV").checked;
    classroom ? $('#Classroom_tag').show() : $('#Classroom_tag').hide();
    lectureHall ? $('#LectureHall_tag').show() : $('#LectureHall_tag').hide();
    auditorium ? $('#Auditorium_tag').show() : $('#Auditorium_tag').hide();
    seminarRoom ? $('#SeminarRoom_tag').show() : $('#SeminarRoom_tag').hide();
    studentAccessible ? $('#StudentAccessible_tag').show() : $('#StudentAccessible_tag').hide();
    board ? $('#Board_tag').show() : $('#Board_tag').hide();
    AV ? $('#AV_tag').show() : $('#AV_tag').hide();
    
    filterMarkers(e);
}

function remove_tag(tag_name) {
    checkbox = document.getElementById(tag_name);
    checkbox.checked = false;
    updateMarkers()
    tag = document.getElementById(tag_name + "_tag");
    $(tag).hide()
}
