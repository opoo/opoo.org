/*
 * Copyright 2013-2015 Alex Lin.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.opoo.press.theme.tp;

import org.apache.commons.lang.StringUtils;
import org.opoo.press.Page;
import org.opoo.press.Post;
import org.opoo.press.ProcessorAdapter;
import org.opoo.press.Site;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Alex Lin
 */
public class SnapshotImageProcessor extends ProcessorAdapter{
    public static final String SNAPSHOT_KEY = "snapshot";

    @Override
    public int getOrder() {
        return Integer.MAX_VALUE - 100;
    }

    @Override
    public void postConvert(Site site, Page page) {
        if(!(page instanceof Post)){
            return;
        }

        Post post = (Post) page;
        String snapshot = post.get(SNAPSHOT_KEY);
        if(StringUtils.isNotBlank(snapshot)) {
            System.out.println("-- [SnapshotImageProcessor] using snapshot: --" + snapshot);
            return;
        }

        String firstImgSrc = findFirstImgSrc(post.getContent());

        if(firstImgSrc != null){
            System.out.println("-- [SnapshotImageProcessor] first img of '" + post.getUrl() + "' is : " + firstImgSrc);
            post.set("snapshot", firstImgSrc);
        }

    }

    public static String findFirstImgSrc(String html) {
        if(StringUtils.isBlank(html)){
            return null;
        }
        String reg = "<img.*src=(.*?)[^>]*?>"; // img src regex
        Pattern p = Pattern.compile(reg, Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(html);
        if (m.find()) {
            String group = m.group();
            //match src
            Matcher m2 = Pattern.compile("src=\"?(.*?)(\"|>|\\s+)").matcher(group);
            if (m2.find()) {
                return m2.group(1);
            }
        }
        return null;
    }
}
