<!--- 
Author: Arowolo Abiodun
Created: 2011/11/19
Modified: 2011/11/19
-> display all the roles and privelages in the application 
--->
<cfoutput> 
    <cfset ursId = '__users_c'/>
    <cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
    <cfparam name="url.cid" default=""/>

    <g:Grid renderTo="#ursId#_all_users#url.cid#" url="modules/ajax/settings.cfm?cmd=getUsers&cid=#url.cid#" commandWidth="85px" class="table-hover table-condensed">
        <g:Columns>
            <g:Column id="UserId" caption="User's ##" field="u.UserId" sortable searchable/>
            <g:Column id="UserName" Caption="Names" sortable field="u.UserName"/>
            <g:Column id="Surname" hide sortable searchable field="u.Surname"/>
            <g:Column id="OtherNames" caption="Other Names" hide sortable searchable field="u.OtherNames"/>
            <g:Column id="Email" />
            <cfif url.cid eq "">
                <g:Column id="Company" />
                <cfelse>
                    <g:Column id="Company" hide/>
                    </cfif>
                <g:Column id="DepartmentName" Caption="Department" field="d.Name" sortable searchable/>
                </g:Columns>

            <g:Commands>
                <g:Command id="viewReport" help="Print Users Report" text="Reports" pin icon="file icon-file"/> 
                <cfif (request.userinfo.role eq "FS") || (request.userinfo.DepartmentId eq 1) || (request.userinfo.role eq "HT") >
                    <g:Command id="rpin" icon="random icon-white" help="Reset PIN" class="btn btn-mini btn-warning"/>
                    <g:Command id="gkey" icon="lock icon-white" help="Update login access" class="btn btn-mini btn-warning"/>
                    <g:Command id="editR" icon="pencil icon-white" help="Edit User" class="btn btn-mini btn-primary"/> 
                </cfif>
            </g:Commands>

            <g:Event command="viewReport">
                <g:Window title="'Report Option'" width="490px" height="120px" url="'modules/settings/users/report_option.cfm'" id="">
                    <g:Button   />
                </g:Window>
            </g:Event>

            <g:Event command="rpin">
                <g:Window title="'Reset PIN for ' + d[1]" width="490px" height="70px" url="'modules/settings/users/reset_pin.cfm?cid=#url.cid#'" id="">
                    <g:Button IsSave value="Reset" />
                </g:Window>
            </g:Event>
            <g:Event command="gkey">
                <g:Window title="'Update login access for ' + d[1]" width="490px" height="170px" url="'modules/settings/users/edit_user_role.cfm?cid=#url.cid#'" id="">
                    <g:Button IsSave />
                </g:Window>
            </g:Event>
            <g:Event command="editR">
                <g:Window title="'Edit ' + d[1]" width="850px" height="330px" url="'modules/settings/users/save_users.cfm?cid=#url.cid#'" id="_">
                    <g:Button IsSave /> 
                </g:Window>
            </g:Event>         

            </g:Grid> 

        </cfoutput>
