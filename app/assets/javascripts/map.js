var map;

function initMap() {
  var mapCenter = {lat: 37.8719402, lng: -122.2622687};
  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 16,
    center: mapCenter,
    mapTypeControl: false,
    fullscreenControl: false
  });
  
  map.data.loadGeoJson("updated_building_geo.json");
  
  // Make sure user won't navigate the map out of the scope of Berkeley.
  var allowedBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(37.867911, -122.266229), 
    new google.maps.LatLng(37.875455, -122.253570)
  );
  var lastValidCenter = map.getCenter();
  google.maps.event.addListener(map, 'center_changed', function() {
    if (allowedBounds.contains(map.getCenter())) {
      // still within valid bounds, so save the last valid position
      lastValidCenter = map.getCenter();
      return; 
    }
    // not valid anymore => return to last valid position
    map.panTo(lastValidCenter);
  });
  
  map.data.addListener('click', function(event) {
    var studentAccessible = document.getElementById("StudentAccessible").checked;
    var whiteboard = document.getElementById("Whiteboard").checked;
    var AV = document.getElementById("AV").checked;
    var typeDrop = document.getElementById("type_drop");
    var roomType = typeDrop.options[typeDrop.selectedIndex].value;
    var capacityDrop = document.getElementById("capacity_drop");
    var capacity = capacityDrop.options[capacityDrop.selectedIndex].value;
    var paramsString = "?utf8=✓";
    paramsString += studentAccessible ? "&StudentAccessible=true" : "";
    paramsString += whiteboard ? "&Whiteboard=true" : "";
    paramsString += AV ? "&AV=true" : "";
    paramsString += "&room_type=" + roomType;
    paramsString += "&capacity=" + capacity;
    window.location.href = '/buildings/' + event.feature.getId() + paramsString;
  });
  
  map.data.addListener('mouseover', function(event) {
    document.getElementById('legend').style.visibility = 'visible';
    legend.innerHTML = event.feature.getProperty("name");
  });
  
  map.data.addListener('mouseout', function(event) {
    document.getElementById('legend').style.visibility = 'hidden';
  });
}