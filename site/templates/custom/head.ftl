<#--Fonts from Google"s Web font directory at http://google.com/webfonts -->
<#-- Google Webfonts website is not so stable in CN -->
<#--
<link href="//fonts.googleapis.com/css?family=PT+Serif:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css">
<link href="//fonts.googleapis.com/css?family=PT+Sans:regular,italic,bold,bolditalic" rel="stylesheet" type="text/css">
-->
<#--
<link href="//www.opoo.org/stylesheets/fonts.css" rel="stylesheet" type="text/css">
-->

<#if (highlighter?? && highlighter == "SyntaxHighlighter")>
<script type="text/javascript" src="${root_url}/plugins/syntax-highlighter/scripts/shCore.js"></script>
<script type="text/javascript" src="${root_url}/plugins/syntax-highlighter/scripts/shAutoloader.js"></script>
<link type="text/css" rel="stylesheet" href="${root_url}/plugins/syntax-highlighter/styles/shCoreDefault.css"/>
</#if>

<#--
<#macro highlight lang="">
<#assign highlighterUsed = true>
<pre<#if lang??> class="brush:${lang}"</#if>><#nested></pre>
</#macro>
-->