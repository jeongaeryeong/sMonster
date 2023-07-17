<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@ include file="../include/header.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- sweetalert -->

<script src="https://code.jquery.com/jquery-3.7.0.js" integrity="sha256-JlqSTELeR4TLqP0OG9dxM7yDPqX1ox/HfgiSLBj8+kM=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<!--FileSaver [savaAs 함수 이용] -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>

<link href="../resources/build/css/custom.css" rel="stylesheet">

<!-- 폰트 -->
<link href="https://webfontworld.github.io/NexonLv2Gothic/NexonLv2Gothic.css" rel="stylesheet">

<link rel="stylesheet" href="/resources/forTest/sm.css"> <!-- 버튼css -->

<c:if test="${empty sessionScope.id}">
    <c:redirect url="/smmain/smMain" />
</c:if>

<style type="text/css">

body {
	font-family: 'NexonLv2Gothic';
}
</style>
<!-- 폰트 -->

<script type="text/javascript">
	
	// 발주 팝업
	function roPopup() {
		 window.open("roPopup","거래처 목록","top=60,left=140,width=877,height=677, location=no");
	}
	
	// 발주 현황 상세페이지
	function detailPopup(rawCode, raw_order_num) {
		window.open("detailPopup?rawCode=" + rawCode + "&raw_order_num=" + raw_order_num, "거래처 상세", "top=60,left=140,width=977,height=377");
	}
	
	// 총액
	function totalAmount() {
		
		var roCount = parseInt(document.getElementById("raw_order_count").value);
		var rawPriceInput = document.getElementById("raw_price").value;
		var rawPrice = parseFloat(rawPriceInput.replace(/,/g, ""));
		
		var totalAmount = roCount * rawPrice;
		
		var fmtAmount = totalAmount.toLocaleString() + "원";
		
		document.getElementById("total_amount").textContent = fmtAmount;
	}
	
	// 창고
	function warehouse() {
		window.open("whPopup","창고 목록","top=60,left=140,width=977,height=677, location=no");
	}
	
	// 체크
	function check() {
		if(document.getElementById("client_actname").value === "") {
// 			alert("발주 항목을 선택해주세요.");
			Swal.fire({
				title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>" + "발주 항목을 선택해주세요"+ "</div>",
				icon: 'warning',
				width: '300px',
			})
			return false;
		} else if(document.getElementById("raw_order_count").value === "") {
// 			alert("발주 수량을 입력해주세요.");
			Swal.fire({
				title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>" + "발주 수량을 입력해주세요"+ "</div>",
				icon: 'warning',
				width: '300px',
			})
			return false;
		} else if(document.getElementById("wh_code").value === "") {
// 			alert("입고 창고를 선택해주세요.");
			Swal.fire({
				title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>" + "입고 창고를 선택해주세요"+ "</div>",
				icon: 'warning',
				width: '300px',
			})
			return false;
		}
	}
	
		
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




<script type="text/javascript">

function toggleDiv(divId) {
    var listDiv = document.getElementById("list");
    var registDiv = document.getElementById("regist");
    
    if(divId === "list"){
   	 listDiv.style.display = "block";
   	registDiv.style.display = "none";
  
   	
    } else if(divId === "regist"){
   
   	 listDiv.style.display = "none";
   	 registDiv.style.display = "block";
    	}
    
    }

	window.onload = function() {
		var listDiv = document.getElementById("list");
		var registDiv = document.getElementById("regist");
		 
		listDiv.style.display = "block";
		registDiv.style.display = "none";
				
	};

</script>
	
