<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp"%>

<link rel="stylesheet" href="/resources/forTest/sm.css"> <!-- 버튼css -->
<link href="../resources/build/css/custom.css" rel="stylesheet">

<!-- 폰트 -->
<link href="https://webfontworld.github.io/NexonLv2Gothic/NexonLv2Gothic.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<!--FileSaver [savaAs 함수 이용] -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>

<style type="text/css">

body {
	font-family: 'NexonLv2Gothic';
}
</style>
<!-- 폰트 -->

<!-- page content -->
<div class="right_col" role="main">

	<h1 style="margin-left: 1%;">입고 관리</h1>

	<!-- 버튼 제어 -->
<!-- 	<div style="margin-left: 1%;"> -->
<!-- 		<input type="button" value="전체" class="B B-info" onclick="showAll()"></input> -->
<!-- 		<input type="button" value="미입고" class="B B-info" onclick="show1()" ></input>  -->
<!-- 		<input type="button" value="입고완료" class="B B-info" onclick="show2()" ></input> -->
<!-- 	</div> -->
	
	<script>!!
	    var team = "${sessionScope.id.emp_department }"; // 팀 조건에 따라 변수 설정!!!!!!!
	
	    if (team === "자재팀" || team === "관리자") {
	        document.getElementById("inMatN").disabled = false;
	        document.getElementById("inMatY").disabled = false;
	    } else {
	        document.getElementById("inMatN").hidden = true;
	        document.getElementById("inMatY").hidden = true;
	    }
	</script>
	<!-- 버튼 제어 -->

	<script>
		function show1() {
			var table = document.getElementById("data-table");
			var rows = table.getElementsByTagName("tr");

			for (var i = 1; i < rows.length; i++) {
				var row = rows[i];
				var statusCell = row.cells[13];

				if (statusCell.innerText.trim() !== "미입고") {
					row.style.display = "none";
				} else {
					row.style.display = "";
				}
			}
		}

		function show2() {
			var table = document.getElementById("data-table");
			var rows = table.getElementsByTagName("tr");

			for (var i = 1; i < rows.length; i++) {
				var row = rows[i];
				var statusCell = row.cells[13];

				if (statusCell.innerText.trim() !== "입고완료") {
					row.style.display = "none";
				} else {
					row.style.display = "";
				}
			}
		}

		function showAll() {
			var table = document.getElementById("data-table");
			var rows = table.getElementsByTagName("tr");

			for (var i = 1; i < rows.length; i++) {
				var row = rows[i];
				row.style.display = "";
			}
		}
		

// 		function go(raw_name,raw_order_count,raw_order_num,raw_code,rawMaterial.wh_code ) {
			
// 			Swal.fire({
// 				title: "<div style='color:#3085d6;font-size:20px;font-weight:lighter'>" + "품명("+raw_name+")이 "+raw_order_count+"개 입고 처리가 되었습니다."+ "</div>",
// 				icon: 'success',
// 				width: '300px',
// 			}).then((result) => {
// 				  if (result.isConfirmed) {
// 				}
// 			});

// 		}
		
		function go(raw_name, raw_order_count, raw_order_num, raw_code, wh_code) {
			  
			var data = {
				rawOrderCount: raw_order_count,
			    rawOrderNum: raw_order_num,
			    rawCode: raw_code,
			    whCode: wh_code
			  };

			  $.ajax({
			    type: 'POST',
			    url: '/stock/In_material',
			    data: data,
			    success: function(response) {
			    	Swal.fire({
						title: "<div style='color:#495057;font-size:20px;font-weight:lighter'>" + "품명("+raw_name+")이 "+raw_order_count+"개 \n입고 처리가 되었습니다."+ "</div>",
						icon: 'success',
						width: '300px',
					}).then((result) => {
						  if (result.isConfirmed) {
							  location.reload();
						}
					});
			    },
			    error: function(xhr, status, error) {
			      alert('실패');
			    }
			  });
			}
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
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



<!-- //////////////////////////////////////////////////////////////////////// -->
<!-- page content -->
	

<div style="margin: 1% 1% 1% 1%;">

	<form action="" method="get">
		<hr>

		<label>입고 번호</label> <input type="text" name="in_mat.in_num" placeholder="입고 번호를 입력해주세요."> &nbsp;
		<label>품명</label> <input type="text" name="rawMaterial.raw_name" placeholder="품명을 입력해주세요."> &nbsp;
		<label>거래처명</label> <input type="text" name="clients.client_actname" placeholder="거래처명을 입력해주세요."> &nbsp; &nbsp;
    
		<input type="submit" class="B B-info" value="조회"> <br>
    
	<hr>
		<button type="submit" value="" class="B B-info" name="in_YN" style="background-color: #EFEFEF; color: #73879c; width: 8%;"><span style="font-weight: 500; font-size: 15px;">전체</span></button>
		<input type="submit" value="미입고" class="B B-info" name="in_YN" style="background-color: #EFEFEF; color: #73879c; width: 8%; font-weight: 500; font-size: 15px;"></input> 
        <input type="submit" value="입고완료" class="B B-info" name="in_YN" style="background-color: #EFEFEF; color: #73879c; width: 8%; font-weight: 500; font-size: 15px;"></input> 
	
  </form>
