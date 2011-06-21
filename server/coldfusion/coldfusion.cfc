<!---
AJAX FileUploader for ColdFusion
version: 1.1.1
feedback:  sid.maestre@designovermatter.com

-----------update history----------------
1.1.1 on 9/30/2010 by Martin Webb <martin[at]cubicstate.com>
- Change function for Upload to returnformat equals JSON
- local var scoping.
1.1 on 9/9/2010 by Sid Maestre
- Split Upload function to handle fallback uploads for browsers that don't support XHR data transfer
--->
<cfcomponent hint="I handle AJAX File Uploads from Valum's AJAX file uploader library">
	
    <cffunction name="Upload" access="remote" output="false" returntype="any" returnformat="JSON">
		<cfargument name="qqfile" type="string" required="true">

		<cfset var local = structNew()>
		<cfset local.response = structNew()>
		<cfset local.requestData = GetHttpRequestData()>
		
		<!--- check if XHR data exists --->
        <cfif len(local.requestData.content) GT 0>
			<cfset local.response = UploadFileXhr(arguments.qqfile, local.requestData.content)>       
		<cfelse>
		<!--- no XHR data process as standard form submission --->
			<cffile action="upload" fileField="qqfile" destination="#ExpandPath('.')#" nameConflict="makeunique">
    		<cfset local.response['success'] = true>
    		<cfset local.response['type'] = 'form'>
		</cfif>
		
		<cfreturn local.response>
	</cffunction>
    
    
    <cffunction name="UploadFileXhr" access="private" output="false" returntype="struct">
		<cfargument name="qqfile" type="string" required="true">
		<cfargument name="content" type="any" required="true">

		<cfset var local = structNew()>
		<cfset local.response = structNew()>

        <!--- write the contents of the http request to a file.  
		The filename is passed with the qqfile variable --->
		<cffile action="write" file="#ExpandPath('.')#/#arguments.qqfile#" output="#arguments.content#">
	
		<!--- if you want to return some JSON you can do it here.  
		I'm just passing a success message	--->
    	<cfset local.response['success'] = true>
    	<cfset local.response['type'] = 'xhr'>
		
		<cfreturn local.response>
    </cffunction>
    
</cfcomponent>