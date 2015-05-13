<#if site.categories?? &&  (site.categories?size > 0)>
<div class="tp-box-content">
    <div class="tp-box">
    <h3><@i18n.msg "Categories"/></h3>
    <ul id="categories" class="nav" >
    <#list site.categories as category>
    <#if !(category.parent)??>
        <@showCategoryItem category=category level=0/>
    </#if>
    </#list>
    </ul>
    </div>
</div>
</#if>
