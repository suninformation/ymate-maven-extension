#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.client;

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
        hearbeatClass = DefaultHeartbeatService.class)
public class NioClient extends NioClientListener {

    private final Logger _LOG = LoggerFactory.getLogger(NioClient.class);

    private static AtomicLong _idx = new AtomicLong(0);

    @Override
    public void onSessionConnected(INioSession session) throws IOException {
        super.onSessionConnected(session);
        session.send("Hello from client.");
    }

    @Override
    public void onMessageReceived(Object message, INioSession session) throws IOException {
        _LOG.info(session + "--->" + message);
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        long _i = _idx.getAndIncrement();
        if (_i < 30) {
            session.send("Hello, " + _i);
        }
    }

    @Override
    public void onExceptionCaught(Throwable e, INioSession session) throws IOException {
        _LOG.error(session + "--->" + StringUtils.trimToEmpty(e.getMessage()), e);
    }
}
