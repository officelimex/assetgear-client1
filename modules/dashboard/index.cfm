<script src="../../dashboard/js/highcharts.js"></script>
<script src="../../dashboard/js/series-label.js"></script>
<script src="../../dashboard/js/exporting.js"></script>

<div class="panel panel-primary">
	<div class="panel-heading">
		<h3 class="text-center"><strong>Executive Summary</strong></h3>
	</div>
	<div class="panel-body">
		<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"></div>
	
	</div>
</div>
 
<cfoutput>
	<script >
	Highcharts.chart('container', {
	  title: {
			text: ''
	  }, 
	  xAxis: {
			categories: [
				<cfloop query="qUnit">
					'#qUnit.Name#',
				</cfloop>
			]
	  },
	  labels: {
			items: [{
		  	style: {
					left: '50px',
					top: '18px',
					color: (Highcharts.theme && Highcharts.theme.textColor) || 'black'
		  	}
			}]
		},
    yAxis: [{ // Primary yAxis
        labels: {
            format: '{value}',
            style: {
              color: Highcharts.getOptions().colors[1]
            }
        },
        title: {
            text: 'Number of Jobs',
            style: {
              color: Highcharts.getOptions().colors[1]
            }
        }
    }, { // Secondary yAxis
        title: {
            text: 'Cost of Maintenance',
            style: {
             	color: Highcharts.getOptions().colors[0]
            }
        },
        labels: {
          style: {
            color: Highcharts.getOptions().colors[0]
          }
        },
        opposite: true
    }],
	  series: [{
			type: 'column',
			name: 'Corrective',
			data: [#gettotalmain(1,3)#, #gettotalmain(2,3)#, #gettotalmain(3,3)#, #gettotalmain(4,3)#]
	  }, {
			type: 'column',
			name: 'Preventive',
			data: [#gettotalmain(1,10)#, #gettotalmain(2,10)#, #gettotalmain(3,10)#, #gettotalmain(4,10)#]
	  }, {
			type: 'column',
			name: 'Others',
			data: [#gettotalmain(1,0)#, #gettotalmain(2,0)#, #gettotalmain(3,0)#, #gettotalmain(4,0)#]
	  }, {
			type: 'spline',
			yAxis: 1,
			name: 'Cost of Maintance',
			data: [
				<cfloop index="i" from="1" to="#arrayLen(x5)#"> 
					#x5[i]#,
				</cfloop> 
				<!---#x5[1]#, #x5[2]#,#x5[3]# , #x5[4]#--->
			],
			marker: {
				lineWidth: 1
			}
	  }]
	});
	</script>

	<cffunction name="gettotalmain" access="private" returntype="numeric">
		<cfargument name="uid" required="yes" type="numeric"/>
		<cfargument name="cid" required="yes" type="numeric"/>

		<cfif arguments.cid eq 3>
			<cfset st = "AND WorkClassId = 3" />
		<cfelseif  arguments.cid eq 10>
			<cfset st = "AND WorkClassId = 10" />
		<cfelseif (arguments.cid neq 3) && (arguments.cid neq 10)>
			<cfset st = "AND WorkClassId <> 10 AND WorkClassId <> 3" />
		</cfif>

		<cfquery name="qOpen" dbtype="query">
			SELECT count(WorkOrderId) i FROM qWO WHERE UnitId = #arguments.uid# #st# 
		</cfquery>

		<cfreturn val(qOpen.i)/>
	</cffunction>

</cfoutput>  