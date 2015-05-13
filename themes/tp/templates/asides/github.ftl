<#if site.github_user??>
<#assign showGitHubRepos = true>
<div class="tp-box-content">
    <div class="tp-box">
    <h3>On GitHub</h3>

      <ul id="gh_repos">
        <li class="loading">Status updating...</li>
      </ul>

      <#if site.github_show_profile_link>
        <a class="github-follow" href="https://github.com/${site.github_user}">@${site.github_user}</a> on GitHub
      </#if>
    </div>
</div>
</#if>
