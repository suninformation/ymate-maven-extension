#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.server;

import net.ymate.platform.core.YMP;
import net.ymate.platform.core.module.IModule;
import net.ymate.platform.serv.IServer;
import net.ymate.platform.serv.Servs;
import net.ymate.platform.serv.annotation.Server;
import net.ymate.platform.serv.nio.codec.TextLineCodec;
import net.ymate.platform.serv.nio.datagram.NioUdpListener;
import net.ymate.platform.serv.nio.datagram.NioUdpServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.InetSocketAddress;

/**
 * UdpServer
 */
@Server(implClass = NioUdpServer.class, codec = TextLineCodec.class)
public class UpdServer extends NioUdpListener {

    private final Logger _LOG = LoggerFactory.getLogger(UpdServer.class);

    public Object onSessionReady() throws IOException {
        return null;
    }

    public Object onMessageReceived(InetSocketAddress sourceAddr, Object message) throws IOException {
        _LOG.info(sourceAddr + "--->" + message);
        if ("quit".equalsIgnoreCase(message.toString())) {
            try {
                ((IModule) Servs.get()).destroy();
                // Or
                // YMP.get().destroy();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null;
        }
        return message;
    }

    public void onExceptionCaught(InetSocketAddress sourceAddr, Throwable e) throws IOException {
        _LOG.info(sourceAddr + "--->" + e);
    }

    /**
     * Startup UdpServer
     *
     * @param args nothing
     */
    public static void main(String[] args) throws Exception {
        YMP.get().init();
        IServer _server = Servs.get().getServer(UpdServer.class);
        _server.start();
    }
}
