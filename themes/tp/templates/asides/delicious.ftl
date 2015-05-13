<#if site.delicious_user?? >
<#assign showDeliciousLinks = true>
<div class="tp-box-content">
    <div class="tp-box">
    <h3>On Delicious</h3>
    <div id="delicious"></div>
    <#--
    <script type="text/javascript" src="http://feeds.delicious.com/v2/json/${ site.delicious_user }?count=${ site.delicious_count }&amp;sort=date&amp;callback=OpooPress.renderDeliciousLinks"></script>
    -->
    <p><a href="http://delicious.com/${ site.delicious_user }">My Delicious Bookmarks &raquo;</a></p>
    </div>
</div>
</#if>
