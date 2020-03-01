package com.dj.shop.web.page;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/index/")
public class IndexPageController {

	/**
	 * 去index页面
	 * @return
	 */
	@RequestMapping("toIndex")
	public String toIndex (String username, Model model) {
		model.addAttribute("username", username);
		return "index/index";
	}

	/**
	 * 去top页面
	 * @return
	 */
	@RequestMapping("toTop")
	public String toTop () {
		return "index/top";
	}

	/**
	 * 去left页面
	 * @return
	 */
	@RequestMapping("toLeft")
	public String toLeft () {
		return "index/left";
	}

	/**
	 * 去right页面
	 * @return
	 */
	@RequestMapping("toRight")
	public String toRight () {
		return "index/right";
	}
}
