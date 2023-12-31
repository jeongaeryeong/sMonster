<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@ include file="../include/header.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- sweetalert -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>

<link rel="stylesheet" href="/resources/forTest/sm.css"> <!-- 버튼css -->
<link href="../resources/build/css/custom.css" rel="stylesheet">

<!-- 폰트 -->
<link href="https://webfontworld.github.io/NexonLv2Gothic/NexonLv2Gothic.css" rel="stylesheet">

<c:if test="${empty sessionScope.id}">
    <c:redirect url="/smmain/smMain" />
</c:if>
 
<style type="text/css">


	body {
		font-family: 'NexonLv2Gothic';
	}

	.selected {
		background-color: #ccc;
	}
	
	div:where(.swal2-container) button:where(.swal2-styled).swal2-deny{
	background-color: #868e96;
	}

	/* 셀렉트 옵션을 가로로 나열하여 버튼으로 꾸미기 위한 스타일 */
	.custom-select1 {
 		display: flex; 
		width: 25%;
		height: 25%;
		font-size: 13px; 
		line-height: 20px;
		background-color: transparent;
		border-style: none;
		padding: -1px;
	}

	.custom-select1 select {
		display: none;
	}

	.custom-select1 button {
		flex: 1;
		border-radius: 4px;
		padding: 5px 15px;
		font-size: 15px;
		font-weight: 500;
		border: none;
		border-style: none;
		cursor: pointer;
		outline: none;
		color: #73879C;
		transition: background-color 0.3s;
	}
	
 	.custom-select1 button:hover { 
 		background-color: #e0e0e0; 
 	} 



</style>
<!-- 폰트 -->


