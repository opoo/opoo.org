<div class="sharing">
  <#if (site.twitter_tweet_button)!false == true>
  <a href="http://twitter.com/share" class="twitter-share-button" data-url="${ site.url }${root_url}${ page.url }" data-via="${ site.twitter_user }" data-counturl="${ site.url }${root_url}${ page.url }" >Tweet</a>
  </#if>
  <#if (site.google_plus_one)!false == true>
  <#-- <div class="g-plusone" data-size="small"></div> -->
  <g:plusone size="${ site.google_plus_one_size }"></g:plusone>
  </#if>
  <#if (site.facebook_like)!false == true>
    <div class="fb-like" data-send="true" data-width="450" data-show-faces="false"></div>
  </#if>
</div>
