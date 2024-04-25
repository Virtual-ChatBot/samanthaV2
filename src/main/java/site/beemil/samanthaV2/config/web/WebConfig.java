package site.beemil.samanthaV2.config.web;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	private final LoginCheckInterceptor loginCheckInterceptor;

	public WebConfig(LoginCheckInterceptor loginCheckInterceptor) {
		this.loginCheckInterceptor = loginCheckInterceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(loginCheckInterceptor)
				.addPathPatterns("/**") // 모든 request URL 진입 거부
				.excludePathPatterns(	// 제외 대상
						"/"
						, "/intro"
						, "/css/**"
						, "/fonts/**"
						, "/images/**"
						, "/media/**"
						, "/js/**"
						, "/user/visit"
						, "/user/login"
						, "/user/logout"
						, "/user/json/loginCk"
						, "/bot/**");
	}
}