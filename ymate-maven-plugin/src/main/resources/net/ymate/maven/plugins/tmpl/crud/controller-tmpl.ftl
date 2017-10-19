package ${app.packageName}.controller;

import net.ymate.framework.validation.*;
import net.ymate.framework.webmvc.WebResult;<#if security?? && security.enabled>
import net.ymate.module.security.ISecurity;
import net.ymate.module.security.annotation.Permission;
import net.ymate.module.security.annotation.Security;</#if>
import net.ymate.platform.core.beans.annotation.*;
import net.ymate.platform.persistence.IResultSet;
import net.ymate.platform.validation.annotation.*;
import net.ymate.platform.validation.validate.*;
import net.ymate.platform.webmvc.annotation.*;<#if upload>
import net.ymate.platform.core.util.FileUtils;
import net.ymate.platform.core.util.RuntimeUtils;
import net.ymate.platform.core.util.UUIDUtils;
import java.io.File;
import net.ymate.platform.webmvc.IUploadFileWrapper;</#if>
import net.ymate.platform.webmvc.base.Type;
import net.ymate.platform.webmvc.view.IView;

import ${app.packageName}.repository.I${api.name?cap_first}Repository;
import ${app.packageName}.repository.impl.${api.name?cap_first}Repository;

import java.util.*;

/**
 * ${api.name?cap_first}Controller <#if api.description?? && (api.description?length > 0)>- ${api.description}</#if>
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ${app.author?default("ymatescaffold")}
 * @version ${app.version?default("1.0.0")}
 */
