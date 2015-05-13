<#assign fullUrl = site.url + root_url + page.url>
<#-- google cdn -->
<#--
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script language="JavaScript">
< ! - -
    !window.jQuery && document.write(unescape('%3Cscript src="${site.theme_root}/javascripts/libs/jquery.min.js"%3E%3C/script%3E'));
/ / - - >
</script>
-->
<#--
<script type="text/javascript" src="${root_url}/javascripts/libs/modernizr.video.min.js"></script>
<script type="text/javascript" src="${root_url}/javascripts/libs/jquery.min.js"></script>
<script type="text/javascript" src="${root_url}/javascripts/libs/bootstrap.min.js"></script>
<script type="text/javascript" src="${root_url}/javascripts/libs/swfobject-modified.min.js"></script>
<script type="text/javascript" src="${root_url}/javascripts/libs/opoopress.js"></script>
-->
<script type="text/javascript" src="${site.theme_root}/javascripts/opoopress-v2-20140916.min.js"></script>
<#-- <script src="/javascripts/opoopress.min.js"></script> -->
<script type="text/javascript">
<!--
    window.OpooPress = new OpooPressApp({siteUrl:'${site.url}',rootUrl:'${root_url}',pageUrl:'${page.url}',<#if page.title??>title:'${page.title}',</#if><#if showGitHubRepos??>github:{target:'#gh_repos',user:'${site.github_user}',count:${site.github_repo_count},skip_forks:${site.github_skip_forks?string}},</#if><#if showDeliciousLinks??>delicious:{user:'${site.delicious_user}',count:'${site.delicious_count}'},</#if>socialShare:{<#if twitterShare??>twitterShare:true,twitterAccount:'${site.twitter_user}',twitterUsername:'@${site.twitter_user}',</#if><#if facebookShare??>facebookShare:true,</#if><#if googlePlusShare??>googlePlusShare:true,</#if>dummy:1},needLoadMore:true,refreshRelativeTimes:true,verbose:false},{});
    OpooPress.init();
<#if showComments!false == true>
    var disqus_shortname = '${ site.disqus_short_name }';
    <#if index??>OpooPress.showDisqusCommentCount();<#else>
    // var disqus_developer = 1;
    var disqus_identifier = '${fullUrl}';
    var disqus_url = '${fullUrl}';
    <#if page.title??>var disqus_title = '${page.title}';</#if>
    //var disqus_category_id = '';
    OpooPress.showDisqusWidgets();</#if>
</#if>
//-->
</script>
<#include "google_analytics.ftl">
<#include "custom/after_footer.ftl">
<#if tagsfilter??>
<script language="JavaScript" src="/javascripts/post.js"></script>
<script language="JavaScript">
<!--

window.checkedTagUrls = [];

$('.btn-tag').each(function(i, btn){
	btn = $(btn);
	var url = btn.data('url');
	//tagNames[url] = btn.text();
	btn.on('click', function(){
        var index = checkedTagUrls.indexOf(url);
        if(index >= 0){
            checkedTagUrls.splice(index, 1)
            btn.removeClass('btn-success');
        }else{
            checkedTagUrls.push(url);
            btn.addClass('btn-success');
        }
        refreshShow();
        //btn.toggleClass('btn-success');
		return false;
	});
});

function search(posts, tagUrls, tagUrlIndex){
	if(tagUrlIndex >= tagUrls.length){
		return posts;
	}

	var tagUrl = tagUrls[tagUrlIndex];
	var result = new Array();
	for(var i = 0 ; i < posts.length; i++){
		var post = posts[i];
		//document.writeln(post);
		if(post.tags && post.tags.indexOf(tagUrl) >= 0){
			result.push(post);
		}
	}

	return search(result, tagUrls, tagUrlIndex + 1);
};

function refreshShow(){
	var checkedPosts = search(sitePosts, checkedTagUrls, 0);
	var checkedPostsHtml = checkedPosts.map(function(p){return '<li><a href="' + p.url + '">' + p.title + '</a></li>';}).join("");
	$('#checkedPostsContainer').html(checkedPostsHtml);
}

refreshShow();

//-->
</script>
</#if>