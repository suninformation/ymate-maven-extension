/*
 * Copyright 2007-2017 the original author or authors.
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
package net.ymate.maven.support;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.HanyuPinyinVCharType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;
import net.ymate.platform.persistence.jdbc.scaffold.IEntityNamedFilter;
import org.apache.commons.lang.StringUtils;

/**
 * 将汉字转换为拼音命名过滤器
 *
 * @author 刘镇 (suninformation@163.com) on 17/4/18 上午9:54
 * @version 1.0
 */
public class ChinesePinyinNamedFilter implements IEntityNamedFilter {

    public String doFilter(String original) {
        String _returnValue = null;
        try {
            HanyuPinyinOutputFormat _format = new HanyuPinyinOutputFormat();
            _format.setVCharType(HanyuPinyinVCharType.WITH_V);
            _format.setCaseType(HanyuPinyinCaseType.LOWERCASE);
            _format.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
            //
            _returnValue = PinyinHelper.toHanYuPinyinString(original, _format, "_", true);
        } catch (BadHanyuPinyinOutputFormatCombination e) {
            e.printStackTrace();
        }
        return StringUtils.defaultIfBlank(_returnValue, original);
    }
}
