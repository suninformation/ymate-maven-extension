package ${app.packageName}.repository.impl;

<#if query>import ${app.packageName}.config.${app.name?cap_first}RepositoryConfig;</#if>
import ${app.packageName}.repository.I${api.name?cap_first}Repository;
import net.ymate.framework.exception.DataVersionMismatchException;
import net.ymate.platform.configuration.IConfiguration;
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
        return <#if (api.primary.type?lower_case == 'string')>UUIDUtils.UUID()<#else>null // TODO Build PrimaryKey for ${api.name?cap_first}</#if>;
    }

    <#if (api.params?? && api.params?size > 0)>@Override
    @Transaction
    public ${api.model} create(<#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>, </#if><#if p.upload.enabled>String<#else>${p.type?cap_first}</#if> ${p.name}</#if></#list>) throws Exception {
        <#if api.timestamp>long _now = System.currentTimeMillis();
        //</#if>
        ${api.model} _target = ${api.model}.builder().id(__buildPrimaryKey())
                <#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
                .${p.name}(${p.name})
                </#if></#list><#if api.timestamp>
                .createTime(_now)
                .lastModifyTime(_now)</#if>
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

    <#if api.status?? && (api.status?size > 0)>@Override
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
                BatchSQL _batchSQL = BatchSQL.create(Update.create(session.getConnectionHolder().getDataSourceCfgMeta().getTablePrefix(), ${api.model}.class)
                        .where(Where.create(Cond.create().eq(${api.model}.FIELDS.${api.primary.column?upper_case}))).field(fieldName).toString());
                for (String _${api.primary.name} : ${api.primary.name}s) {
                    _batchSQL.addParameter(Params.create(value, _${api.primary.name}));
                }
                return session.executeForUpdate(_batchSQL);
            }
        });
    }</#if>

    <#if (api.params?? && api.params?size > 0)>@Override
    @Transaction
    public ${api.model} update(${api.primary.type?cap_first} ${api.primary.name}, <#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>, </#if><#if p.upload.enabled>String<#else>${p.type?cap_first}</#if> ${p.name}</#if></#list><#if api.timestamp>, long lastModifyTime</#if>) throws Exception {
        ${api.model} _target = ${api.model}.builder().id(${api.primary.name}).build().load(IDBLocker.MYSQL);
        <#if api.timestamp>if (lastModifyTime > 0) {
            long _current = BlurObject.bind(_target.getLastModifyTime()).toLongValue();
            if (_current != lastModifyTime) {
                throw new DataVersionMismatchException("Data version mismatch. last: " + lastModifyTime + ", current: " + _current);
            }
        }
        </#if>PropertyStateSupport<${api.model}> _state = PropertyStateSupport.create(_target);
        _target = _state.bind().bind()
                <#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
                .${p.name}(${p.name})
                </#if></#list><#if api.timestamp>
                .lastModifyTime(System.currentTimeMillis())</#if>
                .build();
        return _target.update(Fields.create(_state.getChangedPropertyNames()));
    }</#if>

    @Override
    public ${api.model} find(${api.primary.type?cap_first} ${api.primary.name}) throws Exception {
        if (<#if (api.primary.type?lower_case == 'string')>StringUtils.isBlank(${api.primary.name})<#else>${api.primary.name} == null</#if>) {
            throw new NullArgumentException("${api.primary.name}");
        }
        return ${api.model}.builder().id(${api.primary.name}).build().load();
    }

    @Override
    public IResultSet<${api.model}> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>final ${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, final ${p.type?cap_first} end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if>final Fields fields, final OrderBy orderBy, final int page, final int pageSize) throws Exception {
        return JDBC.get().openSession(new ISessionExecutor<IResultSet<${api.model}>>() {
            @Override
            public IResultSet<${api.model}> execute(ISession session) throws Exception {
                Cond _cond = Cond.create().eqOne();
                <#if api.params?? && (api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>
                    <#if p.type?lower_case == 'string'><#if !p.filter.region>//
                    if (StringUtils.isNotBlank(${p.name})) {
                    <#if p.like?? && p.like>
                        _cond.and().like(${api.model}.FIELDS.${p.column?upper_case}).param("%" + ${p.name} + "%");
                    <#else>
                        _cond.and().eq(${api.model}.FIELDS.${p.column?upper_case}).param(${p.name});
                    </#if>
                    }
                    </#if><#else><#if p.filter.region && (p.type?lower_case == "integer" || p.type?lower_case == "long")>//
                    if (begin${p.name?cap_first} != null && end${p.name?cap_first} != null) {
                        _cond.and().between(${api.model}.FIELDS.${p.column?upper_case}, begin${p.name?cap_first}, end${p.name?cap_first});
                    }
                    <#else>//
                    if (${p.name} != null) {
                        _cond.and().eq(${api.model}.FIELDS.${p.column?upper_case}).param(${p.name});
                    }
                    </#if></#if>
                </#if></#list></#if>//
                Where _where = Where.create(_cond);
                if (orderBy != null) {
                    _where.orderBy().orderBy(orderBy);<#if api.timestamp>
                } else {
                    _where.orderDesc(${api.model}.FIELDS.LAST_MODIFY_TIME);</#if>
                }
                //
                return session.find(Select.create(session.getConnectionHolder().getDataSourceCfgMeta().getTablePrefix(), ${api.model}.class)
                            .field(fields == null ? Fields.create() : fields).where(_where).toSQL(), new EntityResultSetHandler<${api.model}>(${api.model}.class), Page.createIfNeed(page, pageSize));
            }
        });
    }
    </#if>
}