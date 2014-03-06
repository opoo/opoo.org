                <#assign x = paginator.pageNumber>
				<#assign n = paginator.totalPages>

				<div class="pagination">
				  <ul>
                    <li class="disabled"><a href="javascript:void();" title="Page ${x} of ${n}">${x}/${n}</a></li>
					<#if (paginator.previous)??><li><a href="${root_url}${paginator.previous.url}">&laquo;</a></li></#if>
					<#if (x > 3)><li><a href="${root_url}${page.getPage(1).url}">1</a></li></#if>
					<#if (x > 4)><li><a href="javascript:void();">...</a></li></#if>
					<#if (x > 2)><li><a href="${root_url}${page.getPage(x-2).url}">${x-2}</a></li></#if>
					<#if (x > 1)><li><a href="${root_url}${page.getPage(x-1).url}">${x-1}</a></li></#if>
					<li class="active"><a href="javascript:void();">${x}</a></li>
					<#if (x < n)><li><a href="${root_url}${page.getPage(x+1).url}">${x+1}</a></li></#if>
					<#if (x < (n-1))><li><a href="${root_url}${page.getPage(x+2).url}">${x+2}</a></li></#if>
					<#if (x < (n-3))><li><a href="javascript:void();">...</a></li></#if>
					<#if (x < (n-2))><li><a href="${root_url}${page.getPage(n).url}">${n}</a></li></#if>
					<#if (paginator.next)??><li><a href="${root_url}${paginator.next.url}">&raquo;</a></li></#if>
				  </ul>
				</div>
