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
package net.ymate.maven.plugins;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.parser.Feature;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.NullArgumentException;
import org.apache.commons.lang.StringUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.*;

/**
 * @author 刘镇 (suninformation@163.com) on 2017/10/13 下午2:47
 * @version 1.0
 */
@Mojo(name = "crud")
public class CrudMojo extends AbstractTmplMojo {

    @Parameter(property = "file", defaultValue = "misc/crud.json")
    private String fileName;

    public void execute() throws MojoExecutionException, MojoFailureException {
        File _cfgFile = new File(basedir, fileName);
        try {
            if (_cfgFile.exists() && _cfgFile.isFile()) {
                ApplicationMeta _application = new ApplicationMeta(basedir, packageBase, projectName, version,
                        JSON.parseObject(IOUtils.toString(new FileInputStream(_cfgFile), "UTF-8"), Feature.OrderedField));
                //
                if (_application.isLocked()) {
                    getLog().info("CRUD has been locked.");
                } else {
                    Map<String, Object> _sqlMap = new HashMap<String, Object>();
                    //
                    for (ApiMeta _api : _application.getApis()) {
                        Map<String, Object> _props = new HashMap<String, Object>();
                        _props.put("app", _application.toMap());
                        _props.put("api", _api.toMap());
                        _props.put("security", _application.getSecurity());
                        _props.put("query", _api.isQuery());
                        _props.put("upload", _api.isUpload());
                        if (_api.isQuery()) {
                            _sqlMap.put(_api.getName(), _api.getQuery());
                        }
                        if (_api.isLocked()) {
                            getLog().info("API " + _api.getName() + " has been locked.");
                        } else {
                            String _apiName = StringUtils.capitalize(_api.getName());
                            //
                            __doWriteSingleFile(_application.buildJavaFilePath("controller/" + _apiName + "Controller.java"), "crud/controller-tmpl", _props);
                            __doWriteSingleFile(_application.buildJavaFilePath("repository/impl/" + _apiName + "Repository.java"), "crud/repository-tmpl", _props);
                            __doWriteSingleFile(_application.buildJavaFilePath("repository/I" + _apiName + "Repository.java"), "crud/repository-interface-tmpl", _props);
                        }
                    }
                    if (!_sqlMap.isEmpty()) {
                        Map<String, Object> _props = new HashMap<String, Object>();
                        _props.put("app", _application.toMap());
                        _props.put("sqls", _sqlMap);
                        //
                        String _projectName = StringUtils.capitalize(_application.getName());
                        String _cfgFileName = "cfgs/" + _projectName.toLowerCase() + ".repo.xml";
                        //
                        _props.put("cfgFileName", _cfgFileName);
                        //
                        __doWriteSingleFile(_application.buildResourceFilePath(_cfgFileName), "crud/config-file-tmpl", _props);
                        __doWriteSingleFile(_application.buildJavaFilePath("config/" + _projectName + "RepositoryConfig.java"), "crud/config-tmpl", _props);
                    }
                }
            } else {
                Map<String, Object> _props = new HashMap<String, Object>();
                _props.put("projectName", projectName);
                _props.put("packageName", packageBase);
                _props.put("version", version);
                __doWriteSingleFile(_cfgFile, "crud/crud-config-tmpl", _props);
            }
        } catch (IOException e) {
            throw new MojoExecutionException(e.getMessage(), e);
        }
    }

    //

    static class ApplicationMeta {

        private Map<String, Object> __attrs = new HashMap<String, Object>();

        private List<ApiMeta> __apis = new ArrayList<ApiMeta>();

        private Map<String, Object> __security = new HashMap<String, Object>();

        private String __basePath;

