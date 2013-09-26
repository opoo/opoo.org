<#assign single = true>

<#macro postLayout>

<#include "_default.ftl">
<@defaultLayout>
<div>
<article class="hentry" role="article">
  <#include "article.ftl">
  <div class="entry-content"><#nested></div>
  <footer>
    <p class="meta">
      <#include "post/author.ftl">
      <#include "post/date.ftl"><#if was_updated??>${updated}<#else>${time}</#if>
      <#include "post/categories.ftl">
      <#if (page.path)??><@i18n.source page.path></@i18n.source></#if>
    </p>
    <#if (page.sharing)!true == true><#include "post/sharing.ftl"></#if>
    <#--if (page.related_posts)?? && (page.related_posts?size > 0)><#include "post/related_posts.ftl"></#if-->
    <p class="meta">
      <#if (page.previous.url)??>
        <a class="basic-alignment left" href="${root_url}${page.previous.url}" title="<@i18n.msg "Previous Post"/>: ${page.previous.title}">&laquo; ${page.previous.title}</a>
      </#if>
       <#if (page.next.url)??>
        <a class="basic-alignment right" href="${root_url}${page.next.url}" title="<@i18n.msg "Next Post"/>: ${page.next.title}">${page.next.title} &raquo;</a>
      </#if>
    </p>
  </footer>
</article>

<#if (page.related_posts)?? && (page.related_posts?size > 0)>
  <section class="related_posts">
    <h1><@i18n.msg "Related Posts"/></h1>
  <ul>
    <#list page.related_posts as post>
      <li class="post">
        <a href="${ root_url }${ post.url }">${titlecase(post.title)}</a>
      </li>
    </#list>
  </ul>
  </section>
</#if>

<#include "post/comments.ftl">
</div>
<#if !(page.sidebar)?? || ((page.sidebar)?string != "false")>
<aside class="sidebar">
	<#include "asides/post_asides.ftl">
</aside>
</#if>
</@defaultLayout>

</#macro>