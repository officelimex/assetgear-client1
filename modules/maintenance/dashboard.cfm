<style type="text/css">
	div.scrlx  {
		height: 200px;
		overflow-y: auto; }
	.grl{color:gray; font-style:italic;}
	
	
	.overlay {
	  position: fixed;
	  top: 0;
	  bottom: 0;
	  left: 0;
	  right: 0;
	  background: white;
	  transition: opacity 500ms;
	  visibility: hidden;
	  opacity: 0;
	  color:##FCFCFC !important
	}
	.overlay:target {
	  visibility: visible;
	  opacity: 1;
	}
	
	.popup {
	  margin: 70px auto;
	  padding: 20px;
	  background: ##fff;
	  border-radius: 5px;
	  width: 60%;
	  position: relative;
	  transition: all 5s ease-in-out;
	  color:##F3F1F1 !important
	}
	
	.popup h2 {
	  margin-top: 0;
	  color: ##FFFFFF !important;
	  font-family: Tahoma, Arial, sans-serif;
	  text-align:center
	}
	.popup .close {
	   position: absolute;
	  top: 20px;
	  right: 30px;
	  transition: all 200ms;
	  font-size: 30px;
	  font-weight: bold;
	  text-decoration: none;
	  color: #333;
	}
	.popup .close:hover {
	  color: ##06D85F;
	}
	.popup .content {
	  max-height: 30%;
	  overflow: auto;
	}
	
	@media screen and (max-width: 700px){
	  .box{
		width: 100%;
	  }
	  .popup{
		width: 100%;
	  }
	}
</style>

<cfoutput>
<cfimport taglib="../../assets/awaf/tags/xChart_1000/" prefix="c" />
<cfimport taglib="../../assets/awaf/tags/xChart_1001/" prefix="cjs" />
<cfimport taglib="../../assets/awaf/tags/xForm_1001/" prefix="f" />
<div class="container-fluid pad-top10">
    <div class="row-fluid">
      <div class="span12">
        <div class="well well-small">
          
          <span class="label label-success"><a class="button" style="color:##F5F5F5 !important" href="##popup1">Maintenance Report</a></span>
          <strong>&nbsp; | &nbsp;Open WO -</strong> 
          <cfif request.userinfo.role eq "FS">
            <cfquery name="qFSW">
              SELECT
              cd.`Name`, Count(w.WorkOrderId) PM,cd.DepartmentId
              FROM core_department AS cd
              INNER JOIN work_order AS w ON w.DepartmentId = cd.DepartmentId
              WHERE w.`Status` = "Open" 
              GROUP BY cd.`Name`
            </cfquery>
            <cfloop query="qFSW">#Name# <span class="badge badge-inverse"><a href="modules/maintenance/workorder/print_open_wo.cfm?departmentid=#DepartmentId#&status=open" target="_blank" style="color:##F8F5F5">#PM#</a></span> &nbsp;</cfloop>
          <cfelseif  request.userinfo.role eq "MS">
            <cfquery name="qFSW">
              SELECT
              cd.`Name`, Count(w.WorkOrderId) PM,cd.UnitId
              FROM core_unit AS cd
              INNER JOIN work_order AS w ON w.UnitId = cd.UnitId
              WHERE w.`Status` = "Open" GROUP BY cd.`Name`
            </cfquery>
            <cfloop query="qFSW">#Name# <span class="badge badge-inverse"><a href="modules/maintenance/workorder/print_open_wo.cfm?unitid=#request.userinfo.unitid#&status=open" target="_blank" style="color:##F8F5F5">#PM#</a></span> &nbsp;</cfloop>
          <cfelse>
            <cfquery name="qFSW">
              SELECT COUNT(WorkOrderId) AS i FROM work_order WHERE DepartmentId = #request.userinfo.DepartmentId# AND `Status` = "Open"
            </cfquery>
            <cfquery name="qU">
              SELECT COUNT(WorkOrderId) AS i FROM work_order WHERE CreatedByUserId = #request.userinfo.UserId# AND `Status` = "Open"
            </cfquery>
            Open W.O. Created By You: <span class="badge badge-inverse"><a href="modules/maintenance/workorder/print_open_wo.cfm?userid=#request.userinfo.userid#&status=open" target="_blank" style="color:##F8F5F5">#qU.i#</a></span>&nbsp;&nbsp; | &nbsp;&nbsp;
            Total Open Departmental W.O: <span class="badge badge-inverse"><a href="modules/maintenance/workorder/print_open_wo.cfm?departmentid=#request.userinfo.departmentid#&status=open" target="_blank" style="color:##F8F5F5">#qFSW.i#</a></span>&nbsp;&nbsp; | &nbsp;&nbsp;
            Open Service Request: <span class="badge badge-inverse">.</span>
          </cfif>

        </div>
      </div>
    </div>
    <div class="row-fluid">
      <div class="span6">
      
      
      <div id="popup1" class="overlay">
            <div class="popup">
                <h2>Maintenance Report Date Range</h2><a class="close btn" href="##">X</a>
                <br>
                <div class="content">
                    
                    <f:Form id="frm" action="modules/maintenance/workorder/print_mtnce_report.cfm" target="_blank"> 
                    
                        <table border="0" width="100%">
                          <tr>
                            <td width="50%" valign="top">
                              <cfset s_date = dateformat(now(),"yyyy/mm/01")/>
                              <cfset e_date = dateformat(s_date,"yyyy/mm/" & daysInMonth(s_date))/>
                              <f:DatePicker name="StartDate" label="From" required value="#s_date#"/>
                              <f:DatePicker name="EndDate" label="To" value="#e_date#" required/>
                              <f:TextBox name="ExchangeRate" label="Exchange Rate" value="900" class="span5" required/>
                            </td>
                            <td width="50%" valign="top" class="horz-div">
                              <cfset dept = application.com.User.getDepartments()/><cfset unit = application.com.User.getUnit()/>
                              <f:Select name="DepartmentId" label="Department" required ListValue="#Valuelist(dept.DepartmentId)#" ListDisplay="#Valuelist(dept.Name)#" Selected="16" />
                              <f:Select name="Class" label="Asset Class"  ListValue="Critical,Major,Minior" Selected=""/>
                              <!---<f:CheckBox name="Status" ListDisplay="Close,Open,Suspended,Parts on Hold"  ListValue='"Close","Open","Suspended","Parts on Hold"' selected='"Close"' inline showlabel label="Calculate Maintanance Cost For" />     --->                           
                            </td> 
                          </tr>
                        </table> 
                    
                        <f:ButtonGroup>
                          <f:Button value="Show Report" class="btn-primary" IsNewWindow/>
                        </f:ButtonGroup>
                    
                    </f:Form>   
					
                </div>
            </div>
       </div>

