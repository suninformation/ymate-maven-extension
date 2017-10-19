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
    public IResultSet<Object[]> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter>${p.type?cap_first} ${p.name}</#if><#if p_has_next>, </#if></#list>, </#if>int page, final int pageSize, IResultSet<Object[]>... results) throws Exception {
        return results[0];
    }

    <#else>
    protected <#if (api.primary.type?lower_case == 'string')>String<#else>${api.primary.type?cap_first}</#if> __buildPrimaryKey() {
        return <#if (api.primary.type?lower_case == 'string')>UUIDUtils.UUID()<#else>null // TODO Build PrimaryKey for ${api.name?cap_first}</#if>;
    }

    <#if (api.params?? && api.params?size > 0)>@Override
    @Transaction
    public ${api.model} create(<#list api.params as p><#if p.upload.enabled>String<#else>${p.type?cap_first}</#if> ${p.name}<#if p_has_next>, </#if></#list>) throws Exception {
        long _now = System.currentTimeMillis();
        //
        ${api.model} _target = ${api.model}.builder().id(__buildPrimaryKey())
                <#list api.params as p>
                .${p.name}(${p.name})
                </#list>
                .createTime(_now)
                .lastModifyTime(_now)
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

    <#if (api.params?? && api.params?size > 0)>@Override
    @Transaction
    public ${api.model} update(${api.primary.type?cap_first} ${api.primary.name}, <#list api.params as p><#if p.upload.enabled>String<#else>${p.type?cap_first}</#if> ${p.name}<#if p_has_next>, </#if></#list>, long lastModifyTime) throws Exception {
        ${api.model} _target = ${api.model}.builder().id(${api.primary.name}).build().load(IDBLocker.MYSQL);
        if (lastModifyTime > 0 && BlurObject.bind(_target.getLastModifyTime()).toLongValue() != lastModifyTime) {
            throw new DataVersionMismatchException("Data version mismatch.");
        }
        PropertyStateSupport<${api.model}> _state = PropertyStateSupport.create(_target);
        _target = _state.bind().bind()
                <#list api.params as p>
                .${p.name}(${p.name})
                </#list>
                .lastModifyTime(System.currentTimeMillis()).build();
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
    public IResultSet<${api.model}> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter>final ${p.type?cap_first} ${p.name}</#if><#if p_has_next>, </#if></#list>, </#if>final Fields fields, final OrderBy orderBy, final int page, final int pageSize) throws Exception {
        return JDBC.get().openSession(new ISessionExecutor<IResultSet<${api.model}>>() {
            @Override
            public IResultSet<${api.model}> execute(ISession session) throws Exception {
                Cond _cond = Cond.create();
                <#if api.params?? && (api.params?size > 0)><#list api.params as p>
                    <#if p.type?lower_case == 'string'>
                    if (StringUtils.isNotBlank(${p.name})) {
                    <#if p.like?? && p.like>
                        _cond.like(${api.model}.FIELDS.${p.column?upper_case}).param("%" + ${p.name} + "%");
                    <#else>
                        _cond.eq(${api.model}.FIELDS.${p.column?upper_case}).param(${p.name});
                    </#if>
                    }
                    <#else>
                    if (${p.name} != null) {
                        _cond.eq(${api.model}.FIELDS.${p.column?upper_case}).param(${p.name});
                    }
                    </#if>
                </#list></#if>
                //
                Where _where = Where.create(_cond);
                if (orderBy != null) {
                    _where.orderBy().orderBy(orderBy);
                } else {
                    _where.orderDesc(${api.model}.FIELDS.LAST_MODIFY_TIME);
                }
                //
                return session.find(Select.create(session.getConnectionHolder().getDataSourceCfgMeta().getTablePrefix(), ${api.model}.class)
                            .field(fields == null ? Fields.create() : fields).where(_where).toSQL(), new EntityResultSetHandler<${api.model}>(${api.model}.class), Page.createIfNeed(page, pageSize));
            }
        });
    }
    </#if>
}