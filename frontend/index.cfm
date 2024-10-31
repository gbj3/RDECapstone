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

    <cfquery name="getData" datasource="rdecapstone">
        SELECT TOP 20 * FROM vaccination
    </cfquery>
    
    <cfquery name="getMonthCounts" datasource="rdecapstone">
        SELECT Month, COUNT(*) as MonthCount
        FROM vaccination
        GROUP BY Month
        ORDER BY Month ASC
     </cfquery>

     <cfquery name="getDimension" datasource="rdecapstone">
        SELECT Dimension FROM demographics;
     </cfquery>

     <cfquery name="getDimensionCounts" datasource="rdecapstone">
       Select Dimension, COUNT(*) as DimensionCount
       FROM demographics
       WHERE Dimension_Type = 'Age'
       GROUP BY Dimension
       ORDER BY Dimension ASC
     </cfquery>

     <script>
        var dimensionData = [
          <cfoutput query="getDimensionCounts">
              ['#Dimension#', #DimensionCount#]<cfif currentRow lt recordCount>,</cfif>
          </cfoutput>
        ];
     </script>

      
      <!--- <cfoutput>
        <table>
          <tr>
            <th>id</th>
            <th>Vaccine</th>
            <th>Geography_Type</th>
            <th>Geography</th>
            <th>FIPS</th>
            <th>Season_Survey_Year</th>
            <th>Month</th>
          </tr>
          <cfloop query="getData">
            <tr>
              <td>#getData.id#</td>
              <td>#getData.Vaccine#</td>
              <td>#getData.Geography_Type#</td>
              <td>#getData.Geography#</td>
              <td>#getData.FIPS#</td>
              <td>#getData.Season_Survey_Year#</td>
              <td>#getData.Month#</td>
            </tr>
          </cfloop>
        </table>
      </cfoutput> --->

      <cfoutput>
        <div class="barChartContainer">
            <cfchart id='chart' format="html" title="Influenza Vaccination Bar Graph" xaxistitle="Month" yaxistitle="Count"  width="80%" height="600px" >
                <cfchartseries type="bar" serieslabel="">
                    <cfloop query="getMonthCounts">
                        <cfchartdata item="#getMonthCounts.Month#" value="#getMonthCounts.MonthCount#" />
                    </cfloop>
                </cfchartseries>
            </cfchart>
        </div>
      </cfoutput>

      <cfoutput>
        <div class="barChartContainer">
            <cfchart 
              id='dimensionChart' 
              format="html" 
              title="Influenza Vaccination Bar Graph" 
              xaxistitle="Dimension" 
              yaxistitle="Count" 
              showlegend="true" 
              width="80%" 
              height="600px"
            >
              <cfchartseries type="bar" serieslabel="Dimension Counts">
                    <cfloop query="getDimensionCounts">
                        <cfchartdata item="#getDimensionCounts.Dimension#" value="#getDimensionCounts.DimensionCount#" />
                    </cfloop>
                </cfchartseries>
            </cfchart>
        </div>
      </cfoutput>

      <div id="container" width="80%" height="600px">
        <script>
          document.addEventListener('DOMContentLoaded', function () {
              Highcharts.chart('container', {
                  chart: {
                      type: 'column'
                  },
                  title: {
                      text: 'Vaccination Count by Month'
                  },
                  xAxis: {
                      type: 'category',
                      title: {
                          text: 'Month'
                      }
                  },
                  yAxis: {
                      title: {
                          text: 'Count'
                      }
                  },
                  series: [{
                      name: 'Vaccinations',
                      data: dimensionData
                  }]
              });
          });
      </script>
      
      </div>
</body>
</html>
