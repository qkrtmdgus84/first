package first.sample.controller;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import first.common.common.CommandMap;
import first.sample.service.SampleService;
import first.sample.spring.UserInfo;

@Controller
public class SampleController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="sampleService")
	private SampleService sampleService;
	
	@RequestMapping(value="/sample/openBoardList.do")
    public ModelAndView openBoardList(CommandMap commandMap) throws Exception{
    	
		ModelAndView mv = new ModelAndView("/sample/boardList");
    	log.debug("인터셉터 테스트");
    	
        Map<String,Object> resultMap = sampleService.selectBoardList(commandMap.getMap());
        mv.addObject("list", resultMap.get("result"));
        mv.addObject("paginationInfo", (PaginationInfo)resultMap.get("paginationInfo"));

    	return mv;
    
	}
	
	@RequestMapping(value="/sample/testMapArgumentResolver.do") 
	public ModelAndView testMapArgumentResolver(CommandMap commandMap) throws Exception{ 
		
		ModelAndView mv = new ModelAndView(""); 
		if(commandMap.isEmpty() == false){ 
			Iterator<Entry<String,Object>> iterator = commandMap.getMap().entrySet().iterator(); 
			Entry<String,Object> entry = null; 
			while(iterator.hasNext()){ 
				entry = iterator.next(); 
				log.debug("key : "+entry.getKey()+", value : "+entry.getValue()); 
				
			} 
			
		} 
		
		return mv; 
		
	}
	
	@RequestMapping(value="/sample/openBoardWrite.do") 
	public ModelAndView openBoardWrite(CommandMap commandMap) throws Exception{ 
		ModelAndView mv = new ModelAndView("/sample/boardWrite"); 
		
		return mv; 
	}
	
	@RequestMapping(value="/sample/insertBoard.do")
	public ModelAndView insertBoard(CommandMap commandMap, HttpServletRequest request) throws Exception{ 
		ModelAndView mv = new ModelAndView("redirect:/sample/openBoardList.do");
	
		sampleService.insertBoard(commandMap.getMap(), request);
		
		return mv;
	}
	
	@RequestMapping(value="/sample/openBoardDetail.do") 
	public ModelAndView openBoardDetail(CommandMap commandMap) throws Exception{ 
		ModelAndView mv = new ModelAndView("/sample/boardDetail"); 
		Map<String,Object> map = sampleService.selectBoardDetail(commandMap.getMap()); 
		mv.addObject("map", map.get("map")); 
		mv.addObject("list", map.get("list")); 
		
		return mv; 
		
	}
	
	@RequestMapping(value="/sample/openBoardUpdate.do") 
	public ModelAndView openBoardUpdate(CommandMap commandMap) throws Exception{ 
		ModelAndView mv = new ModelAndView("/sample/boardUpdate"); 
		Map<String,Object> map = sampleService.selectBoardDetail(commandMap.getMap()); 
		mv.addObject("map", map.get("map")); 
		mv.addObject("list", map.get("list")); 
		
		return mv; 
		
	} 
	
	@RequestMapping(value="/sample/updateBoard.do") 
	public ModelAndView updateBoard(CommandMap commandMap, HttpServletRequest request) throws Exception{ 
		ModelAndView mv = new ModelAndView("redirect:/sample/openBoardDetail.do"); 
		sampleService.updateBoard(commandMap.getMap(), request); 
		mv.addObject("IDX", commandMap.get("IDX")); 
		
		return mv; 
		
	}
	
	@RequestMapping(value="/sample/deleteBoard.do") 
	public ModelAndView deleteBoard(CommandMap commandMap) throws Exception{ 
		ModelAndView mv = new ModelAndView("redirect:/sample/openBoardList.do"); 
		sampleService.deleteBoard(commandMap.getMap()); 
		
		return mv; 
		
	}
	@RequestMapping(value="/sample/openUserLogin.do")
	public ModelAndView openUserLogin(CommandMap commandMap) throws Exception{
	    ModelAndView mv = new ModelAndView("user/userLogin");
	     
	    mv.addObject("error", commandMap.get("error"));
	     
	    return mv;
	}
	 
	@RequestMapping(value="/sample/loginUser.do")
	public ModelAndView loginUser(CommandMap commandMap, HttpSession session) throws Exception{
	 
	    UserInfo userInfo = sampleService.loginUser(commandMap.getMap());
	    ModelAndView mv = null;;
	    if(!userInfo.isError()) {
	        mv = new ModelAndView("redirect:/sample/openBoardList.do");
	        session.setAttribute("userInfo", userInfo);
	    }else {
	        mv = new ModelAndView("redirect:/sample/openUserLogin.do");
	        mv.addObject("error", userInfo.isError());
	    }
	    return mv;
	}
	 
	@RequestMapping(value="/sample/logoutUser.do")
	public ModelAndView logoutUser(CommandMap commandMap, HttpSession session) throws Exception{
	     
	    ModelAndView mv = new ModelAndView("redirect:/sample/openBoardList.do");
	    session.invalidate();
	     
	    return mv;
	}
}
