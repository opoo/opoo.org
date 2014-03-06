<#--
  Add content to be output at the bottom of each page. (You might use this for analytics scripts, for example)
-->
<#if (highlighter?? && highlighter == "SyntaxHighlighter")>
<!-- START: Syntax Highlighter ComPress -->
<script type="text/javascript" src="${site.default_theme_root}/plugins/syntax-highlighter/scripts/shCore.js"></script>
<script type="text/javascript" src="${site.default_theme_root}/plugins/syntax-highlighter/scripts/shAutoloader.js"></script>
<script type="text/javascript">
    SyntaxHighlighter.autoloader(
        'applescript			${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushAppleScript.js',
        'actionscript3 as3		${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushAS3.js',
        'bash shell				${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushBash.js',
        'coldfusion cf			${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushColdFusion.js',
        'cpp c					${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushCpp.js',
        'c# c-sharp csharp		${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushCSharp.js',
        'css					${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushCss.js',
        'delphi pascal pas		${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushDelphi.js',
        'diff patch			    ${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushDiff.js',
        'erl erlang				${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushErlang.js',
        'groovy					${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushGroovy.js',
        'java					${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushJava.js',
        'jfx javafx				${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushJavaFX.js',
        'js jscript javascript	${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushJScript.js',
        'perl pl				${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushPerl.js',
        'php					${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushPhp.js',
        'text plain				${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushPlain.js',
        'powershell ps          ${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushPowerShell.js',
        'py python				${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushPython.js',
        'ruby rails ror rb		${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushRuby.js',
        'sass scss              ${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushSass.js',
        'scala					${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushScala.js',
        'sql					${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushSql.js',
        'vb vbnet				${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushVb.js',
        'xml xhtml xslt html	${site.default_theme_root}/plugins/syntax-highlighter/scripts/shBrushXml.js'
    );
    SyntaxHighlighter.defaults['auto-links'] = false;                 
    SyntaxHighlighter.defaults['toolbar'] = false;     
    SyntaxHighlighter.defaults['tab-size'] = 4;
    SyntaxHighlighter.all();
</script>
<!-- END: Syntax Highlighter ComPress -->
</#if>
