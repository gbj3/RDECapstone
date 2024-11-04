<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="RDE Capstone visualizing Influenza data">
    <title>RDE Influenza Dashboard</title>
    <link rel="stylesheet" href="./styles/main.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@100;300;400;700;900&family=Open+Sans:wght@300;400;700&display=swap" rel="stylesheet">
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
    <script src="https://unpkg.com/leaflet-choropleth/dist/leaflet-choropleth.js"></script>
</head>
<body>
    <div class="navbar">
        <img src='./images/RDE-logo.png' alt="rde logo" />
        <div>
            <a href="index.cfm">Home</a>
            <select name="links" class="links" onchange="navigateToPage(this.value);">
                <option value="" hidden>Vaccination Pages</option>
                <option value="locations">Location</option>
                <option value="demographics.cfm?dimensionType=Age&seasonSurveyYear=All&geographyType=All">Demographics</option>
                <option value="doses">Doses</option>
                <option value="hospitalizations">Hospitalizations</option>
            </select>
        </div>
        <script>
            function navigateToPage(page) {
                window.location.href = page;
            }
        </script>
    </div>
</body>
<footer>
    <div class="twitterFooter">
        <a href="https://www.x.com/rdesystems"><img src="./images/twitterLogo.png"></a>
    </div>
    <div class="copyrightFooter">
        <p>Copyright &copy 2024 RDE Systems, LLC. All rights reserved.</p>
    </div>
</footer>
</html>
