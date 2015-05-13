        <#assign hasTags = (post.tags?? && (post.tags?size > 0))>
		<#assign hasCategories = (post.categories?? && (post.categories?size > 0))>
		<#assign showComments = site.disqus_short_name?? && (site.disqus_show_comment_count)!false == true && (post.comments)!true == true>
		<#assign showAuthorCard = (site.showAuthorCard)!true == true && (post.authorcard)!true == true>
		<#assign showAuthor = showAuthorCard && (post.showauthor)!true == true && (post.author?? || site.author??)>
		<#assign showPostDate = showAuthorCard && post.date??>
		<#assign showAuthorCard = showAuthor || showPostDate>
        <#if showAuthor>
            <#if post.author??>
                <#assign postAuthor = post.author>
            <#else>
                <#assign postAuthor = site.author>
            </#if>
        </#if>

		<#-- if showAuthor and showPostDate then 'margin: 0 0 8px 0;' else 'margin: 0 0 0 0;' -->
		<#if hasTags || hasCategories || showComments>
        <div class="clearfix pull-right article-profile-right">
			<#if hasTags>
			<i class="opoo-tags xicon-opoo-tags" title="Tags">&nbsp;</i>
                <#if index??>
                <a class="tp-tag" href="${root_url}${post.tags[0].url!'#'}">${post.tags[0].name}</a>
                <#else>
                <#-- <ul class="tp-tag-list"> -->
                    <#list post.tags as tag>
                    <a class="tp-tag" href="${root_url}${tag.url!'#'}">${tag.name}</a>			
                    </#list>
                 <#-- </ul> -->
                </#if>
			</#if>
			<#if hasCategories>
            <#--if hasTags><i class="margin4px"></i></#if-->
			<i class="opoo-folder-open xicon-opoo-categories" title="Categories">&nbsp;</i>
           
				<#if index??>
				<a class="tp-tag" href="${root_url}${post.categories[0].url!'#'}">${post.categories[0].name}</a>
				<#else>
                 <#-- <ul class="tp-tag-list"> -->
                    <#list post.categories as cat>
					<a class="tp-tag" href="${root_url}${cat.url!'#'}">${cat.name}</a>			
					</#list>
                <#--  </ul> -->
				</#if>
			</#if>
			<#-- <i class="tp-post-type -tooltip blog">
                &nbsp;
            </i> -->
			<#if showComments>
			<#--if hasTags || hasCategories><i class="margin4px"></i></#if-->
			<i class="opoo-bubble xicon-opoo-comments">&nbsp;</i>
			<a class="tp-comments" href="${root_url}${post.url}#disqus_thread" class="-tooltip" title="<@s 'View Comments'/>" data-disqus-identifier="${site.url}${root_url}${post.url}"><@s "Comments"/></a>
			</#if>
			<#-- <span class="icon-tag"></span> tag1, tag2 -->
			<#--  
			<i class="tp-post-type blog" title="XXX">
			&nbsp;
			</i>
            <i class="tp-stats">&nbsp;</i>
			-->
		</div>
		</#if>

		<#if showAuthorCard>
		<span class="tp-author-card">
			<#if showAuthor && showPostDate>
			<a class="tp-gravatar small pull-left">
				<img width="24" height="24" alt="${postAuthor}" src="${site.theme_root}/images/user.png"/>
			</a> 
			
			<span>
				<#-- <span class="icon-user icon-white bgcolor-f08f30"></span> -->
				<a class="author"><span>${postAuthor}</span></a>
                <br />
				<#-- <span class="icon-time icon-white bgcolor-f08f30"></span> -->
                <span class="post-date"><time datetime="${post.date?datetime?iso_local}">${post.date?string("yyyy-MM-dd")}</time></span>
			</span>
			<#elseif showAuthor><#-- author only -->
			<span>
				<span class="icon-user"></span>
				<a class="author"><span>${postAuthor}</span></a>
			</span>
			<#else><#-- time only -->
			<span>
				<span class="icon-time"></span>
                <span class="post-date"><time datetime="${post.date?datetime?iso_local}">${post.date?string("yyyy-MM-dd")}</time></span>
			</span>
			</#if>
		</span>
		</#if>