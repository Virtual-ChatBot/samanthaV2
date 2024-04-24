package site.beemil.samanthaV2.service;

import site.beemil.samanthaV2.vo.UserVO;

public interface UserService {
	UserVO login(String userId) throws Exception;
}