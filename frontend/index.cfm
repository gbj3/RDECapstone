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
    <header>
        <nav class="navbar">
            <div class="navbar-container">
                <div class="logo"><img src='./images/RDE-logo.png' alt="rde logo" /></div>
                <ul class="nav-links">
                    <li><a href="index.cfm">Home</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropbtn">Vaccine Pages &or;</a>
                        <div class="dropdown-content">
                            <a href="location.html">Location</a>
                            <a href="demographics.cfm?dimensionType=Age&seasonSurveyYear=All&geographyType=All">Demographics</a>
                            <a href="vaccine.html">Doses</a>
                            <a href="hospitalizations.cfm" id="hospitalization">Hospitalizations</a>
                        </div>
                    </li>
                </ul>
                <div class="hamburger" onclick="toggleMenu()">
                    <div class="icon"><p>&#9776;</p></div>
                </div>
            </div>
            <div class="mobile-menu">
                <a href="index.cfm">Home</a>
                <a href="location.html">Location</a>
                <a href="demographics.cfm?dimensionType=Age&seasonSurveyYear=All&geographyType=All">Demographics</a>
                <a href="vaccine.html">Doses</a>
                <a href="hospitalizations.cfm" id="hospitalization">Hospitalizations</a>
            </div>
        </nav>

        <script>
            function toggleMenu() {
            const mobileMenu = document.querySelector('.mobile-menu');
            mobileMenu.classList.toggle('active');
    }

        </script>
    </header>
    <main>
    </main>
</body>
<footer>
    <div class="twitterFooter">
        <a href="https://www.x.com/rdesystems"><img src="./images/twitterLogo.png"></a>
    </div>
    <div class="copyrightFooter">
        <p>Copyright &copy; 2024 RDE Systems, LLC. All rights reserved.</p>
    </div>
</footer>
</html>
