<#macro defaultLayout><#include "head.ftl">
 <body>
  <div class="bg-container">
    <span id="mobile_menu_link"><@i18n.msg "Menu"/></span>
    <div class="container">
  	  <#include "navbar.ftl">
  	  <div id="content-wrapper">
  	   	<#nested>
  	  	<#include "footer.ftl">
  	  </div>
  	</div>
  </div>
  <#-- facebook like <div id="fb-root"></div> -->
  <#include "after_footer.ftl">
 </body>
</html>
</#macro>