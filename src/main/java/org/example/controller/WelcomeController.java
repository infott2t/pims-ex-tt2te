package org.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.HttpSession;

@Controller
public class WelcomeController {

    @GetMapping(value = {"/", "/welcome"})
    public String welcome(HttpSession session, Model model) {
        model.addAttribute("projectName", "PIMS (Personal Information Management System)");
        model.addAttribute("currentTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        model.addAttribute("greeting", "PIMS 시스템에 오신 것을 환영합니다!");
        model.addAttribute("loginUser", session.getAttribute("loginUser"));
        return "welcome";
    }
}
