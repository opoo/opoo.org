<#macro postLayout><#assign single = true><#include "_default.ftl"><@defaultLayout>
<div class="sidebar-wrapper clearfix">       
	<div class="pane content-pane main-body clearfix">

		<div class="-entity">
		
            <#if (page.profile)!true == true>
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
		
		 	<#include "article_like_bar.ftl">
			
            <div class="tp-pager-bar">
              <#if (page.previous.url)??>
                <a class="" href="${root_url}${page.previous.url}" title="<@i18n.msg "Previous Post"/>: ${page.previous.title}">&laquo; ${page.previous.title}</a>
              </#if>
               <#if (page.next.url)??>
                <a class="pull-right" href="${root_url}${page.next.url}" title="<@i18n.msg "Next Post"/>: ${page.next.title}">${page.next.title} &raquo;</a>
              </#if>
            </div>

            <#if (page.related_posts)?? && (page.related_posts?size > 0)>
            <div id="related-posts-container">
                <h3><@i18n.msg "Related Posts"/></h3>
                <#list page.related_posts as post>
                   <div class="post-link">
                        <a href="${ root_url }${ post.url }">${titlecase(post.title)}</a>
                        <div class="source pull-right">
                        <time datetime="${post.date?datetime?iso_local}">${post.date?string("yyyy-MM-dd")}</time>
                        </div>
                    </div>
                </#list>
          
            </div>
            </#if>

			<#if site.disqus_short_name?? && (page.comments)!true == true>
		    <div id="comment-container">
		   		<h3><@i18n.msg "Comments"/></h3>
		   		<div id="disqus_thread" aria-live="polite"><#include "post/disqus_thread.ftl"></div>
		    </div>
		    </#if>
		</div>

	</div>
	
	<div id="sidebar" class="pane sidebar">
		<#include "asides/post_asides.ftl">
	</div>    
</div>

</@defaultLayout>
</#macro>