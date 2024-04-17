package site.beemil.samanthaV2.config.web;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.PrintWriter;

@Component
public class LoginCheckInterceptor implements HandlerInterceptor {

	///Constructor
	public LoginCheckInterceptor(){

		System.out.println("::"+getClass()+".setLoginCheckInterceptor Call.........");
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

			HttpSession session = request.getSession();
			String userId = (String) session.getAttribute("userId");

		if (userId != null) { // 로그인이 되어 있으면

			System.out.println("::");
			System.out.println("::[LoginCheckInterceptor] 서비스 실행을 허가합니다");

			return true; 	// 컨트롤러의 요청이 처리된다.

		} else {			// 로그인이 되어 있지 않으면

			System.out.println("::");
			System.out.println("::[LoginCheckInterceptor] 서비스 실행을 거부합니다");

			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();

			out.println("<script>");
			out.println("alert('비정상적인 접근입니다');");
			out.println("location.href='/';");
			out.println("</script>");
			out.close();

			return false; // 컨트롤러의 요청이 처리되지 않는다.
		}
	}
}//end of class