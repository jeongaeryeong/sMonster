<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp"%>

<!-- page content -->
<div class="right_col" role="main">

	<h1>입고 관리</h1>

	<!-- 버튼 제어 -->
	<input type="button" value="전체" class="btn btn-info" onclick="showAll()"></input>
	<input type="button" value="미입고" class="btn btn-info" onclick="show1()" id="inMatN"></input> 
	<input type="button" value="입고완료" class="btn btn-info" onclick="show2()" id="inMatY"></input>
	
	<script>
	    var team = "${sessionScope.id.emp_department }"; // 팀 조건에 따라 변수 설정
	
	    if (team === "물류팀" || team === "관리자") {
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
	</script>



	<hr>

	<!-- 	입고 번호 <input type="text" valeu="in_num" placeholder="입고 번호를 입력하세요."> -->
	<!-- 	거래처명 <input type="text"  valeu="clien_name" placeholder="거래처명을 입력하세요."> -->
	<!-- 	품명 <input type="text" valeu="raw_name" placeholder="품명을 입력하세요."> -->
	<!-- 	입고 날짜 <input type="date"> ~ <input type="date"> -->
	<!-- 	<button type="submit">검색</button> -->

	<form action="" method="get">

		<label>품명</label> <input type="text" name="rawMaterial.raw_name" placeholder="품명을 입력해주세요">
		<label>입고 번호</label> <input type="text" name="in_mat.in_num" placeholder="입고 번호를 입력해주세요">
		<label>거래처명</label> <input type="text" name="clients.client_actname" placeholder="거래처명을 입력해주세요">
		<input type="submit" class="btn btn-info" value="검색">

	</form>

	<hr>

	<!--//////////////////////////////////////////// 테이블 템플릿 ////////////////////////////////////////////////////// -->

	<div class="col-md-12 col-sm-12  ">
		<div class="x_panel">
			<div class="x_title">
				<h2>
					입고 목록 <small>총 ${count1}건</small>
				</h2>
				<ul class="nav navbar-right panel_toolbox">
					<li>
						<a class="collapse-link"><i class="fa fa-chevron-up"></i></a>
					</li>
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-expanded="false"><i
							class="fa fa-wrench"></i></a>
						<div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
							<a class="dropdown-item" href="#">Settings 1</a> <a
								class="dropdown-item" href="#">Settings 2</a>
						</div></li>
					<li><a class="close-link"><i class="fa fa-close"></i></a></li>
				</ul>
				<div class="clearfix"></div>
			</div>
			<div class="x_content">
				<div class="table-responsive">
					<form action="" method="post">
						<table class="table table-striped jambo_table bulk_action"
							id="data-table">
							<thead>
								<tr class="headings">
									
									<th class="column-title">입고 번호</th>
									<th class="column-title">발주 번호</th>
									<th class="column-title">입고 창고</th>
									<th class="column-title">거래처명</th>
									<th class="column-title">품번</th>
									<th class="column-title">품명</th>
									<th class="column-title">색상</th>
									<th class="column-title">발주 수량</th>
									<th class="column-title">재고 수량</th>
									<th class="column-title">단가</th>
									<th class="column-title">총액</th>
									<th class="column-title">입고일</th>
									<th class="column-title">담당자</th>
									<th class="column-title">입고 확인</th>
									<th class="column-title">입고 버튼</th>
									<th class="bulk-actions" colspan="7"><a class="antoo"
										style="color: #fff; font-weight: 500;">Bulk Actions ( <span
											class="action-cnt"> </span> ) <i class="fa fa-chevron-down"></i></a>
									</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="rvo" items="${ro_List }">
									<tr class="even pointer">
										<td class=" ">${rvo.in_mat.in_num }</td>
										<td class=" ">${rvo.raw_order_num }</td>
										<td class=" ">${rvo.rawMaterial.wh_code }</td>
										<td class=" ">${rvo.clients.client_actname }</td>
										<td class=" ">${rvo.raw_code }</td>
										<td class=" ">${rvo.rawMaterial.raw_name }</td>
										<td class=" ">${rvo.rawMaterial.raw_color }</td>
										<td class=" ">${rvo.raw_order_count}</td>
										<td class=" ">${rvo.stock.stock_count != null ? rvo.stock.stock_count : 0}</td>
										<td class=" "><fmt:formatNumber
												value=" ${rvo.rawMaterial.raw_price}" />원</td>
										<td class=" "><fmt:formatNumber
												value=" ${rvo.rawMaterial.raw_price*rvo.raw_order_count}" />원</td>
										<td class=" ">${rvo.in_mat.in_date }</td>
										<td class=" ">${rvo.emp_id }</td>
										<td class="a-right a-right ">${rvo.in_mat.in_YN eq null ? '미입고' : rvo.in_mat.in_YN}</td>

										<td class=" ">
										<c:if test = "${sessionScope.id.emp_department eq '물류팀' or sessionScope.id.emp_department eq '관리자'}">
											<c:if test="${rvo.in_mat.in_num == null}">
												<button type="submit" name="in_Button" value="${rvo.raw_order_num},${rvo.raw_code},${rvo.raw_order_count},${rvo.rawMaterial.wh_code }">입고 처리</button>
											</c:if>
										</c:if>
										</td>

									</tr>

								</c:forEach>
							</tbody>
						</table>
					</form>

				</div>
			</div>
		</div>
		<div>
			<c:if test="${count1 > 10 }">
				<c:if test="${bp.prev}">
					<span><a class="btn btn-secondary"
						href="/stock/In_material?page=${bp.startPage -1}&in_mat.in_num=${rvo.in_mat.in_num}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">이전</a></span>
				</c:if>

				<c:forEach var="i" begin="${bp.startPage}" end="${bp.endPage}"
					step="1">
					<a class="btn btn-secondary"
						href="/stock/In_material?page=${i }&in_mat.in_num=${rvo.in_mat.in_num}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">${i }</a>
				</c:forEach>

				<c:if test="${bp.next && bp.endPage > 0}">
					<a class="btn btn-secondary"
						href="/stock/In_material?page=${bp.endPage + 1}&in_mat.in_num=${rvo.in_mat.in_num}&rawMaterial.raw_name=${rvo.rawMaterial.raw_name}&clients.client_actname=${rvo.clients.client_actname}">다음</a>
				</c:if>
			</c:if>
		</div>

	</div>



	<!--//////////////////////////////////////////// 테이블 템플릿 ////////////////////////////////////////////////////// -->




</div>










<!-- /page content -->
<%@ include file="../include/footer.jsp"%>


