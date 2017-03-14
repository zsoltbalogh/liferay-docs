
To leverage the benefits of modularization in @product-ver@, many classes from
former Liferay Portal 6 JAR file <em>portal-service.jar</em> have been moved
into application and framework API modules. The table below provides details
about these classes and the modules they've moved to. Package changes 
and each module's symbolic name (artifact ID) are listed, to facilitate 
<a href="/develop/tutorials/-/knowledge_base/7-0/configuring-dependencies">configuring dependencies</a>. 

<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
    text-align: left;
}
caption {
    text-align: left;
}
</style>
<table style="width:100%">

  <caption>
    <b>Classes Moved from portal-service to com.liferay.portal.kernel</b>
	<p>
      This information was generated based on comparing classes in
      <em>${oldSrc}</em> to classes in <em>${newSrc}</em>.
    </p>
  </caption>
  <tr>
    <th>Class</th>
    <th>Package</th>
    <th>Module Symbolic Name (Artifact ID)</th>
  </tr>

<#list movedClasses as movedClass>
  <tr>
    <td>${movedClass.name}</td>
    <td>
	  <em>Old:</em> ${movedClass.packageOld}<br>
	  <em>New:</em> ${movedClass.packageNew}
	</td>
    <td>${movedClass.module}</td>
  </tr>
</#list>

</table>
