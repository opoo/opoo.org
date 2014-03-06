<#macro pageLayout><#include "_default.ftl"><@defaultLayout>
<div class="sidebar-wrapper clearfix">       
	<div class="pane content-pane main-body clearfix">

		<div class="-entity">
		    
            <#if showProfile!true == true && (page.profile)!true == true>
			<div class="clearfix -article-profile">
            <#assign post = page>
			<#include "article_profile.ftl">
            </div>
            </#if>
		
		    <div>
		        <h1 class="tp-article-title">${titlecase(page.title)}</h1>
		    </div>
		    
		    <div class="tp-body clean-type center-images clearfix">
		         <#nested>
		    </div>
		    
		    <span class="hide">
		        <a href="/">${site.title}</a>
		    </span>
		
            <#if showLikeBar!true == true && (page.likebar)!true == true>
		 	<#include "article_like_bar.ftl">
            </#if>
			
			<#if showComments!true == true && site.disqus_short_name?? && (page.comments)!true == true>
		    <div id="comment-container">
		   		<h3><@i18n.msg "Comments"/></h3>
		   		<div id="disqus_thread" aria-live="polite"><#include "post/disqus_thread.ftl"></div>
		    </div>
		    </#if>
		</div>

	</div>
	
	<div id="sidebar" class="pane sidebar">
		<#include "asides/page_asides.ftl">
	</div>    
</div>

</@defaultLayout>
</#macro>