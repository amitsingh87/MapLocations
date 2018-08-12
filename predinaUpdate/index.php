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

	
	// This will be invoked by a cron job to update the value of riskcolor
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
$api->updateLocationColor();

?>