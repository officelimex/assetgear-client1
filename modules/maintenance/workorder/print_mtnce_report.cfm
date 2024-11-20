<cfset EXCHANGE_RATE = 900/><!---#Form.ExchangeRate#/--->
<cfset HOURLY_RATE = 50/>
<cfparam name="url.unitid" default="1,2,3,4" />
<cfquery name="qUnit">
	SELECT * FROM core_unit WHERE DepartmentId = #val(form.DepartmentId)#
</cfquery>
 
<cfset url.unitid = qUnit.columnData("UnitId").toList()/>
<cfif url.unitid == "">
	<cfset url.unitid = "0"/>
</cfif>
 
<cfif month(now()) eq 1>
	<cfparam name="url.m" default="12"/>
<cfelse>
	<cfparam name="url.m" default="#month(now())-1#"/>
</cfif>

<cfset dmonth = url.m/>

<cfif month(now()) eq 1>
	<cfset dyear = year(now()) - 1 />
<cfelse>
	<cfset dyear = year(now()) />
</cfif>

<cfset dpart = dyear & "/" & dmonth/>
<cfset startd =  "#DateFormat(form.StartDate,'yyyy-mm-dd')#">
<cfset dinmonth = DaysInMonth(startd)/>
<cfset endd =  "#DateFormat(form.EndDate,'yyyy-mm-dd')#">
		  
<cfset ystart = year(startd) & "/01/01"/>
<cfset mtnid = url.unitid /> 

<cfif form.Class eq "">
    <cfset form.Class = "All"/>
    <cfset qselect = ""/>
<cfelse>
    <cfset qselect = ' AND a.Class = "#form.Class#"'/>
</cfif>

<cfquery name="qDepartment">
    SELECT * FROM core_department WHERE DepartmentId = #form.departmentid#
