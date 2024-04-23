package site.beemil.samanthaV2.controller.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WebController {

    @RequestMapping("/")
    public String index() {

        System.out.println("::");
        System.out.println("::[CommonController] 비밀연구소에 오신 걸 환영합니다.");

        return "index";
    }

    @RequestMapping("visit")
    public String visit() {

        System.out.println("::");
        System.out.println("::[CommonController] 비회원 입장 서비스를 실행합니다.");

        return "main";
    }

    @RequestMapping("/intro")
    public String intro() {

        System.out.println("::");
        System.out.println("::[CommonController] 소개 서비스를 실행합니다.");

        return "intro";
    }
}
