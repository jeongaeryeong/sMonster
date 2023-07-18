package com.sm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.SessionScope;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sm.domain.BottomPaging;
import com.sm.domain.ClientsVO;
import com.sm.domain.EmployeesVO;
import com.sm.domain.In_materialVO;
import com.sm.domain.OrderStatusVO;
import com.sm.domain.Out_materialVO;
import com.sm.domain.PageVO;
import com.sm.domain.PerformanceVO;
import com.sm.domain.ProductVO;
import com.sm.domain.Raw_orderVO;
import com.sm.domain.StockVO;
import com.sm.domain.WarehouseVO;
import com.sm.service.In_materialService;
import com.sm.service.Out_materialService;
import com.sm.service.Raw_orderService;
import com.sm.service.StockService;

@Controller
@RequestMapping(value = "/stock/*")
public class stockController {
	
	@Autowired
	private In_materialService service;
	
	@Autowired
	private Raw_orderService ro_service;
	
	@Autowired
	private StockService s_service;
	
	@Autowired
	private Out_materialService o_service;
	
	
	private static final Logger logger = LoggerFactory.getLogger(stockController.class);
	

	// 발주 목록 + 페이징 처리 - 시작
    // http://localhost:8080/stock/raw_order
	// http://localhost:8088/stock/raw_order
	@RequestMapping(value="/raw_order", method = RequestMethod.GET)
    public void getListPage(HttpSession session, PageVO vo, HttpServletRequest request, Model model ,Raw_orderVO rvo) throws Exception {
		
		if((rvo.getClients().getClient_actname() != null && !rvo.getClients().getClient_actname().equals("")) ||
		   (rvo.getRaw_order_num() != null && !rvo.getRaw_order_num().equals("")) || 
		   (rvo.getRawMaterial() != null && rvo.getRawMaterial().getRaw_name() != null && !rvo.getRawMaterial().getRaw_name().equals(""))) {
			

			// 게시물 총 개수
	        int count1 = ro_service.count1(rvo);

	         
	        List<Raw_orderVO> ro_List = ro_service.getRaw_order(vo, rvo);
	        logger.debug("@@@@@@@@@@@@@@ : " + vo);
	        logger.debug("@@@@@@@@@@@@@@ : " + ro_List);
	         
	        BottomPaging bp = new BottomPaging();
			bp.setPageVO(vo);
			bp.setTotalCount(count1);
			logger.debug("@@@@@@@@@@@@@@ : " + bp);
			
			model.addAttribute("ro_List", ro_List);
			model.addAttribute("count1", count1);
			model.addAttribute("bp", bp);

			model.addAttribute("rvo", rvo);
		} else {
			List<Raw_orderVO> ro_List = ro_service.getRaw_order(vo);
			
			int count1 = ro_service.count1();
			
			BottomPaging bp = new BottomPaging();
			bp.setPageVO(vo);
			bp.setTotalCount(count1);
			
			model.addAttribute("ro_List", ro_List);
			model.addAttribute("count1", count1);
			model.addAttribute("bp", bp);
			request.setAttribute("rvo", rvo);
		}
		
		
	}
	// 발주 목록 + 페이징 처리 - 끝
	// 발주 등록
	@RequestMapping(value="/raw_order", method = RequestMethod.POST)
	public String roRegist(@RequestParam("wh_code") String wh_code,
						   Raw_orderVO vo, RedirectAttributes rttr,
						   HttpSession session, HttpServletRequest request,
						   Model model) throws Exception {
		
		// 로그인 정보
		EmployeesVO evo = (EmployeesVO) session.getAttribute("id");
	    String emp_id = evo.getEmp_id();
	    logger.debug("///////////////// emp_id : " + emp_id + "////////////////");
		
		ro_service.roInsert(vo, emp_id);
	
		rttr.addFlashAttribute("result", "roInsert");
		
		return "redirect:/stock/raw_order";
	}

