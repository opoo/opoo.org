package org.opoo.website.plugin;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.opoo.press.Post;
import org.opoo.press.Site;
import org.opoo.press.SiteFilter;
import org.opoo.press.filter.SiteFilterAdapter;

/**
 * @author Alex Lin
 *
 */
public class ImgFinder extends SiteFilterAdapter implements SiteFilter {

	/* (non-Javadoc)
	 * @see org.opoo.press.Ordered#getOrder()
	 */
	@Override
	public int getOrder() {
		return Integer.MAX_VALUE - 100;
	}
	
	/* (non-Javadoc)
	 * @see org.opoo.press.filter.SiteFilterAdapter#postConvertPost(org.opoo.press.Site, org.opoo.press.Post)
	 */
	@Override
	public void postConvertPost(Site site, Post post) {
		String snapshot = (String) post.get("snapshot");
		if(StringUtils.isNotBlank(snapshot)){
			System.out.println("文章【" + post.getTitle() + "】使用 Snapshot 作为第一张图：" + snapshot);
			post.set("first_img_src", snapshot);
			return;
		}

		//String htmlStr = findHtmlStr(post.getContent());
		String firstImgStr = getFirstImgStr(post.getContent());
		
		if(firstImgStr != null){
			System.out.println("文章【" + post.getTitle() + "】第一张图：" + firstImgStr);
			if(firstImgStr.startsWith("/wp-content/uploads")){
				firstImgStr = "//opoo.org" + firstImgStr;
			}
			post.set("first_img_src", firstImgStr);
		}
	}

	public static String findHtmlStr(String html){
		String start = "tp-article-title";
		String end = "tp-like-bar";
		return StringUtils.substringBetween(html, start, end);
	}

	public static String getFirstImgStr(String htmlStr) {
		if(StringUtils.isBlank(htmlStr)){
			return null;
		}
		String reg = "<img.*src=(.*?)[^>]*?>"; // 图片链接地址
		Pattern p = Pattern.compile(reg, Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(htmlStr);
		if (m.find()) {
			String group = m.group();
			//System.out.println(group);
			Matcher m2 = Pattern.compile("src=\"?(.*?)(\"|>|\\s+)").matcher(group); // 匹配src
			if (m2.find()) {
				return m2.group(1);
			}
		}
		return null;
	}
}
