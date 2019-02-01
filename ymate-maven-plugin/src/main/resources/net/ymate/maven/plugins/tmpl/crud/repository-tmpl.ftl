package ${app.packageName}.repository.impl;

<#if query>import ${app.packageName}.config.${app.name?cap_first}RepositoryConfig;</#if>
import ${app.packageName}.repository.I${api.name?cap_first}Repository;
import net.ymate.platform.webmvc.exception.DataVersionMismatchException;<#if query>
import net.ymate.platform.configuration.IConfiguration;</#if>
import net.ymate.platform.core.beans.annotation.Inject;
import net.ymate.platform.core.beans.support.PropertyStateSupport;
import net.ymate.platform.core.lang.BlurObject;
import net.ymate.platform.core.util.UUIDUtils;
import net.ymate.platform.persistence.Fields;
import net.ymate.platform.persistence.IResultSet;
import net.ymate.platform.persistence.Page;
import net.ymate.platform.persistence.Params;
import net.ymate.platform.persistence.jdbc.ISession;
import net.ymate.platform.persistence.jdbc.ISessionExecutor;
import net.ymate.platform.persistence.jdbc.JDBC;
import net.ymate.platform.persistence.jdbc.annotation.Transaction;
import net.ymate.platform.persistence.jdbc.base.impl.EntityResultSetHandler;
import net.ymate.platform.persistence.jdbc.query.*;
<#if query>import net.ymate.platform.persistence.jdbc.repo.IRepository;</#if>
import net.ymate.platform.persistence.jdbc.repo.annotation.Repository;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.NullArgumentException;
import org.apache.commons.lang.StringUtils;
import net.ymate.framework.commons.ExcelFileExportHelper;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

/**
 * ${api.name?cap_first}Repository <#if api.description?? && (api.description?length > 0)>- ${api.description}</#if>
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ${app.author?default("ymatescaffold")}
 * @version ${app.version?default("1.0.0")}
 */
