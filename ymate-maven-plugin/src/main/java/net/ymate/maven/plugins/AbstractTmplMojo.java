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

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapperBuilder;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.*;
import java.util.Map;

/**
 * @author 刘镇 (suninformation@163.com) on 15/10/26 上午12:24
 * @version 1.0
 */
public abstract class AbstractTmplMojo extends AbstractMojo {

    private String __TEMPLATE_ROOT_PATH;

    protected Configuration __freemarkerConfig;

    /**
     * 当前项目基准路径
     */
    @Parameter(defaultValue = "${basedir}")
    protected String basedir;

    /**
     * 是否覆盖已存在的文件
     */
    @Parameter(property = "overwrite")
    protected boolean overwrite;

    public AbstractTmplMojo() {
        __TEMPLATE_ROOT_PATH = this.getClass().getPackage().getName().replace(".", "/");
        //
        __freemarkerConfig = new Configuration(Configuration.VERSION_2_3_22);
        __freemarkerConfig.setDefaultEncoding("UTF-8");
        __freemarkerConfig.setOutputEncoding("UTF-8");
        __freemarkerConfig.setClassForTemplateLoading(this.getClass(), "/");
        __freemarkerConfig.setObjectWrapper(new DefaultObjectWrapperBuilder(Configuration.VERSION_2_3_22).build());
        __freemarkerConfig.setTemplateExceptionHandler(TemplateExceptionHandler.DEBUG_HANDLER);
    }

    protected void __doWriterTargetFile(String path, String fileName, String tmplFile, Map<String, Object> properties) throws IOException, TemplateException {
        File _outputFile = new File(path, fileName);
        __doWriterTargetFile(new FileOutputStream(_outputFile), tmplFile, properties);
        this.getLog().info("Output file: " + _outputFile);
    }

    protected void __doWriterTargetFile(OutputStream output, String tmplFile, Map<String, Object> properties) throws IOException, TemplateException {
        if (tmplFile.charAt(0) != '/') {
            tmplFile = "/".concat(tmplFile);
        }
        if (!tmplFile.startsWith("/tmpl")) {
            tmplFile = "/tmpl".concat(tmplFile);
        }
        if (!tmplFile.endsWith(".ftl")) {
            tmplFile = tmplFile.concat(".ftl");
        }
        Writer _outWriter = null;
        try {
            _outWriter = new OutputStreamWriter(output, __freemarkerConfig.getOutputEncoding());
            __freemarkerConfig.getTemplate(__TEMPLATE_ROOT_PATH + tmplFile).process(properties, new BufferedWriter(_outWriter));
        } finally {
            if (_outWriter != null) {
                _outWriter.flush();
                _outWriter.close();
            }
        }
    }
}