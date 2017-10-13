package ${packageName}.impl;

<#compress>
import ${packageName}.I${serviceName?cap_first};
import net.ymate.platform.core.beans.annotation.Bean;<#if (transaction)>
import net.ymate.platform.persistence.jdbc.annotation.Transaction;</#if></#compress>

/**
 * ${serviceName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
<#compress>
@Bean
<#compress>
<#if (transaction)>@Transaction</#if></#compress></#compress>
public class ${serviceName?cap_first} implements I${serviceName?cap_first} {
}