</div>


	<!--//////////////////////////////////////////// 테이블 템플릿 ////////////////////////////////////////////////////// -->

	<div class="col-md-12 col-sm-12  ">
		<div class="x_panel">
			<div class="x_title">
				<h2>
					입고 목록 <small>총 ${count1}건</small>
				</h2>
			
				<div class="clearfix"></div>
			</div>
		<div class="x_content">
			<div class="table-responsive">
				<div class="table-wrapper" >
					<form action="" method="post" id="fr">
						<table class="table table-striped jambo_table bulk_action"
							id="data-table" style="text-align-last:center;">
							<thead>
								<tr class="headings">
									<th>입고 번호</th>
									<th>발주 번호</th>
									<th>입고 창고</th>
									<th>거래처명</th>
									<th>품번</th>
									<th>품명</th>
									<th>색상</th>
									<th>발주 수량</th>
									<th>재고 수량</th>
									<th>단가</th>
									<th>총액</th>
									<th>입고일</th>
									<th>입고 담당자</th>
									<th>입고 확인</th>
									<th>입고 버튼</th>
									<th class="bulk-actions" colspan="7"><a class="antoo"
										style="color: #fff; font-weight: 500;">Bulk Actions ( <span
											class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								</tr>
							</thead>
							<tbody>
							<c:if test="${count1 > 0}">
								<c:forEach var="rvo" items="${ro_List }">
									<tr class="even pointer">
										<td>${rvo.in_mat.in_num }</td>
										<td>${rvo.raw_order_num }</td>
										<td>${rvo.rawMaterial.wh_code }</td>
										<td>${rvo.clients.client_actname }</td>
										<td>${rvo.raw_code }</td>
										<td>${rvo.rawMaterial.raw_name }</td>
										<td>${rvo.rawMaterial.raw_color }</td>
										<td>${rvo.raw_order_count}</td>
										<td style="color: ${rvo.stock.stock_count <= 20 ? 'red' : 'inherit'}">${rvo.stock.stock_count != null ? rvo.stock.stock_count : 0}</td>
										<td><fmt:formatNumber value=" ${rvo.rawMaterial.raw_price}" />원</td>
										<td><fmt:formatNumber value=" ${rvo.rawMaterial.raw_price*rvo.raw_order_count}" />원</td>
										<td>${rvo.in_mat.in_date }</td>
										<td>${rvo.in_mat.i_emp_id }</td>
<%-- 										<td>${rvo.in_mat.in_YN eq null ? '미입고' : rvo.in_mat.in_YN}</td> --%>
										<td>${rvo.in_YN}</td>
										<td>
										<c:if test = "${sessionScope.id.emp_department eq '물류팀' or sessionScope.id.emp_department eq '관리자'}">
											<c:if test="${rvo.in_mat.in_num == null}">
												<button type="button" name="in_Button" onclick="go('${rvo.rawMaterial.raw_name }','${rvo.raw_order_count}', '${rvo.raw_order_num}','${rvo.raw_code}','${rvo.rawMaterial.wh_code }')" class="B B-info" >입고 처리</button>
											</c:if>
										</c:if>
										</td>
									</tr>
									
								</c:forEach>
								</c:if>
							</tbody>
						</table>
						<div style="text-align: center;">
							<c:if test="${count1 == 0}">
								해당되는 항목이 없습니다.
							</c:if>
						</div>
					</form>
				</div>			
				<div style="display: inline;">
				
				<div id="pagination" class="dataTables_paginate paging_simple_numbers" style="margin-right: 1%;">
					<ul class="pagination">
			            <c:if test="${count1 > 0 }">
						<li class="paginate_button previous disabled">
			                <c:if test="${bp.prev}">
			                    <span><a href="/stock/In_material?page=${bp.startPage -1}&in_mat.in_num=${rvo.in_mat.in_num}&in_YN=${rvo.in_YN}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">Previous</a></span>
			                </c:if>
			            </li>
						<li class="paginate_button previous disabled">
			                <c:forEach var="i" begin="${bp.startPage}" end="${bp.endPage}"
			                    step="1">
			                    <a href="/stock/In_material?page=${i }&in_mat.in_num=${rvo.in_mat.in_num}&in_YN=${rvo.in_YN}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">${i }</a>
			                </c:forEach>
						</li>
						<li class="paginate_button previous disabled">
			                <c:if test="${bp.next && bp.endPage > 0}">
			                    <a href="/stock/In_material?page=${bp.endPage + 1}&in_mat.in_num=${rvo.in_mat.in_num}&in_YN=${rvo.in_YN}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">Next</a>
			                </c:if>
			            </li>
			            </c:if>
			         </ul>
     			</div>	
				
				
				<!-- 엑셀 - 시작 -->
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
<!-- //////////////////////////////////////////////////////////////////////// -->	
	
	
</div>


</div>
<!-- //////////////////////////////////////////////////////////////////////// -->	
      
      
</div>
</div>

	<!--//////////////////////////////////////////// 테이블 템플릿 ////////////////////////////////////////////////////// -->
</div> 
<!-- /page content -->
<%@ include file="../include/footer.jsp"%>