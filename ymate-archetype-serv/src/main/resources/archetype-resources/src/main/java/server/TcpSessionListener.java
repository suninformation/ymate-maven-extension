#set( $symbol_pound = '#' )
#set( $symbol_dollar = '$' )
#set( $symbol_escape = '\' )
package ${package}.server;

import net.ymate.platform.core.YMP;
import net.ymate.platform.core.support.Speedometer;
import net.ymate.platform.serv.IServerCfg;
import net.ymate.platform.serv.Servs;
import net.ymate.platform.serv.impl.DefaultServerCfg;
import net.ymate.platform.serv.impl.DefaultSessionIdleChecker;
import net.ymate.platform.serv.nio.codec.NioStringCodec;
import net.ymate.platform.serv.nio.server.INioSessionListener;
import net.ymate.platform.serv.nio.server.NioSessionManager;
import net.ymate.platform.serv.nio.server.NioSessionWrapper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import java.io.IOException;

/**
 * TcpSessionListener
 */
public class TcpSessionListener implements INioSessionListener<NioSessionWrapper, String> {

    private static final Log _LOG = LogFactory.getLog(TcpSessionListener.class);

    public static void main(String[] args) throws Exception {
        // 初始化YMP框架
        YMP.get().init();
        // 创建服务端配置
        IServerCfg _serverCfg = DefaultServerCfg.create()
                .selectorCount(10)
//                .serverHost("localhost")
                .port(8281)
                .keepAliveTime(60000).build();
        // 通过会话管理器创建服务 (设置会话空闲时间为30秒)
        final NioSessionManager<NioSessionWrapper, String> _manager = new NioSessionManager<NioSessionWrapper, String>(_serverCfg, new NioStringCodec(), new TcpSessionListener(), 30000L);
        // 设置空闲会话检查服务
        _manager.idleChecker(new DefaultSessionIdleChecker<NioSessionWrapper, String, String>());
        // 设置流量速度计数器
        _manager.speedometer(new Speedometer());
        // 初始化并启动服务
        _manager.init(Servs.get());

        // -------------------

        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(30000L);
                    // 遍历会话并向其发送消息
                    for (NioSessionWrapper _session : _manager.sessionWrappers()) {
                        _manager.sendTo(_session.getId(), "Send message from server.");
                    }
                    // 当前会话总数
                    System.out.println("Current session count: " + _manager.sessionCount());
                    Thread.sleep(10000L);
                    // 将已连接的客户端会话从管理器中移除
                    for (NioSessionWrapper _session : _manager.sessionWrappers()) {
                        _manager.closeSessionWrapper(_session);
                    }
                    Thread.sleep(10000L);
                    // 销毁会话管理器
                    _manager.destroy();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        }).start();
    }

    @Override
    public void onSessionRegistered(NioSessionWrapper session) throws IOException {
        _LOG.info("onSessionRegistered: " + session.getId());
        session.getSession().send("Hi!");
    }

    @Override
    public void onSessionAccepted(NioSessionWrapper session) throws IOException {
        _LOG.info("onSessionAccepted: " + session.getId());
    }

    @Override
    public void onBeforeSessionClosed(NioSessionWrapper session) throws IOException {
        _LOG.info("onBeforeSessionClosed: " + session.getId());
    }

    @Override
    public void onAfterSessionClosed(NioSessionWrapper session) throws IOException {
        _LOG.info("onAfterSessionClosed: " + session.getId());
    }

    @Override
    public void onMessageReceived(String message, NioSessionWrapper session) throws IOException {
        _LOG.info("onMessageReceived: " + message + " from " + session.getId());
        session.getSession().send(message);
    }

    @Override
    public void onExceptionCaught(Throwable e, NioSessionWrapper session) throws IOException {
        _LOG.info("onExceptionCaught: " + e.getMessage() + " -- " + session.getId());
    }

    @Override
    public void onSessionIdleRemoved(NioSessionWrapper sessionWrapper) {
        _LOG.info("onSessionIdleRemoved: " + sessionWrapper.getId());
    }
}
