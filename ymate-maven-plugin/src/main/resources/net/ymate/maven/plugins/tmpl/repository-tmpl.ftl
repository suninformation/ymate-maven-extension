package ${packageName}.impl;

<#compress>
import ${packageName}.I${repositoryName?cap_first};<#if (transaction)>
import net.ymate.platform.persistence.jdbc.annotation.Transaction;</#if><#if withConfig>
import net.ymate.platform.configuration.IConfiguration;
import net.ymate.platform.core.beans.annotation.Inject;
import net.ymate.platform.persistence.IResultSet;
import java.util.List;</#if>
import net.ymate.platform.persistence.jdbc.repo.IRepository;
import net.ymate.platform.persistence.jdbc.repo.annotation.Repository;</#compress>

/**
 * ${repositoryName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
<#compress>
@Repository
<#compress>
<#if (transaction)>@Transaction</#if></#compress></#compress>
public class ${repositoryName?cap_first}<#if withInterface> implements I${repositoryName?cap_first}</#if><#if withConfig><#if withInterface>, <#else>implements </#if> IRepository</#if> {

    <#if withConfig>
    @Inject
    private ${repositoryName?cap_first}Config __config;

    @Override
    public IConfiguration getConfig() {
        return __config;
    }

    /**
    * 自定义SQL
    */
    @Repository("select * from table1 where hash = ${r'${hash}'}")
    public IResultSet<Object[]> execSql(String hash, IResultSet<Object[]> results) throws Exception {
        return results;
    }

    /**
    * 读取配置文件中的SQL
    */
    @Repository(item = "demo_query")
    public List<Object[]> execQuery(String hash, IResultSet<Object[]>... results) throws Exception {
        return results[0].getResultData();
    }
    </#if>
}