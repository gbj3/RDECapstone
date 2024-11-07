let map;
let allLocations = [];
let displayedCount = 3;  // Number of locations displayed initially
let markers = [];

// Initialize the Google Map
function initMap() {
  map = new google.maps.Map(document.getElementById("map"), {
    center: { lat: 40.916, lng: -74.17 },  // Default map center (adjust as needed)
    zoom: 12
  });
}

// Function to get the user's location or use the default map center
function getUserLocation() {
  return new Promise((resolve) => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        position => resolve({
          lat: position.coords.latitude,
          lng: position.coords.longitude
        }),
        () => resolve(map.getCenter().toJSON())  // Use map center as fallback
      );
    } else {
      resolve(map.getCenter().toJSON());
    }
  });
}

// Function to fetch and load locations based on the search input
async function loadLocations(searchTerm = "") {
  const url = `localhost/RDE/getLocationData.cfm?searchTerm=${encodeURIComponent(searchTerm)}`;


  const userLocation = await getUserLocation();
  const maxDistance = parseFloat(document.getElementById("distance-filter").value);

  fetch(url)
    .then(response => response.json())
    .then(locations => {
      allLocations = locations;
      clearMarkers();

      // Filter locations based on the specified distance, if provided
      const filteredLocations = maxDistance
        ? locations.filter(location =>
            calculateDistanceInMiles(userLocation, {
              lat: parseFloat(location.latitude),
              lng: parseFloat(location.longitude)
            }) <= maxDistance
          )
        : locations;

      // Display the first few results initially
      displayLocations(Array.isArray(filteredLocations) ? filteredLocations.slice(0, displayedCount) : []);

      document.getElementById("show-more-btn").style.display =
        filteredLocations.length > displayedCount ? "block" : "none";
    })
    .catch(error => console.error('Error fetching locations:', error));
}

// Display a subset of locations in the UI and add markers to the map
function displayLocations(locations) {
  const locationList = document.getElementById("location-list");
  locationList.innerHTML = "";

  locations.forEach(location => {
    const locationItem = document.createElement("div");
    locationItem.classList.add("location-item");

    locationItem.innerHTML = `
      <h3>${location.loc_name}</h3>
      <p>Address: ${location.loc_admin_street1}, ${location.loc_admin_city}, ${location.loc_admin_state}, ${location.loc_admin_zip}</p>
      <p>Phone: ${location.loc_phone}</p>
      <p><strong>Hours:</strong></p>
      <ul>
        <li>Sunday: ${location.sunday_hours}</li>
        <li>Monday: ${location.monday_hours}</li>
        <li>Tuesday: ${location.tuesday_hours}</li>
        <li>Wednesday: ${location.wednesday_hours}</li>
        <li>Thursday: ${location.thursday_hours}</li>
        <li>Friday: ${location.friday_hours}</li>
        <li>Saturday: ${location.saturday_hours}</li>
      </ul>
      <p><strong>In Stock:</strong> ${location.in_stock ? "Yes" : "No"}</p>
      <a href="${location.web_address}" target="_blank">Visit Website</a>
    `;

    locationList.appendChild(locationItem);

    const marker = new google.maps.Marker({
      position: {
        lat: parseFloat(location.latitude),
        lng: parseFloat(location.longitude)
      },
      map: map,
      title: location.loc_name
    });
    markers.push(marker);

    const infoWindow = new google.maps.InfoWindow({
      content: `
        <h3>${location.loc_name}</h3>
        <p>Address: ${location.loc_admin_street1}, ${location.loc_admin_city}, ${location.loc_admin_state}, ${location.loc_admin_zip}</p>
        <p>Phone: ${location.loc_phone}</p>
      `
    });

    marker.addListener("click", () => {
      infoWindow.open(map, marker);
    });
  });
}

// Function to calculate the distance between two lat/lng points in miles
function calculateDistanceInMiles(point1, point2) {
  const R = 3958.8; // Radius of the Earth in miles
  const dLat = (point2.lat - point1.lat) * (Math.PI / 180);
  const dLon = (point2.lng - point1.lng) * (Math.PI / 180);
  const a = 
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(point1.lat * (Math.PI / 180)) * Math.cos(point2.lat * (Math.PI / 180)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Function to clear all existing markers from the map
function clearMarkers() {
  markers.forEach(marker => marker.setMap(null));
  markers = [];
}

// Show more locations when "Show More" button is clicked
function showMoreLocations() {
  displayedCount += 3;  // Show 3 more locations
  displayLocations(allLocations.slice(0, displayedCount));

  if (displayedCount >= allLocations.length) {
    document.getElementById("show-more-btn").style.display = "none";
  }
}

// Handle the search input and load locations
function searchLocation() {
  const searchTerm = document.getElementById("location-search").value;
  displayedCount = 3;
  loadLocations(searchTerm);
}

// Toggle dropdown menu visibility for mobile navigation
function toggleDropdown() {
  const dropdownMenu = document.getElementById('dropdown-menu');
  dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
}

// Load all locations by default when the page loads
window.onload = function() {
  initMap();
  loadLocations();
};