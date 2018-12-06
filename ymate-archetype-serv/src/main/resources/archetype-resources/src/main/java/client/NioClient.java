#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.client;

import net.ymate.platform.core.YMP;
import net.ymate.platform.core.util.RuntimeUtils;
import net.ymate.platform.serv.IClient;
import net.ymate.platform.serv.Servs;
import net.ymate.platform.serv.annotation.Client;
import net.ymate.platform.serv.impl.DefaultHeartbeatService;
import net.ymate.platform.serv.impl.DefaultReconnectService;
import net.ymate.platform.serv.nio.INioSession;
import net.ymate.platform.serv.nio.client.NioClientListener;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.concurrent.atomic.AtomicLong;

/**
 * NioClient
 */
@Client(reconnectClass = DefaultReconnectService.class,
        heartbeatClass = DefaultHeartbeatService.class)
public class NioClient extends NioClientListener {

    private final static Logger _LOG = LoggerFactory.getLogger(NioClient.class);

    private static AtomicLong _idx = new AtomicLong(0);

    @Override
    public void onSessionConnected(INioSession session) throws IOException {
        super.onSessionConnected(session);
        session.send("Hello from client.");
    }

    @Override
    public void onMessageReceived(Object message, INioSession session) throws IOException {
        _LOG.info(session + "--->" + message);
        //
        if (_idx.get() < 30) {
            session.send("Hello, " + _idx.getAndIncrement());
        }
    }

    @Override
    public void onExceptionCaught(Throwable e, INioSession session) throws IOException {
        _LOG.error(session + "--->" + StringUtils.trimToEmpty(e.getMessage()), e);
    }

    public static void main(String[] args) throws Exception {
        YMP.get().init();
        final IClient _client = Servs.get().getClient(NioClient.class);
        _client.connect();
        //
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(50000L);
                    _client.close();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();
    }
}
