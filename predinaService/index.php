<?php
    
    function sendResponse($status = 200, $body = '', $content_type = 'application/json'){
   	 	$status_header = 'HTTP/1.1 ' . $status . ' ' . 'Success';
    	header($status_header);
    	header('Content-type: ' . $content_type);
    	echo $body;
    }
    
class RiskLocationAPI {
    private $mysqli;

    // Constructor - open DB connection
    function __construct() {
        $this->mysqli = new mysqli('localhost', 'root', 'passpass','predina');
        $this->mysqli->autocommit(FALSE);
    }

    // Destructor - close DB connection
    function __destruct() {
        $this->mysqli->close();
    }

    function fetchLocations() {
        $pageSize = isset($_POST["pageSize"]) ? $_POST["pageSize"]:100000 ;
        $currentPage = isset($_POST["currentPage"]) ? $_POST["currentPage"]:1 ;
		$offset = ($currentPage -1) * $pageSize;
		$sql = "select * from risklocatons";
		$count_set = $this->mysqli->query($sql) or die($this->mysqli->error . __LINE__);
		
		$query = "select latitude,longitude,riskcolor from risklocatons LIMIT $offset,$pageSize";
		$result = $this->mysqli->query($query) or die($this->mysqli->error . __LINE__);
		
		$arr = array();
		if ($result->num_rows > 0) {
  	  		while ($row = $result->fetch_assoc()) {
        		$arr[] = $row;
    		}
    	}
    	
    	$locations = array('risklocations' => $arr, 'totalItems' => $count_set->num_rows);
    	
    	sendResponse(200, json_encode($locations));
        return true;
	}
	
	function updateLocationColor() {
	
            $conn = $con=mysqli_connect("localhost","root","passpass","predina");
            
            if(! $conn ) {
               die("Failed to connect to MySQL: " . mysqli_connect_error()); 
            }

            $sql = "UPDATE risklocatons SET riskcolor = FLOOR( 1 + RAND( ) *10 );";
            
            $retval  = mysqli_query($conn, $sql);
            
            if(! $retval ) {
               die('Could not update data: ' . mysqli_error($con));
            }
            echo "Updated data successfully\n";
            mysqli_close($conn);

        return true;
	}
}


$api = new RiskLocationAPI;
$api->fetchLocations();
#$api->updateLocationColor();

?>