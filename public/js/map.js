// var marker;
//
// function initMap() {
//   var map = new google.maps.Map(document.getElementById('map'), {
//     zoom: 13,
//     center: {lat: 59.325, lng: 18.070}
//   });
//
//   marker = new google.maps.Marker({
//     map: map,
//     draggable: true,
//     animation: google.maps.Animation.DROP,
//     position: {lat: 59.327, lng: 18.067}
//   });
//   marker.addListener('click', toggleBounce);
// }
//
// function toggleBounce() {
//   if (marker.getAnimation() !== null) {
//     marker.setAnimation(null);
//   } else {
//     marker.setAnimation(google.maps.Animation.BOUNCE);
//   }
// }
// initMap();


// jQuery(function($) {
//     // Asynchronously Load the map API
//     var script = document.createElement('script');
//     script.src = "https://maps.googleapis.com/maps/api/js??key=AIzaSyAABQ2Xfin8_fQBIn8EQbs4R3qLNssfQ9s&sensor=false&callback=initialize";
//     document.body.appendChild(script);
// });

function initialize() {
    var map;
    var bounds = new google.maps.LatLngBounds();
    var mapOptions = {
        mapTypeId: 'roadmap'
    };

    // Display a map on the page
    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
    map.setTilt(45);

    // Multiple Markers
    var markers = [
        ['NTHU-HSNL',24.794527, 120.994025]
        // ['London Eye, London', 51.503454,-0.119562],
        // ['Palace of Westminster, London', 51.499633,-0.124755]
    ];

    // Info Window Content
    // var infoWindowContent = [
    //     ['<div class="info_content">' +
    //     '<h3>London Eye</h3>' +
    //     '<p>The London Eye is a giant Ferris wheel situated on the banks of the River Thames. The entire structure is 135 metres (443 ft) tall and the wheel has a diameter of 120 metres (394 ft).</p>' +        '</div>'],
    //     ['<div class="info_content">' +
    //     '<h3>Palace of Westminster</h3>' +
    //     '<p>The Palace of Westminster is the meeting place of the House of Commons and the House of Lords, the two houses of the Parliament of the United Kingdom. Commonly known as the Houses of Parliament after its tenants.</p>' +
    //     '</div>']
    // ];

    // Display multiple markers on a map
    var infoWindow = new google.maps.InfoWindow(), marker, i;

    // Loop through our array of markers & place each one on the map
    for( i = 0; i < markers.length; i++ ) {
        var position = new google.maps.LatLng(markers[i][1], markers[i][2]);
        bounds.extend(position);
        marker = new google.maps.Marker({
            position: position,
            animation: google.maps.Animation.DROP,
            map: map,
            title: markers[i][0]
        });

        // Allow each marker to have an info window
        google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
                infoWindow.setContent(markers[i][0]);
                infoWindow.open(map, marker);
            }
        })(marker, i));

        // Automatically center the map fitting all markers on the screen
        map.fitBounds(bounds);
    }

    var cityCircle = new google.maps.Circle({
                strokeColor: '#FF0000',
                strokeOpacity: 0.3,
                strokeWeight: 2,
                fillColor: '#FF0000',
                fillOpacity: 0.2,
                map: map,
                center: {lat: 24.794527, lng: 120.994025},
                radius: 200
              });

    // Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
    var boundsListener = google.maps.event.addListener((map), 'bounds_changed', function(event) {
        this.setZoom(17);
        google.maps.event.removeListener(boundsListener);
    });

}
initialize();
