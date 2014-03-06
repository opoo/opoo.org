    <table class="tp-like-bar">
        <tbody><tr>
            <#if page.path?? && site.source_base_path??>
            <td class="tp-like-cell">
                <a class="btn -tooltip source-at-github" title="<@s 'View current page source at GitHub.com'/>" href="${site.source_base_path}${page.path}" target="_blank" rel="nofollow"><i class="opoo-github-4">&nbsp;</i>Source</a>
            </td>
            </#if>
            <td width="100%" height="45"><hr></td>
                <td nowrap="true" valign="middle">
                    <div class="social-media">
                        <ul class="social-list unstyled horizontal-list pull-right">
                            <#if (site.twitter_tweet_button)!false == true><#assign twitterShare=true/><li title="<@s 'Tweet this Post'/>" class="btn-social twitter -tooltip"></li></#if>
                            <#if (site.facebook_like)!false == true><#assign facebookShare=true/><li title="<@s 'Share on Facebook'/>" class="btn-social facebook -tooltip"></li></#if>
                            <#if (site.google_plus_one)!false == true><#assign googlePlusShare=true/><li title="<@s 'Share on Google+'/>" class="btn-social googleplus -tooltip"></li></#if>
                        </ul>
                    </div>
                </td>
        </tr></tbody>
	</table>