<script type="text/javascript">
	//팝업으로 열었을 때
	function popUp() {
		var queryString = window.location.search;
		var urlParams = new URLSearchParams(queryString);
		var isPop = urlParams.get("input");
		var serch = urlParams.get("search_client_type");
		if(isPop==="null") {
			isPop = null;
		}
		$('#pagination a').each(function(){
			if(serch==="null") {
				var prHref = $(this).attr("href");
				var newHref = prHref + "&input=" + isPop;
				$(this).attr("href", newHref);
			}
			
			var prHref = $(this).attr("href");
			var newHref = prHref + "&input=" + isPop +"&search_client_type"+serch;
			$(this).attr("href", newHref);
				
		}); //페이징 요소	
		
		
		$('#input').val(isPop);
		
		if(isPop!=null && isPop!="") {
			
			$('#addButton').hide();
	    	$('#updateButton').hide();
	    	$('#deleteButton').hide();
	    	$('#cancelButton').hide();
	    	$('#saveButton').hide();
	    	
	    	$('table tr').click(function(){
	   			$(this).css('background', '#ccc');
	    		
	        		var client_code = $(this).find('#client_code').text();
	        		var client_actname = $(this).find('#client_actname').text();
	        		var number = isPop.match(/\d+/);
	        		
	     			$('#'+isPop, opener.document).val(client_code);
	     			if(number !=null){
	     			$('#client_actname'+number, opener.document).val(client_actname);
	     			} else {
	     			$('#client_actname', opener.document).val(client_actname);
	     			}
	    		
	    		window.close();
	    	}); //테이블에서 누른 행 부모창에 자동입력하고 창 닫기
	    		
	     		
			} //if 
			
			else {
				console.log("팝업아님");
		} //if(팝업으로 열었을 때)
			
	} //popUp()
	
	$(document).ready(function() {
		popUp();
		
		//테이블 항목들 인덱스 부여
		$('table tr').each(function(index){
			var num = "<c:out value='${pvo.page}'/>";
			var num2 = "<c:out value='${pvo.pageSize}'/>";
			$(this).find('td:first').text(((num-1)*num2) + index-1);
		});
		
	});


	
	// ==================================== 버튼 =================================================
		
	
	
    function codeCreation() {
    	
		return prodCode;
    }
	
	// input으로 바꾸기
	function inputCng(obj, type, name, value) {
		var inputBox = "<input type='"+type+"' name='"+name+"' id='"+name+"' value='"+value+"'>";
		obj.html(inputBox);
	}// inputCng
	
	$(document).ready(function(){
		
	$('#addButton').click(function() {
			$('#updateButton').attr("disabled", true);
			$('#deleteButton').attr("disabled", true);
			
			var counter = 0;
		    var codeNum = 0;
		   	var clientCode = 0;
			
			if ($(this).hasClass('true')) {

				var tbl = "<tr>";
				// 번호
				tbl += " <td style='width:75px'>";
				tbl += " </td>";
				// 거래처 코드
				tbl += " <td>";
				tbl += "  <input type='text' name='client_code'' id='client_code2' readonly>";
				tbl += " </td>";
				// 거래처명
				tbl += " <td>";
				tbl += "  <input type='text' name='client_actname' id='client_actname2' required class='input-fieldb'>";
				tbl += " </td>";
				// 거래처 구분
				tbl += " <td>";
				tbl += "  <select name='client_type' id='client_type'>";
				tbl += "   <option>선택</option>";
				tbl += "   <option>발주처</option>";
				tbl += "   <option>수주처</option>";
				tbl += "  </select>"
				tbl += " </td>";
				// 사업자 번호
				tbl += " <td>";
				tbl += "  <input type='text' name='client_number' id='client_number' required class='input-fieldb'>";
				tbl += " </td>";
				// 업태
				tbl += " <td>";
				tbl += "  <input type='text' name='client_sort' id='client_sort' required class='input-fieldb'>";
				tbl += " </td>";
				// 대표자
				tbl += " <td>";
				tbl += "  <input type='text' name='client_ceo' id='client_ceo' required class='input-fieldb'>";
				tbl += " </td>";
				// 담당자
				tbl += " <td>";
				tbl += "  <input type='text' name='client_name' id='client_name' value=<c:out value='${sessionScope.id.emp_name}'/> readonly class='input-fieldb'>";
				tbl += " </td>";
				// 주소
				tbl += " <td>";
				tbl += "  <input type='text' name='client_addr' id='client_addr' required class='input-fieldb'>";
				tbl += " </td>";
				// 상세주소
				tbl += " <td>";
				tbl += "  <input type='text' name='client_addr2' id='client_addr2' required class='input-fieldb'>";
				tbl += " </td>";
				// 전화번호
				tbl += " <td>";
				tbl += "  <input type='text' name='client_tel' id='client_tel' required class='input-fieldb'>";
				tbl += " </td>";
				// 휴대폰번호
				tbl += " <td>";
				tbl += "  <input type='text' name='client_phone' id='client_phone' required class='input-fieldb'>";
				tbl += " </td>";
				// 팩스번호
				tbl += " <td>";
				tbl += "  <input type='text' name='client_fax' id='client_fax' required class='input-fieldb'>";
				tbl += " </td>";
				// email
				tbl += " <td>";
				tbl += "  <input type='text' name='client_email' id='client_email' required class='input-fieldb'>";
				tbl += " </td>";
				// 비고
				tbl += " <td>";
				tbl += "  <input type='text' name='client_note' id='client_note' required class='input-fieldb'>";
				tbl += " </td>";
				tbl += "</tr>";

				$('table').append(tbl);
				
				
// 				$("#client_type").on("change", function(){
// 				if($("#client_type option:selected").val() === '수주처' ){
// 					$('input[name="client_code"]').val('OR'+clientCode);
// 				} else if($("#client_type option:selected").val() === '발주처' ){
// 					$('input[name="client_code"]').val('CL'+clientCode);
// 				}
 				
					
					var selectedOption = "";
				    $('#client_type').on('change', function() {
				    	selectedOption = $(this).val(); // 선택된 옵션의 값 가져오기
						getClientCode();
				    });
				    
				    function getClientCode (){
				    	var jsonObj = {client_type : selectedOption};
					    $.ajax({
							url: "/person/clientCode",
							type: "POST",
							contentType : "application/json; charset=UTF-8",
				 			data: JSON.stringify(jsonObj),
				 			success: function (data) {
// 	 							alert(data);
								
								 
				 				 var num = parseInt(data.substring(2)) + counter+1; // 문자열을 숫자로 변환하여 1 증가
//	 			 				 alert("num : "+num);
				  				 var paddedNum = padNumber(num, data.length - 1); // 숫자를 패딩하여 길이 유지
				  				 clientCode = data.substring(0,2) + paddedNum.toString(); // 패딩된 숫자를 다시 문자열로 변환
							   	        
// 				  				alert(clientCode);
				  				 
								$('#client_code2').val(clientCode);
								
							}//success
				        });//ajax
					}

//	 			    counter++;
//	 			} // someFunction(data)
				
				function padNumber(number, length) {
//	 				alert("padNum");
	                var paddedNumber = number.toString();
	                while (paddedNumber.length < length-1) {
	                    paddedNumber = "0" + paddedNumber;
	                }
	                return paddedNumber;
	        } // padNumber(number, length)
				
// 				});
				
				$(this).removeClass('true');
			} // true 클래스 있을 때

			// 저장 -> form 제출하고 저장함
			$('#saveButton').click(function() {

				var client_code = $('#client_code2').val();
				var client_actname = $('#client_actname2').val();
				var client_type = $('#client_type').val();
				var client_number = $('#client_number').val();
				var client_sort = $('#client_sort').val();
				var client_ceo = $('#client_ceo').val();
				var client_name = $('#client_name').val();
				var client_addr = $('#client_addr').val();
				var client_addr2 = $('#client_addr2').val();
				var client_tel = $('#client_tel').val();
				var client_phone = $('#client_phone').val();
				var client_fax = $('#client_fax').val();
				var client_email = $('#client_email').val();
				var client_note = $('#client_note').val();

				if (client_code == "" || client_actname == "" || client_type == "" || client_number == "" || client_sort == "" 
						|| client_ceo == "" || client_name == "" || client_addr == "" || client_addr2 == "" || client_tel == "" 
						|| client_phone == "" || client_fax == "" || client_email == "") {
					
					Swal.fire({
						title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>" + "항목을 모두 입력하세요"+ "</div>",
						icon: 'info',
						width: '300px',
					});
					
					
					
				} else {
					$('#fr').attr("action", "/person/addClient");
					$('#fr').attr("method", "post");
					$('#fr').submit();
				}

			}); //save

			//취소버튼 -> 리셋
			$('#cancelButton').click(function() {
				$('#fr').each(function() {
					this.reset();
				});
			}); // cancle click

		}); // add click
		
		// 삭제 //
		$('#deleteButton').click(function() {

			$('#addButton').attr("disabled", true);
			$('#updateButton').attr("disabled", true);
	
			if($(this).hasClass('true')) {
				
				// td 요소 중 첫번째 열 체크박스로 바꾸고 해당 행의 거래처코드 저장
				$('table tr').each(function() {
					var code = $(this).find('td:nth-child(2)').text();
	
					var tbl = "<input type='checkbox' name='selected' value='";
					tbl += code;
					tbl += "'>";
	
					$(this).find('th:first').html("<input type='checkbox' id='selectAll'>");
					$(this).find('td:first').html(tbl);
				});
				
				//전체선택
				$('#selectAll').click(function() {
					var checkAll = $(this).is(":checked");
	
					if (checkAll) {
						$('input:checkbox').prop('checked', true);
					} else {
						$('input:checkbox').prop('checked', false);
					}
				});
	
				// 저장 -> 삭제
				$('#saveButton').click(function() {
	
					var checked = [];
	
					$('input[name=selected]:checked').each(function() {
						checked.push($(this).val());
					});
	

					// sweetalert
					if(checked.length > 0){
						Swal.fire({
							  title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>" + "총" +checked.length+"건\n정말 삭제하시겠습니까?"+ "</div>",
							  icon: 'info', // 아이콘! 느낌표 색? 표시?
							  showDenyButton: true,
							  confirmButtonColor: '#17A2B8', // confrim 버튼 색깔 지정
							  cancelButtonColor: '#73879C', // cancel 버튼 색깔 지정
							  confirmButtonText: 'Yes', // confirm 버튼 텍스트 지정
							  width : '300px', // alert창 크기 조절
							  
							}).then((result) => {
						
						 /* confirm => 예 눌렀을 때  */
						  if (result.isConfirmed) {
							$.ajax({
		 						url: "/person/delete",
		 						type: "POST",
		 						data: {checked : checked},
		 						dataType: "text",	
		 						success: function () {
		 							Swal.fire({
										  title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>"+ "총" +checked.length+"건 삭제 완료",
										  icon: 'success',
										  width : '300px',
										}).then((result) => {
										  if (result.isConfirmed) {
										    location.reload();
										  }
										});
								},
								error: function () {
									Swal.fire({
										title : "<div style='color:#495057;font-size:20px;font-weight:lighter'>"+ "삭제 중 오류가 발생했습니다",
										icon : 'question',
										width: '300px',
										});
									
								}
							});//ajax
							  } else if (result.isDenied) {
									Swal.fire({
									title : "<div style='color:#495057;font-size:20px;font-weight:lighter'>"+ "삭제가 취소되었습니다",
									icon : 'error',
									width: '300px',
									});
						}// if(confirm)
					});		
							
					}// 체크OOO
					else{
						Swal.fire({
							title : "<div style='color:#495057;font-size:20px;font-weight:lighter'>"+ "선택된 항목이 없습니다",
							icon : 'warning',
							width: '300px',
							});
					}// 체크 XXX
		
				}); // save				
				$(this).removeClass('true');
			} //if(삭제 버튼 true class 있으면)

			//취소 -> 리셋
			$('#cancelButton').click(function() {
				$('input:checkbox').prop('checked', false);
			});

		}); //deleteButton click
		
		// 수정 //
		var isExecuted = false;
		
		//수정버튼 클릭
		$('#updateButton').click(function() {

			$('#addButton').attr("disabled", true);
			$('#deleteButton').attr("disabled", true);

			// 행 하나 클릭했을 때	
			$('table tr:not(:first-child)').click(function() {

				//하나씩만 선택 가능
				if(!isExecuted) {
					isExecuted = true;
					
					$(this).addClass('selected');
					// 거래처코드 저장
					let updateCode = $(this).find('#client_code').text().trim();
					console.log(updateCode);
	
					var jsonData = {
						client_code : updateCode
					};
	
					var self = $(this);
	
					var names = [
							"client_code",
							"client_actname",
							"client_type",
							"client_number",
							"client_sort",
							"client_ceo",
							"client_name", 
							"client_addr", 
							"client_addr2", 
							"client_tel", 
							"client_phone", 
							"client_fax", 
							"client_email", 
							"client_note", 
							];
	
					//tr안의 td 요소들 input으로 바꾸고 기존 값 띄우기
					self.find('td').each(function(idx,item) {

						if (idx > 0) {
							inputCng($(this),"text",names[idx - 1], $(this).text());
							if (idx == 3) {
								var dropDown = "<select id='client_type' name='client_type'>";
								dropDown += "<option value='전체'>전체</option>";
								dropDown += "<option value='발주처'>발주처</option>";
								dropDown += "<option value='수주처'>수주처</option>";
								dropDown += "</select>";
								$(this).html(dropDown);
								$(this).find('option').each(function() {
									if (this.value == $(this).text()) {
										$(this).attr("selected",true);
									}
								}); // option이 client_type와 일치하면 선택된 상태로
							} // 거래처구분 - select
							
							// 거래처코드 readonly 속성 부여
							$(this).find("input").each(function(){
								if($(this).attr("name") === "client_code") {
									$(this).attr("readonly", true);
								}
							}); //readonly
							
						} // 거래처 코드부터 다 수정 가능하게

					}); // self.find(~~)
			
					//저장버튼 -> form 제출
					$('#saveButton').click(function() {
	
						$('#fr').attr("action","/person/update");
						$('#fr').attr("method","post");
						$('#fr').submit();
	
					}); //save

				} //하나씩만 선택 가능
					
					
				//취소버튼 -> 리셋
				$('#cancelButton').click(function() {
					$('#fr').each(function() {
						this.reset();
					});
				}); // cancelButton click

			}); // tr click

		}); // updateButton click

	
	// ==================================== 버튼 =================================================
	
	
	}); // JQuery