	// 발주 등록 팝업창
    @RequestMapping(value = "/roPopup", method = RequestMethod.GET)
    public void getClient(Model model, PageVO vo, Raw_orderVO rvo) throws Exception {
        
        if((rvo.getClients().getClient_actname() != null && !rvo.getClients().getClient_actname().equals("")) ||
                   (rvo.getRawMaterial() != null && rvo.getRawMaterial().getRaw_name() != null && !rvo.getRawMaterial().getRaw_name().equals(""))) {
            
            List<Raw_orderVO> roPopup = ro_service.Popup(vo, rvo);
            
            int countPop = ro_service.countPop(rvo);
            
            BottomPaging bp = new BottomPaging();
            bp.setPageVO(vo);
            bp.setTotalCount(countPop);
            
            model.addAttribute("roPopup", roPopup);
            model.addAttribute("countPop", countPop);
            model.addAttribute("bp", bp);
            
            model.addAttribute("rvo", rvo);
            
        }else {
        
        
        List<Raw_orderVO> roPopup = ro_service.getPopup(vo);
        
        int countPop = ro_service.countPoP();
        
        BottomPaging bp = new BottomPaging();
        bp.setPageVO(vo);
        bp.setTotalCount(countPop);
        
        model.addAttribute("roPopup", roPopup);
        model.addAttribute("countPop", countPop);
        model.addAttribute("bp", bp);
        
        model.addAttribute("rvo", rvo);
        
        }
    }

	// 발주 거래처 상세 팝업
	@RequestMapping(value = "/detailPopup", method = RequestMethod.GET)
	public void getDetail(@RequestParam("rawCode") String rawCode, ClientsVO cvo,
						  @RequestParam("raw_order_num") String raw_order_num,
						  Raw_orderVO rvo, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("@@@@@@@@발주 취소 rawCode : " + rawCode);
		logger.debug("@@@@@@@@발주 취소 raw_order_num : " + raw_order_num);
		
		List<ClientsVO> ro_detail = ro_service.detailPopup(rawCode);
		
		model.addAttribute("ro_detail", ro_detail);
		model.addAttribute("rawCode", rawCode);
		model.addAttribute("raw_order_num", raw_order_num);
		
		model.addAttribute("rvo", rvo);
		model.addAttribute("cvo", cvo);
		
		//		request.setAttribute("rawCode", rawCode);
		
	}

	// 창고 목록 팝업
	@RequestMapping(value = "/whPopup", method = RequestMethod.GET)
	public void getWarehouse(Model model) throws Exception {
		
		List<WarehouseVO> whPopup = ro_service.whPopup();
		
		model.addAttribute("whPopup", whPopup);
		
	}
	
	// 발주 취소 버튼
	@RequestMapping(value = "/detailPopup", method = RequestMethod.POST)
	public void roCancel(@RequestBody String raw_order_num, Model model) throws Exception {
		
		raw_order_num = raw_order_num.replaceAll("^\"|\"$", "");
		logger.debug("@@@@@@@ detailPopup() POST 발주 번호 : "+ raw_order_num);
		
		ro_service.roCancel(raw_order_num);
		
	}
	
	
	
	// ====================================== 발주 - 끝 ====================================== //
	
	// ====================================== 입고 - 시작 ====================================== //
	
	// 입고 페이징
    //http://localhost:8080/stock/In_material
	//http://localhost:8088/stock/In_material
	@RequestMapping(value = "/In_material", method = RequestMethod.GET)
    public void In_matPage(HttpServletRequest request, Model model , Raw_orderVO rvo ,PageVO vo) throws Exception {
            
		if((rvo.getClients().getClient_actname() != null && !rvo.getClients().getClient_actname().equals("")) ||
                (rvo.getIn_mat().getIn_num() != null && !rvo.getIn_mat().getIn_num().equals("")) || 
                (rvo.getIn_YN() != null && !rvo.getIn_YN().equals("")) || 
                (rvo.getRawMaterial().getRaw_name() != null && !rvo.getRawMaterial().getRaw_name().equals(""))) {
                 
                 // 게시물 총 개수
                 int count1 = ro_service.count1(rvo);
                 logger.debug("@@@@@@@@@@@@@@@@@@@@@count1 : "+count1);
                 
                 List<Raw_orderVO> ro_List = ro_service.getRaw_order(vo, rvo);
                 logger.debug("@@@@@@@@@@@@@@ : " + vo);
                 logger.debug("@@@@@@@@@@@@@@ : " + ro_List);
                  
                 BottomPaging bp = new BottomPaging();
                 bp.setPageVO(vo);
                 bp.setTotalCount(count1);
                 logger.debug("@@@@@@@@@@@@@@ : " + bp);
                 
                 model.addAttribute("ro_List", ro_List);
                 model.addAttribute("count1", count1);
                 model.addAttribute("bp", bp);
                 model.addAttribute("rvo", rvo);
                 
             } else {
             
                 List<Raw_orderVO> ro_List = ro_service.getRaw_order(vo);
                 
                 int count1 = ro_service.count1();
                 
                 BottomPaging bp = new BottomPaging();
                 bp.setPageVO(vo);
                 bp.setTotalCount(count1);
                 
                 model.addAttribute("ro_List", ro_List);
                 model.addAttribute("count1", count1);
                 model.addAttribute("bp", bp);
                 model.addAttribute("rvo", rvo);
             }

    }
	
