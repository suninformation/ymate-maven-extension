package ${packageName};

import net.ymate.platform.core.YMP;

/**
 * I${moduleName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
public interface I${moduleName?cap_first} {

    String MODULE_NAME = "${moduleName}";

    /**
     * @return 返回所属YMP框架管理器实例
     */
    YMP getOwner();

    /**
     * @return 返回模块配置对象
     */
    I${moduleName}ModuleCfg getModuleCfg();

    /**
    * @return 返回模块是否已初始化
    */
    boolean isInited();

}