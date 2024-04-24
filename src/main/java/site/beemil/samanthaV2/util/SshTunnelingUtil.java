package site.beemil.samanthaV2.util;

import com.jcraft.jsch.JSch;
import com.jcraft.jsch.JSchException;
import com.jcraft.jsch.Session;
import jakarta.annotation.PreDestroy;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.validation.annotation.Validated;

import java.util.Properties;

@Profile("!prod")
@Component
@ConfigurationProperties(prefix = "ssh")
@Validated
@Setter
public class SshTunnelingUtil {
    private String host;
    private String user;
    private int sshPort;
    private String privateKey;
    private int databasePort;

    private Session session;

    @PreDestroy
    public void closeSSH() {
        if (session != null && session.isConnected()) {
            session.disconnect();
        }
    }

    public Integer buildSshConnection() {
        Integer forwardedPort = null;

        try {
            JSch jSch = new JSch();
            Properties config = new Properties();

            jSch.addIdentity(privateKey);	// 개인키
            session = jSch.getSession(user, host, sshPort);	// 세션 설정

            config.put("StrictHostKeyChecking", "no");
            session.setConfig(config);
            session.connect();	// ssh 연결

            // 로컬pc의 남는 포트 하나와 원격 접속한 pc의 db포트 연결
            forwardedPort = session.setPortForwardingL(5432, "localhost", databasePort);

        } catch (JSchException e){
            this.closeSSH();
            e.printStackTrace();
        }
        return forwardedPort;
    }
}
