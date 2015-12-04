package ${packageName};

<#compress>
import net.ymate.platform.persistence.jdbc.annotation.Transaction;
import net.ymate.platform.webmvc.*;
import net.ymate.platform.webmvc.annotation.*;
<#if (mapping?? && mapping.method?size > 0)>import net.ymate.platform.webmvc.base.Type;</#if>
<#if (mapping?? && mapping.mapping??)>
import net.ymate.platform.webmvc.view.IView;
import net.ymate.platform.webmvc.view.View;</#if></#compress>

import java.util.*;

/**
 * ${controllerName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
<#compress>
@Controller<#if singleton>(singleton = true)</#if>
<@compress single_line=true>
<#if (mapping?? && mapping.mapping??)>@RequestMapping(value = "${mapping.mapping}"<#if (mapping.method?size > 0)>, method = {<#list mapping.method as m>Type.HttpMethod.${m?upper_case}<#if m_has_next>, </#if></#list>}</#if>
<#if (mapping.header?size > 0)>, header = {<#list mapping.header as h>"${h}"<#if h_has_next>, </#if></#list>}</#if>
<#if (mapping.param?size > 0)>, param = {<#list mapping.param as p>"${p}"<#if p_has_next>, </#if></#list>}</#if>)</#if></@compress>
<#compress>
<#if (transaction)>@Transaction</#if></#compress></#compress>
public class ${controllerName?cap_first} {

<#if (mapping?? && mapping.mapping??)>
    @RequestMapping("/")
    public IView __index() throws Exception {
        return View.textView("Hello YMPer!");
    }</#if>

}