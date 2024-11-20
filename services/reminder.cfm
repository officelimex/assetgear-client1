<cfquery name="qWs">
  SELECT 
    wo.SupervisedByUserId, wo.WorkOrderId, wo.DepartmentId,
      wo.Description,
      wo.SupervisedApprovedDate, wo.Status2,
    u.Email,
    cb.Email cb_Email
  FROM work_order wo
  INNER JOIN core_user u ON u.UserId = wo.SupervisedByUserId
  LEFT  JOIN core_user cb ON cb.UserId = wo.CreatedByUserId
  WHERE wo.Status2 IN ("Sent to Supervisor","Sent to FS","Sent to Materials")
    AND wo.Status IN ("Open")
  ORDER BY wo.WorkOrderId DESC
  LIMIT 0, 10
</cfquery>

<cfset application.com.Notice = createobject('component','assetgear.com.awaf.ams.Notice').init()/>
 
<cfoutput>
  
  <cfscript>
    _now = now()
    workStartTime = createDateTime(year(_now), month(_now), day(_now), 7, 0, 0); // 7:00 AM
    workEndTime = createDateTime(year(_now), month(_now), day(_now), 17, 0, 0); // 5:00 PM
    
    // Get the current date and time
    currentTime = _now;
    
    // Check if the current time is within working hours
    if (currentTime >= workStartTime && currentTime <= workEndTime) {
      for(qW in qWs)  {
        switch (qW.Status2) {
          case "Sent to Supervisor":

            if(val(qW.SupervisedByUserId))	{
              application.com.Notice.SendEmail(
                to			: qW.Email,
                cc  		: qW.cb_Email,
                subject	: "Work Order ###qW.WorkOrderId# :: Auto Reminder",
                msg 		: "
                  Hello, 
                  <p>
                    Work Order ###qW.WorkOrderId# has been sent to you for approval <br/>
                    ==================<br/>
                    #qW.Description#<br/>
                    ==================<br/>
                  </p> 
                  Thank you
                "
              )
            }       
          break;

          case "Sent to FS":

            if(val(qW.SupervisedByUserId))	{
              application.com.Notice.SendEmail(
                to			: "fieldsuperintendent@#application.domain#",
                subject	: "Work Order ###qW.WorkOrderId# :: Auto Reminder",
                msg 		: "
                  Hello, 
                  <p>
                    Work Order ###qW.WorkOrderId# has been sent to you for approval <br/>
                    ==================<br/>
                    #qW.Description#<br/>
                    ==================<br/>
                  </p> 
                  Thank you
                "
              )
            }       
          break;

          case "Sent to Materials":

            if(val(qW.SupervisedByUserId))	{
              application.com.Notice.SendEmail(
                to 			: "materials-logistics@#application.domain#",
                cc			: qW.cb_Email,
                subject	: "Work Order ###qW.WorkOrderId# Requires Approval :: Auto Reminder",
                msg 		: "
                  Hello, 
                  <p>
                    Work Order ###qW.WorkOrderId# has been sent to you for approval <br/>
                    ==================<br/>
                    #qW.Description#<br/>
                    ==================<br/>
                  </p> 
                  Thank you
                "
              )
            }       
          break;          
        }
      }
    } 

  </cfscript>


</cfoutput>