        ApplicationMeta(String basedir, String packageBase, String projectBase, String versionBase, JSONObject config) {
            __basePath = basedir;
            JSONObject _application = config.getJSONObject("application");
            if (_application == null) {
                _application = new JSONObject();
            }
            __attrs.put("name", StringUtils.defaultIfBlank(_application.getString("name"), projectBase));
            __attrs.put("packageName", StringUtils.defaultIfBlank(_application.getString("package"), packageBase));
            __attrs.put("version", StringUtils.defaultIfBlank(_application.getString("version"), versionBase));
            __attrs.put("author", StringUtils.defaultIfBlank(_application.getString("author"), "ymatescaffold"));
            __attrs.put("createTime", _application.getString("createTime"));
            __attrs.put("locked", _application.getBooleanValue("locked"));
            //
            JSONArray _apis = config.getJSONArray("apis");
            if (_apis != null && !_apis.isEmpty()) {
                for (int _idx = 0; _idx < _apis.size(); _idx++) {
                    __apis.add(new ApiMeta(_apis.getJSONObject(_idx)));
                }
            }
            //
            JSONObject _security = config.getJSONObject("security");
            boolean _enabled = _security != null && _security.getBooleanValue("enabled");
            __security.put("enabled", _enabled);
            if (_enabled) {
                __security.put("name", _security.getString("name"));
                __security.put("prefix", StringUtils.trimToEmpty(_security.getString("prefix")).toUpperCase());
                //
                JSONObject _roles = _security.getJSONObject("roles");
                if (_roles != null && (_roles.getBooleanValue("admin") || _roles.getBooleanValue("operator") || _roles.getBooleanValue("user"))) {
                    List<String> _roleList = new ArrayList<String>();
                    if (_roles.getBooleanValue("admin")) {
                        _roleList.add("ISecurity.Role.ADMIN");
                    }
                    if (_roles.getBooleanValue("operator")) {
                        _roleList.add("ISecurity.Role.OPERATOR");
                    }
                    if (_roles.getBooleanValue("user")) {
                        _roleList.add("ISecurity.Role.USER");
                    }
                    __security.put("roles", _roleList.toArray());
                }
                //
                JSONArray _permissions = _security.getJSONArray("permissions");
                if (_permissions != null && !_permissions.isEmpty()) {
                    List<String> _pList = new ArrayList<String>();
                    for (int _idx = 0; _idx < _permissions.size(); _idx++) {
                        _pList.add(_permissions.getString(_idx).toUpperCase());
                    }
                    __security.put("permissions", _pList.toArray());
                }
            }
        }

        File buildJavaFilePath(String filePathName) {
            File _base = new File(__basePath + "/src/main/java", ((String) __attrs.get("packageName")).replace(".", "/"));
            return new File(_base, filePathName);
        }

        File buildResourceFilePath(String filePathName) {
            return new File(__basePath + "/src/main/webapp/WEB-INF/", filePathName);
        }

        String getName() {
            return (String) __attrs.get("name");
        }

        boolean isLocked() {
            return (Boolean) __attrs.get("locked");
        }

        List<ApiMeta> getApis() {
            return __apis;
        }

        Map<String, Object> getSecurity() {
            return __security;
        }

        Map<String, Object> toMap() {
            return __attrs;
        }
    }

    static class ApiMeta {

        private Map<String, Object> __attrs = new LinkedHashMap<String, Object>();

        private boolean __query;

        private boolean __upload;

