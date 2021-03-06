package ${app.packageName}.repository;

import net.ymate.platform.persistence.Fields;
import net.ymate.platform.persistence.IResultSet;
import net.ymate.platform.persistence.jdbc.query.OrderBy;
import java.io.File;
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
     <#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filte.enabled>
     * @param <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if> <#if p.label?? && (p.label?length > 0)>${p.label}<#else>${p.description}<#if p.filter.region>范围最小值</#if></#if><#if p.filter.region>
     * @param end${p.name?cap_first} <#if p.label?? && (p.label?length > 0)>${p.label}范围最大值</#if>
     </#if></#if></#list></#if>
     * @param page 查询页号
     * @param pageSize 分页大小
     * @param results 不要对此参数赋值
     * @return 返回查询结果集对象
     * @throws Exception 可能产生的任何异常
     */
    IResultSet<Object[]> find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, ${p.type?cap_first} end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if>int page, final int pageSize, IResultSet<Object[]>... results) throws Exception;

    <#else>
    <#if (api.params?? && api.params?size > 0)>
    /**
     * 创建新数据记录
     *
     <#if formbean && repositoryFormBean>* @param ${api.name}Form DTO对象<#else><#compress><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}<#else>${p.description}</#if></#if>
     </#list></#if></#compress></#if>

     * @return 返回创建后的数据对象
     * @throws Exception 可能产生的任何异常
     */
    ${api.model} create(<#if formbean && repositoryFormBean>${app.packageName}.dto.${api.name?cap_first}UpdateFormBean ${api.name}Form<#else><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>, </#if><#if p.upload.enabled>String<#else>${p.type?cap_first}</#if> ${p.name}</#if></#list></#if>) throws Exception;</#if>

    /**
    * 删除指定主键的记录
    *
    * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
    * @return 返回影响的记录数
    * @throws Exception 可能产生的任何异常
    */
    int remove(${api.primary.type?cap_first} ${api.primary.name}) throws Exception;

    /**
     * 批量删除指定主键的记录
     *
     * @param ${api.primary.name}s <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     * @return 返回影响的记录数
     * @throws Exception 可能产生的任何异常
     */
    int[] remove(${api.primary.type?cap_first}[] ${api.primary.name}s) throws Exception;

    <#if api.status?? && (api.status?size > 0) && !api.updateDisabled>/**
     * 批量更新指定主键记录的fieldName字段value值
     *
     * @param ${api.primary.name}s <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     * @param fieldName 字段名称
     * @param value     值
     * @return 返回影响的记录数
     * @throws Exception 可能产生的任何异常
     */
    int[] update(${api.primary.type?cap_first}[] ${api.primary.name}s, String fieldName, Object value) throws Exception;</#if>

    <#if (api.params?? && api.params?size > 0)><#if !api.updateDisabled>/**
     * 更新指定主键的数据记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     <#if formbean && repositoryFormBean>* @param ${api.name}Form DTO对象<#else><#compress><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}<#else>${p.description}</#if></#if>
     </#list></#if></#compress></#if><#if api.timestamp>

     * @param lastModifyTime 记录最后修改时间(用于版本比较)</#if>
     * @return 返回更新后的数据对象
     * @throws Exception 可能产生的任何异常
     */
    ${api.model} update(${api.primary.type?cap_first} ${api.primary.name}, <#if formbean && repositoryFormBean>${app.packageName}.dto.${api.name?cap_first}UpdateFormBean ${api.name}Form<#else><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>, </#if><#if p.upload.enabled>String<#else>${p.type?cap_first}</#if> ${p.name}</#if></#list></#if><#if api.timestamp>, long lastModifyTime</#if>) throws Exception;</#if></#if>

    /**
     * 查询指定主键的数据记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     * @return 返回数据对象
     * @throws Exception 可能产生的任何异常
     */
    ${api.model} find(${api.primary.type?cap_first} ${api.primary.name}) throws Exception;

    /**
     * 查询指定主键的数据记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     * @param fields 过滤字段集合
     * @return 返回数据对象
     * @throws Exception 可能产生的任何异常
     */
     ${api.model} find(${api.primary.type?cap_first} ${api.primary.name}, Fields fields) throws Exception;

    /**
     * 条件查询
     *
     <#if api.primary.filter?? && api.primary.filter.enabled>
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     </#if>
     <#if formbean && repositoryFormBean>* @param ${api.name}Form DTO对象<#else><#compress><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>
     * @param <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if> <#if p.label?? && (p.label?length > 0)>${p.label}<#else>${p.description}</#if><#if p.filter.region>
     * @param end${p.name?cap_first} <#if p.label?? && (p.label?length > 0)>${p.label}</#if></#if></#if>
     </#list></#if></#compress></#if>

     * @param fields 过滤字段集合
     * @param orderBy 排序对象
     * @param page 查询页号
     * @param pageSize 分页大小
     * @return 返回查询结果集对象
     * @throws Exception 可能产生的任何异常
     */
    IResultSet<${api.model}> find(<#if api.primary.filter?? && api.primary.filter.enabled>${api.primary.type?cap_first} ${api.primary.name}, </#if><#if formbean && repositoryFormBean>${app.packageName}.dto.${api.name?cap_first}FormBean ${api.name}Form, <#else><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, ${p.type?cap_first} end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if></#if>Fields fields, OrderBy orderBy, int page, int pageSize) throws Exception;

   /**
    * 根据条件查询导出数据
    *
    <#if api.primary.filter?? && api.primary.filter.enabled>
    * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
    </#if>
    <#if formbean && repositoryFormBean>* @param ${api.name}Form DTO对象<#else><#compress><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>
    * @param <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if> <#if p.label?? && (p.label?length > 0)>${p.label}<#else>${p.description}</#if><#if p.filter.region>
    * @param end${p.name?cap_first} <#if p.label?? && (p.label?length > 0)>${p.label}</#if></#if></#if>
    </#list></#if></#compress></#if>

    * @param fields 过滤字段集合
    * @param orderBy 排序对象
    * @param pageSize 分页大小
    * @return 返回查询结果集对象
    * @throws Exception 可能产生的任何异常
    */
    File export(<#if api.primary.filter?? && api.primary.filter.enabled>${api.primary.type?cap_first} ${api.primary.name}, </#if><#if formbean && repositoryFormBean>${app.packageName}.dto.${api.name?cap_first}FormBean ${api.name}Form, <#else><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled>${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, ${p.type?cap_first} end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if></#if>Fields fields, OrderBy orderBy, int pageSize) throws Exception;
    </#if>
}