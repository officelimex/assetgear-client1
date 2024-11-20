<!--- Author:	Arowolo Abiodun M.
----- Created	11/11/2013
----- Updated	11/11/2013
----- Copyright	adexfe systems (c) 2009
----- About		Coldfusion custom tag for AWAF --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">   
    <cfparam name="Attributes.id" type="string" default="__#left(createUUID(),5)#"/> 
    <cfparam name="Attributes.width" type="string"/> 
    <cfparam name="Attributes.height" type="string"/> 
    <cfparam name="Attributes.caption" type="string" default=""/>
    <cfparam name="Attributes.axisXtitle" type="string" default=""/>
    <cfparam name="Attributes.axisYtitle" type="string" default=""/>
    <cfparam name="Attributes.showValues" type="string" default="0"/>
    <cfparam name="Attributes.numberPrefix" type="string" default=""/>
    <cfparam name="Attributes.decimalPrecision" type="string" default="0"/>
    <cfparam name="Attributes.bgcolor" type="string" default="ffffff"/>
    <cfparam name="Attributes.bgAlpha" type="string" default=""/>
    <cfparam name="Attributes.showColumnShadow" type="string" default="0"/>
    <cfparam name="Attributes.showAlternateHGridColor" type="string" default="0"/>
    <cfparam name="Attributes.alternateHGridColor" type="string" default=""/><!--- f8f8f8---->
    <cfparam name="Attributes.alternateHGridAlpha" type="string" default=""/><!--- 60 --->
    <cfparam name="Attributes.canvasBorderThickness" type="string" default="0"/>
    <cfparam name="Attributes.canvasBorderColor" type="string" default="c5c5c5"/>
    <cfparam name="Attributes.divlinecolor" type="string" default="cfcfff"/><!--- c5c5c5---->
    <cfparam name="Attributes.PYAxisMaxValue" type="string" default=""/>
    <cfparam name="Attributes.PYAxisName" type="string" default=""/>
    <cfparam name="Attributes.SYAxisName" type="string" default=""/> 
 	<cfparam name="Attributes.showNames" type="string" default=""/>
    <cfparam name="Attributes.caption" type="string" default=""/>
    
   
   <cfset request.chart = Attributes/>
<!--- close tag --->  
<script type="text/javascript">
    window.addEvent('domready', function()  {
        var chart = new CanvasJS.Chart("#Attributes.id#",
        {
					axisY:{
						title:"#Attributes.axisYtitle#"
					},
					axisX:{
						title:"#Attributes.axisXtitle#"
					},
					title:{
						text: "#Attributes.caption#",
						verticalAlign: 'top',
						horizontalAlign: 'left'
					},
          data: [
<cfelse>   
   
   
 
        	]// close data
        });

        chart.render();
    });
    </script>
    <div id="#Attributes.id#" style="height: #Attributes.height#; width: #Attributes.width#;"></div>
</cfif> 
</cfoutput>