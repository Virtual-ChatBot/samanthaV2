<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>

<html lang="ko">

	<head>
		<meta charset="utf-8" />
    	<meta name="viewport" content="width=device-width, initial-scale=1">
    	
		<title>BEEMIL</title>

		<!--LOGO-->
		<link rel="apple-touch-icon" sizes="180x180" href="../images/phantom/logo.svg">
		<link rel="icon" type="image/png" sizes="32x32" href="../images/phantom/logo.svg">
		<link rel="icon" type="image/png" sizes="16x16" href="../images/phantom/logo.svg">
	
		<!--CSS-->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
		<link rel="stylesheet" href="../css/phantom/index.css">

		<noscript>
			<link rel="stylesheet" href="../css/phantom/noscript.css">
		</noscript>
	</head>

	<body class="is-preload">
		<div class="sidenav">

			<div class="login-main-text">
            	<h2>비밀연구소</h2>
         	</div>

			<!--carousel-->
			<div id="carousel" class="carousel carousel-dark slide carousel-fade" data-bs-ride="carousel">

				<div class="carousel-indicators">
					<button type="button" data-bs-target="#carousel" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
					<button type="button" data-bs-target="#carousel" data-bs-slide-to="1" aria-label="Slide 2"></button>
				</div>

				<div class="carousel-inner">

					<div class="carousel-item active" data-bs-interval="5000">

						<img src="../images/beemil/carousel1.png" class="d-block w-100" alt="...">

						<div class="carousel-caption d-none d-md-block">
							<h5>YOUTUBE</h5>
							<p>구독 감사합니다</p>
							<br>
						</div>

					</div>

					<div class="carousel-item" data-bs-interval="5000">
						<img src="../images/beemil/carousel2.png" class="d-block w-100" alt="...">
					</div>

				</div>

				<button class="carousel-control-prev" type="button" data-bs-target="#carousel" data-bs-slide="prev">
					<span class="carousel-control-prev-icon" aria-hidden="true"></span>
					<span class="visually-hidden">Previous</span>
				</button>

				<button class="carousel-control-next" type="button" data-bs-target="#carousel" data-bs-slide="next">
					<span class="carousel-control-next-icon" aria-hidden="true"></span>
					<span class="visually-hidden">Next</span>
				</button>

			</div>

		</div>
    
		<!--bodyContents-->
		<div class="main" id="bodyContents">
	 		<div class="col-md-6 col-sm-12">
				<div class="login-form">

					<div class="form-check">

						<label for="rememberId">
							<input class="form-check-input" type="checkbox" id="rememberId">
							아이디 저장
						</label>

					</div>

					<div class="form-group">
				 		<input type="text" class="form-control" id="userId" name="userId" placeholder="아이디">
					</div>

					<div class="form-group">
				 		<input type="password" class="form-control" id="password" name="password" placeholder="비밀번호">
					</div>

					<br>

					<div class="d-grid gap-2">

						<button class="btn btn-dark" type="button">관리자 로그인</button>

						<a class="btn btn-danger" role="button" href="../visit">비회원 입장</a>
						<!--일부 화면만 전환 가능<a class="btn btn-danger" role="button" onclick="acyncMovePage('/user/addUser')">회원 가입</a>-->

					</div>

					<label class="form-label">*누구나 입장 가능합니다</label>

				</div>
			</div>
		</div>

        <!--Bootstrap-->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>

	    <!--Jquery-->
	    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
	    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js" integrity="sha512-3j3VU6WC5rPQB4Ld1jnLV7Kd5xr+cq9avvhwqzbH/taCRNURoeEpoPBK9pDyeukwSxwRPJ8fDgvYXd6SkaZ2TA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    	<script type="text/javascript">

		$( function() {

			//============= 첫 페이지 아이디 text에 포커스 Event 시작 =============
			$('#userId').focus();

			//============= 첫 페이지 아이디 text에 쿠키 정보 로드하기 Event 시작 =============
			fn_displayRememberId();

			//============= 엔터 Event 시작 =============
			$("#userId").on("keyup",function(key){
		        if(key.keyCode==13) {
		        	getProdNo();
		        }
		    });

			$("#password").on("keyup",function(key){
		        if(key.keyCode==13) {
		        	getProdNo();
		        }
		    });
			//============= 로그인 Event 로 넘어감 =============

			//============= 버튼 클릭 Event 시작 =============
			$(".btn.btn-dark").on("click" , function() {

				getProdNo();

			});
			//============= 로그인 Event 로 넘어감(밑으로) =============

				//============= 제이쿼리 쿠키 Event 시작 =============
			$(".btn.btn-dark").on("click" , function() {		// 로그인 버튼을 클릭 했을때

				if($('#rememberId').is(':checked')) {			// 아이디 저장에 체크가 되어 있을때

					$.cookie('rememberId', $('#userId').val(), {expires: 1}); // 아이디를 쿠키에 저장한다.

				} else {

					$.removeCookie('rememberId', {path:'/'});	// 아이디 저장에 체크가 안되어 있을 시 쿠키값을 삭제한다.
				}
			});

			$("#rememberId").on("click" , function() {			// 체크를 클릭 했을때

				if($('#rememberId').is(':checked')) {			// 아이디 저장에 체크가 될 때

					$.cookie('rememberId', $('#userId').val() , {expires: 1}); 		// 아이디를 쿠키에 저장한다.

				} else{

					$.removeCookie('rememberId', {path:'/'});	// 아이디 저장에 체크가 해제될 때 쿠키값을 삭제한다.
				}
			});
		//============= 아이디 쿠키 저장  Event 종료 =============
		});//끝
		//============= 로그인 EVENT 시작 =============
		function getProdNo() {

			//============= 아이디 입력여부 EVENT 시작 =============
			let id=$("#userId").val();

			if(id.trim()==="") {

				alert("아이디를 입력해주세요");
				$('#userId').focus();
				return;
			}

			//============= 패스워드 입력여부 EVENT 시작 =============
			let pwd=$("#password").val();

			if(pwd.trim()==="") {

				alert("패스워드를 입력해주세요");
				$('#password').focus();
				return;
			}

			$.ajax({

					url:'/user/json/loginCk',
					data:{"userId":id,"password":pwd},
					success:function(result) {

					let res=result.trim();

					if(res==='NOID') {

						alert("계정이 존재하지 않습니다");

						$('#userId').val("");
						$('#password').val("");
						$('#userId').focus();

					} else {

						if(res==='NOPWD') {

							alert("패스워드를 잘못 입력하였습니다");
							$('#password').val("");
							$('#password').focus();

						} else if(res==='YESPWD') {

							self.location="/user/login?userId="+id;
						}
					}
				}
		});
		//============= 로그인 EVENT 종료 =============



		}
		//============= 회원가입 Event 시작 =============
    	function acyncMovePage(url){
            // ajax option
            let ajaxOption = {
                    url : url,
                    async : true,
                    type : "GET",
                    dataType : "html",
                    cache : false
            };

            $.ajax(ajaxOption).done(function(data){
                // Contents 영역 삭제
                $('#bodyContents').children().remove();
                // Contents 영역 교체
                $('#bodyContents').html(data);
            });
        }

    	//============= 아이디 쿠키 저장 불러오기 Event 시작 =============
    	function fn_displayRememberId() {

			let rememberId = $.cookie('rememberId');		//// 쿠키에 저장된 값을 불러온다.

			if(rememberId == '') {							// 쿠키가 비어 있을 시

				$('#userId').val('');						// 아이디 값을 비우고

				$('#rememberId').prop('checked', false); 	// 아이디 체크를 해제한다.

			} else {

					$('#userId').val(rememberId);			// 쿠키에 값이 있을 시 아이디에 값을 채운다.

				if($('#userId').val() != ''){				// 아이디 값이 있을 시

					$('#rememberId').prop('checked', true); // 아이디 체크를 한다.
				}
			}
		}

		</script>

	</body>
</html>