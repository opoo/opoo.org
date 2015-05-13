<div id="navbar" class="navbar">
  <div id="top-nav">
    <span itemscope="" itemtype="http://schema.org/Organization">
        <a class="logo" href="${root_url}/" itemprop="url"></a>
        <meta itemprop="img" content="${site.logo_root}/apple-touch-icon-144x144.png"/>
    </span>

    <#--
    <ul id="nav-tools" class="navigation pull-right">
        <li>
            <a class="" href="" rel="nofollow">Source</a>
        </li>
    </ul>
    -->

    <#--
    isBlog: isIndexPage, isArchivesPages 
    isCategories
    isPages: 
    -->

    <#assign isCategories = isCategories!false == true || (page.pagetype?? && page.pagetype == 'categories')>
    <#if isCategories>
        <#assign isIndexPage = false>
        <#assign isArchivesPage = false>
        <#assign isBlog = false>
        <#--assign isPages = false-->
    <#else>
        <#assign isIndexPage = page.pagetype?? && page.pagetype == "index">
        <#assign isArchivesPage = page.pagetype?? && page.pagetype == "archives">
        <#assign isBlog = isIndexPage || isArchivesPage || (page.layout == "post")>
        <#--assign isPages = !isBlog && site.nav_pages?values?seq_contains(page.url)-->
    </#if>
    
    <!--
    Blog: ${isBlog?string}, Categories: ${isCategories?string}, Index: ${isIndexPage?string}, Archives: ${isArchivesPage?string}
   -->
    
    <ul id="tp-main-nav" class="navigation">
        <li class="dropdown<#if isBlog> active</#if>">
            <a href="${root_url}/"><@s "Blog"/></a>
            <ul class="dropdown-menu">
                <li><a href="${root_url}/"><@s "Posts"/></a></li>
                <li><a href="${root_url}/archives/"><@s "Archives"/></a></li>
            </ul>
            <div class="indicator"></div>
        </li>



        <li class="dropdown<#if isCategories> active</#if>">
            <a href="${root_url}/category/"><@s "Categories"/></a>
            <ul class="dropdown-menu">
				<#list site.categories as category>
                <#if !(category.parent)??>
				    <@showCategoryMenu category=category level=0/>
                </#if>
                </#list>
            </ul>
            <div class="indicator"></div>
        </li>
        
        <#--
        <li class="dropdown<#if isPages> active</#if>">
            <a href="javascript:void();"><@s "Pages"/></a>
            <ul class="dropdown-menu">
                <#list site.nav_pages?keys as navLabel>
  			    <#assign navUrl = site.nav_pages[navLabel]>
  			    <li><a href="${navUrl}">${navLabel}</a></li>
    			</#list>
            </ul>
            <div class="indicator"></div>
        </li>
        -->

        <#list site.nav_pages?keys as navLabel>
        <#assign navUrl = site.nav_pages[navLabel]>
        <li<#if page.url == navUrl> class="active"</#if>><a href="${navUrl}">${navLabel}</a><div class="indicator"></div></li>
        </#list>

        <#-- 
        <li class="mobile-nav"><a href="#">XX</a></li>
        <li class="mobile-nav"><a href="#">YY</a></li> 
        -->
    </ul>
  </div>
  <div id="sub-nav">
    <form class="-global-search" id="global-search-form" action="${ site.simple_search }">
        <div id="global-search" class="dropdown">
            <input type="hidden" name="q" value="site:${ site.url?substring(7)}" />
            <input name="q" class="search-input -tooltip no-jq-placeholder" results="0" placeholder="Search" title="<@s 'Search'/>" type="text"/>
        </div>
    </form>
    
    <ul class="action-bar horizontal-list">
        <#-- <li class="first">·ÖÏí:</li> -->
        <li class="actions-item -tooltip" title="<@s 'OpooPress - a java based static blog generator'/>">
            <a href="http://www.opoopress.com/" target="_blank"><i class="tp-post-type smallmedium opoopress">&nbsp;</i></a>
        </li>

        <#if site.https_url??>
        <li class="actions-item -tooltip" title="<@s 'SSL link'/>">
            <a href="${site.https_url}${root_url}${page.url}"><i class="tp-post-type smallmedium lock">&nbsp;</i></a>
        </li>
        </#if>
        
        <#if site.github_user??>
        <li class="actions-item -tooltip" title="<@s 'My GitHub'/>">
            <a href="https://github.com/${site.github_user}" target="_blank"><i class="tp-post-type smallmedium github">&nbsp;</i></a>
        </li>
        </#if>

        <#if site.twitter_user??>
        <li class="actions-item -tooltip" title="<@s 'My Twitter'/>">
            <a href="https://twitter.com/${site.twitter_user}" target="_blank"><i class="tp-post-type smallmedium twitter">&nbsp;</i></a>
        </li>
        </#if>

        <#if site.email??>
        <li class="actions-item -tooltip" title="<@s 'My Email'/>">
            <a href="mailto:${site.email}" rel="nofollow"><i class="tp-post-type smallmedium email">&nbsp;</i></a>
        </li>
        </#if>
       
        <li class="actions-item -tooltip" title="<@s 'About'/>">
            <a href="${root_url}/about/"><i class="tp-post-type smallmedium question">&nbsp;</i></a>
        </li>
    </ul>
    
    <#if isBlog>
    <ul class="navigation">
    	<li><a href="${root_url}/"<#if isIndexPage> class="active"</#if>><@s "Posts"/></a></li>
        <li><a href="${root_url}/archives/"<#if isArchivesPage> class="active"</#if>><@s "Archives"/></a></li>
    </ul>
    </#if>
    
    <#if isCategories>
    <ul class="navigation">
    	<#list site.categories as category>
	<li><a href="${root_url}${category.url}"<#if page.url == category.url> class="active"</#if>>${category.name}</a></li>
	</#list>
    </ul>
    </#if>
    
    <#-- if isPages>
    <ul class="navigation">
    	<#list site.nav_pages?keys as navLabel>
    	<#assign navUrl = site.nav_pages[navLabel]>
	    <li><a href="${navUrl}"<#if page.url == navUrl> class="active"</#if>>${navLabel}</a></li>
        </#list>
    </ul>
    </#if -->
    
  </div>
 </div>
<#--include "custom/navbar.ftl"-->