<cfquery name="qwot">
	#application.com.WorkOrder.WORK_ORDER_SQL#
    WHERE wo.Status <> "Close"
    	AND DateOpened = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
        <!---<cfif !(request.IsHost or request.IsAdmin)>
        	AND wo.DepartmentId = <cfqueryparam value="#request.userinfo.departmentid#" cfsqltype="cf_sql_integer"/>
        </cfif>--->
		AND wo.WorkingForId = <cfqueryparam cfsqltype="cf_sql_int" value="#request.userinfo.WorkingForId#"/>
</cfquery>

<cfquery name="qAL" cachedwithin="#createtimespan(0,6,0,0)#">
    SELECT
      l.Name Location,
      al.AssetLocationId
    FROM asset_location al
    INNER JOIN location l ON l.LocationId = al.LocationId
</cfquery>


<cfscript>
  private string function getAssetLocation(required string ids)  {

    query name="q1" dbtype="query"  {
      echo('SELECT Location FROM qAL WHERE AssetLocationId IN (' & arguments.ids & ')');
    }
    return q1.Location;
  }

	private string function getAssetLocationdetail(required integer assetids){
		query name="qA1" dbtype="query" {
			echo('SELECT LocDescription FROM asset_location WHERE AssetId = ' & arguments.assetids );
		}
		return qA1.LocDescription;

	}
</cfscript>

