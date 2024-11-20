<cfoutput>

<cfswitch expression="#url.cmd#">
    <!---getAllInbox--->
    <cfcase value="getAllInbox">    
        <cfset start = (url.page * url.perpage) - (url.perpage)/>

        <cfquery name="q" cachedwithin="#CreateTime(0,0,0)#">
            SELECT 
            	i.*,
                CONCAT(fu.Surname," ",fu.OtherNames) Sender
            FROM msg_inbox i
            LEFT JOIN core_user fu ON fu.UserId = i.FromUserId
			<cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
            ORDER BY #url.sort# #url.sortOrder#
            LIMIT #start#,#url.perpage#
        </cfquery>
        <cfquery name="qT">
            SELECT count(InboxId) c 
            FROM msg_inbox
			<cfif structkeyexists(url,'keyword')>
                WHERE (#url.Field# LIKE "%#url.keyword#%")
            </cfif>
        </cfquery>
        <cfoutput>
        {"total": #qT.c#,
            "page": #url.page#,
            "rows":[<cfloop query="q">
            	<cfset sdr = q.Sender/>
                <cfif q.Sender eq "">
					<cfset sdr="System"/>
				</cfif>
                ["#Dateformat(q.Date,'dd mmm yyyy')# #lcase(timeformat(q.Date,'hh:mm tt'))#",#serializeJSON(q.Subject)#,#serializeJSON(sdr)#,#q.InboxId#]
                 <cfif q.recordcount neq q.currentrow>,</cfif>
            </cfloop>]}
        </cfoutput>
    </cfcase>
        
</cfswitch>
    
</cfoutput>
