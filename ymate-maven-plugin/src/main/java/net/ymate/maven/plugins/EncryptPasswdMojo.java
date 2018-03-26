/*
 * Copyright 2007-2016 the original author or authors.
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
package net.ymate.maven.plugins;

import net.ymate.platform.core.support.IPasswordProcessor;
import net.ymate.platform.core.support.impl.DefaultPasswordProcessor;
import net.ymate.platform.core.util.ClassUtils;
import net.ymate.platform.core.util.RuntimeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

/**
 * @author 刘镇 (suninformation@163.com) on 16/12/17 上午5:52
 * @version 1.0
 */
@Mojo(name = "enpasswd")
public class EncryptPasswdMojo extends AbstractTmplMojo {

    @Parameter(property = "passwd", required = true)
    private String passwd;

    @Parameter(property = "passkey")
    private String passkey;

    @Parameter(property = "implClass")
    private String implClass;

    public void execute() throws MojoExecutionException, MojoFailureException {
        try {
            IPasswordProcessor _processor = ClassUtils.impl(StringUtils.defaultIfBlank(implClass, DefaultPasswordProcessor.class.getName()), IPasswordProcessor.class, this.getClass());
            if (StringUtils.isNotBlank(passkey)) {
                _processor.setPassKey(passkey);
            }
            getLog().info("Use passkey: " + _processor.getPassKey());
            getLog().info("Encrypt password: " + _processor.encrypt(passwd));
        } catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), RuntimeUtils.unwrapThrow(e));
        }
    }
}