<p><h4>Today's work order &nbsp;<small> &mdash; #qwot.recordcount#</small></h4></p>
<div class="scrlx">
<table border="0" class="table table-condensed table-hover table-striped">
  <tbody class="scrollContent">
  <cfloop query="qwot">
			<cfquery Name="qA1">
				SELECT LocDescription FROM asset_location WHERE AssetId = #qwot.AssetId#
			</cfquery>
			<cfif qA1.LocDescription neq "">
				<cfset locdes = "/ " & qA1.LocDescription>
			<cfelse>
				<cfset locdes = ""/>
			</cfif>

		  <tr>
		    <td><a href="modules/maintenance/workorder/print_workorder.cfm?id=#qwot.WorkOrderId#" target="_blank">#qwot.WorkOrderId#</a></td>
		    <td>#qwot.Description# <span style="color:gray">on</span> <em>#qwot.Asset#</em> <span style="color:gray">@</span> <em>#getAssetLocation(qwot.AssetLocationIds)# #locdes#</em>&nbsp;
		    	<cfif qwot.UnitId eq 0>
		        	<span class="label #getLabelColor(val(qwot.DepartmentId))#">#qwot.Department#</span>
		        <cfelse>
		        	<span class="label #getLabelColor(val(qwot.UnitId))#">#qwot.Unit#</span>
		        </cfif>

		     <span class="grl">#qwot.Status#</span></td>
		  </tr>
  </cfloop>
  </tbody>
</table>
</div>

<!---Open work order till date {service request}--->
<cfquery name="qwotd">
	#application.com.WorkOrder.WORK_ORDER_SQL#
    WHERE wo.Status NOT IN ("Close","Suspended","Declined")
    	AND wo.ServiceRequestId IS NOT NULL 
        AND wo.PMTaskId IS NULL
   ORDER BY DateOpened DESC
</cfquery>
<p><h4>Service Request &nbsp;<small> &mdash; #qwotd.recordcount#</small></h4></p>
<div class="scrlx">
<table border="0" class="table table-condensed table-hover table-striped">
  <tbody class="scrollContent">
  <cfloop query="qwotd">
  <tr>
    <td><a href="modules/maintenance/workorder/print_workorder.cfm?id=#qwotd.WorkOrderId#" target="_blank">#qwotd.WorkOrderId#</a></td>
    <td>#qwotd.Description# <span style="color:gray">on</span> <em>#qwotd.Asset#</em> <span style="color:gray">@</span> <em>#getAssetLocation(qwotd.AssetLocationIds)#</em>&nbsp;
    	<cfif VAL(qwotd.UnitId) eq 0>
        	<span class="label #getLabelColor(val(qwotd.DepartmentId))#">#qwotd.Department#</span>
        <cfelse>
        	<span class="label #getLabelColor(val(qwotd.UnitId))#">#qwotd.Unit#</span>
        </cfif>  <span class="grl">#qwotd.Status#</span></td>
    <td nowrap="nowrap">#dateformat(qwotd.DateOpened,'dd-mmm-yy')#</td>
  </tr>
  </cfloop>
  </tbody>
</table>
</div>


<!-------->
<cfset startd = dateformat(now(),"yyyy/mm/") & "1">
<cfset endd = now()/>

<cfquery name="qC1" cachedwithin="#CreateTime(1,0,0)#">
	SELECT
    	DATE_FORMAT(DateOpened,'%d') MonthOpen, DATE_FORMAT(DateOpened,'%d') mc, COUNT(WorkOrderId) WCount
    FROM work_order
    WHERE WorkClassId = 10
        AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
        AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
    GROUP BY MonthOpen
    ORDER BY mc
</cfquery>
<cfquery name="qC2" cachedwithin="#CreateTime(1,0,0)#">
	SELECT
    	DATE_FORMAT(DateOpened,'%d') MonthOpen, DATE_FORMAT(DateOpened,'%d') mc, COUNT(WorkOrderId) WCount
    FROM work_order
    WHERE WorkClassId = 3
        AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
        AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
    GROUP BY MonthOpen
    ORDER BY mc
</cfquery>
<cfquery name="qC3" cachedwithin="#CreateTime(1,0,0)#">
	SELECT
    	DATE_FORMAT(DateOpened,'%d') MonthOpen, DATE_FORMAT(DateOpened,'%d') mc, COUNT(WorkOrderId) WCount
    FROM work_order
    WHERE WorkClassId NOT IN (3,10)
        AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
        AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
    GROUP BY MonthOpen
    ORDER BY mc
</cfquery>

<br>

<cjs:Chart caption="#dateformat(now(),'mmmm')# Work Order" width="100%" height="200">

  <cjs:Data query="#qC1#" y="WCount" label="mc" type="column" name="PM task" showlegend toolTip="Day {label}<br/> {y} {name}"/>
  <cjs:Data query="#qC2#" y="WCount" label="mc" type="column" name="Corrective task" showlegend toolTip="Day {label}<br/> {y} {name}"/>
  <cjs:Data query="#qC3#" y="WCount" label="mc" type="column" name="Other task" showlegend toolTip="Day {label}<br/> {y} {name}"/>

