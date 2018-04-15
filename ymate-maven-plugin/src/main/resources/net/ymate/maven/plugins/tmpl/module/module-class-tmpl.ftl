package ${packageName};

import ${packageName}.impl.DefaultModuleCfg;
import net.ymate.platform.core.Version;
import net.ymate.platform.core.YMP;
import net.ymate.platform.core.module.IModule;
import net.ymate.platform.core.module.annotation.Module;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * ${moduleName?cap_first}
 * <br>
 * Code generation by yMateScaffold on ${.now?string("yyyy/MM/dd a HH:mm")}
 *
 * @author ymatescaffold
 * @version 1.0
 */
@Module
public class ${moduleName?cap_first} implements IModule, I${moduleName?cap_first} {

    private static final Log _LOG = LogFactory.getLog(${moduleName?cap_first}.class);

    public static final Version VERSION = new Version(1, 0, 0, ${moduleName?cap_first}.class.getPackage().getImplementationVersion(), Version.VersionType.Alphal);

    private static volatile I${moduleName?cap_first} __instance;

    private YMP __owner;

    private I${moduleName?cap_first}ModuleCfg __moduleCfg;

    private boolean __inited;

    public static I${moduleName?cap_first} get() {
        if (__instance == null) {
            synchronized (VERSION) {
                if (__instance == null) {
                    __instance = YMP.get().getModule(${moduleName?cap_first}.class);
                }
            }
        }
        return __instance;
    }

    public static I${moduleName?cap_first} get(YMP owner) {
        return owner.getModule(${moduleName?cap_first}.class);
    }

    @Override
    public String getName() {
        return I${moduleName?cap_first}.MODULE_NAME;
    }

    @Override
    public void init(YMP owner) throws Exception {
        if (!__inited) {
            //
            _LOG.info("Initializing ${moduleArtifactId}-" + VERSION);
            //
            __owner = owner;
            __moduleCfg = new DefaultModuleCfg(owner);
            //
            // Here to write your code
            //
            __inited = true;
        }
    }

    @Override
    public boolean isInited() {
        return __inited;
    }

    @Override
    public void destroy() throws Exception {
        if (__inited) {
            __inited = false;
            //
            // Here to write your code
            //
            __moduleCfg = null;
            __owner = null;
        }
    }
    @Override
    public YMP getOwner() {
        return __owner;
    }

    @Override
    public I${moduleName?cap_first}ModuleCfg getModuleCfg() {
        return __moduleCfg;
    }
}
