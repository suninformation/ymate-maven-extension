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
    /**
     * 执行条件查询
     *
     <#if (api.params?? && api.params?size > 0)><#list api.params as p>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}</#if> ${p.description}
     </#list></#if>
     * @param page 查询页号
     * @param pageSize 分页大小
     * @param results 不要对此参数赋值
     * @return 返回查询结果集对象
     * @throws Exception 可能产生的任何异常
     */
    IResultSet<Object[]> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter>${p.type?cap_first} ${p.name}</#if><#if p_has_next>, </#if></#list>, </#if>int page, final int pageSize, IResultSet<Object[]>... results) throws Exception;

    <#else>
    <#if api.primary?? && (api.params?? && api.params?size > 0)>
    /**
     * 创建新数据记录
     *
     <#if (api.params?? && api.params?size > 0)><#list api.params as p>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}</#if> ${p.description}
     </#list></#if>
     * @return 返回创建后的数据对象
     * @throws Exception 可能产生的任何异常
     */
    ${api.model} create(<#list api.params as p>${p.type?cap_first} ${p.name}<#if p_has_next>, </#if></#list>) throws Exception;

    /**
    * 删除指定主键的记录
    *
    * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}</#if> ${api.primary.description}
    * @return 返回影响的记录数
    * @throws Exception 可能产生的任何异常
    */
    int remove(${api.primary.type?cap_first} ${api.primary.name}) throws Exception;

    /**
     * 批量删除指定主键的记录
     *
     * @param ${api.primary.name}s <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}</#if> ${api.primary.description}
     * @return 返回影响的记录数
     * @throws Exception 可能产生的任何异常
     */
    int[] remove(${api.primary.type?cap_first}[] ${api.primary.name}s) throws Exception;

    /**
     * 更新指定主键的数据记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}</#if> ${api.primary.description}
     <#if (api.params?? && api.params?size > 0)><#list api.params as p>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}</#if> ${p.description}
     </#list></#if>
     * @param lastModifyTime 记录最后修改时间(用于版本比较)
     * @return 返回更新后的数据对象
     * @throws Exception 可能产生的任何异常
     */
    ${api.model} update(${api.primary.type?cap_first} ${api.primary.name}, <#list api.params as p>${p.type?cap_first} ${p.name}<#if p_has_next>, </#if></#list>, long lastModifyTime) throws Exception;

    /**
     * 查询指定主键的数据记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}</#if> ${api.primary.description}
     * @return 返回数据对象
     * @throws Exception 可能产生的任何异常
     */
    ${api.model} find(${api.primary.type?cap_first} ${api.primary.name}) throws Exception;
    </#if>

    /**
     * 条件查询
     *
     <#if (api.params?? && api.params?size > 0)><#list api.params as p>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}</#if> ${p.description}
     </#list></#if>
     * @param page 查询页号
     * @param pageSize 分页大小
     * @return 返回查询结果集对象
     * @throws Exception 可能产生的任何异常
     */
    IResultSet<${api.model}> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter>${p.type?cap_first} ${p.name}</#if><#if p_has_next>, </#if></#list>, </#if> int page, int pageSize) throws Exception;
    </#if>
}