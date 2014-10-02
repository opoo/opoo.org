<!DOCTYPE html>
<!--[if IEMobile 7 ]><html class="no-js iem7"><![endif]-->
<!--[if lt IE 9]><html class="no-js lte-ie8"><![endif]-->
<!--[if (gt IE 8)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!--><html class="no-js" lang="<#if (site.locale)??>${site.locale.language}<#else>en</#if>"><!--<![endif]-->
<head>
  <meta charset="utf-8">
  <title><#if (page.title)??>${page.title} - </#if>${site.title} - 关注计算机软件与互联网</title>
  <meta name="author" content="${site.author}" />
  <#if site.description?? && (page.url == "/")><meta name="description" content="${site.description}"/><#elseif page.description??><meta name="description" content="${page.description}"/></#if>
  <#--if page.keywords??><meta name="keywords" content="${ page.keywords }"/></#if-->
  <link href="${site.logo_root}/favicon.ico" rel="shortcut icon"/>
  <link rel="apple-touch-icon" sizes="57x57" href="${site.logo_root}/apple-touch-icon-57x57.png" />
  <link rel="apple-touch-icon" sizes="114x114" href="${site.logo_root}/apple-touch-icon-114x114.png" />
  <link rel="apple-touch-icon" sizes="72x72" href="${site.logo_root}/apple-touch-icon-72x72.png" />
  <link rel="apple-touch-icon" sizes="144x144" href="${site.logo_root}/apple-touch-icon-144x144.png" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="Generator" content="OpooPress-${site.class.package.specificationVersion}"/>
  <meta name="Generated" content="${site.time?datetime}"/>
  <link href="${ site.subscribe_rss }" rel="alternate" title="${site.title}" type="application/atom+xml"/>
  <link href="${site.theme_root}/stylesheets/screen.css" rel="stylesheet"/>
  
  <link href="${root_url}${page.url}" rel="canonical" />
  <#if (paginator.next)??><link href="${root_url}${paginator.next.url}" rel="next" /></#if>
  <#if (paginator.previous)??><link href="${root_url}${paginator.previous.url}" rel="prev" /></#if>
  <#if (page.previous.url)??><link rel="next" href="${root_url}${page.previous.url}" title="${page.previous.title}"/></#if>
  <#if (page.next.url)??><link rel="prev" href="${root_url}${page.next.url}" title="${page.next.title}"/></#if>

  <#-- web font -->
  <#-- <link href="//fonts.googleapis.com/css?family=PT+Serif:regular,italic,bold,bolditalic|PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css"> -->
  <#--
  <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script type="text/javascript">!window.jQuery && document.write(unescape('%3Cscript src="${root_url}/javascripts/libs/jquery.min.js"%3E%3C/script%3E'));</script>
  -->
  <!--[if lt IE 9]><script src="${site.theme_root}/javascripts/html5shiv.js"></script><![endif]-->
  <#include "custom/head.ftl">
</head>
