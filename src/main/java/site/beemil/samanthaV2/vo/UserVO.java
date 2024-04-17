package site.beemil.samanthaV2.vo;
import java.sql.Date;

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

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getNickName() {
		return nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public Date getRegDate() {
		return regDate;
	}

	public void setRegDate(Date regDate) {
		this.regDate = regDate;
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