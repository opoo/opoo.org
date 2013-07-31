package org.opoo.website.plugin;

import java.util.List;

import org.opoo.press.Plugin;
import org.opoo.press.Post;
import org.opoo.press.Registry;
import org.opoo.press.Site;
import org.opoo.press.filter.SiteFilterAdapter;

public class OpooOrgPlugin implements Plugin{

	@Override
	public void initialize(Registry reg) {
		reg.registerSiteFilter(new MyTestSiteFilter());
	}
	
	static class MyTestSiteFilter extends SiteFilterAdapter{
		
		@Override
		public int getOrder() {
			return super.getOrder() + 100;
		}

		@Override
		public void postWrite(Site site) {
			List<Post> posts = site.getPosts();
			System.out.println("==> 总计处理文章：" + posts.size());
			for(Post post: posts){
				System.out.println(post.getTitle());
			}
			super.postWrite(site);
		}
	}
}
