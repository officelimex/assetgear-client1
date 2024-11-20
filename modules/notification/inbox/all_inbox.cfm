
<cfoutput>

<!--- for frequency as category {url.cid}--->
<cfparam name="url.cid" default=""/>

<cfset inbxid = '__inbox_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 

<g:Grid renderTo="#inbxid#_all_inbox" url="modules/ajax/message.cfm?cmd=getAllInbox" commandWidth="70px" class="table-hover" firstsortOrder="DESC">
    <g:Columns> 
    	<g:Column id="Date" sortable nowrap/>
        <g:Column id="Subject" sortable searchable />
        <g:Column id="Sender" sortable/>
        <g:Column id="InboxId" hide/>        
	</g:Columns>
    <g:Commands>
        <g:Command id="readMS" text="view" help="View Message"/>
    </g:Commands>

	<g:Event command="readMS">
    	<g:Window title="'Message from '+d[2]" width="700px" height="400px" url="'modules/message/inbox/view_inbox.cfm'" id="">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>     
	<!---<g:Event command="Print">
    	<g:Window title="'JHA ## ' + d[1]" IsNewWindow  url="'modules/ptw/jha/print_jha.cfm?cid=#url.cid#'" />
    </g:Event> ---> 
</g:Grid>  
 
</cfoutput>
