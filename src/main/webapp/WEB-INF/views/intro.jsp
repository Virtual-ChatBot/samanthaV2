<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>

<html lang="ko">

	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />

		<title>BEEMIL</title>

		<!--LOGO-->
		<link rel="apple-touch-icon" sizes="180x180" href="../images/phantom/logo.svg">
		<link rel="icon" type="image/png" sizes="32x32" href="../images/phantom/logo.svg">
		<link rel="icon" type="image/png" sizes="16x16" href="../images/phantom/logo.svg">

		<!--CSS-->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
		<link rel="stylesheet" href="../css/phantom/main.css">

		<noscript>
			<link rel="stylesheet" href="../css/phantom/noscript.css">
		</noscript>
	</head>

	<body class="is-preload">
		<!-- Wrapper -->
			<div id="wrapper">

				<!-- Header -->
					<header id="header">
						<div class="inner">

							<!-- Logo -->
							<c:if test="${sessionScope.user.nickName eq 'BEEMIL'}">

								<a href="../user/login?userId=${user.userId}" class="logo">
									<span class="symbol"><img src="../images/phantom/logo.svg" alt="" /></span><span class="title">BEEMIL</span>
								</a>

							</c:if>

							<c:if test="${sessionScope.user.nickName ne 'BEEMIL'}">

								<a href="../user/visit" class="logo">
									<span class="symbol"><img src="../images/phantom/logo.svg" alt="" /></span><span class="title">BEEMIL</span>
								</a>

							</c:if>

							<!-- Nav -->
								<nav>
									<ul>
										<li><a href="#menu">Menu</a></li>
									</ul>
								</nav>

						</div>
					</header>

				<!-- Menu -->
				<nav id="menu">
					<h2>환영합니다</h2>

					<ul>
						<li>
							<c:if test="${sessionScope.user.nickName eq 'BEEMIL'}">
								<a href="../user/login?userId=${user.userId}">메인으로</a>
							</c:if>

							<c:if test="${sessionScope.user.nickName ne 'BEEMIL'}">
								<a href="../user/visit">메인으로</a>
							</c:if>
						</li>

						<li>
							<a href="../user/logout">로그아웃</a>
						</li>

						<li>
							<a href="../intro">소개</a>
						</li>

						<li>
							<a href="generic.html">게시판</a>
						</li>
					</ul>
				</nav>

				<!-- Main -->
					<div id="main">
						<div class="inner">

							<header>

								<a href="../intro" class="logo">
									<h1>SAMANTHA V2</h1>
								</a>

								<br>

							</header>

							<p>음성인식 챗봇에 관한 이야기입니다</p>
							<span class="image main"><img src="images/beemil/her.png" alt="" /></span>
							<p><b>Q. 왜 음성인식 챗봇이죠?</b></p>
							<p>대학교 졸업을 앞둘 즈음 우연히 '그녀'(HER)라는 영화를 보게 되었어요. 주인공 '테오도르'를 연기한 호아킨 피닉스의 명성 때문이기도 했지만 그가 하얀색 이어폰을 끼고 가상의 인물과 대화하는 모습은 너무나 흥미로운 장면이었습니다. 저는 그 이어폰이 '에어팟'인 줄 알았어요.</p>
							<br>
							<p><b>Q. 그게 당신이 IT를 시작하게 된 계기인가요?</b></p>
							<P>네, 맞아요. 처음엔 공상 영화라고 생각했어요. 하지만 ChatGPT 의 등장과 함께 '그녀'(HER)는 현실이 되었습니다.</P>
							<br>
							<p><b>Q. 당신이 만든 음성인식 챗봇에 대해 설명해주세요</b></p>
							<p>제가 만든 챗봇과 깊은 대화는 할 수 없어요. "안녕", "뭐해" 등 텍스트를 입력하거나 음성인식을 통해 지정된 답변만 가능합니다. 하지만 특별한 점이 있다면 '스테이블 디퓨전'을 통해 '외형'을 얻었다는 점입니다.</p>
							<br>
							<p><b>Q. 외형? 그것에 대해 설명해주세요</b></p>
							<p>처음엔 'D-ID' 사의 스테이블 디퓨전 API를 사용하려고 했어요. 하지만 고비용에 느린 영상 변환 속도 등 실시간 서비스에는 어울리지 않았습니다. 그래서 챗봇 외형 출력 엔진을 직접 자바스크립트로 만들었습니다.</p>
							<br>
							<p><b>Q. 쉽지 않았을텐데요</b></p>
							<p>네, 관련 외국 사이트도 정말 많이 방문했어요. 외국 분들도 해당 이슈에 고민이 많으시더라구요.</p>
							<br>
							<p><b>Q. 챗봇의 외형과 음성에 특히 관심이 많으신 이유가 있으신가요?</b></p>
							<P>'chatGPT' 를 처음 사용하면서 느낀 감정은 "사람같다" 이었습니다. 하지만 오래 사용하다보니 사람이 아닌 '검색엔진' 과 같다는 생각이 들더군요. 그 부분을 매울 수 있는 것이 외형과 음성이라고 생각했습니다. 외형과 음성을 갖는 것만으로도 사람들은 심리적으로 챗봇을 '사람'처럼 생각하게 될 것입니다.</P>
							<br>
							<p><b>Q. 앞으로 목표를 말씀해주세요</b></p>
							<P>외형적으론 스테이블 디퓨전 출력 영상이 끊기지 않도록 보강하는게 첫번째 목표이구요, 음성으로는 챗봇이 출력하려는 문장의 단어를 모두 파악하고 문단마다 등급을 매겨 음을 길게 끌거나 강한 악센트를 주는 등 기준을 부여해 가장 자연스러운 '사람 음성'으로 말할 수 있도록 만드는 것이 제 목표입니다.</P>
							<p><b>(2023/07/26)</b></p>
						</div>
					</div>

				<!-- Footer -->
				<footer id="footer">
					<div class="inner">

						<section>
							<h2>HER</h2>

							<!--carousel-->
							<div id="carousel" class="carousel carousel-dark slide carousel-fade" data-bs-ride="carousel">

								<div class="carousel-inner">
									<div class="carousel-item active">
										<video class="d-block w-100" autoplay loop>
											<source src="../media/beemil/her.mp4" type="video/mp4">
										</video>
									</div>
								</div>

							</div>
						</section>

						<section>
							<div>
								<h2>Follow</h2>
								<ul class="icons">
									<li><a href="https://www.linkedin.com/in/beemil" target="_blank" class="icon brands style2 fa-linkedin"><span class="label">GitHub</span></a></li>
									<li><a href="https://github.com/Virtual-ChatBot" target="_blank" class="icon brands style2 fa-github"><span class="label">GitHub</span></a></li>
									<li><a href="https://www.youtube.com/@beemil" target="_blank" class="icon brands style2 fa-youtube"><span class="label">Youtube</span></a></li>
								</ul>
							</div>

							<br>
							<br>

							<div>
								<h2>Project</h2>
								<ul class="icons">
									<li><a href="https://github.com/Virtual-ChatBot/samanthaAI" target="_blank" class="icon brands style2 fa-git"><span class="label">git</span></a></li>
									<li><a href="https://github.com/Virtual-ChatBot/samanthaV2" target="_blank" class="icon brands style2 fa-git"><span class="label">git</span></a></li>
									<li><a href="https://github.com/Virtual-ChatBot/samanthaV1" target="_blank" class="icon brands style2 fa-git"><span class="label">git</span></a></li>
								</ul>
							</div>
						</section>

						<ul class="copyright">
							<li>&copy; Untitled. All rights reserved</li><li>Design: <a href="https://html5up.net" target="_blank">HTML5 UP</a></li>
						</ul>

					</div>
				</footer>
			</div>

		<!--Bootstrap-->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>

		<!--Jquery-->
		<script src="https://code.jquery.com/jquery-latest.min.js"></script>

		<!-- Scripts -->
		<script src="../js/phantom/browser.min.js"></script>
		<script src="../js/phantom/breakpoints.min.js"></script>
		<script src="../js/phantom/util.js"></script>
		<script src="../js/phantom/main.js"></script>

	</body>
</html>