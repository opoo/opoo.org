<#macro subcategory parent level>
<#if (parent.children?size > 0)>
    <ul class="nav children${level}">
    <#list parent.children as child>
        <#if (child.posts?size > 0)>
        <li class="category2"><a href="${root_url}${child.url}"><span class="badge pull-right">${child.posts?size}</span>${child.name}</a>
        <@subcategory parent=child level=level+1/></li>
        </#if>
    </#list>
    </ul>
</#if>
</#macro>

<#macro showCategoryItem category level>
    <li class="padding-left-level-${level}">
        <a href="${root_url}${category.url}"><span class="badge pull-right">${category.posts?size}</span>${category.name}</a></li>
    <#if (category.children?size > 0)>
        <#list category.children as child>
        <@showCategoryItem category=child level=level+1/>
        </#list>
    </#if>
</#macro>

<#macro showCategoryMenu category level>
    <#--
    <#if (category.children?size > 0)>
        <li class="dropdown-submenu">
            <a href="${root_url}${category.url}">${category.name}</a>
            <ul class="dropdown-menu">
            <#list category.children as child>
            <@showCategoryMenu category=child level=level+1/>
            </#list>
            </ul>
       </li>
    <#else>
        <li><a href="${root_url}${category.url}">${category.name}</a></li>
    </#if> 
    -->

    <li class="padding-left-level-${level}"><a href="${root_url}${category.url}">${category.name}</a></li>
    <#if (category.children?size > 0)>
        <#list category.children as child>
        <@showCategoryMenu category=child level=level+1/>
        </#list>
    </#if>
</#macro>

<#macro category_links categories>
<#assign n = 0>
<#list categories as category><#if n == 1>, </#if><a class="category" href="${root_url}${category.url}">${category.name}</a><#assign n = 1></#list>
</#macro>

<#macro tag_links tags>
<#assign n = 0>
<#list tags as tag><#if n == 1>, </#if><a class="tag" href="${root_url}${tag.url}">${tag.name}</a><#assign n = 1></#list>
</#macro>

<#macro s name><@i18n.msg name/></#macro>