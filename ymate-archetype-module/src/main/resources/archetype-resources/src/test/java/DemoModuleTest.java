#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import junit.framework.TestCase;
import net.ymate.platform.core.YMP;

/**
 * DemoModule TestCase
 */
public class DemoModuleTest extends TestCase {

    @Override
    public void setUp() throws Exception {
        super.setUp();
        //
        YMP.get().init();
    }

    @Override
    public void tearDown() throws Exception {
        super.tearDown();
        //
        YMP.get().destroy();
    }

    public void testDemoModule() throws Exception {
        //
        DemoModule.get().sayHi("guys");
        //
        IDemoModule _demo = DemoModule.get();
        System.out.println(_demo.getModuleCfg().getModuleParamOne());
    }
}
