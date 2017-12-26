<#setting number_format="#">
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
@Security<#if (security.roles?? && (security.roles?size > 0)) || (security.permissions?? && (security.permissions?size > 0)) || security.name?? && (security.name?length > 0)>
@Permission(<#if security.name?? && (security.name?length > 0)>name = "${security.name}"</#if><#if security.roles?? && (security.roles?size > 0)><#if security.name?? && (security.name?length > 0)>, </#if>roles = {<#list security.roles as p>${p}<#if p_has_next>,</#if></#list>}</#if><#if security.permissions?? && (security.permissions?size > 0)>, value = {<#list security.permissions as p>"${p}"<#if p_has_next>,</#if></#list>}</#if>)</#if></#if><#if intercept?? && (intercept?size > 0)><#if intercept.before?? && (intercept.before?size > 0)>
@Before({<#list intercept.before as p>${p}.class<#if p_has_next>,</#if></#list>})</#if><#if intercept.after?? && (intercept.after?size > 0)>
@After({<#list intercept.after as p>${p}.class<#if p_has_next>,</#if></#list>})</#if><#if intercept.around?? && (intercept.around?size > 0)>
@Around({<#list intercept.around as p>${p}.class<#if p_has_next>,</#if></#list>})</#if><#if intercept.params?? && (intercept.params?size > 0)>
@ContextParam({<#list intercept.params?keys as p>@ParamItem(key = "${p}", value = "${intercept.params[p]}")<#if p_has_next>,</#if></#list>})</#if></#if>
public class ${api.name?cap_first}Controller {

    @Inject
    private I${api.name?cap_first}Repository __repository;

    /**
     * 条件查询
     *
<#if api.primary.filter?? && api.primary.filter.enabled>
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
</#if>
<#if formbean>* @param ${api.name}Form DTO对象<#else><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled><#compress>
     * @param <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if> <#if p.label?? && (p.label?length > 0)>${p.label}<#else>${p.description}<#if p.filter.region>范围最小值</#if></#if><#if p.filter.region>
     * @param end${p.name?cap_first} <#if p.label?? && (p.label?length > 0)>${p.label}范围最大值</#if></#if></#compress></#if>
</#list></#if></#if>

     * @param page 查询页号
     * @param pageSize 分页大小
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping("/query")<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_QUERY")</#if>
    public IView __query(<#if api.primary.filter?? && api.primary.filter.enabled>@VRequried<#if api.primary.validation??><#if api.primary.validation.numeric?? && api.primary.validation.numeric>
                         @VNumeric</#if><#if ((api.primary.validation.min?? && api.primary.validation.min > 0) && (api.primary.validation.max?? && api.primary.validation.max > 0))>
                         @VLength(min = ${api.primary.validation.min}, max = ${api.primary.validation.max})<#elseif (api.primary.validation.min?? && api.primary.validation.min > 0)>
                         @VLength(min = ${api.primary.validation.min})<#elseif (api.primary.validation.max?? && api.primary.validation.max > 0)>
                         @VLength(max = ${api.primary.validation.max})</#if><#if api.primary.label?? && (api.primary.label?length > 0)>
                         @VField(label = "${api.primary.label}")</#if></#if> @RequestParam ${api.primary.type?cap_first} ${api.primary.name}, </#if>

                        <#if formbean>@ModelBind ${app.packageName}.dto.${api.name?cap_first}FormBean ${api.name}Form, <#else>

                         <#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled><#if p.validation??><#if p.validation.regex?? && (p.validation.regex?length > 0)>
                         @VRegex(regex = "${p.validation.regex}")</#if><#if p.validation.email?? && p.validation.email>
                         @VEmail</#if><#if p.validation.mobile?? && p.validation.mobile>
                         @VMobile</#if><#if p.validation.datetime?? && p.validation.datetime>
                         @VDateTime</#if><#if p.validation.numeric?? && p.validation.numeric>
                         @VNumeric</#if><#if ((p.validation.min?? && p.validation.min > 0) && (p.validation.max?? && p.validation.max > 0))>
                         @VLength(min = ${p.validation.min}, max = ${p.validation.max})<#elseif (p.validation.min?? && p.validation.min > 0)>@VLength(min = ${p.validation.min})<#elseif (p.validation.max?? && p.validation.max > 0)>@VLength(max = ${p.validation.max})</#if><#if p.label?? && (p.label?length > 0)>
                         @VField(label = "${p.label}<#if p.filter.region>范围最小值</#if>")</#if></#if> @RequestParam ${p.type?cap_first} <#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>,

                         <#if p.validation??><#if p.validation.regex?? && (p.validation.regex?length > 0)>
                         @VRegex(regex = "${p.validation.regex}")</#if><#if p.validation.email?? && p.validation.email>
                         @VEmail</#if><#if p.validation.mobile?? && p.validation.mobile>
                         @VMobile</#if><#if p.validation.datetime?? && p.validation.datetime>
                         @VDateTime</#if><#if p.validation.numeric?? && p.validation.numeric>
                         @VNumeric</#if><#if ((p.validation.min?? && p.validation.min > 0) && (p.validation.max?? && p.validation.max > 0))>
                         @VLength(min = ${p.validation.min}, max = ${p.validation.max})<#elseif (p.validation.min?? && p.validation.min > 0)>@VLength(min = ${p.validation.min})<#elseif (p.validation.max?? && p.validation.max > 0)>@VLength(max = ${p.validation.max})</#if>
                         @VCompare(with = "begin${p.name?cap_first}"<#if p.label?? && (p.label?length > 0)>, withLabel = "${p.label}范围最小值"</#if>)<#if p.label?? && (p.label?length > 0)>
                         @VField(label = "${p.label}<#if p.filter.region>范围最大值</#if>")</#if></#if> @RequestParam ${p.type?cap_first}  end${p.name?cap_first}</#if><#if p_has_next>,

                         </#if></#if></#list></#if>, </#if>

                         @RequestParam int page, @RequestParam int pageSize) throws Exception {

    IResultSet<<#if query>Object[]<#else>${api.model}</#if>> _result = __repository.find(<#if api.primary.filter?? && api.primary.filter.enabled>${api.primary.name}, </#if><#if formbean>${api.name}Form, null, null<#else><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if p.filter?? && p.filter.enabled><#if p.filter.region>begin${p.name?cap_first}<#else>${p.name}</#if><#if p.filter.region>, end${p.name?cap_first}</#if><#if p_has_next>, </#if></#if></#list>, </#if>null, null</#if>, page, pageSize);
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
     <#if formbean>* @param ${api.name}Form DTO对象<#else><#compress><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}<#else>${p.description}</#if></#if>
     </#list></#if></#compress></#if>

     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping(value = "/create", method = Type.HttpMethod.POST)<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_CREATE")</#if><#if upload>
    @FileUpload</#if>
    public IView __create(<#if formbean>@ModelBind ${app.packageName}.dto.${api.name?cap_first}UpdateFormBean ${api.name}Form<#else><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>,

                          </#if><#if p.required?? && p.required>@VRequried</#if><#if p.upload.enabled && (p.min > 0 || p.min > 0) || (p.upload.contentType?? && p.upload.contentType?length > 0)>
                          @VUploadFile(min=${p.min}, max=${p.max}, contentTypes={<#list p.upload.contentTypes as t>"${t}"<#if t_has_next>, </#if></#list>})<#else><#if p.validation??><#if p.validation.regex?? && (p.validation.regex?length > 0)>
                          @VRegex(regex = "${p.validation.regex}")</#if><#if p.validation.email?? && p.validation.email>
                          @VEmail</#if><#if p.validation.mobile?? && p.validation.mobile>
                          @VMobile</#if><#if p.validation.datetime?? && p.validation.datetime>
                          @VDateTime</#if><#if p.validation.numeric?? && p.validation.numeric>
                          @VNumeric</#if><#if ((p.validation.min?? && p.validation.min > 0) && (p.validation.max?? && p.validation.max > 0))>
                          @VLength(min = ${p.validation.min}, max = ${p.validation.max})<#elseif (p.validation.min?? && p.validation.min > 0)>
                          @VLength(min = ${p.validation.min})<#elseif (p.validation.max?? && p.validation.max > 0)>
                          @VLength(max = ${p.validation.max})</#if></#if><#if p.label?? && (p.label?length > 0)>
                          @VField(label = "${p.label}")</#if></#if> @RequestParam<#if !p.required && !p.upload.enabled><#if p.defaultValue?? && (p.defaultValue?length > 0)>(defaultValue = "${p.defaultValue}")</#if></#if> <#if p.upload.enabled>IUploadFileWrapper<#else>${p.type?cap_first}</#if> ${p.name}</#if></#list></#if>) throws Exception {

        __repository.create(<#if formbean>${api.name}Form<#else><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>, </#if><#if p.upload.enabled>__transferUploadFile(${p.name})<#else>${p.name}</#if></#if></#list></#if>);
        return WebResult.SUCCESS().toJSON();
    }

    /**
     * 查询指定主键的记录详情
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping("/detail")<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_DETAIL")</#if>
    public IView __detail(@VRequried<#if api.primary.validation??><#if api.primary.validation.numeric?? && api.primary.validation.numeric>
                          @VNumeric</#if><#if ((api.primary.validation.min?? && api.primary.validation.min > 0) && (api.primary.validation.max?? && api.primary.validation.max > 0))>
                          @VLength(min = ${api.primary.validation.min}, max = ${api.primary.validation.max})<#elseif (api.primary.validation.min?? && api.primary.validation.min > 0)>
                          @VLength(min = ${api.primary.validation.min})<#elseif (api.primary.validation.max?? && api.primary.validation.max > 0)>
                          @VLength(max = ${api.primary.validation.max})</#if><#if api.primary.label?? && (api.primary.label?length > 0)>
                          @VField(label = "${api.primary.label}")</#if></#if> @RequestParam ${api.primary.type?cap_first} ${api.primary.name}) throws Exception {

        return WebResult.SUCCESS().data(__repository.find(${api.primary.name})).toJSON();
    }

    <#if !api.updateDisabled>/**
     * 更新指定主键的记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     <#if formbean>* @param ${api.name}Form DTO对象<#else><#compress><#if (api.params?? && api.params?size > 0)><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else>
     * @param ${p.name} <#if p.label?? && (p.label?length > 0)>${p.label}<#else>${p.description}</#if></#if>
     </#list></#if></#compress></#if><#if api.timestamp>

     * @param lastModifyTime 记录最后修改时间(用于版本比较)</#if>
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping(value = "/update", method = Type.HttpMethod.POST)<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_UPDATE")</#if><#if upload>
    @FileUpload</#if>
    public IView __update(@VRequried<#if api.primary.validation??><#if api.primary.validation.numeric?? && api.primary.validation.numeric>
                          @VNumeric</#if><#if ((api.primary.validation.min?? && api.primary.validation.min > 0) && (api.primary.validation.max?? && api.primary.validation.max > 0))>
                          @VLength(min = ${api.primary.validation.min}, max = ${api.primary.validation.max})<#elseif (api.primary.validation.min?? && api.primary.validation.min > 0)>
                          @VLength(min = ${api.primary.validation.min})<#elseif (api.primary.validation.max?? && api.primary.validation.max > 0)>
                          @VLength(max = ${api.primary.validation.max})</#if><#if api.primary.label?? && (api.primary.label?length > 0)>
                          @VField(label = "${api.primary.label}")</#if></#if> @RequestParam ${api.primary.type?cap_first} ${api.primary.name},

                          <#if formbean>@ModelBind ${app.packageName}.dto.${api.name?cap_first}UpdateFormBean ${api.name}Form<#else>

                          <#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>,

                          </#if><#if p.required?? && p.required>
                          @VRequried</#if><#if p.upload.enabled && (p.min > 0 || p.min > 0) || (p.upload.contentType?? && p.upload.contentType?length > 0)>
                          @VUploadFile(min=${p.min}, max=${p.max}, contentTypes={<#list p.upload.contentTypes as t>"${t}"<#if t_has_next>, </#if></#list>})<#else><#if p.validation??><#if p.validation.regex?? && (p.validation.regex?length > 0)>
                          @VRegex(regex = "${p.validation.regex}")</#if><#if p.validation.email?? && p.validation.email>
                          @VEmail</#if><#if p.validation.mobile?? && p.validation.mobile>
                          @VMobile</#if><#if p.validation.datetime?? && p.validation.datetime>
                          @VDateTime</#if><#if p.validation.numeric?? && p.validation.numeric>
                          @VNumeric</#if><#if ((p.validation.min?? && p.validation.min > 0) && (p.validation.max?? && p.validation.max > 0))>
                          @VLength(min = ${p.validation.min}, max = ${p.validation.max})<#elseif (p.validation.min?? && p.validation.min > 0)>
                          @VLength(min = ${p.validation.min})<#elseif (p.validation.max?? && p.validation.max > 0)>
                          @VLength(max = ${p.validation.max})</#if></#if><#if p.label?? && (p.label?length > 0)>
                          @VField(label = "${p.label}")</#if></#if> @RequestParam<#if !p.required && !p.upload.enabled><#if p.defaultValue?? && (p.defaultValue?length > 0)>(defaultValue = "${p.defaultValue}")</#if></#if> <#if p.upload.enabled>IUploadFileWrapper<#else>${p.type?cap_first}</#if> ${p.name}</#if></#list></#if><#if api.timestamp>,

                          @RequestParam long lastModifyTime</#if>) throws Exception {

        __repository.update(${api.primary.name}, <#if formbean>${api.name}Form<#else><#list api.params as p><#if api.timestamp && (p.name == 'createTime' || p.name == 'lastModifyTime')><#else><#if (p_index > 0)>, </#if><#if p.upload.enabled>__transferUploadFile(${p.name})<#else>${p.name}</#if></#if></#list></#if><#if api.timestamp>, lastModifyTime</#if>);
        return WebResult.SUCCESS().toJSON();
    }</#if></#if>

    /**
     * 删除指定主键的记录
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${api.primary.description}</#if>
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping(value = "/remove", method = Type.HttpMethod.POST)<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_REMOVE")</#if>
    public IView __remove(@VRequried<#if api.primary.validation??><#if api.primary.label?? && (api.primary.label?length > 0)>
                          @VField(label = "${api.primary.label}")</#if></#if> @RequestParam ${api.primary.type?cap_first}[] ${api.primary.name}) throws Exception {

        __repository.remove(${api.primary.name});
        return WebResult.SUCCESS().toJSON();
    }

    <#if api.status?? && (api.status?size > 0 && !api.updateDisabled)><#list api.status as p><#if p.enabled>

    /**
     * <#if p.description?? && (p.description?length > 0)>${p.description}<#else>设置指定主键记录的 ${p.column?upper_case} 字段值为 <#if (p.type?lower_case == 'string')>"${p.value}"<#else>${p.value}</#if></#if>
     *
     * @param ${api.primary.name} <#if api.primary.label?? && (api.primary.label?length > 0)>${api.primary.label}<#else>${p.description}</#if>
     * @param reason 原因说明
     * @return 返回执行结果视图
     * @throws Exception 可能产生的任何异常
     */
    @RequestMapping(value = "/status/${p.name?lower_case}", method = Type.HttpMethod.POST)<#if security?? && security.enabled>
    @Permission("${security.prefix}${api.name?upper_case}_STATUS_${p.name?upper_case}")</#if>
    public IView __status${p.name?cap_first}(@VRequried<#if api.primary.label?? && (api.primary.label?length > 0)>
                         @VField(label = "${api.primary.label}")</#if> @RequestParam ${api.primary.type?cap_first}[] ${api.primary.name},<#if p.reason> @VRequried</#if> @RequestParam String reason) throws Exception {

        __repository.update(${api.primary.name}, ${api.model}.FIELDS.${p.column?upper_case}, <#if (p.type?lower_case == 'string')>"${p.value}"<#else>${p.value}</#if>);
        return WebResult.SUCCESS().toJSON();
    }
    </#if></#list></#if>
</#if>
}