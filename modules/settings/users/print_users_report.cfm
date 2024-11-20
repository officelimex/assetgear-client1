<cfoutput> 
	<cfset qI = application.com.User.init()/>
	<cfdump var="#qI#"/>
	<cfset users = qI.getusers()/>
    
    
	<cfdocument pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4">
	<html>
	<head>
		<cfset bg = "##f7ddf0"/>
		<cfset brd_c = "##f0bde2"/>
		<cfset brd_c2 = "##e17dc6"/>
		<style type="text/css">	
			html,body{padding:0; margin:0;font: 12px Tahoma;}
			.head_section td{font-size: 11px;padding:5px;}
			.head_section td.left{background-color:#bg#;border-left:#brd_c# 1px solid;}
			.head_section td.left,.head_section td.right{border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
			.head_section td.bottom{border-bottom:#brd_c# 1px solid;}
			.sub_head{font-size:11px; background-color:#bg#;border-top:#brd_c# 1px solid; padding:5px;}
			.content{font-size:11px;padding:5px;}
			.tbl{
			font-size: 11px; 
		}
			.tbl th{font-weight: normal;background-color:#bg#;border-top:#brd_c2# 2px solid;border-right:#brd_c# 1px solid; text-align:left; padding:4px;}
			.tbl th.left{border-left:#brd_c# 1px solid;}
			.tbl td{
			padding: 3px 5px;
		border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
			.tbl td.left{border-left:#brd_c# 1px solid;}
			.tbl tr.bottom td{border-bottom:#brd_c# 1px solid;}
			.tbl td.no-right{border-right:none;}
			.tbl td.cbg{background-color:#bg#;}
			.tbl td.no-bottom{border-bottom:none !important;}
			.a-right{text-align:right !important;}
			.center{text-align:center !important;}
		</style>
	</head>
	<body>
		<table width="100%">
			<cfdocumentitem type = "header">
				<cfset request.letterhead.title="ASSETGEAR USERS/PRIVILEGES"/>
				<cfset request.letterhead.Id=""/>
				<!---<cfset request.letterhead.date="Date issued: #dateformat(qMI.DateIssued,'dd-mmm-yyyy')#"/>--->
				<cfinclude template="../../../include/letter_head.cfm"/>
			</cfdocumentitem> 
			<tr>
			    <td>

					<div class="sub_head">USERS & PRIVILEGES</div>
					<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
					  <tr>
						<th class="left" width="1">S/N</th>
						<th width="150">Names</th>
						<th width="170" class="center">Email</th>
						<th width="53" nowrap="nowrap" class="a-right">Company</th>
						<th width="172" class="a-right">Department</th>
						<th width="172" class="">Privilege</th>
					  </tr>
					  <cfset ts=1/>
                        <cfloop query="users" >
                            <tr>
                                <td>#ts#</td>
                                <td>#UserName#</td>
                                <td>#Email# &nbsp;</td>
                                <td>#Company# &nbsp;</td>
                                <td>#DepartmentName# &nbsp;</td>
                                <td>#getUserRole(Role)# &nbsp;</td>
                            </tr>
                            <cfset ts++ />
                        </cfloop>
					</table>
				</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			</tr>
		</table>
	</body>
	</html>
	</cfdocument>

	<cffunction name="getUserRole" access="private" returntype="string" hint="Get user role">
		<cfargument name="uid" hint="user id" required="yes" type="string"/>
		<cfset r = ""/>
        <cfswitch expression="#arguments.uid#">
            <cfcase value="UR"> <cfset r="User" /> </cfcase>
            <cfcase value="FS"> <cfset r="F.S" /> </cfcase>
            <cfcase value="SV"> <cfset r="Supervisor" /> </cfcase>
            <cfcase value="MS"> <cfset r="Main. Supervisor" /> </cfcase>
            <cfcase value="HSE"> <cfset r="HSE" /> </cfcase>
            <cfcase value="PS"> <cfset r="Production Supv." /> </cfcase>
            <cfcase value="AD"> <cfset r="IT" /> </cfcase>
        </cfswitch>

		<cfreturn r/>
	</cffunction>
    
	<cffunction name="getSignature" access="private" returntype="string" hint="Get user signatire">
		<cfargument name="uid" hint="user id" required="yes" type="string"/>

		<cfquery name="qS1" cachedwithin="#CreateTime(1,0,0)#">
			SELECT * FROM `file`
			WHERE `Table` = 'core_user'
				AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.uid)#"/>
			LIMIT 0,1
		</cfquery>

		<cfreturn qS1.File/>
	</cffunction>
</cfoutput>