@Repository
@Transaction
public class ${api.name?cap_first}Repository implements I${api.name?cap_first}Repository<#if query>, IRepository</#if> {

    <#if query>
    @Inject
    private ${app.name?cap_first}RepositoryConfig __config;

    @Override
    public IConfiguration getConfig() {
        return __config;
    }

    @Repository(item = "${api.name?lower_case}")
    public IResultSet<Object[]> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, ${p.type?cap_first} end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if>int page, final int pageSize, IResultSet<Object[]>... results) throws Exception {
        return results[0];
    }

    <#else>
    private <#if (api.primary.type?lower_case == 'string')>String<#else>${api.primary.type?cap_first}</#if> __buildPrimaryKey() {
        <#if (api.primary.type?lower_case == 'string')>return UUIDUtils.UUID();<#else>throw new UnsupportedOperationException("Need to implement the rule of the primary key ${api.name?cap_first} generation");</#if>
    }

    <#if (api.params?? && api.params?size > 0)>@Override
    @Transaction
    public ${api.model} create(<#if formbean && repositoryFormBean>${app.packageName}.dto.${api.name?cap_first}UpdateFormBean ${api.name}Form<#else><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>, </#if><#if p.upload.enabled>String<#else>${p.type?cap_first}</#if> ${p.name}</#if></#list></#if>) throws Exception {
        <#if api.timestamp>long _now = System.currentTimeMillis();
        //</#if>
        ${api.model} _target = ${api.model}.builder().id(__buildPrimaryKey())
                <#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
                .${p.name}(<#if formbean && repositoryFormBean>${api.name}Form.get${p.name?cap_first}()<#else>${p.name}</#if>)
                </#if></#list><#if api.timestamp>
                .createTime(_now)<#if !api.updateDisabled>
                .lastModifyTime(_now)</#if></#if>
                .build();
        return _target.save();
    }</#if>

    @Override
    @Transaction
    public int remove(final ${api.primary.type?cap_first} ${api.primary.name}) throws Exception {
        if (<#if (api.primary.type?lower_case == 'string')>StringUtils.isBlank(${api.primary.name})<#else>${api.primary.name} == null</#if>) {
            throw new NullArgumentException("${api.primary.name}");
        }
        return JDBC.get().openSession(new ISessionExecutor<Integer>() {
            @Override
            public Integer execute(ISession session) throws Exception {
                return session.delete(${api.model}.class, ${api.primary.name});
            }
        });
    }

    @Override
    @Transaction
    public int[] remove(final ${api.primary.type?cap_first}[] ${api.primary.name}s) throws Exception {
        if (ArrayUtils.isEmpty(${api.primary.name}s)) {
            throw new NullArgumentException("${api.primary.name}s");
        }
        return JDBC.get().openSession(new ISessionExecutor<int[]>() {
            @Override
            public int[] execute(ISession session) throws Exception {
                return session.delete(${api.model}.class, ${api.primary.name}s);
            }
        });
    }

    <#if api.status?? && (api.status?size > 0) && !api.updateDisabled>@Override
    @Transaction
    public int[] update(final ${api.primary.type?cap_first}[] ${api.primary.name}s, final String fieldName, final Object value) throws Exception {
        if (ArrayUtils.isEmpty(${api.primary.name}s)) {
            throw new NullArgumentException("${api.primary.name}s");
        }
        if (StringUtils.isBlank(fieldName)) {
            throw new NullArgumentException("fieldName");
        }
        return JDBC.get().openSession(new ISessionExecutor<int[]>() {
            @Override
            public int[] execute(ISession session) throws Exception {
                BatchSQL _batchSQL = BatchSQL.create(Update.create(${api.model}.class)
                        .where(Where.create(Cond.create().eq(${api.model}.FIELDS.${api.primary.column?upper_case}))).field(fieldName).field(${api.model}.FIELDS.LAST_MODIFY_TIME).toString());
                for (String _${api.primary.name} : ${api.primary.name}s) {
                    _batchSQL.addParameter(Params.create(value, System.currentTimeMillis(), _${api.primary.name}));
                }
                return session.executeForUpdate(_batchSQL);
            }
        });
    }</#if>

    <#if (api.params?? && api.params?size > 0)><#if !api.updateDisabled>@Override
    @Transaction
    public ${api.model} update(${api.primary.type?cap_first} ${api.primary.name}, <#if formbean && repositoryFormBean>${app.packageName}.dto.${api.name?cap_first}UpdateFormBean ${api.name}Form<#else><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>, </#if><#if p.upload.enabled>String<#else>${p.type?cap_first}</#if> ${p.name}</#if></#list></#if><#if api.timestamp>, long lastModifyTime</#if>) throws Exception {
        ${api.model} _target = ${api.model}.builder().id(${api.primary.name}).build().load(IDBLocker.DEFAULT);
        if (_target != null) {
            <#if api.timestamp>if (lastModifyTime > 0) {
                DataVersionMismatchException.comparisonVersion(lastModifyTime, _target.getLastModifyTime());
            }
            </#if>PropertyStateSupport<${api.model}> _state = PropertyStateSupport.create(_target, true);
            ${api.model} _entity = _state.bind().bind()
                    <#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
                    .${p.name}(<#if formbean && repositoryFormBean>${api.name}Form.get${p.name?cap_first}()<#else>${p.name}</#if>)
                    </#if></#list>.build();
            String[] _propNames = _state.getChangedPropertyNames();
            if (ArrayUtils.isNotEmpty(_propNames)) {
                <#if api.timestamp>_entity.setLastModifyTime(System.currentTimeMillis());</#if>
                return _state.unbind().update(Fields.create(_propNames)<#if api.timestamp>.add(${api.model}.FIELDS.LAST_MODIFY_TIME)</#if>);
            }
        }
        return null;
    }</#if></#if>

    @Override
    public ${api.model} find(${api.primary.type?cap_first} ${api.primary.name}) throws Exception {
        if (<#if (api.primary.type?lower_case == 'string')>StringUtils.isBlank(${api.primary.name})<#else>${api.primary.name} == null</#if>) {
            throw new NullArgumentException("${api.primary.name}");
        }
        return ${api.model}.builder().id(${api.primary.name}).build().load();
    }

    @Override
    public ${api.model} find(${api.primary.type?cap_first} ${api.primary.name}, Fields fields) throws Exception {
        if (<#if (api.primary.type?lower_case == 'string')>StringUtils.isBlank(${api.primary.name})<#else>${api.primary.name} == null</#if>) {
            throw new NullArgumentException("${api.primary.name}");
        }
        return ${api.model}.builder().id(${api.primary.name}).build().load(fields, null);
    }

    @Override
    public IResultSet<${api.model}> find(<#if api.primary.filter?? && api.primary.filter.enabled>final ${api.primary.type?cap_first} ${api.primary.name}, </#if><#if formbean && repositoryFormBean>final ${app.packageName}.dto.${api.name?cap_first}FormBean ${api.name}Form, <#else><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>final ${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, final ${p.type?cap_first} end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if></#if>final Fields fields, final OrderBy orderBy, final int page, final int pageSize) throws Exception {
        return JDBC.get().openSession(new ISessionExecutor<IResultSet<${api.model}>>() {
            @Override
            public IResultSet<${api.model}> execute(ISession session) throws Exception {
                Cond _cond = Cond.create().eqOne();
                <#if api.primary.filter?? && api.primary.filter.enabled>
                    <#if api.primary.type?lower_case == 'string'>
                    if (StringUtils.isNotBlank(${api.primary.name})) {
                        _cond.and().eq(${api.model}.FIELDS.${api.primary.column?upper_case}).param(${api.primary.name});
                    }
                    <#else>
                    if (${api.primary.name} != null) {
                        _cond.and().eq(${api.model}.FIELDS.${api.primary.column?upper_case}).param(${api.primary.name});
                    }
                    </#if>
                </#if>
                <#if api.params?? && (api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>
                    <#if p.type?lower_case == 'string'><#if !p.filter.region>//
                    if (StringUtils.isNotBlank(<#if formbean && repositoryFormBean>${api.name}Form.get${p.name?cap_first}()<#else>${p.name}</#if>)) {
                    <#if p.filter.like?? && p.filter.like>
                        _cond.and().like(${api.model}.FIELDS.${p.column?upper_case}).param("%" + <#if formbean && repositoryFormBean>${api.name}Form.get${p.name?cap_first}()<#else>${p.name}</#if> + "%");
                    <#else>
                        _cond.and().eq(${api.model}.FIELDS.${p.column?upper_case}).param(<#if formbean && repositoryFormBean>${api.name}Form.get${p.name?cap_first}()<#else>${p.name}</#if>);
                    </#if>
                    }
                    </#if><#else><#if p.filter.region && (p.type?lower_case == "integer" || p.type?lower_case == "long")>//
                    if (<#if formbean && repositoryFormBean>${api.name}Form.getBegin${p.name?cap_first}()<#else>begin${p.name?cap_first}</#if> != null && <#if formbean && repositoryFormBean>${api.name}Form.getEnd${p.name?cap_first}()<#else>end${p.name?cap_first}</#if> != null) {
                        _cond.and().between(${api.model}.FIELDS.${p.column?upper_case}, <#if formbean && repositoryFormBean>${api.name}Form.getBegin${p.name?cap_first}()<#else>begin${p.name?cap_first}</#if>, <#if formbean && repositoryFormBean>${api.name}Form.getEnd${p.name?cap_first}()<#else>end${p.name?cap_first}</#if>);
                    } else if (<#if formbean && repositoryFormBean>${api.name}Form.getBegin${p.name?cap_first}()<#else>begin${p.name?cap_first}</#if> != null) {
                        _cond.and().gtEq(${api.model}.FIELDS.${p.column?upper_case}).param(<#if formbean && repositoryFormBean>${api.name}Form.getBegin${p.name?cap_first}()<#else>begin${p.name?cap_first}</#if>);
                    } else if (<#if formbean && repositoryFormBean>${api.name}Form.getEnd${p.name?cap_first}()<#else>end${p.name?cap_first}</#if> != null) {
                        _cond.and().ltEq(${api.model}.FIELDS.${p.column?upper_case}).param(<#if formbean && repositoryFormBean>${api.name}Form.getEnd${p.name?cap_first}()<#else>end${p.name?cap_first}</#if>);
                    }
                    <#else>//
                    if (<#if formbean && repositoryFormBean>${api.name}Form.get${p.name?cap_first}()<#else>${p.name}</#if> != null) {
                        _cond.and().eq(${api.model}.FIELDS.${p.column?upper_case}).param(<#if formbean && repositoryFormBean>${api.name}Form.get${p.name?cap_first}()<#else>${p.name}</#if>);
                    }
                    </#if></#if>
                </#if></#list></#if>//
                Where _where = Where.create(_cond);
                if (orderBy != null) {
                    _where.orderBy().orderBy(orderBy);<#if api.timestamp>
                } else {
                    _where.orderDesc(${api.model}.FIELDS.<#if api.updateDisabled>CREATE_TIME<#else>LAST_MODIFY_TIME</#if>);</#if>
                }
                //
                return session.find(Select.create(${api.model}.class)
                            .field(fields == null ? Fields.create() : fields).where(_where).toSQL(), new EntityResultSetHandler<${api.model}>(${api.model}.class), Page.createIfNeed(page, pageSize));
            }
        });
    }

    @Override
    public File export(<#if api.primary.filter?? && api.primary.filter.enabled>final ${api.primary.type?cap_first} ${api.primary.name}, </#if><#if formbean && repositoryFormBean>final ${app.packageName}.dto.${api.name?cap_first}FormBean ${api.name}Form, <#else><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>final ${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, final ${p.type?cap_first} end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if></#if>final Fields fields, final OrderBy orderBy, final int pageSize) throws Exception {
        ExcelFileExportHelper _helper = ExcelFileExportHelper.bind(new ExcelFileExportHelper.IExportDataProcessor() {
            @Override
            public Map<String, Object> getData(int index) throws Exception {
                IResultSet<${api.model}> _result = find(<#if api.primary.filter?? && api.primary.filter.enabled>${api.primary.name}, </#if><#if formbean><#if (repositoryFormBean)>${api.name}Form<#else><#list api.params as p><#if p.filter?? && p.filter.enabled><#if p.filter.region>${api.name}Form.getBegin${p.name?cap_first}()<#else>${api.name}Form.get${p.name?cap_first}()</#if><#if p.filter.region>, ${api.name}Form.getEnd${p.name?cap_first}()</#if><#if p_has_next>, </#if></#if></#list></#if><#else><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled><#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if></#if>fields, orderBy, index, pageSize > 0 ? pageSize : 10000);
                if (_result != null && _result.isResultsAvailable()) {
                    Map<String, Object> _data = new HashMap<String, Object>();
                    _data.put("data", _result.getResultData());
                    return _data;
                }
                return null;
            }
        });
        return _helper.export(${api.model}.class);
    }
    </#if>
}