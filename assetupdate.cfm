<cfquery name="a">
		SELECT
				a.*,
				ac.`Name` AS AssetCategory, ac.ParentAssetCategoryId,
				ac1.`Name` ParentAssetCategory1, ac1.AssetCategoryId, ac1.ParentAssetCategoryId,
				-- al.`Name` AS Location,al.LocDescription,
				rt.Type AS ReadingType,
				a1.Description AS ParentAsset
			FROM
				asset AS a
			LEFT JOIN reading_type AS rt ON rt.ReadingTypeId = a.ReadingTypeId
			LEFT JOIN asset AS a1 ON a1.AssetId = a.ParentAssetId
			LEFT JOIN asset_category ac ON ac.AssetCategoryId = a.AssetCategoryId
			LEFT JOIN asset_category ac1 ON ac1.AssetCategoryId = ac.ParentAssetCategoryId
			WHERE a.Status IN ("Online","Transfered")
order by Description
</cfquery>
<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="UTF-8">
  <title>Asset Update Form</title>
  
  
  <link rel='stylesheet prefetch' href='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'>
<link rel='stylesheet prefetch' href='http://cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.9.0/bootstrap-table.min.css'>
<link rel='stylesheet prefetch' href='https://cdn.datatables.net/1.10.9/css/jquery.dataTables.min.css'>

	<style >
		body {
			  margin: 2rem;
			}
			/*
			th {
			  background-color: white;
			}
			tr:nth-child(odd) {
			  background-color: grey;
			}
			th, td {
			  padding: 0.5rem;
			}
			td:hover {
			  background-color: lightsalmon;
			}
			*/
			.paginate_button {
			  border-radius: 0 !important;
			}

	</style>

  
</head>
<cfoutput>
	

<body>

  <table id="example" class="display" cellspacing="0" width="100%">
        <thead>
            <tr>
                <th>##</th>
                <th>Asset Description</th>
                <th align="center">Class</th>
                <th>Status</th>
                <th>Other Concerns</th>
                
            </tr>
        </thead>
 
        <tfoot>
            <tr>
                <th>##</th>
                <th>Asset Description</th>
                <th>Class</th>
                <th>Status</th>
                <th>Comment Concerns</th>
                
            </tr>
        </tfoot>
 
        <tbody>
            <cfloop query="a">           	         
	            <tr>
	                <th>#AssetId#</th>
	                <td>#Description#</td>
	                <td>
	                	<cfset mi = ""/><cfset ma = ""/><cfset cr = ""/>
	                	<cfswitch expression="#class#" >
	                		<cfcase value="Minor"><cfset mi = "Checked"/></cfcase> 
	                		<cfcase value="Major"><cfset ma = "Checked"/></cfcase> 
	                		<cfcase value="Critical"><cfset cr = "Checked"/></cfcase> 
	                		<cfdefaultcase>
	                			
	                		</cfdefaultcase>
	                	</cfswitch>
	                	<label class="radio-inline" for="radios-0">
					      <input type="radio" name="class#AssetId#" onclick="updateclass(this.value,#Assetid#)" id="radios-0#AssetId#" value="Minor" #mi# >
					      Minor
					    </label> 
					    <label class="radio-inline" for="radios-1">
					      <input type="radio" name="class#AssetId#" onclick="updateclass(this.value,#Assetid#)" id="radios-1#AssetId#" value="Major" #ma#>
					      Major
					    </label> 
					    <label class="radio-inline" for="radios-2">
					      <input type="radio" name="class#AssetId#" onclick="updateclass(this.value,#Assetid#)" id="radios-2#AssetId#" value="Critical" #cr#>
					      Critical
					    </label> 
					    	
	                </td>
	                <td>
	                	<select name="status" onchange="updatestatus(this.value,#Assetid#)" >
	                		<option label="" value="">-</option>
	                		<option label="Online" value="Online"  <cfif Status eq "Online">selected</cfif>>Online</option>
	                		<option label="Offline" value="Offline"  <cfif Status eq "Offline">selected</cfif>>Offline</option>
	                		<option label="Out of Service" value="Out of Service" <cfif Status eq "Out of Service">>selected</cfif>Out of Service</option>
	                		<option label="Transfered" value="Transfered" <cfif Status eq "Transfered">selected</cfif>>Transfered</option>
	                		<option label="Decommissioned" value="Decommissioned" <cfif Status eq "Decommissioned">selected</cfif>>Decommissioned</option
	                	</select>
	                	
	                </td>
	                <td>
	                	<input type="text" width="100%" value="#comment#" onkeyup="updatecomment(this.value,#Assetid#)">
	                </td>
	                
	            </tr>
            </cfloop>
            
        </tbody>
    </table>
  <script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script src='http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js'></script>
<script src='https://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js'></script>
<script>
	$(document).ready(function() {
    	$('##example').DataTable();
    	
	} );
	function updateclass(vl,id){
		var data = {method:"updateclas",classval:vl,assetid:id};
		
	    $.ajax({
	        data: data,
	        type: "post",
	        url: "update.cfc",
	        success: function(data){
	        //alert("Data: " + data);
	        }
	    });
	}
	function updatestatus(vl,id){
		var data = {method:"updatestatus",statusval:vl,assetid:id};
		
	    $.ajax({
	        data: data,
	        type: "post",
	        url: "update.cfc",
	        success: function(data){
	        //alert("Data: " + data);
	        }
	    });
	}
	function updatecomment(vl,id){
		var data = {method:"updatecomment",comment:vl,assetid:id};
		
	    $.ajax({
	        data: data,
	        type: "post",
	        url: "update.cfc",
	        success: function(data){
	        //alert("Data: " + data);
	        }
	    });
	}
</script>




</body>
</cfoutput>
</html>
