#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.client;

import net.ymate.platform.core.YMP;
import net.ymate.platform.core.util.RuntimeUtils;
import net.ymate.platform.serv.IClient;
import net.ymate.platform.serv.Servs;
import net.ymate.platform.serv.annotation.Client;
import net.ymate.platform.serv.nio.codec.TextLineCodec;
import net.ymate.platform.serv.nio.datagram.NioUdpClient;
import net.ymate.platform.serv.nio.datagram.NioUdpListener;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.InetSocketAddress;

/**
 * UdpClient
 */
@Client(implClass = NioUdpClient.class, codec = TextLineCodec.class)
public class UdpClient extends NioUdpListener {

    private final static Logger _LOG = LoggerFactory.getLogger(UdpClient.class);

    @Override
    public Object onSessionReady() throws IOException {
        return "Hi, UdpServer!";
    }

    @Override
    public Object onMessageReceived(InetSocketAddress sourceAddr, Object message) throws IOException {
        _LOG.info(sourceAddr + "--->" + message);
        return null;
    }

    @Override
    public void onExceptionCaught(InetSocketAddress sourceAddr, Throwable e) throws IOException {
        _LOG.info(sourceAddr + "--->" + StringUtils.trimToEmpty(e.getMessage()), e);
    }

    /**
     * Startup UdpClient
     *
     * @param args nothing
     */
    public static void main(String[] args) throws Exception {
        YMP.get().init();
        final IClient _client = Servs.get().getClient(UdpClient.class);
        _client.connect();
        //
        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        Thread.sleep(50000L);
                        if (_client.isConnected()) {
                            _client.send("quit");
                            _client.close();
                        }
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                }
            }).start();
        } catch (Throwable e) {
            _LOG.warn("", RuntimeUtils.unwrapThrow(e));
            YMP.get().destroy();
        }
    }
}
