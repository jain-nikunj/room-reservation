var map;
var markers = [];

function initMap() {
  var mapCenter = {lat: 37.8719402, lng: -122.2622687};
  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 16,
    center: mapCenter,
    mapTypeControl: false,
    fullscreenControl: false
  });
  
  // Disable full screen in Panorama too
  var panorama = map.getStreetView();
  panorama.setOptions({fullscreenControl: false});
  
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
  
  updateMarkers();
}

// Get the parameter string based on the selected filters.
function getParamsString() {
  var studentAccessible = document.getElementById("StudentAccessible").checked;
  var board = document.getElementById("Board").checked;
  var AV = document.getElementById("AV").checked;
  var classroom = document.getElementById("Classroom").checked;
  var lectureHall = document.getElementById("LectureHall").checked;
  var auditorium = document.getElementById("Auditorium").checked;
  var seminarRoom = document.getElementById("SeminarRoom").checked;
  var capacityLower = document.getElementById("capacityLower").value;
  var capacityUpper = document.getElementById("capacityUpper").value;
  var paramsString = "?utf8=✓";
  paramsString += studentAccessible ? "&StudentAccessible=true" : "";
  paramsString += board ? "&Board=true" : "";
  paramsString += AV ? "&AV=true" : "";
  paramsString += classroom ? "&Classroom=true" : "";
  paramsString += lectureHall ? "&LectureHall=true" : "";
  paramsString += seminarRoom ? "&SeminarRoom=true" : "";
  paramsString += auditorium ? "&Auditorium=true" : "";
  paramsString += capacityLower ? "&capacityLower=" + capacityLower : "";
  paramsString += capacityUpper ? "&capacityUpper=" + capacityUpper : "";
  return paramsString;
}

function filterMarkers(e) {
  e.preventDefault();
  updateMarkers();
}

function updateMarkers() {
  var paramsString = getParamsString();
  
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      postMarkers(JSON.parse(this.responseText));
    }
  };
  xhttp.open("GET", "/filter" + paramsString, true);
  xhttp.send();
}

function postMarkers(data) {
  // clear existing markers
  var length = markers.length;
  for (var i = 0; i < length; i++) {
    markers[i].setMap(null);
  }
  markers = [];
  
  // for each new building, query for geolocation and create a new marker
  length = data.length;
  for (var i = 0; i < length; i++) {
    addMarker(data[i]['name'], data[i]['id'], data[i]['count'], data[i]['max'])
  }
}

function addMarker(name, id, roomCount, maxCap) {
  var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        result = JSON.parse(this.responseText);
        console.log(name);
        geo = result['results'][0]['geometry']['location'];
        var marker = new google.maps.Marker({
          position: geo,
          map: map,
          id: id,
        });
        markers.push(marker);
        var infoWindow = new google.maps.InfoWindow({
          content: "<div id='tooltip'>" +
          "<h3 id='ttName'>" + name + "</h3>" +
          "<p id='ttCount'>Room Count: " + roomCount + "</p>" + 
          "<p id='ttCap'>Maximum Capacity: " + maxCap + "</p>" +
          "</div>"
        });
        google.maps.event.addListener(marker, 'mouseover', function() {
          infoWindow.open(map, marker);
        });
        google.maps.event.addListener(marker, 'mouseout', function() {
          infoWindow.close();
        })
        google.maps.event.addListener(marker, 'click', function() {
          paramsString = getParamsString();
          window.location.href = '/buildings/' + marker.id + paramsString;
        });
      }
    };
    xhttp.open("GET", "https://maps.googleapis.com/maps/api/geocode/json?address=" + name + "%20Hall%20Berkeley", true);
    xhttp.send();
}