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
import com.alibaba.fastjson.annotation.JSONField;
import com.alibaba.fastjson.parser.Feature;
import com.alibaba.fastjson.serializer.SerializerFeature;
import net.ymate.platform.core.YMP;
import net.ymate.platform.core.lang.PairObject;
import net.ymate.platform.core.util.ClassUtils;
import net.ymate.platform.core.util.RuntimeUtils;
import net.ymate.platform.persistence.base.EntityMeta;
import net.ymate.platform.persistence.jdbc.IDatabase;
import net.ymate.platform.persistence.jdbc.JDBC;
import net.ymate.platform.persistence.jdbc.scaffold.Attr;
import net.ymate.platform.persistence.jdbc.scaffold.ColumnInfo;
import net.ymate.platform.persistence.jdbc.scaffold.ConfigInfo;
import net.ymate.platform.persistence.jdbc.scaffold.TableInfo;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.NullArgumentException;
import org.apache.commons.lang.StringUtils;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;

import java.io.File;
import java.io.FileInputStream;
import java.util.*;

/**
 * @author 刘镇 (suninformation@163.com) on 2017/10/13 下午2:47
 * @version 1.0
 */
@Mojo(name = "crud")
public class CrudMojo extends AbstractTmplMojo {

    @Parameter(property = "file", defaultValue = "misc/crud.json")
    private String fileName;

    @Parameter(property = "action")
    private String action;

    @Parameter(property = "filter")
    private String[] filter;

    @Parameter(property = "fromDb")
    private boolean fromDb;

    @Parameter(property = "formBean")
    private boolean formBean;

    @Parameter(property = "withDoc")
    private boolean withDoc;

    @Parameter(property = "mapping", defaultValue = "v1")
    private String mapping;

