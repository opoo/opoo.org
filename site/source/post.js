---
layout: nil
url: /javascripts/post.js
---
window.sitePosts = new Array();
<#list site.posts as post>
window.sitePosts[${post_index}] = {url: '${root_url}${post.url}',title:'${post.title}'};
<#if post.categories?? && (post.categories?size > 0)>
window.sitePosts[${post_index}].categories = new Array();
<#list post.categories as cat>
window.sitePosts[${post_index}].categories[${cat_index}] = '${cat.url}';<#-- {url:'${cat.url}',name:'${cat.name}'};-->
</#list>
</#if>
<#if post.tags?? && (post.tags?size > 0)>
window.sitePosts[${post_index}].tags = new Array();
<#list post.tags as tag>
window.sitePosts[${post_index}].tags[${tag_index}] = '${tag.url}';<#-- {url:'${tag.url}',name:'${tag.name}'};-->
</#list>
</#if>
</#list>
