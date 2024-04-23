package site.beemil.samanthaV2.config.db;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@Configuration
public class DatabaseConfig {

	/* private final SshTunnelingUtil sshTunnelingUtil;

	public DatabaseConfig(SshTunnelingUtil sshTunnelingUtil) {
		this.sshTunnelingUtil = sshTunnelingUtil;
	} */

	@Bean
	@ConfigurationProperties(prefix = "spring.datasource.hikari")
	public HikariConfig hikariConfig() {
		return new HikariConfig();
	}

	@Bean
	public DataSource dataSource(HikariConfig hikariConfig) {
		// SSH Tunneling 연결 시 사용
		//sshTunnelingUtil.buildSshConnection();

		return new HikariDataSource(hikariConfig);
	}

	@Bean
	public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception{
		final SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
		sessionFactory.setDataSource(dataSource);
		PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

		//mybatis-config 연결
		sessionFactory.setConfigLocation(resolver.getResource("mapper/mybatis-config.xml"));

		//mapper 직접 연결 시 사용
		//sessionFactory.setMapperLocations(resolver.getResources("mapper/*.xml"));

		return sessionFactory.getObject();
	}

	@Bean
	public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) throws Exception{
		return new SqlSessionTemplate(sqlSessionFactory);
	}
}