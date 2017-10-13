package ${packageName};

<#compress>
import net.ymate.platform.core.beans.intercept.AbstractInterceptor;
import net.ymate.platform.core.beans.intercept.InterceptContext;</#compress>

/**
 * ${interceptorName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
public class ${interceptorName?cap_first} extends AbstractInterceptor {

    @Override
    protected Object __before(InterceptContext context) throws Exception {
        return null;
    }

    @Override
    protected Object __after(InterceptContext context) throws Exception {
        return null;
    }
}