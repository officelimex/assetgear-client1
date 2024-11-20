<cfcomponent>

	<cffunction name="Init" access="public" returntype="bDate"> 
	 
		<cfreturn this>
	</cffunction>
	
	<cffunction name="DateFormat1" access="public" returntype="string" hint="return x years y months">
		<cfargument name="m" hint="months" type="numeric">
		
		<cfset temp = "">
		
		<cfif arguments.m neq 0>
		
			<cfset y = arguments.m \ 12>
			<cfset mon = abs((y * 12) - arguments.m)>
			
			<cfif y gt 0>
				<cfif y eq 1>
					<cfset temp = "#y# Year">
				<cfelse>
					<cfset temp = "#y# Years">
				</cfif>
			</cfif>
			
			<cfif mon eq 1>
				<cfset temp = temp & " #mon# Month">
			<cfelseif mon gt 1>
				<cfset temp = temp & " #mon# Months">
			</cfif>
		</cfif>
		
		<cfreturn trim(temp)>
	</cffunction>
    
	<cffunction name="Age" access="public" returntype="string" hint="get age">
		<cfargument name="d1" hint="date 1" type="date">
        <cfargument name="d2" hint="date 1" type="date">
		
		<cfset var temp = "">
		
		<cfset ddf = abs(datediff('d',d1,d2))/>
        
        <cfif ddf eq 0>
        	<cfset temp = "Today"/>
        <cfelseif ddf eq 1>
        	<cfset temp = "Yesterday"/>
        <cfelseif ddf gte 2 and ddf lte 6>
        	<cfset temp = ddf & " days ago"/>
        <cfelseif ddf eq 7>
        	<cfset temp = "1 week ago"/>
        <cfelseif ddf gt 7 and ddf lt 14>
        	<cfset temp = "1 week plus"/> 
        <cfelseif ddf eq 14>
        	<cfset temp = "2 weeks ago"/>
        <cfelseif ddf gt 14 and ddf lt 21>
        	<cfset temp = "2 weeks ago"/>
        <cfelseif ddf eq 21>
        	<cfset temp = "3 weeks ago"/>
        <cfelseif ddf gt 21 and ddf lt 28>
        	<cfset temp = "3 weeks plus"/>
        <cfelseif ddf eq 28>
        	<cfset temp = "1 month ago"/>
        <cfelseif ddf gt 28 and ddf lt 52>
        	<cfset temp = "1 month plus"/>
        <cfelseif ddf eq 52>
        	<cfset temp = "2 months ago"/>
        <cfelseif ddf gt 52 and ddf lt 80>
        	<cfset temp = "2 months plus"/>
        <cfelseif ddf eq 80>
        	<cfset temp = "3 months ago"/>
        <cfelse>
        	<cfset temp = "long time ago"/>
        </cfif>
		
		<cfreturn trim(temp)>
	</cffunction>
	
	<cfscript>

		public string function timeAgo(required date dateThen, date rightNow = now(), string time_frame = "ago") 	{
			var result = "";
			var i = "";
			//var arguments.rightNow = Now();
			Do 	{
				i = dateDiff('yyyy',arguments.dateThen,arguments.rightNow);
				if(i GTE 2)	{
					result = "#i# years #arguments.time_frame#";
					break;
				}
				else if (i EQ 1)	{
					result = "#i# year #arguments.time_frame#";
					break;
				}
				i = dateDiff('m',arguments.dateThen,arguments.rightNow);
				if(i GTE 2)	{
					result = "#i# months #arguments.time_frame#";
					break;
				}
				else if (i EQ 1)	{
					result = "#i# month #arguments.time_frame#";
					break;
				}

				i = dateDiff('d',arguments.dateThen,arguments.rightNow);
				if(i GTE 2){
					result = "#i# days #arguments.time_frame#";
					break;
				}
				else if (i EQ 1)	{
					result = "#i# day #arguments.time_frame#";
					break;
				}

				i = dateDiff('h',arguments.dateThen,arguments.rightNow);
				if(i GTE 2)	{
					result = "#i# hours #arguments.time_frame#";
					break;
				}
				else if (i EQ 1)	{
					result = "#i# hour #arguments.time_frame#";
					break;
				}

				i = dateDiff('n',arguments.dateThen,arguments.rightNow);
				if(i GTE 2)	{
					result = "#i# minutes #arguments.time_frame#";
					break;
				}
				else if (i EQ 1)	{
					result = "#i# minute #arguments.time_frame#";
					break;
				}

				i = dateDiff('s',arguments.dateThen,arguments.rightNow);
				if(i GTE 2)	{
					result = "#i# seconds #arguments.time_frame#";
					break;
				}
				else if (i EQ 1)	{
					result = "#i# second #arguments.time_frame#";
					break;}
				else 	{
					result = "less than 1 second #arguments.time_frame#";
					break;
				}
			}
			While (0 eq 0);

			return result;
		}
	
	
	</cfscript>
	
</cfcomponent>