</cjs:Chart>


      </div>
      <div class="span6">
            <!---Open work order till date --->
<cfquery name="qwotd">
	#application.com.WorkOrder.WORK_ORDER_SQL#
    WHERE wo.Status = "Open"
    	AND DateOpened < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>
        AND wo.ServiceRequestId IS NULL
		<cfif request.userinfo.role neq "FS">
			AND wo.DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
		</cfif>
   ORDER BY DateOpened DESC
</cfquery>

<p><h4>Open work order till date &nbsp;<small> &mdash; #qwotd.recordcount#</small></h4></p>
<div class="scrlx" style="height:400px !important;">
<table border="0" class="table table-condensed table-hover table-striped">
  <tbody class="scrollContent">
  <cfloop query="qwotd">
		<cfquery Name="qA2">
			SELECT LocDescription FROM asset_location WHERE AssetId = #qwotd.AssetId#
		</cfquery>
		<cfif qA2.LocDescription neq "">
			<cfset locdes2 = "/ " & qA2.LocDescription>
		<cfelse>
			<cfset locdes2 = ""/>
		</cfif>
  <tr>
    <td><a href="modules/maintenance/workorder/print_workorder.cfm?id=#qwotd.WorkOrderId#" target="_blank">#qwotd.WorkOrderId#</a></td>
    <td>#qwotd.Description# <span style="color:gray">on</span> <em>#qwotd.Asset#</em> <span style="color:gray">@</span> <em>#getAssetLocation(qwotd.AssetLocationIds)# #locdes2#</em> &nbsp;
    	<cfif VAL(qwotd.UnitId) eq 0>
        	<span class="label #getLabelColor(val(qwotd.DepartmentId))#">#qwotd.Department#</span>
        <cfelse>
        	<span class="label #getLabelColor(val(qwotd.UnitId))#">#qwotd.Unit#</span>
        </cfif>  <span class="grl">#qwotd.Status#</span></td>
    <td nowrap="nowrap">#dateformat(qwotd.DateOpened,'dd-mmm-yy')#</td>
  </tr>
  </cfloop>
  </tbody>
</table>
</div><br/>



<!-----============------>
<cfquery name="qTWO" cachedwithin="#CreateTime(1,0,0)#">
	SELECT
    	COUNT(wo.WorkOrderId) Total
  FROM work_order wo
  WHERE DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
</cfquery>
<cfquery name="qC3" cachedwithin="#CreateTime(1,0,0)#">
	SELECT
    DATE_FORMAT(wo.DateOpened,'%d') MonthOpen, FORMAT(COUNT(wo.WorkOrderId)/#qTWO.Total#*100,1) WCount ,
    jc.Class WorkClass, wo.WorkClassId
  FROM work_order wo
  INNER JOIN job_class jc ON jc.JobClassId = wo.WorkClassId
  WHERE DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/>
  -- GROUP BY wo.WorkClassId
  GROUP BY wo.WorkClassId, MonthOpen, WorkClass
</cfquery>
<br/>
<cjs:Chart width="100%" height="300">
  <cjs:Data type="doughnut" query="#qC3#" label="WorkClass" y="WCount" toolTip="{label}: {y}%"/>
</cjs:Chart>
</div>
	</div>
   <!--- <div class="row-fluid">
    	<!---<div class="span6">



        </div>--->

        <div class="span6" align="center">

        </div>
	</div>--->

</div>

<cffunction name="getLabelColor" access="private" returntype="string">
	<cfargument name="id" required="yes" type="numeric"/>

    <cfswitch expression="#arguments.id#">
    	<cfcase value="1"><cfset t = " label-warning"/></cfcase>
        <cfcase value="2"><cfset t = " label-important"/></cfcase>
        <cfcase value="3"><cfset t = " label-info"/></cfcase>
        <cfcase value="16"><cfset t = " label-inverse"/></cfcase>
        <cfcase value="7"><cfset t = " label-success"/></cfcase>
        <cfdefaultcase><cfset t = ""/></cfdefaultcase>
    </cfswitch>

    <cfreturn t/>
</cffunction>

</cfoutput>
