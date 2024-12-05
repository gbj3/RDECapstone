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
                <div class="logo"><a href="index.html"><img src='./images/RDE-logo.png' alt="rde logo" /></a></div>
                <ul class="nav-links">
                    <li><a href="index.html">Home</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropbtn">Vaccine Pages <span id="dropdown">&#9660;</span><span id="dropup">&#9650;</span></a>
                        <div class="dropdown-content">
                            <a href="location.html">Location</a>
                            <a href="demographics.cfm?dimensionType=Age&seasonSurveyYear=All&geographyType=All&month=All&season_survey_year=All">Demographics</a>
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
                <a href="index.html">Home</a>
                <a href="location.html">Location</a>
                <a href="demographics.cfm?dimensionType=Age&seasonSurveyYear=All&geographyType=All&month=All&season_survey_year=All">Demographics</a>
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
        <div class="hero">
            <img src="./images/heroPicture.webp" alt="hero image" />
        </div>
        <!-- Dropdown filters for Bar Chart !-->
        <div class="charts">
            <div class="barChartCard">
                <div class="queryForms">
                    <form id="constraintForm" method="get">
                        <label for="dimensionType">Choose a Dimension Type:</label>
                        <select name="dimensionType" id="dimensionType" onchange="applyFilter();">
                            <option value="Age" <cfif url.dimensionType EQ 'Age'>selected</cfif>>Age</option>
                            <option value="Race and Ethnicity" <cfif url.dimensionType EQ 'Race and Ethnicity'>selected</cfif>>Race and Ethnicity</option>
                        </select>
                        
                        <label for="seasonSurveyYear">Choose a Season Survey Year:</label>
                        <select name="seasonSurveyYear" id="seasonSurveyYear" onchange="applyFilter();">
                            <option value="All" <cfif url.seasonSurveyYear EQ 'All'>selected</cfif>>All</option>
                            <cfquery name="yearOptions" datasource="rdecapstone">
                                SELECT DISTINCT season_survey_year FROM stage ORDER BY season_survey_year;
                            </cfquery>
                            <cfoutput query="yearOptions">
                                <option value="#season_survey_year#" <cfif url.seasonSurveyYear EQ season_survey_year>selected</cfif>>#season_survey_year#</option>
                            </cfoutput>
                        </select>

                        <label for="geographyType">Choose a Geography Type:</label>
                        <select name="geographyType" id="geographyType" onchange="applyFilter();">
                            <option value="All" <cfif url.geographyType EQ 'All'>selected</cfif>>All</option>
                            <cfquery name="geoOptions" datasource="rdecapstone">
                                SELECT DISTINCT geography_type FROM stage ORDER BY geography_type;
                            </cfquery>
                            <cfoutput query="geoOptions">
                                <option value="#geography_type#" <cfif url.geographyType EQ geography_type>selected</cfif>>#geography_type#</option>
                            </cfoutput>
                        </select>
                    </form>
                </div>
                <!-- Query for Bar Chart !-->
                <cfquery name="ageDimensionData" datasource="rdecapstone">
                    SELECT month, dimension, SUM(sample_size) AS dimension_count
                    FROM demographics_all
                    WHERE dimension_type = <cfqueryparam value="#url.dimensionType#" cfsqltype="CF_SQL_VARCHAR">
                    <cfif url.seasonSurveyYear NEQ "All">
                        AND season_survey_year = <cfqueryparam value="#url.seasonSurveyYear#" cfsqltype="CF_SQL_VARCHAR">
                    </cfif>
                    <cfif url.geographyType NEQ "All">
                        AND geography_type = <cfqueryparam value="#url.geographyType#" cfsqltype="CF_SQL_VARCHAR">
                    </cfif>
                    GROUP BY month, dimension
                    ORDER BY month, dimension;
                </cfquery>
                <!-- Convert output to json to be rendered !-->
                <script type="text/javascript">
                    var chartData = [];
                    <cfoutput query="ageDimensionData">
                        chartData.push({
                            month: "#Replace(ageDimensionData.month, '"', '\"', 'ALL')#",
                            dimension: "#Replace(ageDimensionData.dimension, '"', '\"', 'ALL')#",
                            dimensionCount: #ageDimensionData.dimension_count#
                        });
                    </cfoutput>

                    var months = [...new Set(chartData.map(item => item.month))];
                    var dimensions = [...new Set(chartData.map(item => item.dimension))];

                    var seriesData = dimensions.map(dimension => {
                        return {
                            name: dimension,
                            data: months.map(month => {
                                var entry = chartData.find(item => item.month === month && item.dimension === dimension);
                                return entry ? entry.dimensionCount : 0;
                            })
                        };
                    });
                    // Chart Style
                    document.addEventListener('DOMContentLoaded', function () {
                        Highcharts.chart('chart-container', {
                            chart: {
                                type: 'column',
                                backgroundColor: '#D9D9D9'
                            },
                            title: {
                                text:"Influenza Vaccination Bar Chart"
                            },
                            xAxis: {
                                categories: months,
                                title: {
                                    text: 'Month'
                                }
                            },
                            yAxis: {
                                min: 0,
                                title: {
                                    text: 'Count'
                                }
                            },
                            series: seriesData
                        });
                    });
                </script>
                <!-- Bar Chart Container !-->
                <div class="container">
                    <div id="chart-container" style="width:100%; height:600px"></div>
                </div>
            </div>
            <!-- Heatmap Query !-->
            <div class="heatmap">
                <cfquery name="vaccinationData" datasource="rdecapstone">
                    SELECT fips, SUM(sample_size) AS fipscount
                    FROM demographics_all
                    WHERE geography_type = 'States/Local Areas'
                    <cfif IsDefined("url.month") AND url.month NEQ "All">
                        AND month = <cfqueryparam value="#url.month#" cfsqltype="CF_SQL_VARCHAR">
                    </cfif>
                    <cfif IsDefined("url.season_survey_year") AND url.season_survey_year NEQ "All">
                        AND season_survey_year = <cfqueryparam value="#url.season_survey_year#" cfsqltype="CF_SQL_VARCHAR">
                    </cfif>
                    GROUP BY fips
                </cfquery>
                <!-- Convert to json !-->
                <cfset vaccinationArray = []>
            
                <cfloop query="vaccinationData">
                    <cfset arrayAppend(vaccinationArray, {
                        "fips": vaccinationData.fips,
                        "count": vaccinationData.fipscount
                    })>
                </cfloop>
            
                <cfset vaccinationJSON = serializeJSON(vaccinationArray)>
                <!-- Text next to heatmap !-->
                <div class="heatmapCard">
                    <div class="textContainer">
                        <h1>Influenza Vaccination Heat Map</h1>
                        <p>Track flu vaccine rates across the United States</p>

                        <!-- Form to query year and month !-->
                        <div class="heatmapForms">
                            <form id="monthForm" method="get">
                                <label for="month">Choose a Month:</label>
                                <select name="month" id="month" onchange="applyFilter();">
                                    <option value="All" <cfif url.month EQ 'All' OR NOT IsDefined("url.month")>selected</cfif>>All</option>
                                    <cfquery name="monthOptions" datasource="rdecapstone">
                                        SELECT DISTINCT month FROM demographics_all ORDER BY month;
                                    </cfquery>
                                    <cfoutput query="monthOptions">
                                        <option value="#month#" <cfif url.month EQ month>selected</cfif>>#month#</option>
                                    </cfoutput>
                                </select>
                                <label for="season_survey_year">Choose a Year:</label>
                                <select name="season_survey_year" id="season_survey_year" onchange="applyFilter();">
                                    <option value="All" <cfif url.month EQ 'All' OR NOT IsDefined("url.season_survey_year")>selected</cfif>>All</option>
                                    <cfquery name="season_survey_yearOptions" datasource="rdecapstone">
                                        SELECT DISTINCT season_survey_year FROM demographics_all ORDER BY season_survey_year;
                                    </cfquery>
                                    <cfoutput query="season_survey_yearOptions">
                                        <option value="#season_survey_year#" <cfif url.season_survey_year EQ season_survey_year>selected</cfif>>#season_survey_year#</option>
                                    </cfoutput>
                                </select>
                            </form>
                            
                            <!-- Logic to preserve parameters inside URL !-->
                            <script>
                                function applyFilter() {
                                    // Bar Chart
                                    const selectedDimension = document.getElementById('dimensionType').value;
                                    const selectedSurveyYear = document.getElementById('seasonSurveyYear').value;
                                    const selectedGeographyType = document.getElementById('geographyType').value;

                                    // Heat Map
                                    const selectedMonth = document.getElementById('month').value;
                                    const selectedYear = document.getElementById('season_survey_year').value;

                                    const urlParams = new URLSearchParams(window.location.search);
                    
                                    // Preserve existing query parameters from constraintForm
                                    // Bar Chart
                                    urlParams.set('dimensionType', selectedDimension);
                                    urlParams.set('seasonSurveyYear', selectedSurveyYear);
                                    urlParams.set('geographyType', selectedGeographyType);
                                    
                                    // Heat Map
                                    urlParams.set('month', selectedMonth);
                                    urlParams.set('season_survey_year', selectedYear);
                    
                                    // Redirect with updated query string
                                    window.location.search = urlParams.toString();
                                }
                            </script>
                        </div>
                    </div>
                    <div id="map" style="height: 600px; width: 100%;"></div>
                </div>
                
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Initialize the map after the DOM is fully loaded
                        var map = L.map('map').setView([37.8, -96], 4); // Center of the US
            
                        var vaccinationData = <cfoutput>#vaccinationJSON#</cfoutput>;
                        //console.log(vaccinationData);
                        // Fetch the GeoJSON data for US boundaries
                        fetch('./us-states.json')
                            .then(response => response.json())
                            .then(geojsonData => {
                                fetch('./us-states.json')
                                    .then(response => response.json())
                                    .then(fipsData => {
            
                                        function getColor(count) {
                                            return count > 15000000 ? '#900000' :
                                                count > 14000000  ? '#aa0000' :
                                                count > 13000000  ? '#cc0000' :
                                                count > 12000000  ? '#ee0000' :
                                                count > 11000000  ? '#ff2400' :
                                                count > 10000000  ? '#ff3300' :
                                                count > 9500000  ? '#ff4000' :
                                                count > 9000000  ? '#ff4d00' :
                                                count > 8500000  ? '#ff5a00' :
                                                count > 8000000  ? '#ff6600' :
                                                count > 7500000  ? '#ff7300' :
                                                count > 7000000  ? '#ff8000' :
                                                count > 6500000  ? '#ff8d1a' :
                                                count > 6000000  ? '#ff9933' :
                                                count > 5500000  ? '#ffa64d' :
                                                count > 5000000   ? '#ffb366' :
                                                count > 4500000   ? '#ffbf80' :
                                                count > 4000000   ? '#ffc999' :
                                                count > 3500000   ? '#ffd4b3' :
                                                count > 3000000   ? '#ffdfcc' :
                                                count > 2500000   ? '#ffe9e6' :
                                                count > 2000000   ? '#fff3f0' :
                                                count > 1500000   ? '#fff8f5' :
                                                count > 1000000   ? '#fffaf7' :
                                                                    '#FFFFFF';
                                        }
            
                                        // Style function to apply to each region based on the vaccination count
                                        function style(feature) {
                                            var fips = feature.id;
                                            //console.log(feature.id);
                                            var vaccination = vaccinationData.find(v => v.fips == fips);
                                            var count = vaccination ? vaccination.count : 0;
                                            console.log(vaccination);
                                            
            
                                            return {
                                                fillColor: getColor(count),
                                                weight: 2,
                                                opacity: 1,
                                                color: 'white',
                                                dashArray: '3',
                                                fillOpacity: 0.7
                                            };
                                        }
            
                                        // Add the GeoJSON data to the map
                                        L.geoJson(geojsonData, { style: style }).addTo(map);

                                        /*Legend specific*/
                                        var legend = L.control({ position: "bottomleft" });

                                        legend.onAdd = function(map) {
                                        var div = L.DomUtil.create("div", "legend");
                                        div.innerHTML += "<h4>Vaccination Count</h4>";
                                        div.innerHTML += `
                                            <div style="width: 200px; height: 15px; background: linear-gradient(to right, 
                                                #FFFFFF, 
                                                #fffaf7 4%, 
                                                #fff8f5 8%, 
                                                #fff3f0 12%, 
                                                #ffe9e6 16%, 
                                                #ffdfcc 20%, 
                                                #ffd4b3 24%, 
                                                #ffc999 28%, 
                                                #ffbf80 32%, 
                                                #ffb366 36%, 
                                                #ffa64d 40%, 
                                                #ff9933 44%, 
                                                #ff8d1a 48%, 
                                                #ff8000 52%, 
                                                #ff7300 56%, 
                                                #ff6600 60%, 
                                                #ff5a00 64%, 
                                                #ff4d00 68%, 
                                                #ff4000 72%, 
                                                #ff3300 76%, 
                                                #ff2400 80%, 
                                                #ee0000 84%, 
                                                #cc0000 88%, 
                                                #aa0000 92%, 
                                                #900000); 
                                                border: 1px solid black;"></div>
                                            <div style="display: flex; justify-content: space-between;">
                                                <span>< 1M</span>
                                                <span>> 15M</span>
                                            </div>`;
                                        return div;
                                        };
                                        legend.addTo(map);
                                    })
                                    .catch(error => console.error("Error loading FIPS map data:", error));
                            })
                            .catch(error => console.error("Error loading GeoJSON data:", error));
                    });
                </script>
            </div>
        </div>
    </main>
    <footer class="demographicsFooter">
        <div class="twitterFooter">
            <a href="https://www.x.com/rdesystems"><img src="./images/twitterLogo.png"></a>
        </div>
        <div class="copyrightFooter">
            <p>Copyright &copy; 2024 RDE Systems, LLC. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
