<h1 class="entry-title"><a href="${ root_url }${ post.url }">${post.title}</a></h1>
<time datetime="${ post.date?string("yyyy-MM-dd'T'HH:mm:ssZ")}" pubdate><span class='month'>${post.date?string("MMM")}</span> <span class='day'>${post.date?string("d")}</span> <span class='year'>${post.date?string("yyyy")}</span></time>
<#if ((post.categories)?? && (post.categories?size > 0)) || ((post.tags)?? && (post.tags?size > 0))>
<footer>
<#--
<#if (post.categories)?? && (post.categories?size > 0)>
  <span class="categories"><@i18n.msg "Filed under"/>: ${category_links(post.categories)}</span>&nbsp;
</#if>
<#if (post.tags)?? && (post.tags?size > 0)>
  <span class="tags"><@i18n.msg "Tags"/>: ${tag_links(post.tags)}</span>
</#if>
-->
<#include "post/categories.ftl">
</footer>
</#if>