@Controller
@RequestMapping(value = "${api.mapping}")<#if security?? && security.enabled>
@Security<#if security.roles?? || security.permissions??>
@Permission(<#if security.name?? && (security.name?length > 0)>name = "${security.name}", </#if><#if security.roles?? && (security.roles?size > 0)>roles = {<#list security.roles as p>${p}<#if p_has_next>,</#if></#list>}</#if><#if security.permissions?? && (security.permissions?size > 0)>, value = {<#list security.permissions as p>"${p}"<#if p_has_next>,</#if></#list>}</#if>)</#if></#if><#if intercept?? && (intercept?size > 0)><#if intercept.before?? && (intercept.before?size > 0)>
@Before({<#list intercept.before as p>${p}<#if p_has_next>,</#if></#list>})</#if><#if intercept.after?? && (intercept.after?size > 0)>
@After({<#list intercept.after as p>${p}<#if p_has_next>,</#if></#list>})</#if><#if intercept.around?? && (intercept.around?size > 0)>
@Around({<#list intercept.around as p>${p}<#if p_has_next>,</#if></#list>})</#if><#if intercept.params?? && (intercept.params?size > 0)>
@ContextParam({<#list intercept.params?keys as p>@ParamItem(key = "${p}", value = "${intercept.params[p]}")<#if p_has_next>,</#if></#list>})</#if></#if>
public class ${api.name?cap_first}Controller {

    @Inject
    private I${api.name?cap_first}Repository __repository;

    /**
     * 条件查询
     *
     <#if (api.params?? && api.params?size > 0)><#list api.params as p>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}</#if> ${p.description}
     </#list></#if>
     * @param page 查询页号
     * @param pageSize 分页大小
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping("/query")<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_QUERY")</#if>
    public IView __query(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter><#if p.required?? && p.required>@VRequried</#if><#if p.regex?? && (p.regex?length > 0)>
                         @VRegex(regex = "${p.regex}")</#if><#if p.email?? && p.email>
                         @VEmail</#if><#if p.mobile?? && p.mobile>
                         @VMobile</#if><#if p.datetime?? && p.datetime>
                         @VDateTime</#if><#if p.numeric?? && p.numeric>
                         @VNumeric<#if ((p.min?? && p.min > 0) && (p.max?? && p.max > 0))>(min = #{p.min}, max = ${p.max})<#elseif (p.min?? && p.min > 0)>min = ${p.min})<#elseif (p.max?? && p.max > 0)>max = ${p.max})</#if> <#else><#if ((p.min?? && p.min > 0) && (p.max?? && p.max > 0))>
                         @VLength(min = #{p.min}, max = ${p.max})<#elseif (p.min?? && p.min > 0)>@VLength(min = ${p.min})<#elseif (p.max?? && p.max > 0)>@VLength(max = ${p.max})</#if></#if><#if p.label?? && (p.label?length > 0)>
                         @VField(label = "${p.label}")</#if> @RequestParam ${p.type?cap_first} ${p.name}</#if><#if p_has_next>,

                         </#if></#list>, </#if>

                        @RequestParam int page, @RequestParam int pageSize) throws Exception {

    IResultSet<<#if query>Object[]<#else>${api.model}</#if>> _result = __repository.find(<#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter>${p.name}</#if><#if p_has_next>, </#if></#list>, </#if>null, null, page, pageSize);
    //
    return WebResult.SUCCESS().data(_result).toJSON();
    }

<#if !query><#if upload>
    private String __transferUploadFile(IUploadFileWrapper fileWrapper) throws Exception {
        if (fileWrapper != null) {
            String _fileName = "/upload/${api.name?lower_case}//" + UUIDUtils.UUID() + "." + FileUtils.getExtName(fileWrapper.getName());
            File _dist = new File(RuntimeUtils.getRootPath(false), _fileName);
            File _distParent = _dist.getParentFile();
            if (_distParent.exists() || _distParent.mkdirs()) {
                fileWrapper.transferTo(_dist);
                return _fileName;
            }
        }
        return null;
    }</#if>

    <#if (api.params?? && api.params?size > 0)>/**
     * 创建新记录
     *
     <#if (api.params?? && api.params?size > 0)><#list api.params as p>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}</#if> ${p.description}
     </#list></#if>
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping(value = "/create", method = Type.HttpMethod.POST)<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_CREATE")</#if><#if upload>
    @FileUpload</#if>
    public IView __create(<#list api.params as p><#if p.required?? && p.required>@VRequried</#if><#if p.upload.enabled && (p.min > 0 || p.min > 0) || (p.upload.contentType?? && p.upload.contentType?length > 0)>@VUploadFile(min=${p.min}, max=${p.max}, contentTypes={<#list p.upload.contentTypes as t>"${t}"<#if t_has_next>, </#if></#list>})<#else><#if p.regex?? && (p.regex?length > 0)>
                          @VRegex(regex = "${p.regex}")</#if><#if p.email?? && p.email>
                          @VEmail</#if><#if p.mobile?? && p.mobile>
                          @VMobile</#if><#if p.datetime?? && p.datetime>
                          @VDateTime</#if><#if p.numeric?? && p.numeric>
                          @VNumeric<#if ((p.min?? && p.min > 0) && (p.max?? && p.max > 0))>(min = #{p.min}, max = ${p.max})<#elseif (p.min?? && p.min > 0)>min = ${p.min})<#elseif (p.max?? && p.max > 0)>max = ${p.max})</#if> <#else><#if ((p.min?? && p.min > 0) && (p.max?? && p.max > 0))>
                          @VLength(min = #{p.min}, max = ${p.max})<#elseif (p.min?? && p.min > 0)>@VLength(min = ${p.min})<#elseif (p.max?? && p.max > 0)>@VLength(max = ${p.max})</#if></#if></#if><#if p.label?? && (p.label?length > 0)>
                          @VField(label = "${p.label}")</#if> @RequestParam <#if p.upload.enabled>IUploadFileWrapper<#else>${p.type?cap_first}</#if> ${p.name}<#if p_has_next>,

                          </#if></#list>) throws Exception {
        __repository.create(<#list api.params as p><#if p.upload.enabled>__transferUploadFile(${p.name})<#else>${p.name}</#if><#if p_has_next>, </#if></#list>);
        return WebResult.SUCCESS().toJSON();
    }

    /**
     * 查询指定主键的记录详情
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}</#if> ${api.primary.description}
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping("/detail")<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_DETAIL")</#if>
    public IView __detail(@VRequried<#if api.primary.numeric?? && api.primary.numeric>
                          @VNumeric<#if ((api.primary.min?? && api.primary.min > 0) && (api.primary.max?? && api.primary.max > 0))>(min = #{api.primary.min}, max = ${api.primary.max})<#elseif (api.primary.min?? && api.primary.min > 0)>min = ${api.primary.min})<#elseif (api.primary.max?? && api.primary.max > 0)>max = ${api.primary.max})</#if> <#else><#if ((api.primary.min?? && api.primary.min > 0) && (api.primary.max?? && api.primary.max > 0))>
                          @VLength(min = #{api.primary.min}, max = ${api.primary.max})<#elseif (api.primary.min?? && api.primary.min > 0)>@VLength(min = ${api.primary.min})<#elseif (api.primary.max?? && api.primary.max > 0)>@VLength(max = ${api.primary.max})</#if></#if><#if api.primary.label?? && (api.primary.label?length > 0)>
                          @VField(label = "${api.primary.label}")</#if> @RequestParam ${api.primary.type?cap_first} ${api.primary.name}) throws Exception {
        return WebResult.SUCCESS().data(__repository.find(${api.primary.name})).toJSON();
    }

    /**
     * 更新指定主键的记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}</#if> ${api.primary.description}
     <#if (api.params?? && api.params?size > 0)><#list api.params as p>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}</#if> ${p.description}
     </#list></#if>
     * @param lastModifyTime 记录最后修改时间(用于版本比较)
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping(value = "/update", method = Type.HttpMethod.POST)<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_UPDATE")</#if><#if upload>
    @FileUpload</#if>
    public IView __update(@VRequried<#if api.primary.numeric?? && api.primary.numeric>
                          @VNumeric<#if ((api.primary.min?? && api.primary.min > 0) && (api.primary.max?? && api.primary.max > 0))>(min = #{api.primary.min}, max = ${api.primary.max})<#elseif (api.primary.min?? && api.primary.min > 0)>min = ${api.primary.min})<#elseif (api.primary.max?? && api.primary.max > 0)>max = ${api.primary.max})</#if> <#else><#if ((api.primary.min?? && api.primary.min > 0) && (api.primary.max?? && api.primary.max > 0))>
                          @VLength(min = #{api.primary.min}, max = ${api.primary.max})<#elseif (api.primary.min?? && api.primary.min > 0)>@VLength(min = ${api.primary.min})<#elseif (api.primary.max?? && api.primary.max > 0)>@VLength(max = ${api.primary.max})</#if></#if><#if api.primary.label?? && (api.primary.label?length > 0)>
                          @VField(label = "${api.primary.label}")</#if> @RequestParam ${api.primary.type?cap_first} ${api.primary.name},

                          <#list api.params as p><#if p.required?? && p.required>
                          @VRequried</#if><#if p.regex?? && (p.regex?length > 0)><#if p.upload.enabled && (p.min > 0 || p.min > 0) || (p.upload.contentType?? && p.upload.contentType?length > 0)>
                          @VUploadFile(min=${p.min}, max=${p.max}, contentTypes={<#list p.upload.contentTypes as t>"${t}"<#if t_has_next>, </#if></#list>})<#else>
                          @VRegex(regex = "${p.regex}")</#if><#if p.email?? && p.email>
                          @VEmail</#if><#if p.mobile?? && p.mobile>
                          @VMobile</#if><#if p.datetime?? && p.datetime>
                          @VDateTime</#if><#if p.numeric?? && p.numeric>
                          @VNumeric<#if ((p.min?? && p.min > 0) && (p.max?? && p.max > 0))>(min = #{p.min}, max = ${p.max})<#elseif (p.min?? && p.min > 0)>min = ${p.min})<#elseif (p.max?? && p.max > 0)>max = ${p.max})</#if> <#else><#if ((p.min?? && p.min > 0) && (p.max?? && p.max > 0))>
                          @VLength(min = #{p.min}, max = ${p.max})<#elseif (p.min?? && p.min > 0)>@VLength(min = ${p.min})<#elseif (p.max?? && p.max > 0)>@VLength(max = ${p.max})</#if></#if></#if><#if p.label?? && (p.label?length > 0)>
                          @VField(label = "${p.label}")</#if> @RequestParam <#if p.upload.enabled>IUploadFileWrapper<#else>${p.type?cap_first}</#if> ${p.name}<#if p_has_next>,

                          </#if></#list>,
                          @RequestParam(defaultValue = "0") Long lastModifyTime) throws Exception {
        __repository.update(${api.primary.name}, <#list api.params as p><#if p.upload.enabled>__transferUploadFile(${p.name})<#else>${p.name}</#if><#if p_has_next>, </#if></#list>, lastModifyTime);
        return WebResult.SUCCESS().toJSON();
    }</#if>

    /**
     * 删除指定主键的记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}</#if> ${api.primary.description}
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping(value = "/remove", method = Type.HttpMethod.POST)<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_REMOVE")</#if>
    public IView __remove(@VRequried<#if api.primary.numeric?? && api.primary.numeric>
                          @VNumeric<#if ((api.primary.min?? && api.primary.min > 0) && (api.primary.max?? && api.primary.max > 0))>(min = #{api.primary.min}, max = ${api.primary.max})<#elseif (api.primary.min?? && api.primary.min > 0)>min = ${api.primary.min})<#elseif (api.primary.max?? && api.primary.max > 0)>max = ${api.primary.max})</#if> <#else><#if ((api.primary.min?? && api.primary.min > 0) && (api.primary.max?? && api.primary.max > 0))>
                          @VLength(min = #{api.primary.min}, max = ${api.primary.max})<#elseif (api.primary.min?? && api.primary.min > 0)>@VLength(min = ${api.primary.min})<#elseif (api.primary.max?? && api.primary.max > 0)>@VLength(max = ${api.primary.max})</#if></#if><#if api.primary.label?? && (api.primary.label?length > 0)>
                          @VField(label = "${api.primary.label}")</#if> @RequestParam ${api.primary.type?cap_first} ${api.primary.name}) throws Exception {
        __repository.remove(${api.primary.name});
        return WebResult.SUCCESS().toJSON();
    }
</#if>
}