    public void execute() throws MojoExecutionException, MojoFailureException {
        File _cfgFile = new File(basedir, fileName);
        try {
            if (_cfgFile.exists() && _cfgFile.isFile()) {
                ApplicationInfo _application = JSON.parseObject(new FileInputStream(_cfgFile), ApplicationInfo.class, Feature.OrderedField);
                _application.checkDefaultValue(basedir, packageBase, projectName, version);
                //
                if (_application.isLocked()) {
                    getLog().info("CRUD has been locked.");
                } else {
                    Map<String, Object> _sqlMap = new HashMap<String, Object>();
                    //
                    for (ApiInfo _api : _application.getApis()) {
                        boolean _matched = false;
                        if (!ArrayUtils.isEmpty(filter)) {
                            for (String _item : filter) {
                                if (StringUtils.equalsIgnoreCase(_item, _api.getName())) {
                                    getLog().info("API Name: " + _api.getName() + " has been filtered.");
                                    _matched = true;
                                    break;
                                }
                            }
                        }
                        if (!_matched) {
                            _api.checkDefaultValue();
                            //
                            boolean _isQuery = StringUtils.equalsIgnoreCase(_api.getModel(), "query");
                            //
                            Map<String, Object> _props = new HashMap<String, Object>();
                            _props.put("app", _application.toMap());
                            _props.put("api", _api.toMap());
                            _props.put("security", _application.getSecurity().toMap());
                            _props.put("intercept", _application.getIntercept());
                            _props.put("query", _isQuery);
                            _props.put("upload", _api.isUpload());
                            //
                            _props.put("formbean", formBean && !_api.getParams().isEmpty());
                            _props.put("withDoc", withDoc);
                            //
                            if (_isQuery) {
                                _sqlMap.put(_api.getName(), _api.getQuery());
                            }
                            if (_api.isLocked()) {
                                getLog().info("API " + _api.getName() + " has been locked.");
                            } else {
                                String _apiName = StringUtils.capitalize(_api.getName());
                                //
                                if (formBean && !_api.getParams().isEmpty()) {
                                    __doWriteSingleFile(_application.buildJavaFilePath("dto/" + _apiName + "FormBean.java"), "crud/formbean-tmpl", _props);
                                    __doWriteSingleFile(_application.buildJavaFilePath("dto/" + _apiName + "UpdateFormBean.java"), "crud/formbean-update-tmpl", _props);
                                }
                                //
                                if (StringUtils.isBlank(action) || StringUtils.equalsIgnoreCase(action, "controller")) {
                                    __doWriteSingleFile(_application.buildJavaFilePath("controller/" + _apiName + "Controller.java"), "crud/controller-tmpl", _props);
                                }
                                if (StringUtils.isBlank(action) || StringUtils.equalsIgnoreCase(action, "repository")) {
                                    __doWriteSingleFile(_application.buildJavaFilePath("repository/impl/" + _apiName + "Repository.java"), "crud/repository-tmpl", _props);
                                    __doWriteSingleFile(_application.buildJavaFilePath("repository/I" + _apiName + "Repository.java"), "crud/repository-interface-tmpl", _props);
                                }
                            }
                        }
                    }
                    if ((StringUtils.isBlank(action) || StringUtils.equalsIgnoreCase(action, "repository")) && !_sqlMap.isEmpty()) {
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
                //
                if (fromDb) {
                    _props.put("apis", __buildConfigFromDb());
                }
                __doWriteSingleFile(_cfgFile, "crud/crud-config-tmpl", _props);
            }
        } catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), RuntimeUtils.unwrapThrow(e));
        }
    }

    private String __buildConfigFromDb() throws Exception {
        YMP _owner = null;
        try {
            _owner = new YMP(__doCreateConfigBuilder().build()).init();
            IDatabase _database = JDBC.get(_owner);
            //
            ConfigInfo _config = new ConfigInfo(_owner);
            //
            StringBuilder _apisSB = new StringBuilder();
            //
            mapping = StringUtils.defaultIfBlank(mapping, "v1");
            if (StringUtils.startsWith(mapping, "/")) {
                mapping = mapping.substring(1);
            }
            //
            List<String> _tables = TableInfo.getTableNames(_database);
            for (String _tableName : _tables) {
                boolean _matched = false;
                if (!ArrayUtils.isEmpty(filter)) {
                    for (String _item : filter) {
                        if (StringUtils.equalsIgnoreCase(_item, _tableName)) {
                            getLog().info("Table Name: " + _tableName + " has been filtered.");
                            _matched = true;
                            break;
                        }
                    }
                }
                if (!_matched) {
                    TableInfo _tableInfo = TableInfo.create(_database.getDefaultConnectionHolder(), _config, _tableName, false);
                    if (_tableInfo != null) {
                        ApiInfo _info = new ApiInfo();
                        //
                        PairObject<String, String> _name = _config.buildNamePrefix(_tableName);
                        //
                        _info.setName(StringUtils.uncapitalize(_name.getKey()));
                        _info.setMapping("/" + mapping + "/" + EntityMeta.fieldNameToPropertyName(_info.getName(), 0).replace('_', '/'));
                        _info.setModel(packageBase + ".model." + _name.getKey() + (_config.isUseClassSuffix() ? "Model" : ""));
                        _info.setQuery("");
                        _info.setLocked(false);
                        _info.setTimestamp(_tableInfo.getFieldMap().containsKey("create_time"));
                        _info.setUpdateDisabled(!_tableInfo.getFieldMap().containsKey("last_modify_time"));
                        _info.setDescription("");
                        //
                        if (_tableInfo.getFieldMap() != null && !_tableInfo.getFieldMap().isEmpty() && _tableInfo.getPkSet() != null && !_tableInfo.getPkSet().isEmpty()) {
                            ColumnInfo _primaryColumn = _tableInfo.getFieldMap().get(_tableInfo.getPkSet().get(0));
                            if (_primaryColumn != null) {
                                _info.setPrimary(new ApiParameter(_primaryColumn));
                                //
                                List<ApiParameter> _params = new ArrayList<ApiParameter>();
                                for (ColumnInfo _column : _tableInfo.getFieldMap().values()) {
                                    if (!_column.isPrimaryKey()) {
                                        _params.add(new ApiParameter(_column));
                                    }
                                }
                                _info.setParams(_params);
                                _info.setStatus(Collections.<StatusInfo>emptyList());
                                //
                                if (_apisSB.length() > 0) {
                                    _apisSB.append(",\r\n\t\t");
                                }
                                _apisSB.append(JSON.toJSONString(_info, SerializerFeature.SortField, SerializerFeature.MapSortField, SerializerFeature.PrettyFormat));
                            }
                        }
                    }
                }
            }
            return _apisSB.toString();
        } catch (Exception e) {
            throw new MojoExecutionException(e.getMessage(), RuntimeUtils.unwrapThrow(e));
        } finally {
            if (_owner != null) {
                try {
                    _owner.destroy();
                } catch (Exception ignored) {
                }
            }
        }
    }

    //

    public static class ApplicationInfo {

        private String name;

        @JSONField(name = "package")
        private String packageName;

        private String version;

        private String author;

        private String createTime;

        private boolean locked;

        private List<ApiInfo> apis;

        private SecurityInfo security;

        private InterceptInfo intercept;

        private String __basePath;

        public ApplicationInfo() {
        }

        public void checkDefaultValue(String basedir, String packageBase, String projectBase, String versionBase) {
            this.__basePath = basedir;
            //
            this.name = StringUtils.defaultIfBlank(this.name, projectBase);
            this.packageName = StringUtils.defaultIfBlank(this.packageName, packageBase);
            this.version = StringUtils.defaultIfBlank(this.version, versionBase);
            this.author = StringUtils.defaultIfBlank(this.author, "ymatescaffold");
            //
            if (this.apis == null) {
                this.apis = new ArrayList<ApiInfo>();
            }
            //
            if (this.security == null) {
                this.security = new SecurityInfo();
            } else {
                this.security.checkDefaultValue();
            }
            //
            if (this.intercept == null) {
                this.intercept = new InterceptInfo();
            }
        }

        public File buildJavaFilePath(String filePathName) {
            File _base = new File(this.__basePath + "/src/main/java", this.packageName.replace(".", "/"));
            return new File(_base, filePathName);
        }

        public File buildResourceFilePath(String filePathName) {
            return new File(this.__basePath + "/src/main/webapp/WEB-INF/", filePathName);
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getPackageName() {
            return packageName;
        }

        public void setPackageName(String packageName) {
            this.packageName = packageName;
        }

        public String getVersion() {
            return version;
        }

        public void setVersion(String version) {
            this.version = version;
        }

        public String getAuthor() {
            return author;
        }

        public void setAuthor(String author) {
            this.author = author;
        }

        public String getCreateTime() {
            return createTime;
        }

        public void setCreateTime(String createTime) {
            this.createTime = createTime;
        }

        public boolean isLocked() {
            return locked;
        }

        public void setLocked(boolean locked) {
            this.locked = locked;
        }

        public List<ApiInfo> getApis() {
            return apis;
        }

        public void setApis(List<ApiInfo> apis) {
            this.apis = apis;
        }

        public SecurityInfo getSecurity() {
            return security;
        }

        public void setSecurity(SecurityInfo security) {
            this.security = security;
        }

        public InterceptInfo getIntercept() {
            return intercept;
        }

        public void setIntercept(InterceptInfo intercept) {
            this.intercept = intercept;
        }

        public Map<String, Object> toMap() {
            return ClassUtils.wrapper(this).toMap();
        }
    }

    public static class SecurityInfo {

        private boolean enabled;

        private String name;

        private String prefix;

        private RoleInfo roles;

        private List<String> permissions;

        public SecurityInfo() {
        }

        public void checkDefaultValue() {
            if (this.enabled) {
                this.prefix = StringUtils.trimToEmpty(prefix).toUpperCase();
                //
                if (this.permissions == null) {
                    this.permissions = new ArrayList<String>();
                }
            }
        }

        public boolean isEnabled() {
            return enabled;
        }

        public void setEnabled(boolean enabled) {
            this.enabled = enabled;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getPrefix() {
            return prefix;
        }

        public void setPrefix(String prefix) {
            this.prefix = prefix;
        }

        public RoleInfo getRoles() {
            return roles;
        }

        public void setRoles(RoleInfo roles) {
            this.roles = roles;
        }

        public List<String> getPermissions() {
            return permissions;
        }

        public void setPermissions(List<String> permissions) {
            this.permissions = permissions;
        }

        public Map<String, Object> toMap() {
            Map<String, Object> _returnValue = ClassUtils.wrapper(this).toMap(new ClassUtils.IFieldValueFilter() {
                public boolean filter(String fieldName, Object fieldValue) {
                    return fieldName.equals("roles");
                }
            });
            _returnValue.put("roles", roles.toArray());
            //
            return _returnValue;
        }
    }

    public static class RoleInfo {

        private boolean admin;

        private boolean operator;

        private boolean user;

        public RoleInfo() {
        }

        public boolean isAdmin() {
            return admin;
        }

        public void setAdmin(boolean admin) {
            this.admin = admin;
        }

        public boolean isOperator() {
            return operator;
        }

        public void setOperator(boolean operator) {
            this.operator = operator;
        }

        public boolean isUser() {
            return user;
        }

        public void setUser(boolean user) {
            this.user = user;
        }

        public String[] toArray() {
            List<String> _roleList = new ArrayList<String>();
            if (this.admin) {
                _roleList.add("RoleType.ADMIN");
            }
            if (this.operator) {
                _roleList.add("RoleType.OPERATOR");
            }
            if (this.user) {
                _roleList.add("RoleType.USER");
            }
            return _roleList.toArray(new String[0]);
        }
    }

    public static class InterceptInfo {

        private List<String> before;

        private List<String> after;

        private List<String> around;

        private Map<String, String> params;

        public InterceptInfo() {
        }

        public List<String> getBefore() {
            return before;
        }

        public void setBefore(List<String> before) {
            this.before = before;
        }

        public List<String> getAfter() {
            return after;
        }

        public void setAfter(List<String> after) {
            this.after = after;
        }

        public List<String> getAround() {
            return around;
        }

        public void setAround(List<String> around) {
            this.around = around;
        }

        public Map<String, String> getParams() {
            return params;
        }

        public void setParams(Map<String, String> params) {
            this.params = params;
        }

        public Map<String, Object> toMap() {
            return ClassUtils.wrapper(this).toMap();
        }
    }

    public static class StatusInfo {

        private boolean enabled;

        private String name;

        private String column;

        private String type;

        private String value;

        private boolean reason;

        private String description;

        public void checkDefaultValue() {
            if (this.enabled) {
                if (StringUtils.isBlank(this.name)) {
                    throw new NullArgumentException("STATUS name");
                } else {
                    this.name = StringUtils.replace(this.name, "/", "_");
                    this.name = EntityMeta.propertyNameToFieldName(this.name);
                }
                if (StringUtils.isBlank(this.column)) {
                    throw new NullArgumentException("STATUS column");
                }
                this.type = StringUtils.defaultIfBlank(this.type, "string");
                if (StringUtils.isBlank(this.value)) {
                    throw new NullArgumentException("STATUS value");
                }
            }
        }

        public boolean isEnabled() {
            return enabled;
        }

        public void setEnabled(boolean enabled) {
            this.enabled = enabled;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getColumn() {
            return column;
        }

        public void setColumn(String column) {
            this.column = column;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public boolean isReason() {
            return reason;
        }

        public void setReason(boolean reason) {
            this.reason = reason;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }
    }

    public static class ApiInfo {

        private String name;

        private String mapping;

        private String type;

        private String model;

        private String query;

        private ApiParameter primary;

        private List<ApiParameter> params;

        private List<StatusInfo> status;

        private boolean locked;

        private boolean timestamp;

        private boolean updateDisabled;

        @JSONField(serialize = false)
        private boolean upload;

        private String description;

        public ApiInfo() {
        }

        public void checkDefaultValue() {
            if (StringUtils.isBlank(this.name)) {
                throw new IllegalArgumentException("API name can not null.");
            }
            String _mapping = StringUtils.defaultIfBlank(this.mapping, this.name.toLowerCase());
            if (!StringUtils.startsWith(_mapping, "/")) {
                this.mapping = "/" + _mapping;
            }
            this.type = StringUtils.defaultIfBlank(this.type, "model");
            if (StringUtils.equalsIgnoreCase(this.type, "model") || StringUtils.equalsIgnoreCase(this.type, "query")) {
                if (StringUtils.equalsIgnoreCase(this.type, "model") && StringUtils.isBlank(this.model)) {
                    throw new IllegalArgumentException("API model can not null.");
                } else if (StringUtils.equalsIgnoreCase(this.type, "query") && StringUtils.isBlank(this.query)) {
                    throw new IllegalArgumentException("API query can not null.");
                }
            } else {
                throw new IllegalArgumentException("API model illegal.");
            }
            if (this.primary == null) {
                throw new NullArgumentException("API primary");
            } else {
                this.primary.checkDefaultValue();
            }
            if (this.params != null && !this.params.isEmpty()) {
                for (ApiParameter _param : this.params) {
                    _param.checkDefaultValue();
                    //
                    if (_param.upload.enabled) {
                        this.upload = true;
                    }
                }
            }
            if (this.status != null && !this.status.isEmpty()) {
                for (StatusInfo _status : this.status) {
                    _status.checkDefaultValue();
                }
            }
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getMapping() {
            return mapping;
        }

        public void setMapping(String mapping) {
            this.mapping = mapping;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getModel() {
            return model;
        }

        public void setModel(String model) {
            this.model = model;
        }

        public String getQuery() {
            return query;
        }

        public void setQuery(String query) {
            this.query = query;
        }

        public ApiParameter getPrimary() {
            return primary;
        }

        public void setPrimary(ApiParameter primary) {
            this.primary = primary;
        }

        public List<ApiParameter> getParams() {
            return params;
        }

        public void setParams(List<ApiParameter> params) {
            this.params = params;
        }

        public List<StatusInfo> getStatus() {
            return status;
        }

        public void setStatus(List<StatusInfo> status) {
            this.status = status;
        }

        public boolean isLocked() {
            return locked;
        }

        public void setLocked(boolean locked) {
            this.locked = locked;
        }

        public boolean isTimestamp() {
            return timestamp;
        }

        public void setTimestamp(boolean timestamp) {
            this.timestamp = timestamp;
        }

        public boolean isUpdateDisabled() {
            return updateDisabled;
        }

        public void setUpdateDisabled(boolean updateDisabled) {
            this.updateDisabled = updateDisabled;
        }

        public boolean isUpload() {
            return upload;
        }

        public void setUpload(boolean upload) {
            this.upload = upload;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        Map<String, Object> toMap() {
            return ClassUtils.wrapper(this).toMap();
        }
    }

    public static class UploadInfo {

        private boolean enabled;

        private List<String> contentTypes;

        public boolean isEnabled() {
            return enabled;
        }

        public void setEnabled(boolean enabled) {
            this.enabled = enabled;
        }

        public List<String> getContentTypes() {
            return contentTypes;
        }

        public void setContentTypes(List<String> contentTypes) {
            this.contentTypes = contentTypes;
        }
    }

    public static class ValidationInfo {

        private int max;

        private int min;

        private String regex;

        private boolean mobile;

        private boolean email;

        private boolean numeric;

        private boolean datetime;

        public ValidationInfo() {
        }

        public int getMax() {
            return max;
        }

        public void setMax(int max) {
            this.max = max;
        }

        public int getMin() {
            return min;
        }

        public void setMin(int min) {
            this.min = min;
        }

        public String getRegex() {
            return regex;
        }

        public void setRegex(String regex) {
            this.regex = regex;
        }

        public boolean isMobile() {
            return mobile;
        }

        public void setMobile(boolean mobile) {
            this.mobile = mobile;
        }

        public boolean isEmail() {
            return email;
        }

        public void setEmail(boolean email) {
            this.email = email;
        }

        public boolean isNumeric() {
            return numeric;
        }

        public void setNumeric(boolean numeric) {
            this.numeric = numeric;
        }

        public boolean isDatetime() {
            return datetime;
        }

        public void setDatetime(boolean datetime) {
            this.datetime = datetime;
        }
    }

    public static class FilterInfo {

        private boolean enabled;

        private boolean like;

        private boolean region;

        public FilterInfo() {
        }

        public boolean isEnabled() {
            return enabled;
        }

        public void setEnabled(boolean enabled) {
            this.enabled = enabled;
        }

        public boolean isLike() {
            return like;
        }

        public void setLike(boolean like) {
            this.like = like;
        }

        public boolean isRegion() {
            return region;
        }

        public void setRegion(boolean region) {
            this.region = region;
        }
    }

    public static class ApiParameter {

        private String name;

        private String column;

        private String label;

        private String type;

        private boolean required;

        private String defaultValue;

        private ValidationInfo validation;

        private FilterInfo filter;

        private UploadInfo upload;

        private String description;

        public ApiParameter() {
        }

        public ApiParameter(ColumnInfo columnInfo) {
            Attr _attr = columnInfo.toAttr();
            //
            this.name = _attr.getVarName();
            this.required = columnInfo.isPrimaryKey() || !columnInfo.isNullable();
            this.column = _attr.getColumnName();
            this.label = StringUtils.trimToEmpty(_attr.getRemarks());
            this.type = StringUtils.lowerCase(StringUtils.substringAfterLast(_attr.getVarType(), "."));
            this.defaultValue = StringUtils.trimToEmpty(_attr.getDefaultValue());
            //
            this.validation = new ValidationInfo();
            this.validation.numeric = !StringUtils.equals(this.type, "string") && !StringUtils.equals(this.type, "boolean");
            this.validation.max = _attr.getPrecision();
            //
            this.filter = new FilterInfo();
            this.filter.enabled = !columnInfo.isPrimaryKey();
            //
            this.upload = new UploadInfo();
            this.upload.setContentTypes(Collections.<String>emptyList());
            //
            this.description = StringUtils.trimToEmpty(_attr.getRemarks());
        }

        public void checkDefaultValue() {
            if (StringUtils.isBlank(this.name)) {
                throw new IllegalArgumentException("PARAM name can not null.");
            }
            if (StringUtils.isBlank(this.column)) {
                throw new IllegalArgumentException("PARAM column can not null.");
            }
            this.label = StringUtils.trimToEmpty(this.label);
            this.type = StringUtils.defaultIfBlank(this.type, "string");
            //
            if (this.validation == null) {
                this.validation = new ValidationInfo();
            }
            //
            if (this.filter == null) {
                this.filter = new FilterInfo();
            }
            //
            if (this.upload == null) {
                this.upload = new UploadInfo();
            }
            this.defaultValue = StringUtils.trimToEmpty(this.defaultValue);
            this.description = StringUtils.trimToEmpty(this.description);
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getColumn() {
            return column;
        }

        public void setColumn(String column) {
            this.column = column;
        }

        public String getLabel() {
            return label;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public boolean isRequired() {
            return required;
        }

        public void setRequired(boolean required) {
            this.required = required;
        }

        public String getDefaultValue() {
            return defaultValue;
        }

        public void setDefaultValue(String defaultValue) {
            this.defaultValue = defaultValue;
        }

        public ValidationInfo getValidation() {
            return validation;
        }

        public void setValidation(ValidationInfo validation) {
            this.validation = validation;
        }

        public FilterInfo getFilter() {
            return filter;
        }

        public void setFilter(FilterInfo filter) {
            this.filter = filter;
        }

        public UploadInfo getUpload() {
            return upload;
        }

        public void setUpload(UploadInfo upload) {
            this.upload = upload;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public Map<String, Object> toMap() {
            return ClassUtils.wrapper(this).toMap();
        }
    }
}
