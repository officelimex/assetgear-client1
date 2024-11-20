<style type="text/css">
	div.scrlx2  {
		height: 400px;
		overflow-y: auto; }
	.grl{color:#603; font-style:italic;}
</style>
<cfoutput>
<cfimport taglib="../../assets/awaf/tags/xChart_1000/" prefix="c" />
<div class="container-fluid pad-top10">
    <div class="row-fluid">
        <div class="span12">
            <cfquery name="qwot">
                #application.com.Permit.PERMIT_SQL#
                WHERE p.Status <> "C"
                ORDER BY p.PermitId DESC
            </cfquery>
        	<p><h4>Ongoing Jobs&nbsp;<small> &mdash; #qwot.recordcount#</small></h4></p>
        	<div class="scrlx2">
                <table border="0" class="table table-condensed table-hover table-striped">
                    <tbody class="scrollContent">
                        <cfloop query="qwot">
                            <tr>
                            <td><a href="modules/ptw/permit/print_permit.cfm?id=#qwot.PermitId#" target="_blank">#qwot.PermitId#</a></td>
                            <td>#qwot.Work# <span style="color:gray">on</span> <em>#qwot.Asset#</em>
                            <span class="label #getLabelColor(val(qwot.DepartmentId))#">#qwot.Department#</span> 
                            <span class="grl">&mdash;
                            	<cfswitch expression="#qwot.Status#">
                            		<cfcase value="STPSTC">Waiting for Facility Supv. to close</cfcase>
                                    <cfcase value="STPSTA">Waiting for PA to sign</cfcase>
                                    <cfcase value="WFPSTA">Waiting for Facility Supv. to sign</cfcase>
                                    <cfcase value="WFHTS">Waiting for HSE to sign</cfcase>
                                    <cfcase value="WFFSTA">Waiting for FS to sign</cfcase>
                                    <cfcase value="FSA">Ongoing</cfcase>
                                    <cfcase value="PSR">Revalidated</cfcase>
                                    <cfcase value="SFR">Waiting for Facility Supervisor to validate</cfcase>
                                    <cfdefaultcase>#qwot.Status#</cfdefaultcase>
                                </cfswitch>
                            </span></td>
                            <td nowrap="nowrap">#dateformat(qwot.Date,'dd-mmm-yy')#</td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
        	</div>
        </div>

        <div class="span6" align="center">

<!--- <cfquery name="qC3">
    SELECT 
        COUNT(p.Status) AS CStatus, 
        p.Status
    FROM 
        ptw_permit p
    WHERE 
        p.Status <> 'C'
    GROUP BY 
        p.Status
    ORDER BY 
        MAX(p.PermitId) DESC;
</cfquery>
<br/>
<c:Chart width="510" height="220" type="Pie2D" showNames="1" caption="Permit Status">
	<cfset pcolr = "Fad35e,c4e3f7,A66EDD,8BBA00,F6BD0F,AFD8F8,00ff00,0000ff,af7700"/>
	<cfloop query="qC3">
    	<cfset stus = qC3.Status/>
    	<cfswitch expression="#qC3.Status#">
        	<cfcase value="STPSTC"><cfset stus = "Waiting for PS to close"/></cfcase>
            <cfcase value="STPSTA"><cfset stus = "Waiting for PA to sign"/></cfcase>
            <cfcase value="WFPSTA"><cfset stus = "Waiting for Facility Spv."/></cfcase>
            <cfcase value="WFHTS"><cfset stus = "Waiting for HSE to sign"/></cfcase>
            <cfcase value="WFFSTA"><cfset stus = "Waiting for FS to sign"/></cfcase>
            <cfcase value="SFR"><cfset stus = "Waiting for FS to validate"/></cfcase>
            <cfcase value="FSA"><cfset stus = "Ongoing"/></cfcase>
            <cfcase value="PSR"><cfset stus = "Revalidated permit"/></cfcase>
        </cfswitch>
    	<c:Set name="#stus#" value="#qC3.CStatus#" color="#listgetat(pcolr,qc3.currentrow)#"/>
    </cfloop>
</c:Chart>

<cfset byear = dateformat(now(),'yyyy/01/01')/>
<cfset eyear = dateformat(now(),'yyyy/12/31')/>

<cfquery name="qC4">
    SELECT 
        COUNT(p.Date) AS CDate, 
        DATE_FORMAT(p.Date, '%D') AS DM, 
        p.Date
    FROM 
        ptw_permit p
    WHERE 
        p.Date >= <cfqueryparam cfsqltype="cf_sql_date" value="#byear#"/> 
        AND p.Date <= <cfqueryparam cfsqltype="cf_sql_date" value="#eyear#"/>
    GROUP BY 
        DM, p.Date
    ORDER BY 
        p.Date DESC
    LIMIT 0, 14
</cfquery>

<cfquery name="qC4" dbtype="query">
    SELECT * FROM qC4
    ORDER BY Date ASC
</cfquery>

<c:Chart width="510" height="220" type="Column2D" showNames="1" caption="Daily permit">
	<cfloop query="qC4">
    	<c:Set value="#qC4.CDate#" name="#DM#"/>
    </cfloop>
</c:Chart> --->

        </div>
    </div>
</div>
</cfoutput>

<cffunction name="getLabelColor" access="private" returntype="string">
	<cfargument name="id" required="yes" type="numeric"/>

    <cfswitch expression="#arguments.id#">
    	<cfcase value="16"><cfset t = " label-warning"/></cfcase>
        <cfcase value="10"><cfset t = " label-important"/></cfcase>
        <cfcase value="8"><cfset t = " label-info"/></cfcase>
        <cfcase value="1"><cfset t = " label-inverse"/></cfcase>
        <cfcase value="7"><cfset t = " label-success"/></cfcase>
        <cfdefaultcase><cfset t = ""/></cfdefaultcase>
    </cfswitch>

    <cfreturn t/>
</cffunction>
