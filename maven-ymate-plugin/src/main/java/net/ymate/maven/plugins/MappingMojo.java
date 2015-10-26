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

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 控制器请求方法生成器
 *
 * @author 刘镇 (suninformation@163.com) on 15/10/25 下午11:41
 * @version 1.0
 */
@Mojo(name = "mapping")
public class MappingMojo extends AbstractTmplMojo {

    /**
     * 控制器名称
     */
    @Parameter(property = "name", required = true)
    private String controllerName;

    /**
     * 控制器存放的包名称
     */
    @Parameter(property = "package", defaultValue = "${project.groupId}.controllers")
    private String packageName;

    /**
     * 控制器后缀, 默认为XxxxController
     */
    @Parameter(property = "suffix", defaultValue = "Controller")
    private String suffix;

    /**
     * 控制器方法名称
     */
    @Parameter(property = "method", required = true)
    private String methodName;

    /**
     * 控制器方法参数
     */
    @Parameter(property = "method.param")
    private String[] methodParam;

    /**
     * 控制器请求根路径
     */
    @Parameter(property = "mapping")
    private String mapping;

    /**
     * 控制器请求方法
     */
    @Parameter(property = "mapping.method")
    private String[] mappingMethod;

    /**
     * 控制器请求头
     */
    @Parameter(property = "mapping.header")
    private String[] mappingHeader;

    /**
     * 控制器请求参数
     */
    @Parameter(property = "mapping.param")
    private String[] mappingParam;

    /**
     * 是否添加@FileUpload注解
     */
    @Parameter(property = "fileUpload")
    private boolean fileUpload;

    /**
     * 是否添加@Transaction注解
     */
    @Parameter(property = "transaction")
    private boolean transaction;

    public void execute() throws MojoExecutionException, MojoFailureException {
        Map<String, Object> _props = new HashMap<String, Object>();
        //
        String _controllerName = controllerName.concat(suffix);
        //
        _props.put("fileUpload", fileUpload);
        _props.put("transaction", transaction);
        //
        List<String> _finalParams = new ArrayList<String>();
        for (String _param : methodParam) {
            String[] _paramArr = StringUtils.split(_param, ":");
            String _type = "@RequestParam";
            String _fieldType = null;
            if (_paramArr.length >= 2) {
                if (_paramArr[0].equalsIgnoreCase("path")) {
                    _type = "@PathVariable";
                } else if (_paramArr[0].equalsIgnoreCase("header")) {
                    _type = "@RequestHeader";
                } else if (_paramArr[0].equalsIgnoreCase("cookie")) {
                    _type = "@CookieVariable";
                } else if (_paramArr[0].equalsIgnoreCase("model")) {
                    _type = "@ModelBind";
                } else if (_paramArr[0].equalsIgnoreCase("file")) {
                    _fieldType = "IUploadFileWrapper";
                }
            }
            switch (_paramArr.length) {
                case 1:
                    _finalParams.add(_type + " String " + StringUtils.uncapitalize(_paramArr[0]));
                    break;
                case 2:
                    _finalParams.add(_type + " " + StringUtils.defaultIfEmpty(_fieldType, "String") + " " + StringUtils.uncapitalize(_paramArr[1]));
                    break;
                case 3:
                    _finalParams.add(_type + " " + StringUtils.defaultIfEmpty(_fieldType, _paramArr[1]) + " " + StringUtils.uncapitalize(_paramArr[2]));
                    break;
                case 4:
                    _finalParams.add(_type + "(\"" + _paramArr[1] + "\") " + StringUtils.defaultIfEmpty(_fieldType, _paramArr[2]) + " " + StringUtils.uncapitalize(_paramArr[3]));
                    break;
                default:
                    throw new IllegalArgumentException("method.param");
            }
        }
        Map<String, Object> _method = new HashMap<String, Object>();
        _method.put("name", methodName);
        _method.put("param", _finalParams);
        //
        _props.put("method", _method);
        //
        Map<String, Object> _mapping = new HashMap<String, Object>();
        _mapping.put("mapping", mapping);
        _mapping.put("method", mappingMethod);
        _mapping.put("header", mappingHeader);
        _mapping.put("param", mappingParam);
        //
        _props.put("mapping", _mapping);
        //
        getLog().info("properties:");
        getLog().info("\t|--controllerName:" + _controllerName);
        getLog().info("\t|--fileUpload:" + fileUpload);
        getLog().info("\t|--transaction:" + transaction);
        getLog().info("\t|--method:" + methodName);
        for (String _v : methodParam) {
            getLog().info("\t  |--param:" + _v);
        }
        if (!StringUtils.isBlank(mapping)) {
            getLog().info("\t|--mapping:" + mapping);
            for (String _v : mappingMethod) {
                getLog().info("\t  |--method:" + _v.toUpperCase());
            }
            for (String _v : mappingHeader) {
                getLog().info("\t  |--header:" + _v);
            }
            for (String _v : mappingParam) {
                getLog().info("\t  |--param:" + _v);
            }
        }
        //
        File _path = new File(basedir + "/src/main/java", packageName.replace(".", "/"));
        String _targetFileName = StringUtils.capitalize(_controllerName.concat(".java"));
        File _targetFile = new File(_path, _targetFileName);
        if (_targetFile.exists()) {
            try {
                final StringWriter _s = new StringWriter();
                __doWriterTargetFile(new OutputStream() {
                    public void write(int b) throws IOException {
                        _s.write(b);
                    }
                }, "mapping-tmpl", _props);
                //
                StringBuilder _targetContent = new StringBuilder(FileUtils.readFileToString(_targetFile, __freemarkerConfig.getOutputEncoding()));
                _targetContent.insert(_targetContent.lastIndexOf("}"), _s);
                //
                FileUtils.write(_targetFile, _targetContent, __freemarkerConfig.getOutputEncoding());
                this.getLog().info("Output file: " + _targetFile);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        } else {
            getLog().warn("Skip file not existing " + _targetFile);
        }
    }
}
