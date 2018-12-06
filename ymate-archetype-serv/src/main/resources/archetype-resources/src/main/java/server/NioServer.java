#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.server;

import net.ymate.platform.core.YMP;
import net.ymate.platform.serv.Servs;
import net.ymate.platform.serv.annotation.Server;
import net.ymate.platform.serv.nio.INioSession;
import net.ymate.platform.serv.nio.server.NioServerListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * NioServer
 */
@Server
public class NioServer extends NioServerListener {

    private final static Logger _LOG = LoggerFactory.getLogger(NioServer.class);

    @Override
    public void onSessionAccepted(INioSession session) throws IOException {
        super.onSessionAccepted(session);
        session.send("hello from server.");
    }

    @Override
    public void onMessageReceived(Object message, INioSession session) throws IOException {
        super.onMessageReceived(message, session);
        _LOG.info(session + "--->" + message);
        session.send(message);
    }

    /**
     * Startup NioServer
     *
     * @param args nothing
     */
    public static void main(String[] args) throws Exception {
        YMP.get().init();
        Servs.get().getServer(NioServer.class).start();
    }
}
