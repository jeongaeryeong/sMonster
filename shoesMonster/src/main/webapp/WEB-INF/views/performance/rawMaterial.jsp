<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@ include file="../include/header.jsp"%>
<!-- sweetalert -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<!-- SheetJS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<!--FileSaver [savaAs 함수 이용] -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>

<link href="./resources/build/css/custom.css" rel="stylesheet" type="text/css">

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

div:where(.swal2-container) button:where(.swal2-styled).swal2-deny{
	background-color: #868e96;
}

</style>
<!-- 폰트 -->

    <script>
    
	//input으로 바꾸기 
	function inputCng(obj, type, name, value) {
		var inputBox = "<input type='"+type+"' name='"+name+"' id='"+name+"' value='"+value+"'>";
		obj.html(inputBox);
	} //inputCng
	
	// 팝업 옵션
	const popupOpt = "top=60,left=140,width=877,height=677";
	
	//검색 팝업(거래처,창고)
  	function openWindow(search, inputId) {
   	 	var url = "/workorder/search?type=" + search + "&input=" + inputId;
    	var popup = window.open(url, "", popupOpt);
    } //openWindow()
    
	
	// 추가 시 거래처 검색 
    function serchClient(inputId){
    	openWindow("client_r",inputId);
    }
    
    // 추가 시 창고 검색
    function serchWh(inputId){
    	openWindow("wh_r",inputId);
    }
    
    function submitForm() {
  	  var isValid = true;

  	  // 유효성 검사
  	  $('#rawTable input[required]').each(function() {
  	    if ($(this).val().trim() === '') {
  	      isValid = false;
  	      return false; // 유효성 검사 실패 시 반복문 종료
  	    }
  	  });

  	  if (isValid) {
  	    $('#fr').submit();
  	  } else {
  		  Swal.fire({
			title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>" + "항목을 모두 입력하세요"+ "</div>",
			icon: 'info',
			width: '300px',
		});
  	 }
  	}
    
    
 	// 팝업으로 열었을 때
    function popUp() {
    	var queryString = window.location.search;
    	var urlParams = new URLSearchParams(queryString);
    	var isPop = urlParams.get("input");
    	
    	if(isPop==="null") {
    		isPop = null;
    	}
    	
    	$('#pagination a').each(function(){
    		
       		var prHref = $(this).attr("href");
       			
    			var newHref = prHref + "&input=" + isPop;
    			$(this).attr("href", newHref);
    			
    	}); //페이징 요소	
    	
    	
    	$('#input').val(isPop);
    	
    	if(isPop!=null && isPop!="") {
    		
    		$('#addButton').hide();
        	$('#modify').hide();
        	$('#delete').hide();
        	$('#cancle').hide();
        	$('#save').hide();
        	
       		$('table tr:not(:first-child)').click(function(){
       			$(this).css('background', '#ccc');
        		
            		var rawCode = $(this).find('#rawCode').text();
            		var rawName = $(this).find('#rawName').text();
            		var number = isPop.match(/\d+/);
            		
         			$('#'+isPop, opener.document).val(rawCode);
         			if(number !=null){
         			$('#raw_name'+number, opener.document).val(rawName);
         			} else {
         			$('#raw_name', opener.document).val(rawName);
         			}
        		
        		window.close();
        	}); //테이블에서 누른 행 부모창에 자동입력하고 창 닫기
        		
         		
    		} //if 
    		
    		else {
    			console.log("팝업아님");
    	} //if(팝업으로 열었을 때)
    		
    } //popUp()
    
        $(document).ready(function() {

        	//테이블 항목들 인덱스 부여
    		$('table tr').each(function(index){
    			var num = "<c:out value='${paging.nowPage}'/>";
    			var num2 = "<c:out value='${paging.cntPerPage}'/>";
    			$(this).find('td:first').text(((num-1)*num2) + index-1);
    		});

        	popUp();
        	
        	
        	 // 추가 시 필요한 변수들

            var counter = 0;
            var codeNum = 0;
        	var rawCode = 0;
            
         	// 버튼 클릭시 addRow() 기능 불러오기
            $('#addButton').click(function() {
            	$('#modify').attr("disabled", true);
    			$('#delete').attr("disabled", true);
    			
    			$.ajax({
    				  url: "/performance/rawCode",
    				  method: "GET",
    				  dataType: "text",
    				  success: function(data) {
    				    // Ajax 요청 안에서 데이터를 받아와서 변수에 할당 및 후속 작업 수행
    				    codeNum = data;
    				    console.log("Ajax 내부에서의 codeNum:", codeNum); // Ajax 내부에서의 codeNum: [받아온 데이터]
    				    
    				    // 변수에 할당된 데이터를 기반으로 추가 작업 수행
    				    someFunction(codeNum);
    				  }
    				}); // ajax 끝

    				function someFunction(data) {
    					 codeNum = data; // 외부에서의 codeNum: [받아온 데이터]
   						 var num = parseInt(codeNum.substring(2)) + counter+1; // 문자열을 숫자로 변환하여 1 증가
   						 var paddedNum = padNumber(num, codeNum.length - 2); // 숫자를 패딩하여 길이 유지
   			             rawCode = codeNum.charAt(0) + codeNum.charAt(1)+ paddedNum.toString(); // 패딩된 숫자를 다시 문자열로 변환
   			             addRow();
   			             counter++;
    				} // someFunction(data)
    				
    				$('#save').click(function() {
            		
    					submitForm();

					}); //save
            	
            }); //  $('#addButton').click(function()
            
            // 추가 버튼 클릭 시 row 생성
            function addRow() {
                var row = '<tr>' +
                	'<td style="width: 75px"></td>'+
                    '<td><input type="text" name="raws[' + counter + '].raw_code" value="'+ rawCode +'" readonly required class="input-fieldb"></td>' +
                    '<td><input type="text" name="raws[' + counter + '].raw_name" required class="input-fieldb"></td>' +
                    '<td><input type="text" name="raws[' + counter + '].raw_color" required class="input-fieldb"></td>' +
                    '<td><input type="text" name="raws[' + counter + '].raw_unit" required class="input-fieldb" value="EA"></td>' +
                    '<td><input type="text" name="raws[' + counter + '].raw_size" required class="input-fieldb"></td>' +
                    '<input type="hidden" name="raws[' + counter + '].client_code" id="client_code'+counter+'" required required>' +
                    '<td><input type="text" name="raws[' + counter + '].clients.client_actname" id="client_actname'+counter+'" readonly onclick=serchClient("client_code'+counter+'"); class="input-fielda"></td>' +
                    '<input type="hidden" name="raws[' + counter + '].wh_code" id="wh_code'+counter+'" onclick=serchWh("wh_code'+counter+'"); required>' +
                    '<td><input type="text" name="raws[' + counter + '].wh.wh_name" id="wh_name'+counter+'" readonly onclick=serchWh("wh_code'+counter+'"); required class="input-fielda"></td>' +
                    '<td><input type="text" name="raws[' + counter + '].raw_price" required class="input-fieldb"></td>' +
                    '<td><input type="text" name="raws[' + counter + '].raw_note" class="input-fieldb"></td>' +
                    '</tr>';

                $('#rawTable').append(row);
                
            	 // 테이블이 많이 생성되면 스크롤바 생성
                var table = document.getElementById('rawTable');
                table.scrollTop = table.scrollHeight;
                
                
            }
            
            function padNumber(number, length) {
                var paddedNumber = number.toString();
                while (paddedNumber.length < length) {
                    paddedNumber = "0" + paddedNumber;
                }
                return paddedNumber;
       		 } // padNumber(number, length)

            
            // =============================================================================================================
 			
            /////////////// 수정 //////////////////////////////
			var isExecuted = false;
			
			//수정버튼 클릭
			$('#modify').click(function() {
				event.preventDefault();
				$('#addButton').attr("disabled", true);
				$('#delete').attr("disabled", true);

				//행 하나 클릭했을 때	
				$('table tr:not(:first-child)').click(function() {
					
					//하나씩만 선택 가능
					if(!isExecuted) {
						isExecuted = true;
								
						$(this).addClass('selected');
						//품목코드 저장
						let updateCode = $(this).find('#rawCode').text().trim();
						console.log(updateCode);
		
						var jsonData = {
							raw_code : updateCode
						};
		
						var self = $(this);
		
						$.ajax({
							url : "/performance/rawOne",
							type : "post",
							contentType : "application/json; charset=UTF-8",
							dataType : "json",
							data : JSON.stringify(jsonData),
							success : function(data) {
								// alert("*** 아작스 성공 ***");
								var sum = 0;
								
								var preVOs = [
										data.raw_code,
										data.raw_name,
										data.raw_color,
										data.raw_unit,
										data.raw_size,
										data.client_code,
										data.clients.client_actname,
										data.wh_code,
										data.wh.wh_name,
										data.raw_price,
										data.raw_note
										];
								
								var names = [
										"raw_code",
										"raw_name",
										"raw_color",
										"raw_unit",
										"raw_size",
										"client_code",
										"client_actname",
										"wh_code",
										"wh_name",
										"raw_price",
										"raw_note"
										];
		
								//tr안의 td 요소들 input으로 바꾸고 기존 값 띄우기
								
								self.find('td').each(function(idx,item) {
									if (idx > 0) {
										inputCng($(this),"text",names[idx - 1],preVOs[idx - 1]);
										if (idx == 6) {
										inputCng($(this),"hidden",names[5],preVOs[5]);
										} else if (idx == 8){
										inputCng($(this),"hidden",names[7],preVOs[7]);
										}
									} //라인코드부터 다 수정 가능하게
		
								}); // self.find(~~)
								
								//거래처 검색 
								$('#client_actname').click(function() {
									openWindow("client_r","client_code");
								}); //client_code click
								
								// 창고 검색
								$('#wh_name').click(function() {
									openWindow("wh_r","wh_code");
								}); // wh_code click
								
							},
							error : function(data) {
								alert("아작스 실패 ~~");
							}
						}); //ajax
		
						//저장버튼 -> form 제출
						$('#save').click(function() {
		
							$('#fr').attr("action","/performance/rawModify");
							$('#fr').attr("method","post");
							$('#fr').submit();
		
						}); //save

					} //하나씩만 선택 가능
						
						
					//취소버튼 -> 리셋
					$('#cancle').click(function() {
						$('#fr').each(function() {
							this.reset();
						});
					}); //cancle click

				}); //tr click

			}); //modify click
            	
           	
            // =============================================================================================================

        	//취소버튼 -> 리셋
			$('#cancle').click(function(){
				$('#fr').each(function(){
					this.reset();
				});
			}); //cacle click
			
			
			// 삭제 기능
			$('#delete').click(function(event){
				event.preventDefault();
				$('#addButton').attr("disabled", true);
				$('#modify').attr("disabled", true);
				
				// td 요소 중 첫번째 열 체크박스로 바꾸고 해당 행의 작업 지시 코드 저장
				$('table tr').each(function(){
					var code = $(this).find('td:nth-child(2)').text();
					
					var tbl = "<input type='checkbox' name='selected' value='";
					tbl += code;
					tbl += "'>";
					
					$(this).find('th:first').html("<input type='checkbox' id='selectAll'>");
					$(this).find('td:first').html(tbl);
				});
				
				$('#selectAll').click(function() {
					var checkAll = $(this).is(":checked");
					
					if(checkAll) {
						$('input:checkbox').prop('checked', true);
					} else {
						$('input:checkbox').prop('checked', false);
					}
				});
				
				
				//저장 -> 삭제
				$('#save').click(function() {
					
					var checked = [];
					
					$('input[name=selected]:checked').each(function(){
						checked.push($(this).val());
					});
					
//	 				alert(checked);
					
					if(checked.length > 0) {
						
						 
// 						Swal.fire({
// 						  title: "<div style='color:#3085d6;font-size:20px'>" + "총" +checked.length+"행\n정말 삭제하시겠습니까?"+ "</div>",
// 								  // “<div style=’color:#f00;font-size:15px’>” + msg + “</div>”,    //  HTML & CSS 로 직접수정
// 						  icon: 'warning', // 아이콘! 느낌표 색? 표시?
// 						  showDenyButton: true,
// 						  confirmButtonColor: '#3085d6', // confrim 버튼 색깔 지정
// 						  cancelButtonColor: '#d33', // cancel 버튼 색깔 지정
// 						  confirmButtonText: '예', // confirm 버튼 텍스트 지정
// 						  cancelButtonText: '아니오', // cancel 버튼 텍스트 지정
// 						  width : '300px' // alert창 크기 조절
						   
// 						}).then((result) => {
// 						 /* confirm => 예 눌렀을 때  */
// 						  if (result.isConfirmed) {
							  
// 							  $.ajax({
// 									url: "/performance/rawMaterialDelete",
// 									type: "post",
// 									data: {checked:checked},
// 									dataType: "text",
// 									success: function() {
// 										Swal.fire({
// 											  title:  "총" +checked.length+"건 삭제 완료",
// 											  icon: 'error',
// 											}).then((result) => {
// 											  if (result.isConfirmed) {
// 											    location.reload();
// 											  }
// 											});
// 									},
// 									error: function() {
// 										Swal.fire('삭제 실패!.', '', 'success')
// 									}
// 								}); //ajax
							  
// 						  } else if (result.isDenied) {
// 						    Swal.fire('삭제가 취소되었습니다.', '', 'info')
// 						  }
// 						});
						
						
// 					} //체크된거 있을대
// 					else {
// 						 Swal.fire('선택된 항목이 없습니다.', '', 'info')
// 					} //체크된거 없을때
					
// 				}); //save

						Swal.fire({
							  title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>" + "총" +checked.length+"건\n정말 삭제하시겠습니까?"+ "</div>",
									  // “<div style=’color:#f00;font-size:15px’>” + msg + “</div>”,    //  HTML & CSS 로 직접수정
							  icon: 'info', // 아이콘! 느낌표 색? 표시?
							  showDenyButton: true,
							  confirmButtonColor: '#17A2B8', // confrim 버튼 색깔 지정
							  cancelButtonColor: '#73879C', // cancel 버튼 색깔 지정
							  confirmButtonText: 'Yes', // confirm 버튼 텍스트 지정
//	 						  cancelButtonText: '아니오', // cancel 버튼 텍스트 지정
							  width : '300px', // alert창 크기 조절
							  
							}).then((result) => {
						
						 /* confirm => 예 눌렀을 때  */
						  if (result.isConfirmed) {
							  
						  
							$.ajax({
		 						url: "/performance/rawMaterialDelete",
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
				
				
				//취소 -> 리셋
				$('#cancle').click(function(){
					$('input:checkbox').prop('checked', false);
				});
				
			}); //delete click

            
        });
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

	<h1 style="margin-left: 1%;">원자재 관리</h1>

	<div style="margin: 1% 1%;">
		<hr>
		<form action="" method="get">
			<fieldset>
			<input type="hidden" name="input" id="input" value="${input }">
	       		<label>원자재코드&nbsp;</label>
	        	<input type="text" name="raw_code" id="searchCode" placeholder="원자재코드를 입력하세요."> &nbsp;&nbsp;
	        	<label>원자재명&nbsp;</label>
	        	<input type="text" name="raw_name" id="searchCategory" placeholder="원자재명을 입력하세요."> &nbsp;&nbsp;
	        	<label>거래처명&nbsp;</label>
	        	<input type="hidden" name="client_code" id="client_code9999" >
	        	<input type="text" name="clients.client_actname" id="client_actname9999" placeholder="거래처를 선택하세요." onclick="serchClient('client_code9999')" class="input-fieldc"> &nbsp;&nbsp;
	        	<input type="submit" class="B B-info" value="조회">
	        	
			</fieldset>
		</form>
		<hr>
	</div>	


	<div class="col-md-12 col-sm-12">
		<div class="x_panel">
			
			<div class="x_title">
				<h2>원자재 목록<small>총 ${paging.total} 건</small></h2>
				
				<div style="float: left;  margin-top: 1.5px;">
					<c:if test="${empty param.input }">
						<button onclick="location.href='/performance/rawMaterial'" class="B2 B2-info">↻</button>
					</c:if>
					<c:if test="${!empty param.input }">
						<button onclick="location.href='/performance/rawMaterial?input=${param.input }'" class="B2 B2-info">↻</button>
					</c:if>
				</div>
				
				<div style="float: right;">
					<button id="addButton" class="B B-info">추가</button>
					<button id="modify" class="B B-info">수정</button>
					<button id="delete" class="B B-info">삭제</button>
					<button type="reset" id="cancle" class="B B-info">취소</button>
					<input type="submit" class="B B-info" value="저장" id="save" class ="btn btn-success">
				</div>
				<div class="clearfix"></div>
			</div>

 	<!-- 버튼 제어 -->
<form method="post" id="fr">
	<script>
	    var team = "${sessionScope.id.emp_department }"; // 팀 조건에 따라 변수 설정
	
	    if (team === "물류팀" || team === "관리자") {
	        document.getElementById("addButton").disabled = false;
	        document.getElementById("modify").disabled = false;
	        document.getElementB yId("delete").disabled = false;
	        document.getElementById("cancle").disabled = false;
	        document.getElementById("save").disabled = false;
	        document.querySelector("[onclick^='location.href']").disabled = false;
	    } else {
	        document.getElementById("addButton").hidden = true;
	        document.getElementById("modify").hidden = true;
	        document.getElementById("delete").hidden = true;
	        document.getElementById("cancle").hidden = true;
	        document.getElementById("save").hidden = true;
	        document.querySelector("[onclick^='location.href']").hidden = true;
	    }
	</script>
	<!-- 버튼 제어 -->
		
		<div class="x_content">
			<div class="table-responsive">
				<div class="table-wrapper" >
		<table id="rawTable" class="table table-striped jambo_table bulk_action" style="text-align-last:center;">
		<thead>
				<tr class="headings">
					<th class="column-title">번호</th>
					<th>품번</th>
					<th>품명</th>
					<th>색상</th>
					<th>재고 단위</th>
					<th>규격</th>
					<th type='hidden' style='display: none;'>거래처코드</th>
					<th>거래처명</th>
					<th type='hidden' style='display: none;'>창고코드</th>
					<th>창고명</th>
					<th>매입단가</th>
					<th>비고</th>
				</tr>
			</thead>
			<tr type='hidden' style='display: none;'></tr>
			
			<c:forEach var="vo" items="${rawList}">
					<tr>
						<td></td>
         			    <td id="rawCode">${vo.raw_code }</td>
						<td id="rawName">${vo.raw_name }</td>
						<td>${vo.raw_color }</td>
						<td>${vo.raw_unit }</td>
						<td>${vo.raw_size }</td>
						<td type='hidden' style='display: none;'>${vo.client_code }</td>
						<td>${vo.clients.client_actname }</td>
						<td type='hidden' style='display: none;'>${vo.wh_code }</td>
						<td>${vo.wh.wh_name }</td>
						<td><fmt:formatNumber>${vo.raw_price }</fmt:formatNumber></td>
						<td>${vo.raw_note }</td>
					</tr>
			</c:forEach>
		</table>
		</div>
		</div>
		</div>
	</form>

	<button id="excelDownload" class="B B-info">엑셀 ⬇️</button>
	
	<script type="text/javascript">

		//오늘 날짜 yyyy-mm-dd
		function getToday() {
			var date = new Date();
			var year = date.getFullYear();
			var month = ("0" + (1 + date.getMonth())).slice(-2);
			var day = ("0" + date.getDate()).slice(-2);
		
			return year + "-" + month + "-" + day;
		} //getToday()
        
        //엑셀
        var excelDownload = document.querySelector('#excelDownload');
        
        document.addEventListener('DOMContentLoaded', ()=> {
            excelDownload.addEventListener('click', exportExcel);
        });
        
        function exportExcel() {
            //1. workbook 생성
            var wb = XLSX.utils.book_new();
            
            //2. 시트 만들기
            var newWorksheet = excelHandler.getWorksheet();
            
            //3. workbook에 새로 만든 워크시트에 이름을 주고 붙이기
            XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName());
            
            //4. 엑셀 파일 만들기
            var wbout = XLSX.write(wb, {bookType:'xlsx', type:'binary'});
            
            //5. 엑셀 파일 내보내기
            saveAs(new Blob([s2ab(wbout)], {type:"application/octet-stream"}), excelHandler.getExcelFileName());
            
        } //exportExcel()
        
        var excelHandler = {
            getExcelFileName : function() {
                return 'raw_Material_list'+getToday()+'.xlsx'; //파일명
            },
            getSheetName : function() {
                return 'raw_Material Sheet'; //시트명
            },
            getExcelData : function() {
                return document.getElementById('rawTable'); //table id
            },
            getWorksheet : function() {
                return XLSX.utils.table_to_sheet(this.getExcelData());
            }
        } //excelHandler
        
        function s2ab(s) {
            var buf = new ArrayBuffer(s.length);  // s -> arrayBuffer
            var view = new Uint8Array(buf);  
            for(var i=0; i<s.length; i++) {
                view[i] = s.charCodeAt(i) & 0xFF;
            }
            return buf;
        } //s2ab(s)
        
    </script>
	
	<div id="pagination" class="dataTables_paginate paging_simple_numbers" style="margin-right: 1%;">
		<ul class="pagination">
			<li class="paginate_button previous disabled">	
				<c:if test="${paging.startPage != 1 }">
					<a href="/performance/rawMaterial?nowPage=${paging.startPage - 1 }&cntPerPage=${paging.cntPerPage}&raw_code=${vo.raw_code }&raw_name=${vo.raw_name }&clients.client_actname=${vo.clients.client_actname }">Previous</a>
				</c:if>
			</li>
			<li class="paginate_button previous disabled">	
				<c:forEach begin="${paging.startPage }" end="${paging.endPage }" var="p">
							<a href="/performance/rawMaterial?nowPage=${p }&cntPerPage=${paging.cntPerPage}&raw_code=${vo.raw_code }&raw_name=${vo.raw_name }&clients.client_actname=${vo.clients.client_actname }">${p }</a>
				</c:forEach>
			</li>
			<li class="paginate_button previous disabled">	
				<c:if test="${paging.endPage != paging.lastPage}">
					<a href="/performance/rawMaterial?nowPage=${paging.endPage+1 }&cntPerPage=${paging.cntPerPage}&raw_code=${vo.raw_code }&raw_name=${vo.raw_name }&clients.client_actname=${vo.clients.client_actname }">Next</a>
				</c:if>
			</li>
		</ul>
	</div>
	</div>
</div>
	
	
	
	
	
</div>
	
<!-- /page content -->
<%@ include file="../include/footer.jsp"%>