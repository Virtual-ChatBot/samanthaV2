package site.beemil.samanthaV2.dao;


import org.apache.ibatis.annotations.Mapper;
import site.beemil.samanthaV2.vo.UserVO;

@Mapper
public interface UserDAO {
	// 로그인 서비스
	public UserVO login(String userId) throws Exception;

}