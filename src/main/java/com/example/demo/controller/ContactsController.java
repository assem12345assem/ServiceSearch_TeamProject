package com.example.demo.controller;

import com.example.demo.service.ContactsService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/contact")
@RequiredArgsConstructor
public class ContactsController {
    private final ContactsService contactsService;
    @GetMapping
    public String getAll(Model model) {
        model.addAttribute("contacts", contactsService.getAll());
//        model.addAttribute("searchResults", contactsService.getSearchResultItems());
        return "specialist/contacts";
    }
    @GetMapping(value = "/contact-item/delete")
    public String deleteContact(@RequestParam String contactType, @RequestParam String contactValue) {
       contactsService.deleteContactInfo(contactType, contactValue);
        return "redirect:/profile/add_contacts";
    }

}
