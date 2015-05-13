                <#assign year = "0000">
				<#list posts as post>
				<#assign this_year = post.date?string("yyyy")>
				<#if year != this_year>
				<#if year != "0000"></ul></#if>
				<#assign year = this_year>
				  <h2>${ year }</h2>
				  <ul class="archive-list">
				</#if>
					<li>
					
					<a href="${root_url}${post.url}">${post.title}</a>
					
					<div class="footer">
						<#--
						<i class="icon-user"></i>
						<a href="#">${site.author}</a>
						-->
						<i class="icon-time alpha60"></i>
						<span class="post-date"><time datetime="${post.date?datetime?iso_local}">${post.date?string("yyyy-MM-dd")}</time></span>

						<div class="pull-right">
							<#if post.tags?? && (post.tags?size > 0)>
							<i class="opoo-tags xicon-opoo-tags" title="Tags"></i>
							<span class="tags"><@tag_links post.tags/></span>
							</#if>
							
							<#if post.categories?? && (post.categories?size > 0)>
							<i class="opoo-folder-open xicon-opoo-categories" title="Categories"></i>
							<span class="categories"><@category_links post.categories/></span>
							</#if>
						</div>
					</div>
					
					</li>
				</#list>
				</ul>