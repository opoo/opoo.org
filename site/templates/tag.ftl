<#include "_page.ftl">

<#assign isCategories = true>
<#assign showProfile = false>
<#assign showLikeBar = false>
<#assign showComments = false>
<@pageLayout>

<#assign posts = page.posts>
<#include "/archive_post.ftl">

</@pageLayout>
