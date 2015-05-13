<div id="footer">
  <div class="row-fluid wrapper">
    <div class="span2 logo-wrapper" style="text-align: center">
        <a id="footerLogo2" href="${root_url}/"></a>
        <div class="footer-copyright">
            &copy; ${site.time?string("yyyy")}  ${ site.author }<br/>Powered by <a href="http://www.opoopress.com/">OpooPress</a>
        </div>
    </div>
    
    <div class="span8 link-lists-container">
        <ul class="footer-link-list pull-left">
            <li><a href="${root_url}/"><@s "Posts"/></a></li>
            <li><a href="${root_url}/archives/"><@s "Archives"/></a></li>
        </ul>

        <ul class="footer-link-list  pull-left">
            <li><a href="${root_url}/category/"><@s "Categories"/></a></li>
            <#list site.categories as category>
			<li><a href="${root_url}${category.url!'#'}">${category.name}</a></li>
			</#list>
        </ul>

        <ul class="footer-link-list  pull-left">
            <#list site.nav_pages?keys as navLabel>
		    <#assign navUrl = site.nav_pages[navLabel]>
		    <li><a href="${navUrl}">${navLabel}</a></li>
			</#list>
        </ul>
    </div>
    
    <div class="span2 footer-social-container">
        <ul class="footer-social-list">
            <li>
                <a href="${ site.subscribe_rss }" target="_blank" rel="subscribe-rss" title="subscribe via RSS">
                    <span class="opoo-feed icon"></span>
                    Blog
                </a>
            </li>
            
            <#if site.github_user??>
            <li>
                <a href="https://github.com/${site.github_user}" target="_blank">
                    <span class="opoo-github-alt icon"> </span>
                    GitHub
                </a>
            </li>
            </#if>

            <#if site.twitter_user??>
	        <li>
                <a href="http://twitter.com/${site.twitter_user}" target="_blank">
                    <span class="opoo-twitter icon"> </span>
                    Twitter
                </a>
            </li>
            </#if>
	        
            <#if site.email??>
            <li>
                <a href="mailto:${site.email}" target="_blank">
                    <span class="opoo-envelope-2 icon"> </span>
                    Mail
                </a>
            </li>
            </#if>
        </ul>
    </div>
    
  </div>
</div>
<#include "custom/footer.ftl">