</cfquery>
<cfquery name="qWO" cachedwithin="#createTimespan(1,0,0,0)#">
	SELECT 
		-- sum(if(isnull(wi.ItemId) , wi.UnitPrice * wi.Quantity, if(wt.Currency = "USD",#EXCHANGE_RATE# * wt.UnitPrice * wi.Quantity ,wt.UnitPrice * wi.Quantity ))) AS TCOST,							
		SUM(cn.Cost) AS ContractCost,
		wo.TotalCost,
		wo.ManHours,
		wo.*,wo.Status as WOStatus, 
		a.Description Asset, a.Class AssetClass, 
		ac.Name AssetCategory, 
		jc.Class JobClass, 
		d.Name Department, 
		ut.Name Unit, 
		CONCAT(cu.Surname," ",cu.OtherNames) ClosedBy, 
		CONCAT(su.Surname," ",su.OtherNames) SupervisedBy, 
		CONCAT(rb.Surname," ",rb.OtherNames) RequestBy 
	FROM work_order wo 
	INNER JOIN `core_department` d ON d.DepartmentId = wo.DepartmentId 
	LEFT JOIN `work_order_item` wi ON wi.WorkOrderId = wo.WorkOrderId
	LEFT JOIN `contract` cn ON wo.WorkOrderId=  cn.WorkOrderId
	LEFT JOIN whs_item AS wt ON wt.ItemId = wi.ItemId
	LEFT JOIN `core_unit` ut ON ut.UnitId = wo.UnitId 
	INNER JOIN `asset` a ON a.AssetId = wo.AssetId 
	LEFT JOIN `asset_category` ac ON ac.AssetCategoryId = a.AssetCategoryId 
	INNER JOIN `job_class` jc ON jc.JobClassId = wo.WorkClassId 
	LEFT JOIN `service_request` sr ON sr.ServiceRequestId = wo.ServiceRequestId 
	LEFT JOIN `core_user` rb ON rb.UserId = sr.RequestByUserId 
	-- users 
	LEFT JOIN `core_user` cu ON cu.UserId = wo.ClosedByUserId 
	LEFT JOIN `core_user` su ON su.UserId = wo.SupervisedByUserId 
    WHERE wo.UnitId IN (#mtnid#) AND wo.Status <> "Decline" 
    AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
    AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/> #qselect#
	GROUP BY wo.WorkOrderId
</cfquery>
<cfquery name="qCt" cachedwithin="#createTimespan(1,0,0,0)#">
	SELECT 
	c.WorkOrderId, wo.UnitId, wo.DepartmentId,if(c.Currency = "USD", #EXCHANGE_RATE# * c.Cost, c.Cost ) as Cost
	FROM `contract` c
	INNER JOIN work_order wo ON wo.WorkOrderId = c.WorkOrderId
	INNER JOIN `asset` a ON a.AssetId = wo.AssetId 
	WHERE wo.UnitId IN (#mtnid#) AND wo.Status = "Close" 
	AND DateOpened >= <cfqueryparam cfsqltype="cf_sql_date" value="#startd#"/>
	AND DateOpened <= <cfqueryparam cfsqltype="cf_sql_date" value="#endd#"/> #qselect#
	GROUP BY wo.WorkOrderId
</cfquery>

<cfquery name="qWC" cachedwithin="#createTimespan(1,0,0,0)#">
	SELECT *
	FROM job_class
</cfquery>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Maintenance Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <link rel="stylesheet" type="text/css" href="bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="font-awesome/css/font-awesome.min.css" />

    <script type="text/javascript" src="js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
<cfset request.letterhead.title="#ucase(qDepartment.Name)#  DEPARTMENT"/>
<cfset request.letterhead.Id=""/>
<!---cfset request.letterhead.date = "Period : #MonthAsString(dmonth)# - #dyear#"/--->
<cfset request.letterhead.date = ""/>
<cfset request.letterhead.noline = true/>

<div class="container">
<cfinclude template="../../../include/letter_head.cfm"/>
<cfoutput>
    <div class="page-header">
        <div class="row">
            <div class="col-md-6"><h4>REPORT ON: <small> #ucase(form.Class)# ASSET</small></h4></div>
            <div class="col-md-6"><h4 class="text-right"><small><strong>PERIOD:</strong> #ucase(dateformat(startd,"dd-mmm-yyyy"))# <strong>TO</strong> #ucase(dateformat(endd,"dd-mmm-yyyy"))#</small></h4></div>
        </div>
    </div>

    <!-- Simple Invoice - START -->
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-primary">
                    <div class="panel-heading">
											<h3 class="text-center"><strong>Cost of Maintenance<small style="color:aliceblue"><sup> - For Only Closed Jobs</sup></small></strong></h3>
                    </div>
                    <div class="panel-body">
											<div class="table-responsive">
												<table class="table table-condensed table-hover">
													<thead>
														<tr>
															<th><strong>Work Class</strong></th>
															<cfloop list="#url.unitid#" item="uid">
																<cfset "c#uid#" = []/> 
																<cfquery name="_qUnit">
																	SELECT * FROM core_unit WHERE UnitId = #uid#
																</cfquery>
																<th class="text-right" title="#Class#"><strong>#_qUnit.Name#</strong></th>
															</cfloop>
															<th class="text-right"><strong>Subtotal</strong></th>
														</tr>
													</thead>
                          <tbody>
													<cfset stotal = 0/>
													
													<cfloop query="qWC"> 
														<tr>
															<td><strong>#qWC.Class#</strong></td>
															<cfset s = 0/>
															<cfloop list="#url.unitid#" item="uid">
																<cfset v = getCost(uid, qWC.JobClassId).totalCost/>
																<cfset s = s + v/>
																<cfset arrayAppend(evaluate("c#uid#"), v)/>
																<td class="text-right">#numberFormat(v,"9,999.99")#</td>
															</cfloop>
															<td class="text-right"> #numberFormat(s, '9,999.99')#</td> 
														</tr>
													</cfloop>
													<tr>
														<cfset x5 = []/>
														<td class="highrow" text-left>Subtotal</td>
														<cfloop list="#url.unitid#" index="uid">
															<cfset v = getcost(uid, 0).totalCost/>
															<cfset arrayAppend(x5, v)/>
															<!---<cfset v = arraySum(evaluate("c#uid#"))/>--->
															<cfset stotal = stotal + v/>
															<td class="highrow text-right">
															<strong> ₦ #numberFormat(v,"9,999.99")#</strong></td>
														</cfloop>
														<td class="highrow text-right">₦ <strong>#numberFormat(stotal,"9,999.99")#</strong></td>
													</tr>
												</tbody>
											</table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
		
			<div class="row">
        <div class="col-xs-12">
				<cfinclude template="../../dashboard/index.cfm" />
			</div>
		</div>
	</div>
		<br>
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                
                <div class="row">
                    <div class="col-xs-12 col-md-12 col-lg-12 pull-left">
                        <div class="row">
                            <div class="col-md-6">
                              <h5 ><strong>JOB COUNT <small>(<i class="fa fa-thumbs-up"></i>=Open W.O; <i class="fa fa-thumbs-down"></i>=Closed Out; <i class="fa fa-tags"></i>=Suspended; <i class="fa fa-gears"></i>=Part On Hold)</small> </strong></h5>
                            </div>
                            <div class="col-md-6">
								
															<h5 class="pull-right">
																Total Jobs <span class="badge">#qWO.Recordcount#</span>
																&nbsp;&nbsp;Open <span class="badge alert-info">#getstatus().Open#</span>
																&nbsp;&nbsp;Close <span class="badge alert-success">#getstatus().Close#</span>
																&nbsp;&nbsp;Suspended <span class="badge alert-danger">#getstatus().Suspend#</span>
																&nbsp;&nbsp;Parts on Hold <span class="badge alert-warning">#getstatus().Parts#</span>
															</h5>
                            </div>
                        </div>
                    </div>
                   
                   <cfloop list="#url.unitid#" index="name">
											<cfquery name="_qUnit">
													SELECT * FROM core_unit WHERE UnitId = #name#
											</cfquery>
											<cfquery name="qTWO" dbtype="query" result="rt">
													SELECT * FROM qWO WHERE UnitId = #name#
											</cfquery>
											<div class="col-xs-12 col-md-3 col-lg-3 pull-left">
												<div class="panel panel-primary height">
													<div class="panel-heading">#_qUnit.Name# Unit</div>
													<div class="panel-body">
														<table id="exportTable" class="table table-condense table-hover" stlye style="font-size:10px !important">
																<thead>
																	<tr>
																		<th class="text-right"></th>
																		<th class="text-right"><i class="fa fa-thumbs-up"></i></th>
																		<th class="text-right"><i class="fa fa-thumbs-down"></i></th>
																		<th class="text-right"><i class="fa fa-tags"></i></th>
																		<th class="text-right"><i class="fa fa-gears"></i></th>
																		<th class="text-right"></th>
																	</tr>
																</thead>
																<tbody>
																		<!--- Unit, Class, Status --->
																		<!--- 3 = CM; 10 = PM; Part on hold, Suspended, CLose, Open--->
																		<tr>
																				<td>CM</td>
																				<cfset cm1 = getCount(Name,3,"Open")/>
																				<cfset cm2 = getCount(Name,3,"Close")/>
																				<cfset cm3 = getCount(Name,3,"Suspended")/>
																				<cfset cm4 = getCount(Name,3,"Part on hold")/>
																				<td class="text-right">#cm1#</td>
																				<td class="text-right">#cm2#</td>
																				<td class="text-right">#cm3#</td>
																				<td class="text-right">#cm4#</td>
																				<td class="text-right">#cm1+cm2+cm3+cm4#</td>
																		</tr>
																		<tr>
																				<td>PM</td>
																				<cfset j = getCount(Name,10,"Open") + getCount(Name,10,"Close") + getCount(Name,10,"Suspended") + getCount(Name,10,"Part on hold") />
																				<td class="text-right">#getCount(Name,10,"Open")#</td>
																				<td class="text-right">#getCount(Name,10,"Close")#</td>
																				<td class="text-right">#getCount(Name,10,"Suspended")#</td>
																				<td class="text-right">#getCount(Name,10,"Part on hold")#</td>
																				<td class="text-right">#j#</td>

																		</tr>
																		<tr>
																				<td>OT</td>
																				<cfset a = getCount(Name,0,"Open") + getCount(Name,0,"Close") + getCount(Name,0,"Suspended") + getCount(Name,0,"Part on hold") />
																				<td class="text-right">#getCount(Name,0,"Open")#</td>
																				<td class="text-right">#getCount(Name,0,"Close")#</td>
																				<td class="text-right">#getCount(Name,0,"Suspended")#</td>
																				<td class="text-right">#getCount(Name,0,"Part on hold")#</td>
																				<td class="text-right">#a#</td>

																		</tr>
																</tbody>
																<tfoot>
																		<tr>
																			<td colspan="5" class="text-right">Total</td>
																			<td colspan="1" class="text-right">#qTWO.Recordcount#</td>
																		</tr>
																</tfoot>
														</table>
													</div>
												</div>
											</div>
                    </cfloop>
                </div>
            </div>
        </div>

        <div class="row">
					<div class="col-md-12">
						<div class="panel panel-default">
							<div class="panel-heading">
								<h3 class="text-center"><strong>Jobs Performance</strong></h3>
							</div>
							<br>

							<table class="table table-condensed table-hover">
								<cfloop list="#url.unitid#" index="name">
									<cfquery name="_qUnit">
										SELECT * FROM core_unit WHERE UnitId = #name#
									</cfquery>
									<cfset vl = round(getper(name).percount) />
									
									<cfset t = "">
									<cfif name == "1"><cfset t = "warning"/></cfif>
									<cfif name == "2"><cfset t = "important"/></cfif>
									<cfif name == "3"><cfset t = "info"/></cfif>
									<cfif name == "16"><cfset t = "inverse"/></cfif>
									<cfif name == "4"><cfset t = "success"/></cfif>
									<tr>
										<td width="10%" valign="top">
											<strong>#_qUnit.Name#</strong><br>
											<sup class="text-primary">
												<small> &nbsp;&nbsp; #round(getper(name).closeCount)# of #round(getper(name).allCount)# Done</small>
											</sup>
										</td>
										<td valign="middle">
											<div class="table-responsive">
												<div class="progress">
													<div class="progress-bar progress-bar-#t# progress-bar-striped" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100" style="width: #val(getper(name).percount)#%">
														<span style="color: white;">#round(getper(name).percount)#% Complete </span>
													</div>
													<span class="progress-type"></span>
												</div>
											</div>
										</td>
									</tr>
								</cfloop>
							</table>
								
						</div>
					</div>
        </div>

    </div>
   
    <cffunction name="getCost" access="private" returntype="struct">
			<cfargument name="uid" required="yes" type="numeric"/>
			<cfargument name="cid" required="yes" type="numeric"/>

			<cfset l = {} />
<!--- 			<cfset st = "" />
			
			<cfif arguments.cid eq 3>
				<cfset st = "AND WorkClassId = 3" />
			<cfelseif  arguments.cid eq 10>
				<cfset st = "AND WorkClassId = 10" />
			<cfelseif (arguments.cid neq 3) && (arguments.cid neq 10)>
				<cfset st = "AND WorkClassId <> 10 AND WorkClassId <> 3" />
			</cfif> --->
				
			<cfquery name="qOpen" dbtype="query">
				SELECT SUM(TotalCost) TotalCost, SUM(ManHours) ManHours 
				FROM qWO 
				WHERE Status IN ('Close') AND UnitId = #arguments.uid# <cfif arguments.cid>AND WorkClassId = #arguments.cid#</cfif>
			</cfquery>
			<cfquery name="q" dbtype="query">
				SELECT SUM(Cost) AS c FROM qCt WHERE UnitId = #arguments.uid#
			</cfquery>
				
			<cfset l.totalCost = val(qOpen.TotalCost) />
			<cfset l.totalConCost = val(q.c) />
			<cfset l.totalManHour= val(qOpen.ManHours) />
				
			<cfreturn l />
		</cffunction>
		
	<cffunction name="getstatus" access="private" returntype="struct">
		<cfset l = structNew() />
		<cfquery name="qOpen" dbtype="query">
			SELECT COUNT(WorkOrderId) AS oWO FROM qWO WHERE Status = 'Open'
		</cfquery>
		<cfquery name="qClose" dbtype="query">
			SELECT COUNT(WorkOrderId) AS oWO FROM qWO WHERE Status = 'Close'
		</cfquery>
		<cfquery name="qS" dbtype="query">
			SELECT COUNT(WorkOrderId) AS oWO FROM qWO WHERE Status = 'Suspended'
		</cfquery>
		<cfquery name="qP" dbtype="query">
			SELECT COUNT(WorkOrderId) AS oWO FROM qWO WHERE Status = 'Part On Hold'
		</cfquery>
		<cfset l.Open = val(qOpen.oWO) />
		<cfset l.Close = val(qClose.oWO) />
		<cfset l.Suspend = val(qS.oWO) />
		<cfset l.Parts = val(qP.oWO) />
		<cfreturn l />
	</cffunction>

  <cffunction name="getper" access="private" returntype="struct">
		<cfargument name="id" required="yes" type="numeric"/>
		<cfset l = structNew() />
		<cfquery name="qall" dbtype="query">
			SELECT COUNT(WorkOrderId) AS allCount FROM qWO WHERE UnitId = #arguments.id#
		</cfquery>
		<cfquery name="qallClose" dbtype="query">
			SELECT COUNT(WorkOrderId) AS allCount FROM qWO WHERE UnitId = #arguments.id# AND Status = 'Close'
		</cfquery>
		
		<cfset l.allCount = val(qall.allCount) />
		<cfset l.closeCount = val(qallClose.allCount) />
		<cfset l.perCount = 0 />
		<cfif val(qall.allCount) neq 0>  
		    <cfset l.perCount = (val(qallClose.allCount)*100)/val(qall.allCount) />
		</cfif>
		
		<cfreturn l />
	</cffunction>
    
	<cffunction name="getcount" access="private" returntype="string">
        <cfargument name="u" required="yes" type="numeric"/>
        <cfargument name="cl" required="no" type="numeric"/> <!--- 3 = CM; 10 = PM; Part on hold, Suspended, CLose, Open--->
        <cfargument name="st" required="no" type="string"/>
        
        <cfset qcl = "" />
        <cfset qu = "" />
        <cfset qst = "" />

        <cfif  arguments.cl eq 0>
            <cfset qcl = ' WorkClassId <> 3 AND WorkClassId <> 10 '/>
        <cfelse>
            <cfset qcl = ' WorkClassId = #arguments.cl# ' />
        </cfif>

        <cfif arguments.u neq 0>
            <cfset qu = ' UnitId = #arguments.u# ' />
        </cfif>

        <cfif arguments.st neq "all">
            <cfset qst =  "WOStatus = ""#arguments.st#""" />
        </cfif>

        <cfset acl = ""/>
        <cfset ast = arguments.st/>
        <cfset au = ""/>

        <cfif arguments.cl neq ""> <cfset acl = " AND "/></cfif>
        <cfif arguments.st eq "All"> <cfset ast = """Open"",""Close"""/></cfif>
        <cfif arguments.u neq ""> <cfset au = " AND "/></cfif>

        <cfquery name="q" dbtype="query">
            SELECT COUNT(WorkOrderId) AS tSum FROM qWO WHERE WorkingForId = 1 AND Status ='#arguments.st#' #au# #qu# #acl# #qcl#
        </cfquery>

        <cfreturn val(q.tSum)/>
    </cffunction>
</cfoutput>

<style>
.height {
    min-height: 200px;
}

.icon {
    font-size: 47px;
    color: #5CB85C;
}

.iconbig {
    font-size: 77px;
    color: #5CB85C;
}

.table > tbody > tr > .emptyrow {
    border-top: none;
}

.table > thead > tr > .emptyrow {
    border-bottom: none;
}

.table > tbody > tr > .highrow {
    border-top: 3px solid;
}
</style>

<!-- Simple Invoice - END -->

</div>


<cffunction name="getLabelColor" access="private" returntype="string">
	<cfargument name="id" required="yes" type="numeric"/>

    <cfswitch expression="#arguments.id#">
    	<cfcase value="1"><cfset t = "warning"/></cfcase>
        <cfcase value="2"><cfset t = "important"/></cfcase>
        <cfcase value="3"><cfset t = "info"/></cfcase>
        <cfcase value="16"><cfset t = "inverse"/></cfcase>
        <cfcase value="4"><cfset t = "success"/></cfcase>
        <cfdefaultcase><cfset t = ""/></cfdefaultcase>
    </cfswitch>

    <cfreturn t/>
</cffunction>
</body>
</html>