#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package};

import net.ymate.platform.core.YMP;
import net.ymate.platform.log.Logs;

/**
 * My first YMP app.
 */
public class App {
    public static void main(String[] args) throws Exception {
        try {
            YMP.get().init();
            Logs.get().getLogger().info("Hello YMP world!");
        } finally {
            YMP.get().destroy();
        }
    }
}
