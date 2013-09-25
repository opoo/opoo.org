<!DOCTYPE html>
<!--[if IEMobile 7 ]><html class="no-js iem7"><![endif]-->
<!--[if lt IE 9]><html class="no-js lte-ie8"><![endif]-->
<!--[if (gt IE 8)|(gt IEMobile 7)|!(IEMobile)|!(IE)]><!--><html class="no-js" lang="<#if (site.locale)??>${site.locale}<#else>en</#if>"><!--<![endif]-->
<head>
  <meta charset="utf-8">
  <title><#if (page.title)??>${page.title} - </#if>${site.title} - 关注计算机软件与互联网</title>
  <meta name="author" content="${site.author}">
  <#if site.description?? && (page.url == "/")><meta name="description" content="${site.description}"><#elseif page.description??><meta name="description" content="${page.description}"></#if>
  <#--if page.keywords??><meta name="keywords" content="${ page.keywords }"></#if-->
  <meta name="HandheldFriendly" content="True">
  <meta name="MobileOptimized" content="320">
  <meta name="OpooPressSiteRoot" content="${ root_url }">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="Generator" content="OpooPress-${site.OpooPressVersion}">
  <#-- <link rel="canonical" href="${ canonical }"> -->
  <link href="${ root_url }/favicon.ico" rel="icon">
  <link href="${ root_url }/stylesheets/screen.css" media="screen, projection" rel="stylesheet" type="text/css">
  <link href="//fonts.googleapis.com/css?family=PT+Serif:regular,italic,bold,bolditalic|PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css">
  <#-- <link href="//fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css"> -->
  <link href="${ site.subscribe_rss }" rel="alternate" title="${site.title}" type="application/atom+xml">
  <#if (root_url?length > 0)><script language="JavaScript">
  <!--
	window.OpooPress = {root:"${root_url}"};
  //-->
  </script></#if>
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
  <script>!window.jQuery && document.write(unescape('%3Cscript src="${root_url}/javascripts/libs/jquery.min.js"%3E%3C/script%3E'))</script>
  <!--[if (gt IE 8)|(gt IEMobile 7)|!(IE)]><!--><script src="${ root_url }/javascripts/opoopress.js"></script><!--<![endif]-->
  <!--[if lt IE 9]><script src="${ root_url }/javascripts/opoopress-ie.js"></script><![endif]-->
  <#include "custom/head.ftl">
  <#-- move to footer -->
  <#-- <#include "google_analytics.ftl"> -->
</head>