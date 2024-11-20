component  {

    remote string function deleteAsset(required numeric id) {

        // check if work order is not already created an opened for this asset
        query name="local.qI" {
            echo('DELETE FROM asset WHERE AssetId=#arguments.id#');
        }

        return "Asset was deleted";
    }
	remote string function SaveDowntime(required numeric id) { 
        
        if(arguments.id eq 0)   {
            sql_start = "INSERT INTO "
        }
        else    {
            sql_start = "UPDATE ";
        }
        end_start = "WHERE DowntimeId = #arguments.id#";
        query result="rt"  {
            echo("#sql_start# asset_downtime SET
                AssetLocationId=#val(form.AssetLocationId)#
            ");
			if(arguments.id eq 0){
                echo(",CreatedById       = ");    queryParam cfsqltype="cf_sql_int" value="#request.userinfo.userid#";
                echo(",CreatedDate       = ");    queryParam cfsqltype="cf_sql_timestamp" value="#now()#";
                echo(",DepartmentId      = ");    queryParam cfsqltype="cf_sql_int" value="#request.UserInfo.DepartmentId#";
                echo(",WorkingForId      = ");    queryParam cfsqltype="cf_sql_int" value="#request.UserInfo.WorkingForId#";
                echo(",OfficeLocationId  = ");    queryParam cfsqltype="cf_sql_int" value="#request.UserInfo.OfficeLocationId#";

			};
            echo(",DownTimeCause         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.DownTimeCause#";
            echo(",FailureReportId       = ");    queryParam cfsqltype="cf_sql_int" value="#form.FailureReportId#";
            echo(",EndPeriod             = ");    queryParam cfsqltype="cf_sql_timestamp" value="#form.EndPeriod#";
            echo(",StartPeriod           = ");    queryParam cfsqltype="cf_sql_timestamp" value="#form.StartPeriod#";
            echo(",Remark                = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Remark#";
            if(form.EndPeriod neq ""){
                echo(",Status            = ");    queryParam cfsqltype="cf_sql_varchar" value="Close";
            }
            if(arguments.id neq 0){
                echo("WHERE DowntimeId = #arguments.id#");
            }
        }
        var _id = arguments.id;
        if(arguments.id eq 0)    {
            _id = rt.GENERATED_KEY;
        }
            if(form.EndPeriod eq ""){
                i = application.com.Notice.SendEmail("fieldsuperintendent@#application.domain#","AssetGear Equipment Availibility","Hello, <p>This is to notify you that #form.Asset# has been flagged unavailable; <br/> Reason: #form.DownTimeCause# <br/> Downtime Date: #dateFormat(form.StartPeriod,"dd-mm-yyyy")# </p> Thank you")
            }else{
                i = application.com.Notice.SendEmail("fieldsuperintendent@#application.domain#","AssetGear Equipment Availibility","Hello, <p>This is to notify you that #form.Asset# is back online <br/></p> Thank you")
			}
        return "Report #arguments.id# was saved successfuly";
    }
    remote string function SaveAssetFailureReport(required numeric id) {

        var sql_start = sql_end = "";
        h = createobject('component','assetgear.com.awaf.util.helper').Init();
        /*if ((arguments.Status eq "Close") && (arguments.WorkDone eq "")){
          return "Report Not Close. Enter 'Repair Action' before you can close report";
          abort;
        }*/
        param name="form.Status" default="Open";
        param name="form.RootCause" default="";
        param name="form.OtherRootCause" default="";
        param name="form.DownTimeCosting" default="";
        param name="form.SupervisorComment" default="";
        param name="form.ResolvedDate" default="";
		param name="form.ActionTaken" default="";
		param name="form.WorkDone" default="";
		param name="form.PreventiveMeasure" default="";
		param name="form.SuspectedCause" default="";
		param name="form.ReportTitle" default="";
		param name="form.DescriptionOfSuspectedCause" default="";
		param name="form.ResolveTimeLine" default="";
		param name="form.ResolveStartTime" default="";
		param name="form.DownTimePeriod" default="";
		
        if ((form.Status eq "Close") && (form.ResolvedDate eq "")){
          return "Report Not Close. Enter 'Resolved Date' before you can close report";
          abort;
        }
		//if (form.SuspectedCause eq ""){return "Select suspected cause(s) of failure"; abort;}
        if(arguments.id eq 0)   {
            sql_start = "INSERT INTO "
        }
        else    {
            sql_start = "UPDATE ";
            end_start = "WHERE AssetFailureReportId=#arguments.id#";
        }
        b = "";
        if(arguments.id eq 0){ b = "//"};
        if (form.Status eq ""){Form.Status = "Open"};

        query result="rt"  {
            echo("#sql_start# asset_failure_report SET
				OfficeLocationId=#val(request.userinfo.OfficeLocationId)#,
				DepartmentId = #val(request.userinfo.DepartmentId)#
            ");
			if(arguments.id eq 0){
				echo(",CreatedByUserId         = ");    queryParam cfsqltype="cf_sql_int" value="#request.userinfo.userid#";
			};

            if(form.FailureOn eq "Fix Asset"){
            	echo(",AssetLocationId         = ");    queryParam cfsqltype="cf_sql_int" value="#form.AssetLocationId#";
            	echo(",ServiceDescription         = ");    queryParam cfsqltype="cf_sql_varchar" value="";
            }else{
            	echo(",AssetLocationId         = ");    queryParam cfsqltype="cf_sql_int" value="";
            	echo(",ServiceDescription         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.ServiceDescription#";
            }
            echo(",RootCause         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.RootCause#";
            echo(",OtherActionTaken         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.OtherActionTaken#";
            echo(",DownTimePeriod         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.DownTimePeriod#";
            echo(",ResolveTimeLine         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.ResolveTimeLine#";
            echo(",ResolveStartTime         = ");    queryParam cfsqltype="cf_sql_timestamp" value="#form.ResolveStartTime#";
            echo(",DescriptionOfSuspectedCause         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.DescriptionOfSuspectedCause#";
            echo(",OtherRootCause         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.OtherRootCause#";
            echo(",DownTimeCosting  = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.DownTimeCosting#";
            echo(",SupervisorComment = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.SupervisorComment#";
            echo(",ReportTitle = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.ReportTitle#";
            echo(",ResolvedDate  = ");    queryParam cfsqltype="cf_sql_timestamp" value="#form.ResolvedDate#";
            echo(",`Date`            = ");    queryParam cfsqltype="cf_sql_timestamp" value="#form.Date#";
            echo(",InitiatorsComment         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.InitiatorsComment#";
            echo(",ActionTaken       = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.ActionTaken#";
            echo(",FailureOn    = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.FailureOn#";
            echo(",PreventiveMeasure = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.PreventiveMeasure#";
            echo(",OtherPreventiveMeasure = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.OtherPreventiveMeasure#";
            echo(",RiskLevel = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.RiskLevel#";
            echo(",Serviceprovider = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Serviceprovider#";
            echo(",SuspectedCause = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.SuspectedCause#";
            echo(",WorkDone          = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.WorkDone#";
            echo(",OtherCauses         = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.OtherCauses#";
            echo(",Effect  = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Effect#";
            echo(",ReasonForDelay  = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.ReasonForDelay#";
            echo(",Recommendation  = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Recommentdation#";
            if(form.ResolvedDate eq ""){
            	echo(",Status = "); queryParam cfsqltype="cf_sql_varchar" value="#form.Status#";
            }
            else{
            	echo(",Status = "); queryParam cfsqltype="cf_sql_varchar" value="Close";
            }
            //echo(",Status  = ");    queryParam cfsqltype="cf_sql_varchar" value="#form.Status#";
            //if(val(form.WorkOrderId))   {
                //echo(",WorkOrderId   = #val(form.WorkOrderId )#");
            //}
            if(arguments.id)    {
                echo(" WHERE AssetFailureReportId=#arguments.id#");
            }
        }
        var _id = arguments.id;
        if(arguments.id eq 0)    {
            _id = rt.GENERATED_KEY;
        }
        h.SaveFromTempTable(form.IntegratIon,
				"failure_report_integration",
				"IntegrateTable,PK",
				"text0,int0",
                "IntegratIonId","AssetFailureReportId",_id)
                
        return "Report #_id# was saved successfuly";

    }
}
