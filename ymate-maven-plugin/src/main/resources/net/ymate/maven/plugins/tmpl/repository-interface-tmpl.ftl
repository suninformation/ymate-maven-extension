package ${packageName};

<#if withConfig>
import net.ymate.platform.persistence.IResultSet;
import java.util.List;</#if>

/**
 * I${repositoryName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
public interface I${repositoryName?cap_first} {

    <#if withConfig>
    IResultSet<Object[]> execSql(String hash, IResultSet<Object[]> results) throws Exception;

    List<Object[]> execQuery(String hash, IResultSet<Object[]>... results) throws Exception;
    </#if>
}