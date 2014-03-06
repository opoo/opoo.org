<div class="tp-box-content">
    <div class="tp-box"><h3><@i18n.msg "Recent Posts"/></h3>
    <#if (site.posts?size <= site.recent_posts)>
	  <#assign recent_posts = site.posts >
	<#else>
	  <#assign recent_posts = site.posts[0..(site.recent_posts-1)]>
    </#if>
  
    <#list recent_posts as post>

    <div class="sidebar-link">
        <a href="${ root_url }${ post.url }">${titlecase(post.title)}</a>
        <div class="source">
        <time datetime="${post.date?datetime?iso_local}">${post.date?string("yyyy-MM-dd")}</time>
        </div>
    </div>
    </#list>
    </div>            
</div>

