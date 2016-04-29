<!DOCTYPE html>
<html>
  <head>
    <title>Assignment6</title>
    <meta name="viewport" content="initial-scale=1.0">
    <meta charset="utf-8">
    <style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map {
        height: 100%;
      }
      #Selections{
        position: absolute;
        top: 20px;
        left: 5%;
        z-index: 5;
        background-color: #fff;
        padding: 5px;
        border: 1px solid #999;
        font-family: 'Roboto','sans-serif';
        line-height: 30px;
        padding-left: 10px;
      }
    </style>
  </head>
  <body>
    <div id ="Selections">
    <form action="assignment6.php" method='POST' id='myform' enctype='multipart/form-data'>
    <input type="checkbox" name="checkbox[]" id ="4d4b7104d754a06370d81259" value='4d4b7104d754a06370d81259'> &nbsp; Arts &amp; Entertainment <br/>
    <input type="checkbox" name="checkbox[]" id ="4d4b7105d754a06374d81259" value='4d4b7105d754a06374d81259'> &nbsp; Food <br/>
    <input type="checkbox" name="checkbox[]" id ="4d4b7105d754a06376d81259" value='4d4b7105d754a06376d81259'> &nbsp; Nightlife Spot <br/>
    <input type="checkbox" name="checkbox[]" id ="4d4b7105d754a06377d81259" value='4d4b7105d754a06377d81259'> &nbsp; Outdoors &amp; Recreation <br/>
    <input type="checkbox" name="checkbox[]" id ="4d4b7105d754a06378d81259" value='4d4b7105d754a06378d81259'> &nbsp; Shop &amp; Service <br/>
    <input type="checkbox" name="checkbox[]" id ="4d4b7105d754a06379d81259" value='4d4b7105d754a06379d81259'> &nbsp; Travel &amp; Transport <br/>
    <input type="checkbox" name="checkbox[]" id ="4d4b7105d754a06372d81259" value='4d4b7105d754a06372d81259'> &nbsp; College &amp; University <br/>
    <input type="checkbox" name="checkbox[]" id ="4d4b7105d754a06375d81259" value='4d4b7105d754a06375d81259'> &nbsp; Professional &amp; OtherPlaces <br/> 
    <input type="checkbox" name="checkbox[]" id ="4e67e38e036454776db1fb3a" value='4e67e38e036454776db1fb3a'> &nbsp; Residence <br/>
    Limit (K):<br/>
    <script type="text/javascript">
    function showLimit(){
      document.getElementById('showlimitvalue').value = document.getElementById('limitvalue').value;
    }
    </script>
    <input type="range" id="limitvalue" min="0" max="50" step="1" onchange="showLimit()"><br/>
    <input type="text" name="limitvalue" readonly="readonly" id="showlimitvalue" value="25"><br/>
    Radius (M):<br/>
    <script type="text/javascript">
    function showRadius(){
      document.getElementById('showradiusvalue').value = document.getElementById('radiusvalue').value;
    }
    </script>
    <input type="range"  id="radiusvalue" min="0" max="3000" step="100" onchange="showRadius()"><br/>
    <input type="text" name="radiusvalue" readonly="readonly" id="showradiusvalue" value="1500"><br/>
    <input type="hidden" id="positionlat" name="positionlat" value="0">
    <input type="hidden" id="positionlng" name="positionlng" value="0">
    <script type="text/javascript">
    function submitfun(){
      if(document.getElementById('positionlat').value == "0"){

      }
      else{
        var form = document.getElementById('myform');
        form.submit();        
      }
    }
    </script>
    <input type="button" value="Submit" onclick='submitfun()'>
    </form>
    </div>
    <div id="map"></div>
    <script>
    var map;
    function initMap() {
      map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 44.983333, lng: -93.266667},
        zoom: 14
      });
      //clicked marker position
      var markers =[];  
      var markerposition;
      var hidemarker = new google.maps.Marker({
      position: {lat: 44.983333, lng: -93.266667},
      map: null
      });
      markers.push(hidemarker);
      // This event listener calls addMarker() when the map is clicked.
      google.maps.event.addListener(map, 'click', function(event) {
        markers[0].setMap(null);
        markers = [];
        markerposition = event.latLng;
        var marker = new google.maps.Marker({
        position:event.latLng,
        map:map,
        title:'location:'+event.latLng.toString(),
        });
        markers.push(marker);
        document.getElementById('positionlat').value = markers[0].position.lat();
        document.getElementById('positionlng').value = markers[0].position.lng();
      });
      <?php
        if(isset($_POST['positionlat'])){
          $array = $_POST['checkbox'];
          $ids ="";
          $K = $_POST['limitvalue'];
          $R = $_POST['radiusvalue'];
          foreach($array as $x){
             $ids = $ids.$x.",";
             print("document.getElementById('".$x."').checked = 'checked';");
          }
          print("document.getElementById('limitvalue').value = ".$K.";");
          print("document.getElementById('showlimitvalue').value = ".$K.";");
          print("document.getElementById('radiusvalue').value = ".$R.";");
          print("document.getElementById('showradiusvalue').value = ".$R.";");
          print("document.getElementById('positionlat').value = ".$_POST['positionlat'].";");
          print("document.getElementById('positionlng').value = ".$_POST['positionlng'].";");
          $ids = substr($ids,0,-1);
          $URL = "https://api.foursquare.com/v2/venues/search?ll=".$_POST['positionlat'].",".$_POST['positionlng']."&intent=browse&oauth_token=IEFALGQT4VSDK0NCK1UT5QIQN2ONGMABYE3ZYBLWNVB3QMAI&v=20151116&limit=".$K."&radius=".$R."&categoryId=".$ids."&v=20151116";
          $json = file_get_contents($URL);
          $json_data = json_decode($json,true);
          $result = $json_data['response'];
          $answer = $result['venues'];
          print("var newmarker = new google.maps.Marker({");
          print("position: {lat: ".$_POST['positionlat'].", lng: ".$_POST['positionlng']."},");
          print("map: map");
          print("});");
          print("markers.push(newmarker);");
          for($i=0;$i<count($answer);$i++){
            print("var newmarker = new google.maps.Marker({");
            print("position: {lat: ".$answer[$i]['location']['lat'].", lng: ".$answer[$i]['location']['lng']."},");
            print("map: map,");
            print('title:"'.addslashes($answer[$i]["name"]).'",');
            print("icon: '".$answer[$i]['categories'][0]['icon']['prefix']."bg_32".$answer[$i]['categories'][0]['icon']['suffix']."'");
            print("});");
            $message = "<p>".addslashes($answer[$i]["name"])."</p><p>".$answer[$i]['location']['address']."</p><p>".$answer[$i]['location']['lat']."</p><p>".$answer[$i]['location']['lng']."</p>";
            print('attachSecretMessage(newmarker,"'.$message.'");');
            print("markers.push(newmarker);");
          }
        }
      ?>
    }
    function attachSecretMessage(marker, Message) {
      var infowindow = new google.maps.InfoWindow({
        content: Message
      });
      marker.addListener('click', function() {
        infowindow.open(marker.get('map'), marker);
      });
    }
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBNO8HciShO_3XLUk0IxinHb-YVcIRaaew&callback=initMap"
        async defer></script>
  </body>
</html>