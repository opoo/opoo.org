<#if (site.tags?size > 0)>
<div class="tp-box-content">
    <div class="tp-box">
    <h3><@i18n.msg "Tags"/></h3>
  <ul id="tags">
<#list site.tags?sort_by("postSize")?reverse as tag>
	<a href="${root_url}${tag.url}" class="op-tag">${tag.name}<span class="count">${tag.postSize}</span></a>
</#list>
  </ul>

        <div style="padding-top:15px;">
            <a href="${root_url}/filter/">筛选</a>
        </div>
    </div>
</div>
</#if>