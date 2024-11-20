component  {

    remote string function closeServiceRequest(required numeric id) {

        // check if work order is not already created an opened for this asset
        query name="local.qI" {
            echo('UPDATE service_request
            SET `Status` = "Close", ClosedByUserId = #request.userinfo.UserId#,
            ClosedDate = #now()# 
            WHERE ServiceRequestId=#arguments.id#');
        }

        return "Service Request #arguments.id# was closed.";
    }


    }
