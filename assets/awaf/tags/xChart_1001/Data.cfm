<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
  
  <cfparam name="Attributes.TagName" type="string" default="Dataset"/> 
 	<cfparam name="Attributes.type" type="string"/>
	<cfparam name="Attributes.query" default=""/>
	<cfparam name="Attributes.y" type="string"/>
	<cfparam name="Attributes.label" type="string"/>
	<cfparam name="Attributes.delimiters" type="string" default=","/>
	<cfparam name="Attributes.numberprefix" type="string" default=""/>
	<cfparam name="Attributes.showlegend" type="boolean" default="false"/> 
	<cfparam name="Attributes.name" type="string" default=""/> 
	<cfparam name="Attributes.toolTip" type="string" default=""/>
	
	<cfassociate basetag="cf_Chart"/>

		{        
				type: "#Attributes.type#",
				<cfswitch expression="##">
					<cfcase value="doughnut,pie">
						startAngle:20,
					</cfcase>
				</cfswitch>
				<cfif Attributes.showlegend>
					showInLegend: #Attributes.showlegend#,
				</cfif>
				<cfif Attributes.toolTip neq "">
					toolTipContent: "#Attributes.toolTip#",
				</cfif>
				name: "#Attributes.name#",
				dataPoints: [
				<cfif isquery(Attributes.query)>
					<cfloop  query="Attributes.query">
						{  y: #Attributes.query[Attributes.y]#, label: "#Attributes.query[Attributes.label]#" },
					</cfloop>
				</cfif> 
<!--- close tag --->   
<cfelse>
    
            ]
            },
 
</cfif> 
</cfoutput>