<cfquery name="qN">
	#application.com.Notice.NOTICE_SQL#
    WHERE (RecipientId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>)
            OR (RecipientDepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>)
            <cfif request.userinfo.unitid neq "">
            	OR (RecipientUnitId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.unitid#"/>)
            </cfif>
            OR (Role = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.userinfo.role#"/>)
    ORDER BY NoticeId DESC
    LIMIT 0,50
</cfquery> 
 
<style>
tr.o_n td{font-weight:bold !important;}
</style>
<cfoutput>
<table class="table table-hover table-striped"><thead><tr>
    <th>From</th>
    <th>Message</th>
    <th>Time</th>                    
  </tr>
</thead>
  <cfloop query="qN">
  <tr <cfif qN.Status eq "o">class="o_n"</cfif>>
    <td>#qN.Sender#</td>
    <td>#qN.Message#</td>
    <td nowrap="nowrap">
<!---<cfswitch expression="#qN.Module#">
	<cfcase value="jha"><a class="notice_update_jha" href="javascript:;" rel="#qN.PK#">update JHA</a></cfcase>
</cfswitch>--->
    #dateformat(date,'dd mmm yy')# - #lcase(timeformat(date,'hh:mm tt'))#
    </td>
  </tr>
  </cfloop>
</table>

<!---<script>
	window.addEvent('domready', function(){
		$$('a.notice_update_jha').addEvent('click', function(e)	{
			//alert(e.target.get('rel'));
			var _id = e.target.get('rel');
			var _w = new aWindow('______Df',{ 
				'title':'Update JHA ' + _id,
				'url':'modules/ptw/jha/save_jha.cfm?id=' + _id,
				'size' : {
					width : '1150px', height : '430px'	
				}
			});
			_w.show();
		}); 
	});
</script>--->
</cfoutput>