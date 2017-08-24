function initialize() {
    var map;
    var bounds = new google.maps.LatLngBounds();
    var mapOptions = {
        mapTypeId: 'roadmap'
    };
    var circle_red = '/image/red.png';
    var circle_blue = '/image/blue.png';
    var circle_yellow = '/image/yellow.png';
    var circle_pink = '/image/pink.png';
    var circle_green = '/image/green.png';

    // Display a map on the page
    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
    map.setTilt(45);

    // Multiple Markers
    var markers = [
        ['Gateway: NTHU-HSNL',24.794527, 120.994025, null, google.maps.Animation.DROP],
        ['Smart Greenhouse: 05000023',24.793213, 120.993241, circle_green, google.maps.Animation.DROP],
        ['Smart Greenhouse: 05010413',24.794603, 120.993806, circle_green, google.maps.Animation.DROP],
        ['Smart Greenhouse: 05010413',24.794581, 120.994431, circle_green, google.maps.Animation.DROP],
        ['Parking: 00000390',24.794663, 120.995287, circle_red, google.maps.Animation.DROP],
        ['Parking: 0d0100de',24.794705, 120.995182, circle_red, google.maps.Animation.DROP],
        ['Parking: 00000393',24.795091, 120.994307, circle_red, google.maps.Animation.DROP],
        ['Parking: 0000038f',24.795162, 120.994158, circle_red, google.maps.Animation.DROP],
        ['Parking: 0d01009b',24.794851, 120.994828, circle_red, google.maps.Animation.DROP],
        ['Parking: 00000394',24.795143, 120.994191, circle_red, google.maps.Animation.DROP],
        ['Parking: 00000397',24.795123, 120.994240, circle_red, google.maps.Animation.DROP],
        ['Parking: 0d0100a1',24.794845, 120.994918, circle_red, google.maps.Animation.DROP],
        ['Parking: 0d0100d6',24.794811, 120.994934, circle_red, google.maps.Animation.DROP],
        ['Parking: 0d0100ac',24.794762, 120.995054, circle_red, google.maps.Animation.DROP],
    ];

    var legends = [
        ['Nodes with GPS  <br> &nbsp; &nbsp; (Fixed Location)', circle_red],
        ['Nodes without GPS <br> &nbsp; &nbsp; (Estimated Location)', circle_green],
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
            animation: markers[i][4],
            map: map,
            icon: markers[i][3],
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
                fillOpacity: 0.1,
                map: map,
                center: {lat: 24.794527, lng: 120.994025},
                radius: 200
              });

    var legend = document.getElementById('legend');
        for (i = 0; i < legends.length; i++ ) {
          var name = legends[i][0];
          var icon = legends[i][1];
          var div = document.createElement('div');
          div.innerHTML = '<img src="' + icon + '"> ' + name;
          legend.appendChild(div);
        }

    map.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legend);

    // Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
    var boundsListener = google.maps.event.addListener((map), 'bounds_changed', function(event) {
        this.setZoom(17);
        google.maps.event.removeListener(boundsListener);
    });

}
initialize();
