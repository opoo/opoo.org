<#if site.disqus_short_name??>
<div class="tp-box-content">
    <div class="tp-box">
    <h3><@i18n.msg "Recent Comments"/></h3>
  <script language="JavaScript">
  <!--
	var is_https = ('https:' == document.location.protocol);
	var rcw_script_src = (is_https ? 'https:' : 'http:') + '//${site.disqus_short_name}.disqus.com/recent_comments_widget.js?num_items=5&excerpt_length=100&hide_avatars=0&avatar_size=32';
	var rcw_script = '<scr' + 'ipt type="text/javascript" src="' + rcw_script_src + '"></scr' + 'ipt>';
	document.writeln(rcw_script);
  //-->
  </script>	
	    <div>
            <a href="${root_url}/comments/"><@s "More Comments..."/></a>
        </div>
    </div>
</div>
</#if>