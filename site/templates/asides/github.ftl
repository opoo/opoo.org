<#if site.github_user??>
<section>
  <h1>GitHub Repos</h1>
  <ul id="gh_repos">
    <li class="loading">Status updating...</li>
  </ul>
  <#if site.github_show_profile_link>
  <a href="https://github.com/${site.github_user}">@${site.github_user}</a> on GitHub
  </#if>
  <script type="text/javascript">
    $(document).ready(function(){
        if (!window.jXHR){
            var jxhr = document.createElement('script');
            jxhr.type = 'text/javascript';
            jxhr.src = '${ root_url}/javascripts/libs/jXHR.js';
            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(jxhr, s);
        }

        github.showRepos({
            user: '${site.github_user}',
            count: ${site.github_repo_count},
            skip_forks: ${site.github_skip_forks?string},
            target: '#gh_repos'
        });
    });
  </script>
  <script src="${ root_url }/javascripts/github.js" type="text/javascript"> </script>
</section>
</#if>