</script>

<style>
.table-wrapper {
    overflow-x: auto; /* 테이블 직접 조절 */
    overflow-y: hidden;
}
.table-wrapper table {
    width: 100%; /* 테이블 직접 조절 */
    white-space: nowrap; 
    text-align: center;
}
.input-fielda {
    cursor: pointer;
    display: inline-block;
    text-align-last: center;
}
.input-fieldb {
    display: inline-block;
    text-align-last: center;
}
</style>

<!-- page content -->
<div class="right_col" role="main">
	
	<h1 style="margin-left: 1%;">거래처 관리</h1>

	<div style="margin:1% 1%;">
	<hr>
		<form method="get" >
		
			<input type="hidden" name="input" id="input" value="${input }">
			거래처코드&nbsp;
			<input type="text" name="search_client_code" id="search_client_code" placeholder="거래처 코드를 입력하세요."> &nbsp;&nbsp;
			거래처명&nbsp;
			<input type="text" name="search_client_actname" id="search_client_actname" placeholder="거래처명을 입력하세요."> &nbsp;&nbsp;
			<input type="submit" class="B B-info" value="조회">
			
			<hr>
			<c:if test="${empty param.input }">
			<div class="custom-select1">
				<select name="search_client_type">
					<option value="전체" ${search.search_client_type == null ? 'selected' : ''}>전체</option>
					<option value="수주처" ${search.search_client_type == '수주처' ? 'selected' : ''}>수주처</option>
					<option value="발주처" ${search.search_client_type == '발주처' ? 'selected' : ''}>"발주처"</option>
				</select>
					<button onclick="selectOption(0)">전 체</button>
					<button onclick="selectOption(1)">수주처</button>
					<button onclick="selectOption(2)">발주처</button>
				</div>
			</c:if>
					
			<script>
			  function selectOption(index) {
			    var select = document.querySelector('.custom-select1 select');
			    select.selectedIndex = index;
			    select.dispatchEvent(new Event('change'));
			  }
			</script>
	
		</form>
	</div>

	<div class="col-md-12 col-sm-12">
		<div class="x_panel">
			<div class="x_title">
				<h2>거래처 목록<small>총 ${pm.totalCount } 건</small></h2>
				
				<div style="float: left;  margin-top: 1.5px;">
					<c:if test="${empty param.input }">
						<button onclick="location.href='/person/Clients'" class="B2 B2-info">↻</button>
					</c:if>
					<c:if test="${!empty param.input && empty param.search_client_type}">
						<button onclick="location.href='/person/Clients?input=${param.input }'" class="B2 B2-info">↻</button>
					</c:if>
					<c:if test="${!empty param.input && !empty param.search_client_type }">
						<button onclick="location.href='/person/Clients?input=${param.input }&search_client_type=${param.search_client_type }'" class="B2 B2-info">↻</button>
					</c:if>
				</div>

				<div style="float: right;">
					<input type="button" value="추가" id="addButton" class="true B B-info">
					<input type="button" value="수정" id="updateButton" class="B B-info"> 
					<input type="button" value="삭제" id="deleteButton" class="true B B-info"> 
					<input type="button" value="취소" id="cancelButton" class="B B-info"> 
					<input type="button" value="저장" id="saveButton" class="B B-info">
				</div>
			
			<!-- 버튼 제어 -->
			<script>
			    var team = "${sessionScope.id.emp_department }"; // 팀 조건에 따라 변수 설정
			
			    if (team === "인사팀" || team === "관리자") {
			        document.getElementById("addButton").disabled = false;
			        document.getElementById("updateButton").disabled = false;
			        document.getElementById("deleteButton").disabled = false;
			        document.getElementById("cancelButton").disabled = false;
			        document.getElementById("saveButton").disabled = false;
			        document.querySelector("[onclick^='location.href']").disabled = false;
			    } else {
			        document.getElementById("addButton").hidden = true;
			        document.getElementById("updateButton").hidden = true;
			        document.getElementById("deleteButton").hidden = true;
			        document.getElementById("cancelButton").hidden = true;
			        document.getElementById("saveButton").hidden = true;
			        document.querySelector("[onclick^='location.href']").hidden = true;
			    }
			</script>
			<!-- 버튼 제어 -->
			
			<div class="clearfix"></div>
		</div>
		<div class="x_content">
			<div class="table-responsive">
				<div class="table-wrapper" >
					<form id="fr">
					<table id="clientsTable" class="table table-striped jambo_table bulk_action" style="text-align-last:center;">
						<thead>
							<tr class="headings">
								<th>번호</th>
								<th>거래처코드</th>
								<th>거래처명</th>
								<th>거래처구분</th>
								<th>사업자번호</th>
								<th>업태</th>
								<th>대표자</th>
								<th>담당자</th>
								<th>주소</th>
								<th>상세주소</th>
								<th>전화번호</th>
								<th>휴대폰번호</th>
								<th>팩스번호</th>
								<th>email</th>
								<th>비고</th>
							</tr>
						</thead>
							<tr type="hidden" style="display: none;"></tr>
								<c:forEach var="vo" items="${searchClientsList }" varStatus="i">
									<c:if test="${vo.client_type == '전체' || vo.client_type == '발주처' || vo.client_type == '수주처' }">
										<tr>
											<td></td>
											<td id="client_code" >${vo.client_code}</td>
											<td id="client_actname">${vo.client_actname}</td>
											<td>${vo.client_type}</td>
											<td>${vo.client_number}</td>
											<td>${vo.client_sort}</td>
											<td>${vo.client_ceo}</td>
											<td>${vo.client_name}</td>
											<td>${vo.client_addr}</td>
											<td>${vo.client_addr2}</td>
											<td>${vo.client_tel}</td>
											<td>${vo.client_phone}</td>
											<td>${vo.client_fax}</td>
											<td>${vo.client_email}</td>
											<td>${vo.client_note}</td>
										</tr>
									</c:if>
								</c:forEach>
							</table>
						</form>
					</div>
				</div>
			</div>
		
		<!-- 페이징 -->
		<div id="pagination" class="dataTables_paginate paging_simple_numbers">
			<ul class="pagination">
				<li class="paginate_button previous disabled">
					<c:if test="${pm.prev }">
						<a href="/person/Clients?page=${pm.startPage - 1 }&search_client_code=${search.search_client_code}&search_client_actname=${search.search_client_actname}&search_client_type=${search.search_client_type}"> Previous </a>
					</c:if>
				</li>
				<li class="paginate_button previous disabled">
					<c:forEach var="page" begin="${pm.startPage }" end="${pm.endPage }" step="1">
						<a href="/person/Clients?page=${page }&search_client_code=${search.search_client_code}&search_client_actname=${search.search_client_actname}&search_client_type=${search.search_client_type}">${page }</a>
					</c:forEach>
				</li>
				<li class="paginate_button previous disabled">
					<c:if test="${pm.next }">
						<a href="/person/Clients?page=${pm.endPage + 1 }&search_client_code=${search.search_client_code}&search_client_actname=${search.search_client_actname}&search_client_type=${search.search_client_type}"> Next </a>
					</c:if>
				</li>
			</ul>
		</div>
		<!-- 페이징 -->
		</div>
	</div>
</div>
<!-- /page content -->
<%@ include file="../include/footer.jsp"%>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">


