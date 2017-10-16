package ${app.packageName}.repository;

import net.ymate.platform.persistence.IResultSet;
import java.util.List;

/**
 * I${api.name?cap_first}Repository <#if api.description?? && (api.description?length > 0)>- ${api.description}</#if>
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ${app.author?default("ymatescaffold")}
 * @version ${app.version?default("1.0.0")}
 */
public interface I${api.name?cap_first}Repository {

    <#if query>
    IResultSet<Object[]> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter>${p.type?cap_first} ${p.name}</#if><#if p_has_next>, </#if></#list>, </#if>int page, final int pageSize, IResultSet<Object[]>... results) throws Exception;

    <#else>
    <#if api.primary?? && (api.params?? && api.params?size > 0)>
    ${api.model} create(<#list api.params as p>${p.type?cap_first} ${p.name}<#if p_has_next>, </#if></#list>) throws Exception;

    int remove(${api.primary.type?cap_first} ${api.primary.name}) throws Exception;

    int[] remove(${api.primary.type?cap_first}[] ${api.primary.name}s) throws Exception;

    ${api.model} update(${api.primary.type?cap_first} ${api.primary.name}, <#list api.params as p>${p.type?cap_first} ${p.name}<#if p_has_next>, </#if></#list>, long lastModifyTime) throws Exception;

    ${api.model} find(${api.primary.type?cap_first} ${api.primary.name}) throws Exception;
    </#if>

    IResultSet<${api.model}> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter>${p.type?cap_first} ${p.name}</#if><#if p_has_next>, </#if></#list>, </#if> int page, int pageSize) throws Exception;
    </#if>
}