<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RDE Influenza Dashboard</title>
    <link rel="stylesheet" href="./styles/main.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Open+Sans:ital,wght@0,300..800;1,300..800&display=swap" rel="stylesheet">
</head>
<body>
    <div class="navbar">
        <img src='./images/RDE-logo.png' alt="rde logo" />
        <div>
            <a href="index.cfm">Home</a>
            <select name="links" class="links">
                <option>Vaccination Pages</option>
                <option value="locations"><a href="maps">Vaccination Locations</a></option>
                <option value="demographics"><a href="maps">Vaccination Demographics</a></option>
                <option value="doses"><a href="maps">Vaccination Doses</a></option>
                <option value="hospitalizations"><a href="maps">Vaccination Hospitalizations</a></option>
            </select>
        </div>
    </div>
    <div class="hero">
        <img src="./images/heroPicture.png" alt="hero image" />
    </div>
    <cfquery name="getData" datasource="rdecapstone">
        SELECT TOP 5 * FROM vaccine
      </cfquery>
      
      <cfoutput>
        <table>
          <tr>
            <th>id</th>
            <th>Vaccine</th>
            <th>Month</th>
          </tr>
          <cfloop query="getData">
            <tr>
              <td>#getData.id#</td>
              <td>#getData.Vaccine#</td>
              <td>#getData.Month#</td>
            </tr>
          </cfloop>
        </table>
      </cfoutput>
      
</body>
</html>
