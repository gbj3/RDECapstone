<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="RDE Capstone visualizing Influenza data">
        <title>RDE Influenza Dashboard</title>
        <link rel="stylesheet" href="./styles/main.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Open+Sans:ital,wght@0,300..800;1,300..800&display=swap" rel="stylesheet">
        <script src="https://code.highcharts.com/highcharts.js"></script>
    </head>
    <body>
        <div class="navbar">
            <img src='./images/RDE-logo.png' alt="rde logo" />
            <div>
                <a href="index.cfm">Home</a>
                <select name="links" class="links">
                    <option value="" hidden>Vaccination Pages</option>
                    <a href="maps.cfm"><option value="locations">Location</option></a>
                    <option value="demographics"><a href="maps">Demographics</a></option>
                    <option value="doses"><a href="maps">Doses</a></option>
                    <option value="hospitalizations"><a href="maps">Hospitalizations</a></option>
                </select>
            </div>
        </div>
    
        <div class="hero">
            <img src="./images/heroPicture.webp" alt="hero image" />
        </div>

        <form id="dimensionForm" method="get">
            <label for="dimensionType">Choose a Dimension Type:</label>
            <select name="dimensionType" id="dimensionType" onchange="document.getElementById('dimensionForm').submit();">
                <option value="Age" <cfif url.dimensionType EQ 'Age'>selected</cfif>>Age</option>
                <option value="Race and Ethnicity" <cfif url.dimensionType EQ 'Race and Ethnicity'>selected</cfif>>Race and Ethnicity</option>
            </select>
        </form>

        <cfquery name="ageDimensionData" datasource="rdecapstone">
            SELECT month, dimension, COUNT(*) AS dimension_count
            FROM stage
            WHERE dimension_type = <cfqueryparam value="#url.dimensionType#" cfsqltype="CF_SQL_VARCHAR">
            GROUP BY month, dimension
            ORDER BY month, dimension;
        </cfquery>

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

            document.addEventListener('DOMContentLoaded', function () {
                Highcharts.chart('chart-container', {
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: 'Vaccination Dimension Data by Month'
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

        <div class="container">
            <div id="chart-container" style="height:600px;"></div>
        </div>
    </body>
</html>