<%-- 	<c:if test="${empty emp_id }"> --%>
<%-- 		<c:redirect url="/smmain/smLogin" /> --%>
<%-- 	</c:if> --%>
	
	<h1 style="margin-left: 1%;"> 발주 관리 </h1>

    <div style="margin: 1% 1%">
    
  		<script>
		    var team = "${sessionScope.id.emp_department }"; // 팀 조건에 따라 변수 설정 
		
		    if (team === "영업팀" || team === "관리자") {
		        document.getElementById("matList").disabled = false;
		        document.getElementById("matAdd").disabled = false;
		    } else {
		        document.getElementById("matList").hidden = true;
		        document.getElementById("matAdd").hidden = true;
		    }
		</script>
    <!-- 버튼 제어 -->
    <form action="" name="ro">
	    <input type="button" value="발주 현황" class="B B-info"  onclick="toggleDiv('list')" id="matList" style="background-color: #EFEFEF; color: #73879c; width: 8%; font-weight: 500; font-size: 15px;"></input>
	    <input type="button" value="발주 등록" class="B B-info" onclick="toggleDiv('regist')"id="matAdd" style="background-color: #EFEFEF; color: #73879c; width: 8%; font-weight: 500; font-size: 15px;"></input>
    </form>
	
    <div id="list">
	    <form action="" method="get">
    	<hr>
		    발주 번호 <input type="text" name="raw_order_num" placeholder="발주 번호를 입력하세요."> &nbsp;
		   	품명 <input type="text" name="rawMaterial.raw_name" placeholder="품명을 입력하세요."> &nbsp;
		   	거래처명 <input type="text" name="clients.client_actname" placeholder="거래처명을 입력하세요."> &nbsp; &nbsp;
		   	<input type="submit" class="B B-info" value="조회"></input>
	    </form>
	    <hr>
	    
    
	   
	
    <!-- ///////////////////////////////////////////////목록 템플릿  \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ -->
    
    <div class="col-md-12 col-sm-12">
		<div class="x_panel">
			<div class="x_title">
				<h2> 발주 목록 <small>총 ${count1 }건</small></h2>
				
				<div class="clearfix"></div>
			</div>
			<div class="x_content" >
				
				<div class="table-wrapper" >
					<form action="" method="post">
						<table id="data-table" class="table table-striped jambo_table bulk_action" style="text-align-last:center;">
							<thead>
								<tr class="headings">
									<th></th>
									<th>발주 번호</th>
									<th>거래처명</th>
									<th>품번</th>
									<th>품명</th>
									<th>색상</th>
									<th>발주 수량</th>
									<th>재고 수량</th>
									<th>단가</th>
									<th>총액</th>
									<th>입고 창고</th>
									<th>발주일</th>
									<th>담당자</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="vo" items="${ro_List }">
									<tr class="even pointer">
										<td><a onclick="detailPopup('${vo.raw_code}', '${vo.raw_order_num }')" style="font-size:15px">&#128269;</a></td>
										<td>${vo.raw_order_num }</td>
										<td>${vo.clients.client_actname }</td>
										<td>${vo.raw_code }</td>
										<td>${vo.rawMaterial.raw_name }</td>
										<td>${vo.rawMaterial.raw_color }</td>
										<td>${vo.raw_order_count}</td>
										<td style="color: ${vo.stock.stock_count <= 50 ? 'red' : 'inherit'}">${vo.stock.stock_count != null ? vo.stock.stock_count : 0}</td>
										<td><fmt:formatNumber value=" ${vo.rawMaterial.raw_price}" />원</td>
										<td><fmt:formatNumber value=" ${vo.rawMaterial.raw_price*vo.raw_order_count}" />원</td>
										<td>${vo.rawMaterial.wh_code }</td>
										<td>${vo.raw_order_date}</td>
										<td>${vo.emp_id }</td>
										
									</tr>

								</c:forEach>
							</tbody>
						</table>
						
					</form>
					<div style="display: inline;">
					
					<div id="pagination" class="dataTables_paginate paging_simple_numbers"> 
		<ul class="pagination"> 
	<!--     			<div style="text-align: right;"> -->
					<c:if test="${count1 > 0 }">
					<li class="paginate_button previous disabled">
						<c:if test="${bp.prev}">
						    <a href="/stock/raw_order?page=${bp.startPage - 1}&raw_order_num=${param.raw_order_num}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">Previous</a>
						</c:if>
						<c:forEach begin="${bp.startPage}" end="${bp.endPage}" step="1" var="idx">
						    <a href="/stock/raw_order?page=${idx}&raw_order_num=${param.raw_order_num}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">${idx}</a>
						</c:forEach>
						<c:if test="${bp.next && bp.endPage > 0}">
						    <a href="/stock/raw_order?page=${bp.endPage + 1}&raw_order_num=${param.raw_order_num}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">Next</a>
						</c:if>
					</li>
					</c:if>
	<!-- 			</div> -->
	    </ul>
	    </div>
					
					<button id="excelDownload" class="B B-info">엑셀 ⬇️ </button>
					</div>
			
	<script type="text/javascript">
	function getToday() {
		var date = new Date();
		
		var year = date.getFullYear();
		var month = ("0" + (1 + date.getMonth())).slice(-2);
		var day = ("0" + date.getDate()).slice(-2);
		
		return year + "-" + month + "-" + day;
	} //getToday()
	
	
        //엑셀
        const excelDownload = document.querySelector('#excelDownload');
        
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
                return 'performanceList'+getToday()+'.xlsx'; //파일명
            },
            getSheetName : function() {
                return 'Performance Sheet'; //시트명
            },
            getExcelData : function() {
                return document.getElementById('data-table'); //table id
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
    <!-- 엑셀 - 끝 -->
		
				</div>
			</div>
		</div>

	</div>
    
	</div>
	
    <!-- //////////////////////////////////목록 템플릿  /////////////////////////////////////// -->
    
    
	
    
	
	<!-- ============================ 발주 현황ㅇㅇㅇㅇㅇ ============================ -->
	
	
	
	
	
	<!-- ============================ 발주 등록 ============================ -->

	<br>
	
	<div id="regist">
		<form action="" method="post" onsubmit="return check()">
		<div class="col-md-12 col-sm-12" >
			<div class="x_panel" style="height: 382px">
			<div class="x_title">
				<h2>발주 등록</h2>
				<div class="clearfix"></div>
			</div>
			<c:set var="today" value="<%=new Date()%>" />
			<br>
					<div class="table-wrapper" >
						<div class="table-responsive">
							<table id="table"
								class="table table-striped jambo_table bulk_action" style="text-align-last:center;">
								<thead>
									<tr class="headings">
										<th>발주일</th>
										<th>거래처 코드</th>
										<th>거래처명</th>
										<th>품번</th>
										<th>품명</th>
										<th>색상</th>
										<th>입고 창고</th>
										<th>발주 수량</th>
										<th>재고 수량</th>
										<th>단가</th>
										<th>총액</th>
										<th>담당자</th>
									</tr>
								</thead>
								<tbody>

									<tr class="even pointer">
										<td><input type="text" name="raw_order_date"
											value="<fmt:formatDate value="${today }" pattern="yyyy-MM-dd"/>"
											readonly></td>
										<td onclick="roPopup();"><input type="text" 
											name="client_code" id="client_code" readonly class="input-fielda"></td>
										<td onclick="roPopup();"><input type="text" 
											name="client_actname" id="client_actname" required readonly class="input-fielda"></td>
										<td onclick="roPopup();"><input type="text" 
											name="raw_code" id="raw_code" readonly class="input-fielda"></td>
										<td onclick="roPopup();"><input type="text" 
											name="raw_name" id="raw_name" readonly class="input-fielda"></td>
										<td onclick="roPopup();"><input type="text" 
											name="raw_color" id="raw_color" readonly class="input-fielda"></td>
										<td onclick="roPopup();" ><input type="text" name="wh_code" id="wh_code" readonly class="input-fielda"></td>
										<td><input type="number" min="1"
											id="raw_order_count" name="raw_order_count"
											oninput="totalAmount()"></td>
										<!-- CSS할 때 증감버튼 없애기 -->
										<td><input type="text" style="color: ${inputValue <= 50 ? 'red' : 'inherit'}" 
											name="stock_count" id="stock_count" readonly >
										</td>
										<td><input type="text"  name="raw_price"
											id="raw_price" readonly></td>
										<td id="total_amount"></td>
										<td>${sessionScope.id.emp_id }</td>
									</tr>
								</tbody>
							</table> 
							<br><br>
							</div>
							<input type="submit" class="B B-info" value="발주 신청" style="margin-top: 2%; padding: 2px; width: 75px;">
							
							</div>
							</div>
							</div>
							</form>
						</div>

	 </div>
     </div>
	<!-- ============================ 발주 등록 ============================ -->

	
	
<!-- /page content -->
<%@ include file="../include/footer.jsp"%>