        ApiMeta(JSONObject config) {
            if (config == null) {
                throw new NullArgumentException("config");
            }
            String _name = config.getString("name");
            if (StringUtils.isBlank(_name)) {
                throw new IllegalArgumentException("api name can not null.");
            }
            __attrs.put("name", _name);
            //
            String _mapping = StringUtils.defaultIfBlank(config.getString("mapping"), _name.toLowerCase());
            if (!StringUtils.startsWith(_mapping, "/")) {
                _mapping = "/" + _mapping;
            }
            __attrs.put("mapping", _mapping);
            //
            String _type = StringUtils.defaultIfBlank(config.getString("type"), "model");
            __attrs.put("type", _type);
            //
            if (StringUtils.equalsIgnoreCase(_type, "model")) {
                String _model = config.getString("model");
                if (StringUtils.isBlank(_model)) {
                    throw new IllegalArgumentException("api model can not null.");
                }
                __attrs.put("model", _model);
            } else if (StringUtils.equalsIgnoreCase(_type, "query")) {
                String _query = config.getString("query");
                if (StringUtils.isBlank(_query)) {
                    throw new IllegalArgumentException("api query can not null.");
                }
                __attrs.put("query", _query);
                __query = true;
            } else {
                throw new IllegalArgumentException("api model or query can not null.");
            }
            //
            __attrs.put("locked", config.getBooleanValue("locked"));
            __attrs.put("description", config.getString("description"));
            //
            JSONObject _primary = config.getJSONObject("primary");
            if (_primary == null) {
                throw new NullArgumentException("primary");
            }
            __attrs.put("primary", new ApiParameter(_primary).toMap());
            //
            JSONArray _params = config.getJSONArray("params");
            if (_params != null && !_params.isEmpty()) {
                List<Map<String, Object>> _paramList = new ArrayList<Map<String, Object>>();
                for (int _idx = 0; _idx < _params.size(); _idx++) {
                    ApiParameter _param = new ApiParameter(_params.getJSONObject(_idx));
                    if (_param.isUpload()) {
                        __upload = true;
                    }
                    _paramList.add(_param.toMap());
                }
                __attrs.put("params", _paramList);
            }
        }

        String getName() {
            return (String) __attrs.get("name");
        }

        String getQuery() {
            return (String) __attrs.get("query");
        }

        boolean isQuery() {
            return __query;
        }

        boolean isLocked() {
            return (Boolean) __attrs.get("locked");
        }

        boolean isUpload() {
            return __upload;
        }

        Map<String, Object> toMap() {
            return __attrs;
        }
    }

    static class ApiParameter {

        private Map<String, Object> __attrs = new HashMap<String, Object>();

        private boolean __upload;

        ApiParameter(JSONObject config) {
            if (config == null) {
                throw new NullArgumentException("config");
            }
            String _name = config.getString("name");
            if (StringUtils.isBlank(_name)) {
                throw new IllegalArgumentException("param name can not null.");
            }
            __attrs.put("name", _name);
            //
            String _column = config.getString("column");
            if (StringUtils.isBlank(_column)) {
                throw new IllegalArgumentException("param column can not null.");
            }
            __attrs.put("column", _column);
            //
            __attrs.put("label", StringUtils.trimToEmpty(config.getString("label")));
            __attrs.put("type", StringUtils.defaultIfBlank(config.getString("type"), "string"));
            __attrs.put("max", config.getIntValue("max"));
            __attrs.put("min", config.getIntValue("min"));
            __attrs.put("regex", StringUtils.trimToEmpty(config.getString("regex")));
            __attrs.put("numeric", config.getBooleanValue("numeric"));
            __attrs.put("datetime", config.getBooleanValue("datetime"));
            __attrs.put("required", config.getBooleanValue("required"));
            __attrs.put("filter", config.getBooleanValue("filter"));
            __attrs.put("like", config.getBooleanValue("like"));
            //
            Map<String, Object> _uploadMap = new HashMap<String, Object>();
            JSONObject _upload = config.getJSONObject("upload");
            if (_upload != null && _upload.getBooleanValue("enabled")) {
                __upload = true;
                JSONArray _types = _upload.getJSONArray("contentTypes");
                List<String> _contentTypes = new ArrayList<String>();
                if (_types != null) {
                    for (int _idx = 0; _idx < _types.size(); _idx++) {
                        _contentTypes.add(_types.getString(_idx));
                    }
                }
                _uploadMap.put("contentTypes", _contentTypes);
                //
            }
            _uploadMap.put("enabled", __upload);
            __attrs.put("upload", _uploadMap);
            __attrs.put("description", StringUtils.trimToEmpty(config.getString("description")));
        }

        boolean isUpload() {
            return __upload;
        }

        Map<String, Object> toMap() {
            return __attrs;
        }
    }
}
