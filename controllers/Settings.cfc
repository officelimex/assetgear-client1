component  {

    remote string function deleteAsset(required numeric id) {

        // check if work order is not already created an opened for this asset
        query name="local.qI" {
            echo('DELETE FROM asset WHERE AssetId=#arguments.id#');
        }

        return "Asset was deleted";
    }

    remote string function SaveUser(required numeric id) {
		
        var sql_start = sql_end = "";
        
        param name="form.Email" default="";
        param name="form.UnitId" default="";
        param name="form.OfficeLocationId" default="1";
        
        if(arguments.id eq 0)   {
          sql_start = "INSERT INTO "
        }
        else    {
					sql_start = "UPDATE ";
					end_start = "WHERE UserId=#arguments.id#";
        }
        //b = "";
        //if(arguments.id eq 0){ b = "//"};
        //if (form.Status eq ""){Form.Status = "Open"};

        query result="rt"  {
            echo("#sql_start# core_user SET ");
            echo("Surname         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Surname#";
            echo(",OtherNames         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.OtherNames#";
            echo(",Position  = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Position#";
            echo(",ManagerId = ");    queryParam cfsqltype="cf_sql_numeric" value="#form.ManagerId#";
            echo(",CompanyId = ");    queryParam cfsqltype="cf_sql_numeric" value="#form.CompanyId#";
            echo(",WorkingForId = ");    queryParam cfsqltype="cf_sql_numeric" value="#form.CompanyId#";
            echo(",OfficeLocationId  = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.OfficeLocationId#";
            echo(",`DepartmentId`            = ");    queryParam cfsqltype="cf_sql_numeric" value="#form.DepartmentId#";
            echo(",UnitId         = ");    queryParam cfsqltype="cf_sql_numeric" value="#form.UnitId#";
            echo(",PersonalEmail       = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.PersonalEmail#";
           	
            if(arguments.id eq 0){ 
				echo(",CreatedDate         = ");    queryParam cfsqltype="cf_sql_date" value="#Now()#";
				echo(",Email         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Email#";
				echo(",CreatedByUserId     = ");    queryParam cfsqltype="cf_sql_numeric" value="#request.userinfo.userid#";
			};
			echo(",Approved       = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Approved#";
			
            if(arguments.id)    {
                echo(" WHERE UserId=#arguments.id#");
            }
        }
        var _id = arguments.id;
        if(arguments.id eq 0)    {
            _id = rt.GENERATED_KEY;
        }
        
        f = CreateObject("component","assetgear.com.awaf.util.file").init()
        h = createobject('component','assetgear.com.awaf.util.helper').Init();
        s_path = form.PhotosSource & "/" & form.Photos 
		d_path = form.PhotosDestination & "/core_user/" & _id & "/"
        f.Move('core_user',form.id,'p',s_path,d_path)
        
        h.SaveFromTempTable(form.Users,
				"report_to",
				"HeadId,Position",
				"int0,text0",
                "ReportToId","UserId",_id)
        h.SaveFromTempTable(form.Relief,
				"relief_user",
				"BackToBackId",
				"int0",
                "ReliefUserId","UserId",_id)
                
        query result="qS" {
        	echo("SELECT UserId FROM signature WHERE UserId = #_id#"); 
        }
        query result = "rt2" {
        	if(qS.RECORDCOUNT eq ""){
        		echo("INSERT INTO ");
        	}else {
        		echo("UPDATE ");
        	};
        	echo("signature SET ");
        	echo("UserId         = ");    queryParam cfsqltype="cf_sql_varchar" value="#_id#";
        	echo(",`Height`         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Height#";
        	echo(",`Width`         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Width#";
        	if(qS.RECORDCOUNT neq ""){
        		echo(" WHERE UserId = #_id#"); 
        	}
        }
        
                
        return "Report #_id# was saved successfuly";

    }
    
    remote string function SaveComment() { 
        
        query result="rt"  {
            echo("INSERT INTO core_comment SET
                Comments='#form.Comments#'
            ");
            echo(",PK         = ");    queryParam cfsqltype="cf_sql_int" value="#form.PK#";
            echo(",`Table`       = ");    queryParam cfsqltype="cf_sql_string" value="#form.Table#";
            echo(",CommentByUserId           = ");    queryParam cfsqltype="cf_sql_int" value="#request.userinfo.UserId#";
        }
        var _id = arguments.id;
        if(arguments.id eq 0)    {
            _id = rt.GENERATED_KEY;
        }

        return "Report #arguments.id# was saved successfuly";
    }
}