	// 입고 등록 버튼
	//http://localhost:8080/stock/In_material
	//http://localhost:8088/stock/In_material
    @RequestMapping(value = "/In_material" , method = RequestMethod.POST)
    public String inRegist( @RequestParam("rawOrderCount") Integer raw_order_count,
				            @RequestParam("rawOrderNum") String raw_order_num,
				            @RequestParam("rawCode") String rawCode,
				            @RequestParam("whCode") String wh_code,
    						PageVO vo,
    					   Raw_orderVO rvo, RedirectAttributes rttr, HttpSession session, HttpServletRequest request, Model model) throws Exception{
        

//    	String raw_order_num = requestData.get("raw_order_num");
//    	String rawCode = requestData.get("raw_code");
//    	String wh_code = requestData.get("wh_code");
//    	String ro_count = requestData.get("raw_order_count");

    	logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@ 123");
        logger.debug("@@@@@@@@@@@@@@@ 버튼 발주 번호 확인용 : " + raw_order_num);
        logger.debug("@@@@@@@@@@@@@@@ 원자재 코드 확인용 : " + rawCode);
//        logger.debug("@@@@@@@@@@@@@@@ 1 발주 개수 확인용 : " + ro_count);
        logger.debug("@@@@@@@@@@@@@@@ 입고 창고 확인용 : " + wh_code);
        
//        int raw_order_count = Integer.parseInt(ro_count);
//        logger.debug("@@@@@@@@@@@@@@@ 2 발주 개수 확인용 : " + raw_order_count);
        
        // 로그인
        EmployeesVO evo = (EmployeesVO) session.getAttribute("id");
	    String emp_id = evo.getEmp_id();
	    logger.debug("///////////////// emp_id : " + emp_id + "////////////////");
        
        service.inInsert(raw_order_num, emp_id);
        service.inInsert1(raw_order_num);
//        service.updateIn(raw_order_num);
        
        logger.debug("_______________^__________^^_________^^^^^^^^____^^^^^^^^^^__^^^^^_");
//        service.updateIn(raw_order_num);

        rttr.addFlashAttribute("result", "inInsert");
        
        logger.debug("@@@@@@@@@@@@ 리턴 확인용 : " + raw_order_num);
  	
        
        
        boolean result = service.selectCheck(rawCode);
        
        if(result) {
        	logger.debug("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
        	service.updateStock(rawCode, raw_order_count);
        } else {
        	logger.debug("XXXXXXXXXXXXXXXXX ");
        	service.insertStock(rawCode, raw_order_count, wh_code);
        }
        
        
        rttr.addFlashAttribute("result", "inInsert");
        
        logger.debug("@@@@@@@@@@@@ 리턴 확인용 : " + raw_order_num);

        
        return "redirect:/stock/In_material";
    }

    // ====================================== 입고 - 끝 ====================================== //
    
    // ====================================== 재고 - 시작 ====================================== //
   
    //http://localhost:8080/stock/stockList_raw
	//http://localhost:8088/stock/stockList_raw
	@RequestMapping(value="/stockList_raw" ,method = RequestMethod.GET)
	public void stockList_raw(PageVO vo, HttpServletRequest request , Model model, StockVO svo) throws Exception {
		
		logger.debug("/////////////////////////////////////svo /////////////////////////////////////" + svo);
		logger.debug("//////////// "+ svo.getRaw_code());
		logger.debug("//////////// "+ svo.getProd_code());
		logger.debug("//////////// "+ svo.getRaw_mat().getRaw_name());
		logger.debug("//////////// "+ svo.getProduct().getProd_name());
		logger.debug("//////////// "+ svo.getWh_code());
		
		if((svo.getRaw_code() != null && !svo.getRaw_code().equals("")) ||
				(svo.getRaw_mat().getRaw_name() != null && !svo.getRaw_mat().getRaw_name().equals("")) || 
				(svo.getWh_code() != null && !svo.getWh_code().equals(""))) {
			
			logger.debug("ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ");
			
			// 게시물 총 개수
			int countR3 = s_service.countR3(svo);
			logger.debug("검색 재고 개수 : " + countR3);
			
			List<StockVO> stock_ListR = s_service.getStockR(vo, svo);
			logger.debug("@@@@@@@@@@@@@@ : " + vo);
			logger.debug("@@@@@@@@@@@@@@ : " + stock_ListR);
			
			BottomPaging bp = new BottomPaging();
			bp.setPageVO(vo);
			bp.setTotalCount(countR3);
			logger.debug("@@@@@@@@@@@@@@ : " + bp);
			
			model.addAttribute("stock_ListR", stock_ListR);
			model.addAttribute("count3", countR3);
			model.addAttribute("bp", bp);
			model.addAttribute("svo", svo);
			
		} else {
			
			logger.debug("ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ");
			
			int countR3 = s_service.countR3();
			logger.debug("재고 총 개수 : " + countR3);
			
			List<StockVO> stock_ListR = s_service.getStockR(vo);
			
			BottomPaging bp = new BottomPaging();
			bp.setPageVO(vo);
			bp.setTotalCount(countR3);
			
			model.addAttribute("stock_ListR", stock_ListR);
			model.addAttribute("countR3", countR3);
			model.addAttribute("bp", bp);
			request.setAttribute("svo", svo);
		}
		
		
	}
    
    
    //http://localhost:8080/stock/stockList_prod
	//http://localhost:8088/stock/stockList_prod
	@RequestMapping(value="/stockList_prod" ,method = RequestMethod.GET)
	public void stockList_prod(PageVO vo, HttpServletRequest request , Model model, StockVO svo) throws Exception {
		
		logger.debug("/////////////////////////////////////svo /////////////////////////////////////" + svo);
		logger.debug("//////////// "+ svo.getRaw_code());
		logger.debug("//////////// "+ svo.getProd_code());
		logger.debug("//////////// "+ svo.getRaw_mat().getRaw_name());
		logger.debug("//////////// "+ svo.getProduct().getProd_name());
		logger.debug("//////////// "+ svo.getWh_code());
		
		if((svo.getProd_code() != null && !svo.getProd_code().equals("")) ||
		   (svo.getProduct().getProd_name() != null && !svo.getProduct().getProd_name().equals("")) || 
		   (svo.getWh_code() != null && !svo.getWh_code().equals(""))) {
					
				logger.debug("ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ");

					// 게시물 총 개수
			        int countP3 = s_service.countP3(svo);
			        logger.debug("검색 재고 개수 : " + countP3);

			        List<StockVO> stock_ListP = s_service.getStockP(vo, svo);
			        logger.debug("@@@@@@@@@@@@@@ : " + vo);
			        logger.debug("@@@@@@@@@@@@@@ : " + stock_ListP);
			         
			        BottomPaging bp = new BottomPaging();
					bp.setPageVO(vo);
					bp.setTotalCount(countP3);
					logger.debug("@@@@@@@@@@@@@@ : " + bp);
					
					model.addAttribute("stock_ListP", stock_ListP);
					model.addAttribute("countP3", countP3);
					model.addAttribute("bp", bp);
					model.addAttribute("svo", svo);
  
    				} else {
    				
    					logger.debug("ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ");
    					
    					int countP3 = s_service.countP3();
    					logger.debug("재고 총 개수 : " + countP3);
    					
    					List<StockVO> stock_ListP = s_service.getStockP(vo);
					
						BottomPaging bp = new BottomPaging();
						bp.setPageVO(vo);
						bp.setTotalCount(countP3);
						
						model.addAttribute("stock_ListP", stock_ListP);
						model.addAttribute("countP3", countP3);
						model.addAttribute("bp", bp);
						request.setAttribute("svo", svo);
				}
    		
            
    	}
	
	
	// 재고 팝업
	@RequestMapping(value = "/stockPopup", method = RequestMethod.GET)
	public void stockPopup(@RequestParam("code") String code, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("@@@@@@@@2222222222 재고 GET 방식 호출 code : " + code);
		
		List<StockVO> stockPopup = s_service.stockPopup(code);
		
		model.addAttribute("code", code);
		model.addAttribute("stockPopup", stockPopup);
		
		
	}
	
	// 재고 팝업 수정 버튼
	//http://localhost:8080/stock/stockList
	//http://localhost:8088/stock/stockList
	@RequestMapping(value ="/stockPopup", method = RequestMethod.POST)
	public void updateCount(@RequestBody Map<String, String> requestData, Model model,
							  HttpSession session, HttpServletRequest request) throws Exception{
		
		
		String stockCount = requestData.get("stock_count");
        String code = requestData.get("code");

        int newCount = Integer.parseInt(stockCount);
		
		
		logger.debug("stockPopup() POST 호출");
		
		logger.debug("ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ컨트롤러 재고 POST 방식 code : " + code + "ㅁㅁㅁㅁㅁㅁㅁㅁ");
		logger.debug("ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ컨트롤러 재고 POST 방식 newCount : " + newCount + "ㅁㅁㅁㅁㅁㅁㅁㅁ");

		s_service.updateCount(code, newCount);
		
	}
	
	@ResponseBody
	@RequestMapping(value = "/stockGraph", method = RequestMethod.POST)
	public Map<String, List<StockVO>> stockGraph() throws Exception {
		logger.debug("@@@@@ CONTROLLER: status() 호출");
		
		Map<String, List<StockVO>> GraphMap = s_service.stockGraph1();
		
		logger.debug(""+GraphMap);
		
		
		
		return GraphMap;
		
	} //stockGraph

	
    // ====================================== 재고 - 끝 ====================================== //
    
	
    // ====================================== 출고 - 시작 ====================================== //
    	
    	
	// 출고 처리 버튼 - 시작
	//http://localhost:8080/stock/Out_material
	//http://localhost:8088/stock/Out_material
	@RequestMapping(value = "/Out_material", method = RequestMethod.POST)
	public String omRegist(Out_materialVO vo, RedirectAttributes rttr,
			HttpSession session, HttpServletRequest request,
			@RequestParam("out_Button") String out_Button, Model model) throws Exception {
	    logger.debug("@@@@@@@@@@ 출고 처리 버튼 컨트롤러 @@@@@@@@@@");
	    
	    String[] values = out_Button.split(",");
	    String order_code = values[0];
	    int order_count = Integer.parseInt(values[1]);
	    String prod_code = values[2];

	    logger.debug("!!!!!!!!!!!!!!!!!!! 1 order_code :" + order_code);
        logger.debug("!!!!!!!!!!!!!!!!!!! 2 order_count :" + order_count);
        logger.debug("!!!!!!!!!!!!!!!!!!! 3 prod_code :" + prod_code);
        
        // 로그인
        EmployeesVO evo = (EmployeesVO) session.getAttribute("id");
	    String emp_id = evo.getEmp_id();
	    logger.debug("/////////////////출고 버튼 emp_id : " + emp_id + "////////////////");
        
//    	    String emp_id = (String) session.getAttribute("emp_id"); // 로그인 정보 세션에 담아오기
//    	    vo.getOut_mat().setEmp_id(emp_id); // 담당자 설정

	    o_service.deleteStock(order_count, prod_code); // 재고 빠짐
	    o_service.omButton(order_code, emp_id); // 출고 처리 메서드 호출
	    o_service.updateYN(order_code);

	    return "redirect:/stock/Out_material";
	}
	// 출고 처리 버튼 - 끝
	
	
	// http://localhost:8080/stock/Out_material
	// http://localhost:8088/stock/Out_material
	@RequestMapping(value="/Out_material", method = RequestMethod.GET)
	public void Out_material(PageVO vo, HttpServletRequest request, Model model ,Out_materialVO rvo) throws Exception {
        
		if((rvo.getOut_num() !=null && !rvo.getOut_num().equals("")) ||
		   (rvo.getOrders().getOut_YN() !=null && !rvo.getOrders().getOut_YN().equals("")) ||
		   (rvo.getProd().getProd_name() != null && !rvo.getProd().getProd_name().equals("")) ||
		   (rvo.getClients().getClient_actname() != null && !rvo.getClients().getClient_actname().contentEquals(""))) {
			
			// 게시물 총 개수
	        int count4 = o_service.count4(rvo);
	        
	        List<Out_materialVO> out_List = o_service.getSearch_Out(vo, rvo);
	        
	        logger.debug("@@@@@@@@@@@@@@ : " + vo);
	        logger.debug("@@@@@@@@@@@@@@ : " + out_List);
	         
	        BottomPaging bp = new BottomPaging();
			bp.setPageVO(vo);
			bp.setTotalCount(count4);
			logger.debug("@@@@@@@@@@@@@@ : " + bp);
			
			model.addAttribute("out_List", out_List);
			model.addAttribute("count4", count4);
			model.addAttribute("bp", bp);

			model.addAttribute("rvo", rvo);
	
		} else {
		
			List<Out_materialVO> out_List = o_service.getOut_matList(vo);
			
			int count4 = o_service.count4();
			
			BottomPaging bp = new BottomPaging();
			bp.setPageVO(vo);
			bp.setTotalCount(count4);
			
			model.addAttribute("out_List", out_List);
			model.addAttribute("count4", count4);
			model.addAttribute("bp", bp);
			request.setAttribute("rvo", rvo);
		}
		
		
	}
    	
    	
    // ====================================== 출고 - 끝 ====================================== //    
}
    	

