package site.beemil.samanthaV2.vo;
import lombok.Setter;

import java.sql.Date;

@Setter
public class UserVO {

	///Field
	private String userId;
	private String password;
	private String nickName;
	private String role;
	private Date regDate;

	///Method
	public String getUserId() {
		return userId;
	}

    public String getPassword() {
		return password;
	}

    public String getNickName() {
		return nickName;
	}

    public String getRole() {
		return role;
	}

    public Date getRegDate() {
		return regDate;
	}

    @Override
	public String toString() {
		return "User{" +
				"userId='" + userId + '\'' +
				", password='" + password + '\'' +
				", nickName='" + nickName + '\'' +
				", role='" + role + '\'' +
				", regDate=" + regDate +
				'}';
	}
}